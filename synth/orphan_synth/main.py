# Orphan Synth v2: the ARM side of the 8-voice FPGA synth (JMSCNC, Rev. J. Money 2026, GPL-3 + attribution).
#
#   Web GUI + WebSocket on port 8000 (notes and knobs in, the synth's own audio out to the browser)
#   raw s16le mono audio on TCP 8001 (ffplay), local JSON-lines control on 127.0.0.1:8002 (term.py)
#   MIDI over LAN: RTP-MIDI / AppleMIDI on UDP 5004/5005 (advertised over mDNS by avahi), USB MIDI via aseqdump
#   velocity, pitch bend, mod wheel + CCs, sustain pedal, presets, an arpeggiator, LED light shows
import base64
import hashlib
import http.server
import json
import queue
import math
import os
import random
import shutil
import socketserver
import struct
import subprocess
import threading
import time

from blocks import Bus, require

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = 8000
FS = 48828.125
SLOT, LED_SLOT = 1, 14

bus = Bus()
if bus.rd(1, 27) != 0x53594E33:                  # the synth core's own ID register: "SYN3"
    raise SystemExit('The FPGA does not hold Orphan Synth v3 (SYN3). Load the orphan_synth project first.')
W = lambda i, v: bus.wr(SLOT, i, v)     # noqa: E731
R = lambda i: bus.rd(SLOT, i)           # noqa: E731
LW = lambda i, v: bus.wr(LED_SLOT, i, v)  # noqa: E731
lock = threading.RLock()


def step_for(seconds):
    """Envelope seconds (0 -> full scale) as a step per sample."""
    return max(1, min(0xFFFFFF, int((1 << 24) / max(1.0, float(seconds) * FS))))


# ---------------------------------------------------------------- parameters (name: register, default, kind)
LFO_SHAPES = ['triangle', 'sine', 'saw up', 'saw down', 'square', 'random']
MOD_SRCS = ['off', 'LFO1', 'LFO2', 'LFO1 x LFO2']
MOD_DSTS = ['none', 'pitch', 'cutoff', 'resonance', 'amp', 'pulse width', 'drive', 'crush']
DRIVE_SHAPES = ['off', 'soft', 'hard', 'fold']
PARAMS = {
    'saw': (1, 0.8, 'lvl'), 'pulse': (2, 0.0, 'lvl'), 'tri': (3, 0.0, 'lvl'),
    'sine': (4, 0.0, 'lvl'), 'sub': (5, 0.0, 'lvl'), 'noise': (6, 0.0, 'lvl'),
    'attack': (7, 0.01, 'time'), 'decay': (8, 0.30, 'time'), 'sustain': (9, 0.70, 'level'), 'release': (10, 0.25, 'time'),
    'f_attack': (11, 0.01, 'time'), 'f_decay': (12, 0.40, 'time'), 'f_sustain': (13, 0.30, 'level'),
    'f_release': (14, 0.30, 'time'),
    'cutoff': (15, 0.55, 'u16'), 'reso': (16, 0.30, 'res'), 'f_env': (17, 0.30, 's16'), 'f_mode': (30, 0, 'int'),
    'volume': (18, 0.80, 'vol'), 'pw': (31, 0.5, 'u16'),
    # LFOs + mod matrix (4 slots: source, destination, depth -1..1)
    'lfo1_rate': (19, 5.0, 'hz'), 'lfo2_rate': (20, 0.5, 'hz'), 'lfo1_shape': (21, 0, 'shape'), 'lfo2_shape': (21, 0, 'shape'),
    'mod1_src': (22, 0, 'slot'), 'mod1_dst': (22, 0, 'slot'), 'mod1_depth': (22, 0.0, 'slot'),
    'mod2_src': (23, 0, 'slot'), 'mod2_dst': (23, 0, 'slot'), 'mod2_depth': (23, 0.0, 'slot'),
    'mod3_src': (24, 0, 'slot'), 'mod3_dst': (24, 0, 'slot'), 'mod3_depth': (24, 0.0, 'slot'),
    'mod4_src': (25, 0, 'slot'), 'mod4_dst': (25, 0, 'slot'), 'mod4_depth': (25, 0.0, 'slot'),
    # drive + bitcrusher
    'drive': (64, 0.0, 'drive'), 'drive_shape': (64, 0, 'drive'),
    'crush_bits': (65, 16, 'crush'), 'crush_rate': (65, 1, 'crush'),
    # delay + looper (mixed in the FPGA; the buffers live in RAM in orphan-fxd)
    'dly_fb': (66, 0.35, 'u16'), 'dly_wet': (67, 0.0, 'u16'), 'dly_tone': (68, 0.75, 'u16'), 'loop_vol': (69, 0.9, 'u16'),
    'dly_time': (None, 0.375, 'fx'), 'dly_sync': (None, 'off', 'fx'), 'wobble': (None, 0.0, 'fx'),
    'loop_half': (None, 0, 'fx'), 'loop_rev': (None, 0, 'fx'), 'loop_decay': (None, 1.0, 'fx'),
    # ARM side only
    'vel_sens': (None, 0.6, 'arm'), 'bend_range': (None, 2, 'arm'),
}
FX_PARAMS = ('dly_time', 'dly_sync', 'wobble', 'dly_fb', 'dly_wet', 'dly_tone', 'loop_vol', 'loop_half', 'loop_rev',
             'loop_decay', 'volume', 'vel_sens', 'bend_range')
state = {k: v[1] for k, v in PARAMS.items()}
DRIVE_PRESETS = {'Off': ('off', 0.0), 'Warm': ('soft', 0.12), 'Crunch': ('hard', 0.3), 'Fuzz': ('hard', 0.6),
                 'Fold': ('fold', 0.45), 'Destroy': ('fold', 1.0)}
