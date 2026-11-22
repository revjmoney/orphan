"""Check the demodulators with known tones, including opposite-sideband rejection."""
import cmath
import ctypes
import math
import sys

lib = ctypes.CDLL(sys.argv[1])
lib.receiver_new.restype = ctypes.c_void_p
lib.receiver_free.argtypes = [ctypes.c_void_p]
lib.receiver_free.restype = None
lib.receiver_audio.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_int,
                               ctypes.c_int, ctypes.POINTER(ctypes.c_int16)]
lib.receiver_audio.restype = None


def iq(source):
    result = bytearray()
    for n in range(25_000):
        z = source(n / 250_000)
        result.extend((round(127.5+z.real), round(127.5+z.imag)))
    return bytes(result)


def audio_level(mode, data, tone):
    ctx = lib.receiver_new()
    assert ctx
    pcm = (ctypes.c_int16 * (len(data)//10))()
    try:
        lib.receiver_audio(ctx, data, len(data)//2, mode, pcm)
    finally:
        lib.receiver_free(ctx)
    steady = list(pcm)[len(pcm)//2:]
    step = -2j * math.pi * tone / 50_000
    return abs(sum(value * cmath.exp(step * n) for n, value in enumerate(steady))) * 2 / len(steady)


wfm = iq(lambda t: 90 * cmath.exp(55j * math.sin(2*math.pi*1000*t)))
nfm = iq(lambda t: 90 * cmath.exp(2j * math.sin(2*math.pi*1000*t)))
am = iq(lambda t: complex(60 + 22 * math.sin(2*math.pi*1000*t)))
offset_am = iq(lambda t: (60 + 22*math.sin(2*math.pi*1000*t)) * cmath.exp(2j*math.pi*150*t))
upper = iq(lambda t: 35 * cmath.exp(2j*math.pi*1000*t))
lower = iq(lambda t: 35 * cmath.exp(-2j*math.pi*1000*t))
cw = iq(lambda t: complex(35))

for mode, source, tone in ((0, wfm, 1000), (1, nfm, 1000), (2, am, 1000), (5, cw, 700), (6, offset_am, 1000)):
    assert audio_level(mode, source, tone) > 2000
for mode, wanted, rejected in ((3, upper, lower), (4, lower, upper)):
    assert audio_level(mode, wanted, 1000) > 15 * max(1, audio_level(mode, rejected, 1000))
print('PASS WFM, NFM, AM, SAM, CW and USB/LSB sideband rejection')
