"""Orphan Games, Commodore 64: system ROMs, programs and keys for orphan_c64.
 - system ROMs: Commodore's ROMs are NOT part of Orphan. The board owner puts their own in <roms>/system:
   basic.rom (8 KB), kernal.rom (8 KB), chargen.rom (4 KB) (the usual VICE / MiSTer file names work too).
 - programs: .prg files (2-byte load address, then the bytes) go straight into RAM; a BASIC program (loaded at
   $0801) gets its pointers set and RUN typed for it.
 - keys: the browser's KeyboardEvent.code -> a PS/2 set-2 scan code (extended, code) for the core's keyboard matrix.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os

PALETTE = [0x000000, 0xFFFFFF, 0x68372B, 0x70A4B2, 0x6F3D86, 0x588D43, 0x352879, 0xB8C76F,
           0x6F4F25, 0x433900, 0x9A6759, 0x444444, 0x6C6C6C, 0x9AD284, 0x6C5EB5, 0x959595]   # VIC-II colours

PS2 = {'KeyA': 0x1C, 'KeyB': 0x32, 'KeyC': 0x21, 'KeyD': 0x23, 'KeyE': 0x24, 'KeyF': 0x2B, 'KeyG': 0x34,
       'KeyH': 0x33, 'KeyI': 0x43, 'KeyJ': 0x3B, 'KeyK': 0x42, 'KeyL': 0x4B, 'KeyM': 0x3A, 'KeyN': 0x31,
       'KeyO': 0x44, 'KeyP': 0x4D, 'KeyQ': 0x15, 'KeyR': 0x2D, 'KeyS': 0x1B, 'KeyT': 0x2C, 'KeyU': 0x3C,
       'KeyV': 0x2A, 'KeyW': 0x1D, 'KeyX': 0x22, 'KeyY': 0x35, 'KeyZ': 0x1A,
       'Digit0': 0x45, 'Digit1': 0x16, 'Digit2': 0x1E, 'Digit3': 0x26, 'Digit4': 0x25, 'Digit5': 0x2E,
       'Digit6': 0x36, 'Digit7': 0x3D, 'Digit8': 0x3E, 'Digit9': 0x46,
       'Backquote': 0x0E, 'Minus': 0x4E, 'Equal': 0x55, 'Backspace': 0x66, 'Tab': 0x0D, 'BracketLeft': 0x54,
       'BracketRight': 0x5B, 'Backslash': 0x5D, 'CapsLock': 0x58, 'Semicolon': 0x4C, 'Quote': 0x52, 'Enter': 0x5A,
       'ShiftLeft': 0x12, 'ShiftRight': 0x59, 'ControlLeft': 0x14, 'AltLeft': 0x11, 'Space': 0x29, 'Comma': 0x41,
       'Period': 0x49, 'Slash': 0x4A, 'Escape': 0x76, 'F1': 0x05, 'F2': 0x06, 'F3': 0x04, 'F4': 0x0C, 'F5': 0x03,
       'F6': 0x0B, 'F7': 0x83, 'F8': 0x0A, 'F9': 0x01, 'F10': 0x09, 'F11': 0x78, 'F12': 0x07,
       'ArrowUp': 0x175, 'ArrowDown': 0x172, 'ArrowLeft': 0x16B, 'ArrowRight': 0x174, 'Home': 0x16C, 'End': 0x169,
       'Insert': 0x170, 'Delete': 0x171, 'PageUp': 0x17D, 'PageDown': 0x17A, 'ControlRight': 0x114,
       'AltRight': 0x111}                                   # 0x100 = extended (E0)


def system_roms(folder):
    """(BASIC + KERNAL 16 KB, character ROM 4 KB) from <roms>/system; ValueError when one is missing."""
    d = os.path.join(folder, 'system')

    def find(size, *names):
        for n in names:
            p = os.path.join(d, n)
            if os.path.exists(p):
                b = open(p, 'rb').read()
                if len(b) != size:
                    raise ValueError('%s has %d bytes (want %d)' % (n, len(b), size))
                return b
        raise ValueError('no %s: put your own C64 ROM in %s' % (names[0], d))
    basic = find(8192, 'basic.rom', 'basic.901226-01.bin', 'basic')
    kernal = find(8192, 'kernal.rom', 'kernal.901227-03.bin', 'kernal')
    char = find(4096, 'chargen.rom', 'characters.901225-01.bin', 'chargen')
    return basic + kernal, char


def parse_prg(data):
    if len(data) < 3:
        raise ValueError('not a .prg (%d bytes)' % len(data))
    addr = data[0] | data[1] << 8
    body = data[2:]
    if addr + len(body) > 0x10000:
        raise ValueError('program runs past $FFFF')
    return addr, body