CRUSH_PRESETS = {'Clean': (16, 1), 'Lo-fi': (12, 2), '8-bit': (8, 3), 'Atari': (5, 6), 'Pulverize': (2, 16)}
SYNCS = {'off': None, '1/2': 2.0, '1/4': 1.0, '1/4T': 2 / 3, '1/8.': 0.75, '1/8': 0.5, '1/8T': 1 / 3, '1/16': 0.25}


def apply(name, val):
    reg, _, kind = PARAMS[name]
    state[name] = val
    c = lambda x: max(0.0, min(1.0, float(x)))  # noqa: E731
    with lock:
        if kind == 'lvl':
            W(reg, int(c(val) * 255))
        elif kind == 'time':
            W(reg, step_for(val))
        elif kind == 'level':
            W(reg, int(c(val) * 65535))
        elif kind == 'u16':
            W(reg, int(c(val) * 65535))
        elif kind == 's16':
            W(reg, int(max(-1.0, min(1.0, float(val))) * 32767) & 0xFFFF)
        elif kind == 'res':
            W(reg, int((1.0 - 0.97 * c(val)) * 2 * 32767) & 0xFFFF)
        elif kind == 'vol':
            W(reg, int(c(val) * 256))
        elif kind == 'hz':
            W(reg, int(max(0.01, min(40.0, float(val))) * (1 << 32) / FS) & 0xFFFFFFFF)
        elif kind == 'int':
            W(reg, int(val) & 3)
        elif kind == 'shape':
            W(21, (int(state['lfo1_shape']) & 7) | (int(state['lfo2_shape']) & 7) << 3)
        elif kind == 'slot':
            n = name[3]
            depth = int(max(-1.0, min(1.0, float(state['mod%s_depth' % n]))) * 32767) & 0xFFFF
            W(reg, (int(state['mod%s_src' % n]) & 3) | (int(state['mod%s_dst' % n]) & 7) << 4 | depth << 16)
        elif kind == 'drive':
            gain = int(256 * 256 ** c(state['drive']))
            W(64, min(65535, gain) | (int(state['drive_shape']) & 3) << 16)
        elif kind == 'crush':
            W(65, int(state['crush_bits']) & 31 | (int(state['crush_rate']) & 63) << 8)
        elif kind == 'fx':
            fx_push()


# ---------------------------------------------------------------- presets
PRESETS = {
    'Moog Bass': dict(saw=0.9, pulse=0.0, tri=0.0, sine=0.0, sub=0.7, noise=0.0, attack=0.003, decay=0.25, sustain=0.6,
                      release=0.12, f_attack=0.002, f_decay=0.22, f_sustain=0.15, f_release=0.15, cutoff=0.30, reso=0.55,
                      f_env=0.55, f_mode=0, vibrato=0.0, tremolo=0.0, pwm=0.0, f_lfo=0.0, lfo_rate=5.0, pw=0.5),
    'Ensoniq Pad': dict(saw=0.6, pulse=0.5, tri=0.0, sine=0.3, sub=0.0, noise=0.03, attack=0.9, decay=1.5, sustain=0.8,
                        release=1.8, f_attack=1.2, f_decay=2.0, f_sustain=0.4, f_release=1.5, cutoff=0.45, reso=0.25,
                        f_env=0.35, f_mode=0, vibrato=0.08, tremolo=0.0, pwm=0.6, f_lfo=0.1, lfo_rate=0.7, pw=0.5),
    'Casio Organ': dict(saw=0.0, pulse=0.0, tri=0.4, sine=0.9, sub=0.5, noise=0.0, attack=0.005, decay=0.1, sustain=1.0,
                        release=0.05, f_attack=0.01, f_decay=0.1, f_sustain=1.0, f_release=0.1, cutoff=1.0, reso=0.0,
                        f_env=0.0, f_mode=3, vibrato=0.12, tremolo=0.25, pwm=0.0, f_lfo=0.0, lfo_rate=6.5, pw=0.5),
    'Brass': dict(saw=0.9, pulse=0.3, tri=0.0, sine=0.0, sub=0.2, noise=0.0, attack=0.06, decay=0.4, sustain=0.75,
                  release=0.2, f_attack=0.08, f_decay=0.5, f_sustain=0.45, f_release=0.25, cutoff=0.35, reso=0.2,
                  f_env=0.5, f_mode=0, vibrato=0.1, tremolo=0.0, pwm=0.0, f_lfo=0.0, lfo_rate=5.5, pw=0.5),
    'Pluck': dict(saw=0.7, pulse=0.4, tri=0.0, sine=0.0, sub=0.0, noise=0.05, attack=0.002, decay=0.35, sustain=0.0,
                  release=0.3, f_attack=0.001, f_decay=0.15, f_sustain=0.0, f_release=0.2, cutoff=0.25, reso=0.45,
                  f_env=0.7, f_mode=0, vibrato=0.0, tremolo=0.0, pwm=0.0, f_lfo=0.0, lfo_rate=5.0, pw=0.3),
    'Acid': dict(saw=1.0, pulse=0.0, tri=0.0, sine=0.0, sub=0.0, noise=0.0, attack=0.002, decay=0.2, sustain=0.5,
                 release=0.08, f_attack=0.001, f_decay=0.12, f_sustain=0.0, f_release=0.1, cutoff=0.20, reso=0.85,
                 f_env=0.75, f_mode=0, vibrato=0.0, tremolo=0.0, pwm=0.0, f_lfo=0.0, lfo_rate=5.0, pw=0.5,
                 drive_shape=1, drive=0.25),
    'Hoover Sweep': dict(saw=0.8, pulse=0.6, tri=0.0, sine=0.0, sub=0.6, noise=0.0, attack=0.02, decay=0.5, sustain=0.8,
                         release=0.6, f_attack=0.3, f_decay=0.8, f_sustain=0.5, f_release=0.5, cutoff=0.5, reso=0.5,
                         f_env=0.3, f_mode=0, vibrato=0.25, tremolo=0.0, pwm=0.8, f_lfo=0.35, lfo_rate=2.0, pw=0.4),
    'Wind': dict(saw=0.0, pulse=0.0, tri=0.0, sine=0.0, sub=0.0, noise=0.9, attack=0.8, decay=1.0, sustain=0.9,
                 release=1.5, f_attack=0.5, f_decay=1.0, f_sustain=0.5, f_release=1.0, cutoff=0.5, reso=0.85,
                 f_env=0.0, f_mode=1, vibrato=0.0, tremolo=0.2, pwm=0.0, f_lfo=0.45, lfo_rate=0.3, pw=0.5),
    'Fuzz Lead': dict(saw=0.8, pulse=0.5, tri=0.0, sine=0.0, sub=0.4, noise=0.0, attack=0.01, decay=0.3, sustain=0.8,
                      release=0.3, f_attack=0.01, f_decay=0.4, f_sustain=0.5, f_release=0.3, cutoff=0.55, reso=0.35,
                      f_env=0.3, f_mode=0, vibrato=0.06, tremolo=0.0, pwm=0.0, f_lfo=0.0, lfo_rate=5.5, pw=0.5,
                      drive_shape=2, drive=0.6),
    'Wavefold Growl': dict(saw=0.4, pulse=0.0, tri=0.9, sine=0.0, sub=0.5, noise=0.0, attack=0.005, decay=0.4,
                           sustain=0.7, release=0.2, f_attack=0.005, f_decay=0.3, f_sustain=0.4, f_release=0.2,
                           cutoff=0.7, reso=0.3, f_env=0.2, f_mode=0, vibrato=0.0, tremolo=0.0, pwm=0.0, f_lfo=0.0,
                           lfo_rate=0.4, pw=0.5, drive_shape=3, drive=0.55, mods=[(1, 6, 0.6)]),
    '8-bit Chip': dict(saw=0.0, pulse=0.9, tri=0.0, sine=0.0, sub=0.0, noise=0.0, attack=0.002, decay=0.15, sustain=0.6,
                       release=0.08, f_attack=0.01, f_decay=0.1, f_sustain=1.0, f_release=0.1, cutoff=1.0, reso=0.0,
                       f_env=0.0, f_mode=3, vibrato=0.05, tremolo=0.0, pwm=0.0, f_lfo=0.0, lfo_rate=7.0, pw=0.25,
                       crush_bits=5, crush_rate=4),
}
state['preset'] = ''
OLD_MODS = (('vibrato', 1, 0.5), ('tremolo', 4, 1.0), ('pwm', 5, 1.0), ('f_lfo', 2, 1.0))


