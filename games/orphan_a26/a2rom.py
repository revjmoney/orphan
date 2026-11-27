"""Orphan Games, Apple IIe: system ROMs and disk images for orphan_a2.
 - system ROMs: Apple's ROMs are NOT part of Orphan. The board owner puts their own copies in
   <roms>/system/: apple2e.rom (16 KB, C000-FFFF of an enhanced //e; a 32 KB file: its last 16 KB),
   video.rom (the //e enhanced video ROM, 4 or 8 KB; optional) and diskii.rom (the 256-byte Disk II boot ROM, P5).
   Without video.rom Orphan uses its OWN character set (below, drawn for Orphan) with the //e graphics table.
 - disks: .dsk / .do (DOS 3.3 order), .po (ProDOS order) are turned into 35 tracks of 6656 nibbles each
   (6-and-2 encoding, as DOS 3.3's RWTS reads it); .nib files are used as they are.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os

TRACK = 6656
TRANS = bytes.fromhex('96979A9B9D9E9FA6A7ABACADAEAFB2B3B4B5B6B7B9BABBBCBDBEBFCBCDCECFD3'
                      'D6D7D9DADBDCDDDEDFE5E6E7E9EAEBECEDEEEFF2F3F4F5F6F7F9FAFBFCFDFEFF')
DOS_ORDER = [0, 7, 14, 6, 13, 5, 12, 4, 11, 3, 10, 2, 9, 1, 8, 15]     # physical sector -> sector in a .dsk
PRODOS_ORDER = [0, 8, 1, 9, 2, 10, 3, 11, 4, 12, 5, 13, 6, 14, 7, 15]  # physical sector -> sector in a .po


def _44(b):
    return bytes([(b >> 1) | 0xAA, b | 0xAA])


def encode62(data):
    """256 data bytes -> 343 disk nibbles (86 'twos' + 256 'sixes' + checksum, each XOR'd with the one before)."""
    aux = [0] * 86
    for i in range(256):
        b = data[i] & 3
        aux[i % 86] |= (((b & 1) << 1) | (b >> 1)) << (2 * (i // 86))
    vals = aux + [d >> 2 for d in data]
    out, prev = bytearray(), 0
    for v in vals:
        out.append(TRANS[v ^ prev])
        prev = v
    out.append(TRANS[prev])
    return bytes(out)


def nibble_track(sectors, track, volume=254):
    """16 sectors of 256 bytes in physical order -> one 6656-byte track."""
    t = bytearray(b'\xFF' * 48)
    for p in range(16):
        t += b'\xD5\xAA\x96' + _44(volume) + _44(track) + _44(p) + _44(volume ^ track ^ p) + b'\xDE\xAA\xEB'
        t += b'\xFF' * 6
        t += b'\xD5\xAA\xAD' + encode62(sectors[p]) + b'\xDE\xAA\xEB'
        t += b'\xFF' * 27
    return bytes(t + b'\xFF' * (TRACK - len(t)))


def disk_tracks(data, name):
    """A disk image -> list of 35 tracks of 6656 nibbles."""
    ext = os.path.splitext(name)[1].lower()
    if ext == '.nib':
        if len(data) != 35 * TRACK:
            raise ValueError('a .nib disk has %d bytes (want %d)' % (len(data), 35 * TRACK))
        return [data[i * TRACK:(i + 1) * TRACK] for i in range(35)]
    if len(data) != 143360:
        raise ValueError('a 5.25" disk image has 143360 bytes (this one %d)' % len(data))
    order = PRODOS_ORDER if ext == '.po' else DOS_ORDER
    return [nibble_track([data[(t * 16 + order[p]) * 256:(t * 16 + order[p] + 1) * 256] for p in range(16)], t)
            for t in range(35)]


# ---------------------------------------------------------------- the video ROM
# Orphan's own 5 x 7 character set, drawn for Orphan (rows top to bottom, '#' = dot). Characters 0x20..0x5F;
# lower case is shown as upper case.
FONT = {
    ' ': '.....|.....|.....|.....|.....|.....|.....', '!': '..#..|..#..|..#..|..#..|..#..|.....|..#..',
    '"': '.#.#.|.#.#.|.#.#.|.....|.....|.....|.....', '#': '.#.#.|.#.#.|#####|.#.#.|#####|.#.#.|.#.#.',
    '$': '..#..|.####|#.#..|.###.|..#.#|####.|..#..', '%': '##...|##..#|...#.|..#..|.#...|#..##|...##',
    '&': '.##..|#..#.|#.#..|.#...|#.#.#|#..#.|.##.#', "'": '..#..|..#..|.#...|.....|.....|.....|.....',
    '(': '...#.|..#..|.#...|.#...|.#...|..#..|...#.', ')': '.#...|..#..|...#.|...#.|...#.|..#..|.#...',
    '*': '.....|..#..|#.#.#|.###.|#.#.#|..#..|.....', '+': '.....|..#..|..#..|#####|..#..|..#..|.....',
    ',': '.....|.....|.....|.....|..#..|..#..|.#...', '-': '.....|.....|.....|#####|.....|.....|.....',
    '.': '.....|.....|.....|.....|.....|.....|..#..', '/': '.....|....#|...#.|..#..|.#...|#....|.....',
    '0': '.###.|#...#|#..##|#.#.#|##..#|#...#|.###.', '1': '..#..|.##..|..#..|..#..|..#..|..#..|.###.',
    '2': '.###.|#...#|....#|..##.|.#...|#....|#####', '3': '#####|...#.|..#..|...#.|....#|#...#|.###.',
    '4': '...#.|..##.|.#.#.|#..#.|#####|...#.|...#.', '5': '#####|#....|####.|....#|....#|#...#|.###.',
    '6': '..##.|.#...|#....|####.|#...#|#...#|.###.', '7': '#####|....#|...#.|..#..|.#...|.#...|.#...',
    '8': '.###.|#...#|#...#|.###.|#...#|#...#|.###.', '9': '.###.|#...#|#...#|.####|....#|...#.|.##..',
    ':': '.....|.....|..#..|.....|..#..|.....|.....', ';': '.....|.....|..#..|.....|..#..|..#..|.#...',
    '<': '...#.|..#..|.#...|#....|.#...|..#..|...#.', '=': '.....|.....|#####|.....|#####|.....|.....',
    '>': '.#...|..#..|...#.|....#|...#.|..#..|.#...', '?': '.###.|#...#|....#|...#.|..#..|.....|..#..',
    '@': '.###.|#...#|#.###|#.#.#|#.###|#....|.####', 'A': '..#..|.#.#.|#...#|#...#|#####|#...#|#...#',
    'B': '####.|#...#|#...#|####.|#...#|#...#|####.', 'C': '.###.|#...#|#....|#....|#....|#...#|.###.',
    'D': '####.|#...#|#...#|#...#|#...#|#...#|####.', 'E': '#####|#....|#....|####.|#....|#....|#####',
    'F': '#####|#....|#....|####.|#....|#....|#....', 'G': '.####|#....|#....|#.###|#...#|#...#|.####',
    'H': '#...#|#...#|#...#|#####|#...#|#...#|#...#', 'I': '.###.|..#..|..#..|..#..|..#..|..#..|.###.',
    'J': '....#|....#|....#|....#|....#|#...#|.###.', 'K': '#...#|#..#.|#.#..|##...|#.#..|#..#.|#...#',
    'L': '#....|#....|#....|#....|#....|#....|#####', 'M': '#...#|##.##|#.#.#|#.#.#|#...#|#...#|#...#',
    'N': '#...#|#...#|##..#|#.#.#|#..##|#...#|#...#', 'O': '.###.|#...#|#...#|#...#|#...#|#...#|.###.',
    'P': '####.|#...#|#...#|####.|#....|#....|#....', 'Q': '.###.|#...#|#...#|#...#|#.#.#|#..#.|.##.#',
    'R': '####.|#...#|#...#|####.|#.#..|#..#.|#...#', 'S': '.###.|#...#|#....|.###.|....#|#...#|.###.',
    'T': '#####|..#..|..#..|..#..|..#..|..#..|..#..', 'U': '#...#|#...#|#...#|#...#|#...#|#...#|.###.',
    'V': '#...#|#...#|#...#|#...#|#...#|.#.#.|..#..', 'W': '#...#|#...#|#...#|#.#.#|#.#.#|##.##|#...#',
    'X': '#...#|#...#|.#.#.|..#..|.#.#.|#...#|#...#', 'Y': '#...#|#...#|.#.#.|..#..|..#..|..#..|..#..',
    'Z': '#####|....#|...#.|..#..|.#...|#....|#####', '[': '.###.|.#...|.#...|.#...|.#...|.#...|.###.',
    '\\': '.....|#....|.#...|..#..|...#.|....#|.....', ']': '.###.|...#.|...#.|...#.|...#.|...#.|.###.',
    '^': '..#..|.#.#.|#...#|.....|.....|.....|.....', '_': '.....|.....|.....|.....|.....|.....|#####',
}


def _glyph(code):
    """the 8 rows of a character as 7-dot bit patterns (bit 0 = the leftmost dot, 1 = lit)"""
    c = chr(code & 0x7F)
    if 'a' <= c <= 'z':
        c = c.upper()
    rows = FONT.get(c if 0x20 <= ord(c) < 0x60 else ' ', FONT[' ']).split('|')
    return [sum(1 << (k + 1) for k in range(5) if r[k] == '#') for r in rows] + [0]


def video_rom():
    """An 8 KB //e video ROM made by Orphan: the text half from FONT, the graphics half from the //e rule
    (hi-res: the 7 dots of the byte; lo-res: the colour nibble repeated, phase per column). A ROM byte's 0 bits are lit."""
    half = bytearray(4096)
    for a in range(2048):                      # text: a10 a9 = the character set block, then DL5..0, then the row
        blk, c, row = a >> 9, (a >> 3) & 63, a & 7
        # block 0: inverse (and flashing) @A-Z.. / space-?, 1: MouseText + inverse lower case (Orphan: inverse),
        # 2: normal @A-Z.. / space-?, 3: normal @A-Z.. / lower case
        code = {0: 0x40 + c if c < 32 else c, 1: 0x40 + c if c < 32 else 0x40 + c,
                2: 0x40 + c if c < 32 else c, 3: 0x40 + c}[blk]
        dots = _glyph(code)[row]
        half[a] = (dots if blk < 2 else ~dots) & 0xFF
    for a in range(2048):                      # graphics: DL7..0, SEG
        dl, seg = a >> 3, a & 7
        if seg in (0, 1, 4, 5):
            v = 0xFF ^ (dl & 0x7F)
        else:
            n = (dl & 15) if seg in (2, 3) else dl >> 4
            p = n | n << 4
            if seg in (3, 7):
                p = ((p << 2) | (p >> 6)) & 0xFF
            v = 0xFF ^ p
        half[2048 + a] = v
    return bytes(half) * 2


def system_roms(folder):
    """(main 16 KB, video 8 KB, disk boot 256 bytes or None, notes) from <roms>/system; ValueError without a main ROM."""
    d = os.path.join(folder, 'system')
    def find(*names):
        for n in names:
            p = os.path.join(d, n)
            if os.path.exists(p):
                return open(p, 'rb').read()
        return None
    main = find('apple2e.rom', 'apple2e_enhanced.rom', 'apple2ee.rom')
    if main is None:
        raise ValueError('no Apple IIe ROM: put your own apple2e.rom (16 KB) in %s' % d)
    if len(main) == 32768:
        main = main[16384:]
    if len(main) != 16384:
        raise ValueError('apple2e.rom has %d bytes (want 16384)' % len(main))
    vid = find('video.rom', 'apple2e_video.rom', '342-0273-a.bin')
    notes = []
    if vid is None:
        vid, notes = video_rom(), notes + ['Orphan character set']
    elif len(vid) == 4096:
        vid = vid * 2
    if len(vid) != 8192:
        raise ValueError('video.rom has %d bytes (want 4096 or 8192)' % len(vid))
    disk = find('diskii.rom', 'disk2.rom', 'slot6.rom', '341-0027.bin')
    if disk is not None and len(disk) != 256:
        raise ValueError('diskii.rom has %d bytes (want 256)' % len(disk))
    if disk is None:
        notes.append('no diskii.rom: disks can not boot')
    return main, vid, disk, notes
