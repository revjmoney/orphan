#!/usr/bin/env python3
"""Board-side receiver for the PC's loopback-only rtl_tcp tunnel."""
import ctypes
import http.server
import json
import mmap
import os
import socket
import struct
import subprocess
import tempfile
import threading
import zlib
from pathlib import Path
from urllib.parse import urlsplit

ROOT = Path(__file__).resolve().parent
RATE = 250_000
PAIRS = 8192 // 5 * 5          # Whole audio decimation periods per packet.
BYTES = 2 * PAIRS
MODES = ('wfm', 'nfm', 'am', 'usb', 'lsb', 'cw', 'sam')
GAINS = (0, 9, 14, 27, 37, 77, 87, 125, 144, 157, 166, 197, 207, 229,
         254, 280, 297, 328, 338, 364, 372, 386, 402, 421, 434, 439, 445, 480, 496)
DSP = ctypes.CDLL(str(ROOT / 'demod.so'))
DSP.receiver_new.restype = ctypes.c_void_p
DSP.receiver_free.argtypes = [ctypes.c_void_p]
DSP.receiver_free.restype = None
DSP.receiver_audio.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_int,
                               ctypes.c_int, ctypes.POINTER(ctypes.c_int16)]
DSP.receiver_audio.restype = None
DSP.decoder_iq.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_int,
                           ctypes.POINTER(ctypes.c_int16)]
DSP.decoder_iq.restype = ctypes.c_int
DECODERS = ('off', 'cw', 'navtex', 'wwvb', 'sstv')
IMAGE = 8384 + 65536 * 6


class Decoder:
    def __init__(self, mode, decoder):
        self.directory = tempfile.TemporaryDirectory(prefix='orphan-iq-')
        self.path = Path(self.directory.name) / 'rx'
        self.child = subprocess.Popen([ROOT / 'rxd-external', '--iq-stdin', self.path],
                                      stdin=subprocess.PIPE, stderr=subprocess.DEVNULL)
        self.config = struct.pack('<7i', 0, ('am', 'sam', 'usb', 'lsb', 'cw', 'nfm').index(mode)
                                  if mode != 'wfm' else 0, 0, 0, 0, 0, DECODERS.index(decoder))
        self.memory = None

    def feed(self, samples):
        if self.memory is None and self.path.exists() and self.path.stat().st_size > IMAGE:
            with self.path.open('r+b') as stream:
                self.memory = mmap.mmap(stream.fileno(), 0)
            self.memory[4:len(self.config)] = self.config[4:]
        if self.memory is not None:
            self.child.stdin.write(samples)

    def stop(self):
        self.child.terminate()
        try:
            self.child.wait(timeout=0.2)
        except subprocess.TimeoutExpired:
            self.child.kill()
            self.child.wait()
        try:
            self.child.stdin.close()
        except BrokenPipeError:
            pass
        if self.memory is not None:
            self.memory.close()
        self.directory.cleanup()

    def status(self):
        m = self.memory
        if m is None:
            return {}
        wpm, _, locked, count = struct.unpack_from('<ffII', m, 48)
        start = max(0, count - 8192)
        begin, end = start % 8192, count % 8192
        if count - start == 8192 or end < begin:
            log = m[192 + begin:8384] + m[192:192 + end]
        else:
            log = m[192 + begin:192 + end]
        seq, width, height, rows = struct.unpack_from('<4I', m, IMAGE)
        return dict(text=log.decode('utf-8', 'replace'), locked=bool(locked), wpm=wpm,
                    image=dict(seq=seq, width=width, height=height, rows=rows))

    def image(self):
        m = self.memory
        if m is None:
            return None
        _, width, height, rows = struct.unpack_from('<4I', m, IMAGE)
        if not (0 < width <= 640 and 0 < height <= 496 and rows):
            return None
        pixels = b''.join(b'\0' + m[IMAGE+32+y*1920:IMAGE+32+y*1920+width*3]
                          for y in range(height))
        def chunk(tag, data):
            return struct.pack('>I', len(data)) + tag + data + struct.pack('>I', zlib.crc32(tag+data))
        return (b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0))
                + chunk(b'IDAT', zlib.compress(pixels, 1)) + chunk(b'IEND', b''))