def load_preset(name):
    p = dict(PRESETS.get(name, {}))
    if not p:
        return
    # the v2 LFO knobs become mod-matrix slots from LFO1
    mods = list(p.pop('mods', []))
    for key, dst, scale in OLD_MODS:
        v = float(p.pop(key, 0.0))
        if v:
            mods.append((1, dst, v * scale))
    p['lfo1_rate'] = p.pop('lfo_rate', 5.0)
    p.setdefault('lfo1_shape', 0)
    p.setdefault('drive_shape', 0)
    p.setdefault('drive', 0.0)
    p.setdefault('crush_bits', 16)
    p.setdefault('crush_rate', 1)
    for i in range(4):
        srcv, dstv, depth = mods[i] if i < len(mods) else (0, 0, 0.0)
        p['mod%d_src' % (i + 1)], p['mod%d_dst' % (i + 1)], p['mod%d_depth' % (i + 1)] = srcv, dstv, depth
    for k, v in p.items():
        if k in PARAMS:
            state[k] = v
    for k in p:
        if k in PARAMS:
            apply(k, state[k])
    state['preset'] = name


# ---------------------------------------------------------------- orphan-fxd: the delay line + looper in RAM
FXD_SRC = os.path.join(HERE, 'fxd.c')
FXD_BIN = os.path.join(HERE, 'orphan-fxd')
SHM = '/dev/shm/orphan_fx'
SHM_FMT = '<IiffIiiifiiiiIIIIi'
LOOP_CMDS = {'pedal': 1, 'stop': 2, 'play': 3, 'clear': 4, 'undo': 5, 'save': 6}
LOOP_STATES = ['empty', 'recording', 'playing', 'overdub', 'stopped']
fx = {'proc': None, 'mm': None}


def fx_start():
    import mmap
    try:
        if not os.path.exists(FXD_BIN) or os.path.getmtime(FXD_BIN) < os.path.getmtime(FXD_SRC):
            subprocess.run(['gcc', '-O2', '-o', FXD_BIN, FXD_SRC, '-lm'], check=True)
        fd = os.open(SHM, os.O_RDWR | os.O_CREAT, 0o644)
        os.ftruncate(fd, struct.calcsize(SHM_FMT))
        fx['mm'] = mmap.mmap(fd, struct.calcsize(SHM_FMT))
        os.close(fd)
        fx['proc'] = subprocess.Popen([FXD_BIN])
        time.sleep(0.3)
        if fx['proc'].poll() is not None:
            raise RuntimeError('orphan-fxd exited')
        fx_push()
        return True
    except Exception as e:  # noqa: BLE001
        print('fx: delay/looper not available:', e)
        return False


