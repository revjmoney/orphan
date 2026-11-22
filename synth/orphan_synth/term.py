#!/usr/bin/env python3
"""Orphan Synth terminal keyboard (JMSCNC, Rev. J. Money 2026, GPL-3 + attribution).

Play the FPGA synth from an SSH terminal. Talks to the running main.py on 127.0.0.1:8002.
Terminals only send key presses (no key release), so a note holds while the key auto-repeats
and stops shortly after you let go.

Sound: the terminal itself cannot carry audio. Hear it through the PCM5102A on J3, the web page
(port 8000), or raw on TCP 8001, e.g. on a PC with ffmpeg:
    ffplay -nodisp -f s16le -ar 48828 -ch_layout mono -fflags nobuffer tcp://<board ip>:8001
"""
import curses
import json
import os
import socket
import subprocess
import time

LOWER = 'zsxdcvgbhnjm,'          # C..C   (tracker layout)
UPPER = 'q2w3er5t6y7ui9o0p'      # C..E one octave up
FIRST_HOLD = 0.6                 # seconds before the terminal starts auto-repeating
REPEAT_HOLD = 0.15               # gap between repeats that still counts as "held"


def note_for(ch, octave):
    if ch in LOWER:
        return 12 * (octave + 1) + LOWER.index(ch)
    if ch in UPPER:
        return 12 * (octave + 2) + UPPER.index(ch)
    return None


os.environ.setdefault('ESCDELAY', '25')      # Esc quits quickly (arrow keys still work)