class Receiver:
    def __init__(self, label, port, min_hz, max_hz, *, rtl=False, lf_offset=0):
        self.label, self.port, self.rtl = label, port, rtl
        self.min_hz, self.max_hz, self.lf_offset = min_hz, max_hz, lf_offset
        self.lock = threading.Lock()
        self.stream = threading.Lock()
        self.link = None
        self.tuner = None
        initial = max(min_hz, min(99_500_000, max_hz))
        self.config = dict(frequency=initial, mode='wfm' if initial >= 88_000_000 else 'am',
                           gain=None, decoder='off', reset=0)
        self.decoder = None

    def state(self):
        with self.lock:
            return {**self.config, 'tuner': self.tuner, 'connected': self.link is not None,
                    'iq_rate': RATE, 'audio_rate': RATE // 5, 'packet_iq_bytes': BYTES,
                    'gains': GAINS if self.rtl else (), 'modes': MODES, 'decoders': DECODERS,
                    'label': self.label, 'available': bool(self.port), 'min_hz': self.min_hz,
                    'max_hz': self.max_hz}

    @staticmethod
    def command(link, operation, value):
        link.sendall(struct.pack('>BI', operation, value & 0xffffffff))

    def tune(self, changes):
        if not isinstance(changes, dict) or set(changes) - {'frequency', 'mode', 'gain', 'decoder', 'clear'}:
            raise ValueError('Unrecognized receiver setting')
        with self.lock:
            config = {**self.config, **{key: value for key, value in changes.items() if key != 'clear'}}
            if changes.get('clear'):
                config['reset'] += 1
            frequency, mode, gain = (config[key] for key in ('frequency', 'mode', 'gain'))
            if type(frequency) is not int or not self.min_hz <= frequency <= self.max_hz:
                raise ValueError(f'Frequency must be {self.min_hz / 1000:g} to {self.max_hz / 1000:g} kHz')
            if mode not in MODES or (gain is not None and (not self.rtl or type(gain) is not int or gain not in GAINS)):
                raise ValueError('Unsupported mode or tuner gain')
            if config['decoder'] not in DECODERS:
                raise ValueError('Unsupported decoder')
            if config['decoder'] == 'wwvb' and not self.min_hz <= 60_000 <= self.max_hz:
                raise ValueError('WWVB at 60 kHz uses the built-in tuner or an LF converter')
            if self.link is not None:
                self.configure(self.link, config, self.config)
            self.config = config

    def configure(self, link, new, previous):
        frequency, gain = new['frequency'], new['gain']
        old_frequency = previous.get('frequency')
        def tuned_hz(f):
            return f + self.lf_offset if f < 100_000 else f
        if frequency != old_frequency:
            hz = tuned_hz(frequency)
            direct = hz < 25_000_000
            if self.rtl and (old_frequency is None or direct != (tuned_hz(old_frequency) < 25_000_000)):
                self.command(link, 9, 2 if direct else 0)
            self.command(link, 1, hz)
        if self.rtl and ('gain' not in previous or gain != previous['gain']):
            self.command(link, 3, int(gain is not None))
            if gain is not None:
                self.command(link, 4, gain)


def env_int(name, default, minimum, maximum):
    value = int(os.environ.get(name, default))
    if not minimum <= value <= maximum:
        raise ValueError(f'{name} must be between {minimum} and {maximum}')
    return value


lf_offset = env_int('ORPHAN_NESDR_LF_OFFSET_HZ', 0, 0, 1_749_900_000)
if 0 < lf_offset < 100_000:
    raise ValueError('ORPHAN_NESDR_LF_OFFSET_HZ must be zero or at least 100000 Hz')
rx = Receiver('NESDR', 9123, 1_000 if lf_offset else 100_000, 1_750_000_000,
              rtl=True, lf_offset=lf_offset)