def fx_fields():
    if not fx['mm']:
        return None
    return list(struct.unpack_from(SHM_FMT, fx['mm'], 0))


def fx_push(cmd=None):
    f = fx_fields()
    if f is None:
        return
    secs = float(state['dly_time'])
    sync = SYNCS.get(state['dly_sync'])
    if sync:
        secs = 60.0 / max(20.0, arp.bpm) * sync
    f[0] = 0x3158464F
    f[1] = int(max(0.05, min(20.0, secs)) * FS)
    f[2] = float(state['wobble']) * 0.015 * FS              # up to 15 ms of tape wobble
    f[3] = 0.6
    f[6], f[7] = int(float(state['loop_half'])), int(float(state['loop_rev']))
    f[8] = float(state['loop_decay'])
    if cmd:
        f[5] = LOOP_CMDS[cmd]
        f[4] = (f[4] + 1) & 0xFFFFFFFF
    struct.pack_into(SHM_FMT, fx['mm'], 0, *f)


def fx_status():
    f = fx_fields()
    if f is None or fx['proc'] is None or fx['proc'].poll() is not None:
        return {'ok': False}
    return {'ok': True, 'state': LOOP_STATES[f[10]] if 0 <= f[10] < 5 else '?', 'len': round(f[11] / FS, 3),
            'pos': round(f[12] / FS, 3), 'underruns': f[13], 'resyncs': f[15],
            'saved': f[16] == f[4] and f[5] == 6}


def fx_status_loop():
    last = None
    while True:
        st = fx_status()
        key = (st.get('state'), st.get('len'), st.get('ok'), st.get('saved'))
        if st.get('state') in ('recording', 'playing', 'overdub') or key != last:
            msg = json.dumps({'fx': st}).encode()
            with clients_lock:
                cs = list(clients)
            for c in cs:
                try:
                    ws_send(c, msg, opcode=1)
                except OSError:
                    pass
            last = key
        time.sleep(0.2)


# ---------------------------------------------------------------- voices
voice_note = [None] * 8          # MIDI note sounding on each voice
voice_age = [0.0] * 8
held = {}                        # note -> voice
bend = 0.0                       # semitones
pedal = False
pedal_held = set()               # notes released while the pedal is down


def inc_for(note):
    f = 440.0 * 2 ** ((note + bend - 69) / 12.0)
    return int(f * (1 << 32) / FS) & 0xFFFFFFFF


def gain_for(vel):
    s = float(state['vel_sens'])
    return int(65535 * (1.0 - s * (1.0 - max(1, min(127, vel)) / 127.0)))


def voice_on(note, vel=100):
    with lock:
        if note in held:
            v = held[note]
        else:
            free = [v for v in range(8) if voice_note[v] is None and not (R(28) >> v) & 1]
            v = free[0] if free else min(range(8), key=lambda k: voice_age[k])      # steal the oldest
            if voice_note[v] is not None:
                held.pop(voice_note[v], None)
        base = 32 + 4 * v
        W(base, inc_for(note))
        W(base + 2, gain_for(vel))
        W(base + 1, 0)
        W(base + 1, 1)
        voice_note[v], voice_age[v], held[note] = note, time.time(), v
    leds_note(note, vel)


def voice_off(note):
    with lock:
        v = held.pop(note, None)
        if v is not None:
            W(32 + 4 * v + 1, 0)
            voice_note[v] = None


def set_bend(semitones):
    global bend
    with lock:
        bend = semitones
        for v in range(8):
            if voice_note[v] is not None:
                W(32 + 4 * v, inc_for(voice_note[v]))


def all_off():
    global pedal
    with lock:
        pedal = False
        pedal_held.clear()
        arp.keys.clear()
        arp.latched.clear()
        for n in list(held):
            voice_off(n)
        for v in range(8):
            W(32 + 4 * v + 1, 0)
            voice_note[v] = None


# notes from keys / MIDI go through here (the arpeggiator takes them when it is on)
def note_on(note, vel=100):
    if arp.on:
        arp.key_down(note, vel)
    else:
        pedal_held.discard(note)
        voice_on(note, vel)


def note_off(note):
    if arp.on:
        arp.key_up(note)
    elif pedal:
        pedal_held.add(note)
    else:
        voice_off(note)


def set_pedal(down):
    global pedal
    pedal = down
    if not down:
        for n in list(pedal_held):
            voice_off(n)
        pedal_held.clear()


# ---------------------------------------------------------------- arpeggiator
DIVS = {'1/4': 1.0, '1/8': 0.5, '1/8T': 1 / 3, '1/16': 0.25, '1/16T': 1 / 6, '1/32': 0.125}
ARP_MODES = ['up', 'down', 'up-down', 'down-up', 'random', 'as played', 'chord', 'converge', 'pinky']