def main(scr):
    curses.curs_set(0)
    curses.start_color()
    curses.use_default_colors()
    curses.init_pair(1, 214, -1)      # gold
    curses.init_pair(2, 245, -1)      # dim
    curses.init_pair(3, 0, 214)       # bar
    scr.nodelay(True)
    scr.keypad(True)

    s = socket.create_connection(('127.0.0.1', 8002), timeout=3)
    f = s.makefile('rw')
    full = json.loads(f.readline())

    def send(**m):
        f.write(json.dumps(m) + '\n')
        f.flush()

    def refresh():
        nonlocal full
        send(get=1)
        full = json.loads(f.readline())

    octave = 3
    held = {}                         # note -> (last key time, repeats seen)
    ip = (subprocess.run(['hostname', '-I'], capture_output=True, text=True).stdout.split() or ['<board>'])[0]
    try:
        while True:
            now = time.time()
            st, arp = full['state'], full['arp']
            k = scr.getch()
            while k != -1:
                ch = chr(k).lower() if 0 < k < 256 else ''
                n = note_for(ch, octave)
                if n is not None:
                    if n in held:
                        held[n] = (now, held[n][1] + 1)
                    else:
                        send(on=n, vel=100)
                        held[n] = (now, 0)
                elif k == 27:
                    return
                elif ch == '\t':                                  # next preset
                    ps = full['presets']
                    send(preset=ps[(ps.index(st['preset']) + 1) % len(ps) if st['preset'] in ps else 0])
                    refresh()
                elif ch == 'f':                                   # filter mode
                    send(param='f_mode', value=(int(st['f_mode']) + 1) % 4)
                    refresh()
                elif ch == 'a':                                   # arp on / off
                    send(arp={'on': not arp['on']})
                    refresh()
                elif ch == 'k':                                   # arp mode
                    ms = full['arp_modes']
                    send(arp={'mode': ms[(ms.index(arp['mode']) + 1) % len(ms)]})
                    refresh()
                elif ch == 'l':                                   # arp latch
                    send(arp={'latch': not arp['latch']})
                    refresh()
                elif ch in '-=':                                  # tempo
                    send(arp={'bpm': max(40, min(240, arp['bpm'] + (5 if ch == '=' else -5)))})
                    refresh()
                elif ch == '`':                                   # light show
                    ls = full['leds']
                    send(leds=ls[(ls.index(st['leds']) + 1) % len(ls)])
                    refresh()
                elif ch == '[':
                    octave = max(0, octave - 1)
                elif ch == ']':
                    octave = min(7, octave + 1)
                elif k in (curses.KEY_UP, curses.KEY_DOWN):
                    send(param='cutoff', value=max(0.0, min(1.0, float(st['cutoff']) + (0.03 if k == curses.KEY_UP else -0.03))))
                    refresh()
                elif k in (curses.KEY_RIGHT, curses.KEY_LEFT):
                    send(param='reso', value=max(0.0, min(1.0, float(st['reso']) + (0.05 if k == curses.KEY_RIGHT else -0.05))))
                    refresh()
                elif ch == ' ':
                    send(panic=1)
                    held.clear()
                st, arp = full['state'], full['arp']
                k = scr.getch()
            for n, (t, reps) in list(held.items()):     # release notes whose key stopped repeating
                if now - t > (REPEAT_HOLD if reps else FIRST_HOLD):
                    send(off=n)
                    del held[n]

            scr.erase()
            h, w = scr.getmaxyx()
            scr.addstr(0, 0, ' ORPHAN SYNTH  ·  terminal keyboard '.ljust(w - 1), curses.color_pair(3) | curses.A_BOLD)
            fc = 40 * 200 ** float(st['cutoff'])
            rows = [
                ('Preset', (st['preset'] or 'custom') + '   (Tab = next)'),
                ('Filter', ['low pass', 'band pass', 'high pass', 'off'][int(st['f_mode'])] + '   (F = next)'),
                ('Cutoff', '%d Hz   (Up / Down)' % round(fc)),
                ('Resonance', '%d %%   (Left / Right)' % round(100 * float(st['reso']))),
                ('Arp', '%s  %s  %d bpm  %s   (A on/off, K mode, L latch, - = tempo)' % (
                    'ON' if arp['on'] else 'off', arp['mode'], arp['bpm'], 'latch' if arp['latch'] else '')),
                ('Lights', st['leds'] + '   (` = next show)'),
                ('Octave', '%d   ([ / ])' % octave),
                ('Playing', ' '.join(name(n) for n in sorted(held)) or '-'),
            ]
            for i, (a, b) in enumerate(rows):
                scr.addstr(4 + i, 2, a.ljust(11), curses.color_pair(2))
                scr.addstr(4 + i, 13, b[:w - 15], curses.color_pair(1) | curses.A_BOLD)
            kb = [' 2 3   5 6 7   9 0       s d   g h j',
                  'q w e r t y u i o p     z x c v b n m ,']
            scr.addstr(13, 2, 'Keys (like a tracker):', curses.color_pair(2))
            for i, line in enumerate(kb):
                scr.addstr(14 + i, 4, line, curses.color_pair(1))
            scr.addstr(16, 2, 'upper row = octave +1, lower row = octave.  Space = all notes off.  Esc = quit', curses.color_pair(2))
            cmd = 'ffplay -nodisp -f s16le -ar 48828 -ch_layout mono -fflags nobuffer tcp://%s:8001' % ip
            line = 'Hear it on your PC:  ' + cmd                 # wrapped onto rows 1-2 when the terminal is narrow
            scr.addstr(1, 1, line[:w - 2], curses.color_pair(1) | curses.A_BOLD)
            if len(line) > w - 2:
                scr.addstr(2, 1, line[w - 2:2 * (w - 2)], curses.color_pair(1) | curses.A_BOLD)
            if h > 19:
                hint = 'Also: PCM5102A on J3, or the web page http://%s:8000' % ip
                scr.addstr(18, 2, hint[:w - 3], curses.color_pair(2))
            scr.refresh()
            time.sleep(0.01)
    finally:
        send(panic=1)
        s.close()


def name(n):
    return ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'][n % 12] + str(n // 12 - 1)


if __name__ == '__main__':
    try:
        curses.wrapper(main)
    except ConnectionRefusedError:
        print('Orphan Synth is not running. Load it first:  ardzy load orphan_synth')