gpio_min = env_int('ORPHAN_GPIO_MIN_HZ', 1_000, 1, 4_294_967_295)
gpio = Receiver('GPIO I/Q', env_int('ORPHAN_GPIO_IQ_PORT', 0, 0, 65535), gpio_min,
                env_int('ORPHAN_GPIO_MAX_HZ', 49_000_000, gpio_min, 4_294_967_295))


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *args):
        pass

    def allowed_origin(self):
        origin = self.headers.get('Origin')
        host = self.headers.get('Host', '')
        if host and origin in ('http://' + host, 'http://' + urlsplit('//' + host).netloc.rsplit(':', 1)[0] + ':8000'):
            return origin
        return None

    def cors(self):
        self.send_header('Vary', 'Origin')
        if self.allowed_origin():
            self.send_header('Access-Control-Allow-Origin', self.allowed_origin())

    def route(self):
        return (gpio, self.path[5:]) if self.path.startswith('/gpio/') else (rx, self.path)

    def do_OPTIONS(self):
        _, path = self.route()
        self.send_response(204 if self.allowed_origin() and path == '/api' else 403)
        self.cors()
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def reply(self, code, payload, kind='application/json'):
        body = payload if isinstance(payload, bytes) else json.dumps(payload).encode()
        self.send_response(code)
        self.send_header('Content-Type', kind)
        self.send_header('Content-Length', str(len(body)))
        self.send_header('Cache-Control', 'no-store')
        self.cors()
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        receiver, path = self.route()
        if self.path == '/':
            self.reply(200, (ROOT / 'index.html').read_bytes(), 'text/html; charset=utf-8')
        elif path == '/api':
            self.reply(200, receiver.state())
        elif path in ('/decoder', '/decoder.png'):
            with receiver.lock:
                decoder = receiver.decoder
                image = path.endswith('.png')
                content = decoder.image() if decoder and image else decoder.status() if decoder else None
            if image and content:
                self.reply(200, content, 'image/png')
            else:
                self.reply(404 if image else 200, content or {})
        elif path in ('/stream', '/iq'):
            if self.headers.get('Origin') and not self.allowed_origin():
                self.reply(403, {'error':'Stream origin is not allowed'})
            else:
                self.relay(receiver, path == '/iq')
        else:
            self.reply(404, {'error': 'Unknown path'})

    def do_POST(self):
        try:
            receiver, path = self.route()
            if path != '/api' or self.headers.get_content_type() != 'application/json':
                raise ValueError('Expected a JSON tuner command')
            origin = self.headers.get('Origin')
            if origin and not self.allowed_origin():
                raise ValueError('Cross-origin tuner command')
            length = int(self.headers.get('Content-Length', '0'))
            if not 0 < length <= 1024:
                raise ValueError('Invalid command size')
            receiver.tune(json.loads(self.rfile.read(length)))
            self.reply(200, receiver.state())
        except (ValueError, TypeError) as exc:
            self.reply(400, {'error': str(exc)})
        except OSError:
            self.reply(503, {'error': 'Tuner link closed'})

    def relay(self, rx, raw):
        if not rx.port:
            self.reply(503, {'error': 'GPIO I/Q adapter is not configured'})
            return
        if not rx.stream.acquire(blocking=False):
            self.reply(409, {'error': f'{rx.label} is already streaming to another client.'})
            return
        context = None
        decoder = None
        started = False
        try:
            with socket.create_connection(('127.0.0.1', rx.port), timeout=3) as link, link.makefile('rb') as source:
                self.connection.settimeout(4)
                header = source.read(12)
                if len(header) != 12 or not header.startswith(b'RTL0'):
                    raise OSError('Unexpected rtl_tcp header')
                with rx.lock:
                    rx.command(link, 2, RATE)
                    rx.configure(link, rx.config, {})
                    rx.tuner = struct.unpack_from('>I', header, 4)[0]
                    rx.link = link
                self.send_response(200)
                self.send_header('Content-Type', 'application/octet-stream')
                self.send_header('Cache-Control', 'no-store')
                self.send_header('Connection', 'close')
                self.cors()
                self.end_headers()
                started = True
                pcm = (ctypes.c_int16 * (PAIRS // 5))()
                narrow = (ctypes.c_int16 * (2 * (PAIRS * 25 // 512 + 1)))()
                previous = None
                while True:
                    data = source.read(BYTES)
                    if len(data) != BYTES:
                        break
                    if raw:
                        self.wfile.write(data)
                        continue
                    with rx.lock:
                        config = rx.config.copy()
                    if config != previous:
                        if context:
                            DSP.receiver_free(context)
                        context = DSP.receiver_new()
                        if not context:
                            raise MemoryError('Cannot allocate demodulator')
                        if decoder:
                            with rx.lock:
                                rx.decoder = None
                            decoder.stop()
                            decoder = None
                        if config['decoder'] != 'off':
                            decoder = Decoder(config['mode'], config['decoder'])
                            with rx.lock:
                                rx.decoder = decoder
                        previous = config
                    DSP.receiver_audio(context, data, PAIRS, MODES.index(config['mode']), pcm)
                    if decoder:
                        count = DSP.decoder_iq(context, data, PAIRS, narrow)
                        try:
                            decoder.feed(bytes(narrow)[:count * 4])
                        except BrokenPipeError:
                            with rx.lock:
                                rx.decoder = None
                            decoder.stop()
                            decoder = None
                    self.wfile.write(data + bytes(pcm))
        except (OSError, MemoryError):
            if not started:
                message = 'Start rtl_tcp and the board tunnel.' if rx.rtl else 'Start the GPIO I/Q adapter on the board.'
                self.reply(503, {'error': message})
        finally:
            if context:
                DSP.receiver_free(context)
            with rx.lock:
                rx.link = None
                rx.tuner = None
                rx.decoder = None
            if decoder:
                decoder.stop()
            rx.stream.release()


if __name__ == '__main__':
    http.server.ThreadingHTTPServer(('', 8002), Handler).serve_forever()