class Arp:
    def __init__(self):
        self.on = False
        self.mode, self.octaves, self.bpm, self.div = 'up', 1, 120.0, '1/16'
        self.gate, self.swing, self.latch, self.ratchet = 0.5, 0.0, False, 1
        self.oct_jump, self.skip, self.transpose = 0.0, 0.0, 0
        self.keys = {}               # held keys: note -> velocity, in the order pressed
        self.latched = {}            # notes kept by latch
        self.pos, self.dir, self.step_no = 0, 1, 0
        self.sounding = []           # notes the arp is sounding now
        threading.Thread(target=self.run, daemon=True).start()

    def key_down(self, note, vel):
        if self.latch and not self.keys:      # a new chord replaces the latched one
            self.latched = {}
        self.keys[note] = vel
        if self.latch:
            self.latched[note] = vel

    def key_up(self, note):
        self.keys.pop(note, None)

    def notes(self):
        src = self.latched if self.latch else self.keys
        base = list(src.items())
        if self.mode != 'as played':
            base.sort()
        seq = []
        for o in range(self.octaves):
            seq += [(n + 12 * o + self.transpose, v) for n, v in base]
        return seq

    def pattern(self, seq):
        n = len(seq)
        if self.mode in ('up', 'as played'):
            return seq
        if self.mode == 'down':
            return seq[::-1]
        if self.mode == 'up-down':
            return seq + seq[-2:0:-1]
        if self.mode == 'down-up':
            r = seq[::-1]
            return r + r[-2:0:-1]
        if self.mode == 'converge':           # outside in: low, high, 2nd low, 2nd high ...
            out, lo, hi = [], 0, n - 1
            while lo <= hi:
                out.append(seq[lo])
                if lo != hi:
                    out.append(seq[hi])
                lo, hi = lo + 1, hi - 1
            return out
        if self.mode == 'pinky':              # lowest note between every other note
            return [x for s in seq[1:] for x in (seq[0], s)] or seq
        return seq

    def set(self, **kw):
        for k, v in kw.items():
            if k == 'on':
                self.on = bool(v)
                if not self.on:
                    self.release()
                    self.latched = {}
            elif k in ('octaves', 'ratchet', 'transpose'):
                setattr(self, k, int(v))
            elif k in ('bpm', 'gate', 'swing', 'oct_jump', 'skip'):
                setattr(self, k, float(v))
            elif k == 'latch':
                self.latch = bool(v)
                if not self.latch:
                    self.latched = {}
            elif k == 'mode' and v in ARP_MODES:
                self.mode = v
            elif k == 'div' and v in DIVS:
                self.div = v

    def release(self):
        for n in self.sounding:
            voice_off(n)
        self.sounding = []

    def state(self):
        return dict(on=self.on, mode=self.mode, octaves=self.octaves, bpm=self.bpm, div=self.div, gate=self.gate,
                    swing=self.swing, latch=self.latch, ratchet=self.ratchet, oct_jump=self.oct_jump, skip=self.skip,
                    transpose=self.transpose)

    def run(self):
        nxt = time.monotonic()
        while True:
            beat = 60.0 / max(20.0, self.bpm)
            step_len = beat * DIVS[self.div] * 4 / 4 if self.div.startswith('1/4') else beat * DIVS[self.div] * 4 / 4
            step_len = beat * DIVS[self.div] * 4                  # DIVS are fractions of a whole note
            step_len /= 4                                         # ... and a beat is a quarter note
            # swing: even steps late, odd steps early
            sw = self.swing * step_len * 0.5
            dur = step_len + (sw if self.step_no % 2 == 0 else -sw)
            seq = self.pattern(self.notes()) if self.on else []
            if not seq:
                self.release()
                self.pos = 0
                nxt = time.monotonic() + 0.01
                time.sleep(0.01)
                continue
            if self.mode == 'chord':
                chord = seq
            elif self.mode == 'random':
                chord = [random.choice(seq)]
            else:
                self.pos %= len(seq)
                chord = [seq[self.pos]]
                self.pos += 1
            self.step_no += 1
            play = random.random() >= self.skip
            if play and self.oct_jump and random.random() < self.oct_jump:
                chord = [(n + 12 * random.choice((-1, 1, 2)), v) for n, v in chord]
            r = max(1, self.ratchet)
            sub = dur / r
            for k in range(r):
                if play:
                    self.release()
                    for n, vel in chord:
                        if 0 <= n < 128:
                            voice_on(n, vel)
                            self.sounding.append(n)
                    front_beat(self.step_no % 4 == 1 and k == 0)
                time.sleep(max(0.0, min(sub * self.gate, sub - 0.004)))
                if play:
                    self.release()
                rest = sub - sub * self.gate
                nxt += sub
                time.sleep(max(0.0, nxt - time.monotonic()))
                _ = rest


arp = Arp()


# ---------------------------------------------------------------- LEDs: D5..D8 (FPGA PWM) + the front LED (ARM)
LED_SHOWS = {           # SOURCE register: 4 bits per LED (0 manual 1 flash 2 voices 3 VU bar 4 LFO 5 LFO inv 6 VU 7 off)
    'voices': 0x2222, 'vu meter': 0x3333, 'breathe': 0x4545, 'pulse': 0x6666, 'notes': 0x1111, 'chase': 0x1111,
    'sparkle': 0x1111, 'off': 0x7777,
}
state['leds'] = 'voices'
state['front'] = 1               # front LED: green = note / arp step, red = downbeat, ps = something sounding
chase_pos = [0]
try:
    from ardzy import led as front_led
except ImportError:
    front_led = None
sdleds_stopped = [False]


def set_leds(show):
    if show not in LED_SHOWS:
        return
    state['leds'] = show
    with lock:
        LW(6, 6 if show != 'chase' else 3)
        LW(1, LED_SHOWS[show])


def leds_note(note, vel):
    """Per-note flashes for the flash-based shows."""
    show = state['leds']
    lvl = min(255, 60 + vel * 3)
    with lock:
        if show == 'notes':
            LW(2 + note % 4, lvl)
        elif show == 'sparkle':
            LW(2 + random.randrange(4), lvl)
        elif show == 'chase':
            chase_pos[0] = (chase_pos[0] + 1) % 6
            LW(2 + (0, 1, 2, 3, 2, 1)[chase_pos[0]], 255)
    if state['front'] and front_led:
        front_on('green')


def front_on(name, ms=40):
    if not front_led:
        return
    if not sdleds_stopped[0]:
        subprocess.run(['systemctl', 'stop', 's9-sdleds'], stderr=subprocess.DEVNULL)
        sdleds_stopped[0] = True
    try:
        front_led(name, True)
        threading.Timer(ms / 1000.0, front_led, args=(name, False)).start()
    except Exception:  # noqa: BLE001
        pass


def front_beat(downbeat):
    if state['front'] and downbeat:
        front_on('red', 60)


def ps_led_loop():
    last = None
    while True:
        on = bool(state['front']) and bool(R(28))
        if on != last and front_led:
            try:
                front_led('ps', on)
            except Exception:  # noqa: BLE001
                pass
            last = on
        time.sleep(0.05)


# ---------------------------------------------------------------- MIDI messages (RTP-MIDI and USB share this)
CC_MAP = {1: 'mod4_depth', 74: 'cutoff', 71: 'reso', 7: 'volume', 73: 'attack', 72: 'release', 76: 'lfo1_rate',
          75: 'f_env'}   # mod wheel (CC1) = vibrato through mod slot 4


def midi_bytes(status, data):
    hi = status & 0xF0
    if hi == 0x90 and len(data) == 2 and data[1] > 0:
        note_on(data[0], data[1])
    elif (hi == 0x80 or hi == 0x90) and len(data) == 2:
        note_off(data[0])
    elif hi == 0xE0 and len(data) == 2:
        set_bend(((data[1] << 7 | data[0]) - 8192) / 8192.0 * float(state['bend_range']))
    elif hi == 0xB0 and len(data) == 2:
        cc, val = data
        if cc == 64:
            set_pedal(val >= 64)
        elif cc in (120, 123):
            all_off()
        elif cc in CC_MAP:
            p, x = CC_MAP[cc], val / 127.0
            if p in ('attack', 'release'):
                x = 0.002 + 2.0 * x * x
            elif p == 'lfo1_rate':
                x = 0.1 + 15.0 * x * x
            elif p == 'f_env':
                x = 2 * x - 1
            elif p == 'mod4_depth':
                x = 0.5 * x
                state['mod4_src'], state['mod4_dst'] = 1, 1     # LFO1 -> pitch
            apply(p, x)
            broadcast_state()


# ---------------------------------------------------------------- one message format for web, terminal and tests
def handle_msg(m):
    if m.get('on') is not None:
        note_on(int(m['on']), int(m.get('vel', 100)))
    elif m.get('off') is not None:
        note_off(int(m['off']))
    elif m.get('param') in PARAMS:
        val = m['value']
        if m['param'] != 'dly_sync':
            val = float(val)
        elif val not in SYNCS:
            return
        apply(m['param'], val)
        if m['param'] not in FX_PARAMS:
            state['preset'] = ''
    elif m.get('preset') in PRESETS:
        load_preset(m['preset'])
        broadcast_state()
    elif m.get('arp') is not None:
        arp.set(**m['arp'])
        if state['dly_sync'] != 'off':
            fx_push()                               # a tempo-synced echo follows the arp tempo
        broadcast_state()
    elif m.get('leds') is not None:
        set_leds(m['leds'])
        broadcast_state()
    elif m.get('front') is not None:
        state['front'] = int(m['front'])
        broadcast_state()
    elif m.get('bend') is not None:
        set_bend(float(m['bend']))
    elif m.get('loop') in LOOP_CMDS:
        fx_push(m['loop'])
    elif m.get('drive_preset') in DRIVE_PRESETS:
        shape, amt = DRIVE_PRESETS[m['drive_preset']]
        state['drive_shape'], state['drive'] = DRIVE_SHAPES.index(shape), amt
        apply('drive', amt)
        broadcast_state()
    elif m.get('crush_preset') in CRUSH_PRESETS:
        state['crush_bits'], state['crush_rate'] = CRUSH_PRESETS[m['crush_preset']]
        apply('crush_bits', state['crush_bits'])
        broadcast_state()
    elif m.get('panic'):
        all_off()


def full_state():
    return {'state': state, 'arp': arp.state(), 'fs': FS, 'presets': list(PRESETS), 'arp_modes': ARP_MODES,
            'divs': list(DIVS), 'leds': list(LED_SHOWS), 'lfo_shapes': LFO_SHAPES, 'mod_srcs': MOD_SRCS,
            'mod_dsts': MOD_DSTS, 'drive_shapes': DRIVE_SHAPES, 'drive_presets': list(DRIVE_PRESETS),
            'crush_presets': list(CRUSH_PRESETS), 'syncs': list(SYNCS), 'fx': fx_status()}


# ---------------------------------------------------------------- WebSocket (stdlib only)
clients = {}                     # socket -> send lock
clients_lock = threading.Lock()


def ws_frame(payload, opcode=2):
    n = len(payload)
    return bytes([0x80 | opcode]) + (bytes([n]) if n < 126 else bytes([126]) + struct.pack('>H', n) if n < 65536
                                     else bytes([127]) + struct.pack('>Q', n)) + payload


def ws_send(sock, payload, opcode=2):
    """Queue a frame for one client. Each client has its own sender thread, so a slow or stuck browser
    only loses its own frames and never stalls the audio loop (or the other listeners)."""
    q = clients.get(sock)
    if q is None:
        raise OSError('client gone')
    try:
        q.put_nowait(ws_frame(payload, opcode))
    except queue.Full:
        pass                                    # this client is behind: drop the frame


def ws_sender(sock, q):
    try:
        while True:
            f = q.get()
            if f is None:
                return
            sock.sendall(f)
    except OSError:
        pass
    finally:
        with clients_lock:
            clients.pop(sock, None)


def broadcast_state():
    msg = json.dumps(full_state()).encode()
    with clients_lock:
        cs = list(clients)
    for c in cs:
        try:
            ws_send(c, msg, opcode=1)
        except OSError:
            pass


def ws_recv(rf):
    b = rf.read(2)
    if len(b) < 2:
        return None, None
    op, n = b[0] & 0x0F, b[1] & 0x7F
    if n == 126:
        n = struct.unpack('>H', rf.read(2))[0]
    elif n == 127:
        n = struct.unpack('>Q', rf.read(8))[0]
    mask = rf.read(4) if b[1] & 0x80 else b'\0\0\0\0'
    data = bytes(c ^ mask[i % 4] for i, c in enumerate(rf.read(n)))
    return op, data


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def do_GET(self):
        if self.path.startswith('/ws') and self.headers.get('Upgrade', '').lower() == 'websocket':
            key = self.headers['Sec-WebSocket-Key']
            acc = base64.b64encode(hashlib.sha1((key + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11').encode()).digest())
            self.send_response(101)
            self.send_header('Upgrade', 'websocket')
            self.send_header('Connection', 'Upgrade')
            self.send_header('Sec-WebSocket-Accept', acc.decode())
            self.end_headers()
            self.wfile.flush()
            sock = self.connection
            q = queue.Queue(maxsize=64)
            with clients_lock:
                clients[sock] = q
            threading.Thread(target=ws_sender, args=(sock, q), daemon=True).start()
            ws_send(sock, json.dumps(full_state()).encode(), opcode=1)
            try:
                while True:
                    op, data = ws_recv(self.rfile)
                    if op is None or op == 8:
                        break
                    if op == 1:
                        handle_msg(json.loads(data))
            except (OSError, ValueError):
                pass
            finally:
                with clients_lock:
                    q = clients.pop(sock, None)
                if q is not None:
                    q.put(None)
            return
        if self.path.startswith('/loop.wav') and os.path.exists('/tmp/orphan_loop.wav'):
            body = open('/tmp/orphan_loop.wav', 'rb').read()
            self.send_response(200)
            self.send_header('Content-Type', 'audio/wav')
            self.send_header('Content-Disposition', 'attachment; filename="orphan_loop.wav"')
            self.send_header('Content-Length', str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return
        page = 'index.html' if self.path in ('/', '/index.html') else None
        if not page:
            self.send_error(404)
            return
        body = open(os.path.join(HERE, page), 'rb').read()
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)


class Server(socketserver.ThreadingMixIn, http.server.HTTPServer):
    daemon_threads = True
    allow_reuse_address = True


# ---------------------------------------------------------------- audio to the browsers and to TCP 8001
#   ffplay -nodisp -f s16le -ar 48828 -ch_layout mono -fflags nobuffer tcp://<board>:8001
raw_clients = set()
raw_lock = threading.Lock()


def audio_pump():
    """Drain the FPGA capture buffer; send ~20 ms chunks of int16 mono to every browser and raw listener."""
    buf = bytearray()
    while True:
        with lock:
            n = R(26)
            vals = [R(25) for _ in range(n)]
        if vals:
            buf += struct.pack('<%dh' % len(vals), *[x - (1 << 32) if x & 0x80000000 else x for x in vals])
        if len(buf) >= 2048:
            with clients_lock:
                cs = list(clients)
            for c in cs:
                try:
                    ws_send(c, bytes(buf))
                except OSError:
                    with clients_lock:
                        clients.pop(c, None)
            with raw_lock:
                rs = list(raw_clients)
            for c in rs:
                try:
                    c.sendall(bytes(buf))
                except OSError:
                    with raw_lock:
                        raw_clients.discard(c)
                    c.close()
            buf = bytearray()
        time.sleep(0.01)


def raw_audio_server():
    import socket
    srv = socket.socket()
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind(('', 8001))
    srv.listen(4)
    while True:
        c, _ = srv.accept()
        c.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        with raw_lock:
            raw_clients.add(c)


# ---------------------------------------------------------------- local control on 127.0.0.1:8002 (term.py)
def control_server():
    import socket
    srv = socket.socket()
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind(('127.0.0.1', 8002))
    srv.listen(4)

    def serve(c):
        f = c.makefile('rw')
        f.write(json.dumps(full_state()) + '\n')
        f.flush()
        for line in f:
            try:
                m = json.loads(line)
                if m.get('get'):
                    f.write(json.dumps(full_state()) + '\n')
                    f.flush()
                else:
                    handle_msg(m)
            except (ValueError, KeyError, TypeError):
                pass
        c.close()
    while True:
        c, _ = srv.accept()
        threading.Thread(target=serve, args=(c,), daemon=True).start()


# ---------------------------------------------------------------- MIDI over LAN: RTP-MIDI / AppleMIDI on UDP 5004 + 5005
# Windows: rtpMIDI (Tobias Erichsen, needs Apple Bonjour), macOS: Audio MIDI Setup > Network.
# The board is advertised over mDNS (avahi) as "Orphan Synth"; or add it by hand: <board ip>, port 5004.
MIDI_PORT = 5004
MIDI_NAME = b'Orphan Synth'
MY_SSRC = struct.unpack('>I', os.urandom(4))[0]


def rtp_midi_commands(buf, z):
    """Walk an RTP-MIDI command list (RFC 6295): delta times, running status, sysex skipped."""
    i, first, running = 0, True, None
    while i < len(buf):
        if z or not first:
            while i < len(buf) and buf[i] & 0x80:
                i += 1
            i += 1
        first = False
        if i >= len(buf):
            return
        b = buf[i]
        if b & 0x80:
            status = b
            i += 1
            if b < 0xF0:
                running = b
        else:
            status = running
        if status is None:
            return
        if status in (0xF0, 0xF7):
            while i < len(buf) and buf[i] not in (0xF7, 0xF0, 0xF4):
                i += 1
            i += 1
            continue
        if status >= 0xF8:
            continue
        hi = status & 0xF0
        n = 1 if hi in (0xC0, 0xD0) else 2 if hi < 0xF0 else {0xF1: 1, 0xF2: 2, 0xF3: 1}.get(status, 0)
        yield status, buf[i:i + n]
        i += n


def rtp_midi():
    import socket
    ctl, dat = socket.socket(socket.AF_INET, socket.SOCK_DGRAM), socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    ctl.bind(('', MIDI_PORT))
    dat.bind(('', MIDI_PORT + 1))
    t0 = time.time()

    def answer(sock, pkt, addr):
        if pkt[2:4] == b'IN':                       # invitation -> accept
            sock.sendto(b'\xff\xffOK' + pkt[4:12] + struct.pack('>I', MY_SSRC) + MIDI_NAME + b'\0', addr)
            if sock is ctl:
                print('midi: RTP-MIDI session from %s (%s)' % (addr[0], pkt[16:].split(b'\0')[0].decode(errors='replace')))
        elif pkt[2:4] == b'CK' and len(pkt) >= 36:  # clock sync
            count = pkt[8]
            now = int((time.time() - t0) * 10000)
            ts = list(struct.unpack('>QQQ', pkt[12:36]))
            if count == 0:
                ts[1] = now
            elif count == 1:
                ts[2] = now
            else:
                return
            sock.sendto(b'\xff\xffCK' + struct.pack('>IB3x', MY_SSRC, count + 1) + struct.pack('>QQQ', *ts), addr)
        elif pkt[2:4] == b'BY':
            print('midi: RTP-MIDI session from %s ended' % addr[0])
            all_off()

    def loop(sock):
        while True:
            pkt, addr = sock.recvfrom(2048)
            try:
                if pkt[:2] == b'\xff\xff':
                    answer(sock, pkt, addr)
                elif sock is dat and len(pkt) > 13 and (pkt[0] & 0xC0) == 0x80:
                    h = pkt[12]
                    if h & 0x80:                    # B: 12-bit length
                        n, off = ((h & 0x0F) << 8) | pkt[13], 14
                    else:
                        n, off = h & 0x0F, 13
                    for st, d in rtp_midi_commands(pkt[off:off + n], bool(h & 0x20)):
                        midi_bytes(st, d)
            except (IndexError, struct.error):
                pass
    threading.Thread(target=loop, args=(ctl,), daemon=True).start()
    loop(dat)


# ---------------------------------------------------------------- USB / ALSA MIDI (any ALSA MIDI input via aseqdump)
def midi_in():
    if not shutil.which('aseqdump'):
        print('midi: install alsa-utils for USB MIDI keyboards')
        return
    while True:
        ports = subprocess.run(['aseqdump', '-l'], capture_output=True, text=True).stdout.splitlines()[1:]
        ports = [p.split()[0] for p in ports if p.strip() and not p.split()[0].startswith(('0:', '14:'))]
        if not ports:
            time.sleep(5)
            continue
        print('midi: listening on', ports)
        p = subprocess.Popen(['aseqdump'] + sum([['-p', x] for x in ports], []), stdout=subprocess.PIPE, text=True)
        for line in p.stdout:
            parts = [s.strip(' ,') for s in line.split()]
            try:
                if 'Note' in line and 'note' in parts:
                    note = int(parts[parts.index('note') + 1])
                    vel = int(parts[parts.index('velocity') + 1]) if 'velocity' in parts else 0
                    midi_bytes(0x90 if ('on' in parts and vel > 0) else 0x80, bytes([note, vel]))
                elif 'Control' in line and 'controller' in parts:
                    cc = int(parts[parts.index('controller') + 1])
                    val = int(parts[parts.index('value') + 1])
                    midi_bytes(0xB0, bytes([cc, val]))
                elif 'Pitch' in line and 'value' in parts:
                    val = int(parts[parts.index('value') + 1]) + 8192
                    midi_bytes(0xE0, bytes([val & 0x7F, val >> 7 & 0x7F]))
            except (ValueError, IndexError):
                pass
        time.sleep(2)


if __name__ == '__main__':
    with lock:
        W(0, 0b11)                                  # sound + capture on
    for k in PARAMS:
        if PARAMS[k][0] is not None:
            apply(k, state[k])
    if fx_start():
        with lock:
            W(0, 0b111)                             # + delay / looper streams
        print('fx: orphan-fxd running (long delay + looper in RAM)')
    load_preset('Moog Bass')
    set_leds(state['leds'])
    for t in (audio_pump, midi_in, rtp_midi, raw_audio_server, control_server, ps_led_loop, fx_status_loop):
        threading.Thread(target=t, daemon=True).start()
    ip = subprocess.run(['hostname', '-I'], capture_output=True, text=True).stdout.split()[0]
    print('Orphan Synth: open http://%s:%d in a browser' % (ip, PORT))
    print('Hear it on your PC: ffplay -nodisp -f s16le -ar 48828 -ch_layout mono -fflags nobuffer tcp://%s:8001' % ip,
          flush=True)
    try:
        Server(('', PORT), Handler).serve_forever()
    finally:
        if fx['proc']:
            fx['proc'].terminate()
        if sdleds_stopped[0]:
            subprocess.run(['systemctl', 'start', 's9-sdleds'], stderr=subprocess.DEVNULL)
