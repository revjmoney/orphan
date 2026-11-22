#!/usr/bin/env python3
"""Orphan login menu: BBS-style lightbar for the S9 control board.
Orphan · FPGA Dev Linux for the S9 Control Board - by JMSCNC, makers of RotatoCAM.

Keys: arrows or j/k move, Enter or a hotkey picks, Q or S drops to the shell.
"""
import curses
import glob
import locale
import os
import shutil
import signal
import socket
import subprocess
import time

SHARE = '/usr/local/share/orphan'
CONF = '/etc/orphan'
TITLE = [
    ' ██████  ██████  ██████  ██   ██  █████  ███    ██',
    '██    ██ ██   ██ ██   ██ ██   ██ ██   ██ ████   ██',
    '██    ██ ██████  ██████  ███████ ███████ ██ ██  ██',
    '██    ██ ██   ██ ██      ██   ██ ██   ██ ██  ██ ██',
    ' ██████  ██   ██ ██      ██   ██ ██   ██ ██   ████',
]
TAGLINE = 'FPGA Dev Linux for the S9 Control Board'


LOGO_SIZES = (40, 32, 26)          # chafa renders, widest first (logo_NN.ans)


def load_ans(path):
    """chafa's ANSI art -> rows of (char, fg, bg); colors are 256-color numbers, -1 = terminal default."""
    import re
    try:
        with open(path, encoding='utf-8') as f:
            text = f.read()
    except OSError:
        return []
    rows, fg, bg = [], -1, -1
    for line in text.rstrip('\n').split('\n'):
        cells = []
        for part in re.split(r'(\x1b\[[0-9;]*m)', line):
            if part.startswith('\x1b['):
                p = [int(x) if x else 0 for x in part[2:-1].split(';')]
                i = 0
                while i < len(p):
                    if p[i] == 0:
                        fg = bg = -1
                    elif p[i] in (38, 48) and i + 2 < len(p) and p[i + 1] == 5:
                        if p[i] == 38:
                            fg = p[i + 2]
                        else:
                            bg = p[i + 2]
                        i += 2
                    elif p[i] == 39:
                        fg = -1
                    elif p[i] == 49:
                        bg = -1
                    i += 1
            else:
                cells.extend((ch, fg, bg) for ch in part)
        rows.append(cells)
    return rows


def quote(avoid=''):
    """A random line from quotes.txt (never the same as `avoid`), in quotes; '' if there are none."""
    import random
    try:
        with open(SHARE + '/quotes.txt', encoding='utf-8') as f:
            q = ['"%s"' % ln.strip() for ln in f if ln.strip() and not ln.lstrip().startswith('#')]
    except OSError:
        q = []
    if len(q) > 1 and avoid in q:
        q.remove(avoid)
    return random.choice(q) if q else ''
BYLINE = 'by JMSCNC, makers of RotatoCAM'


def sh(cmd, timeout=10):
    try:
        return subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=timeout).stdout.strip()
    except Exception as e:  # noqa: BLE001  (show the problem instead of crashing the menu)
        return 'error: %s' % e


def read(path, default=''):
    try:
        with open(path) as f:
            return f.read().strip()
    except OSError:
        return default


def root_mode():
    src = sh('findmnt -no SOURCE /')
    if src.startswith('ubi'):
        return 'FLASH (lean)'
    if src.startswith('/dev/mmcblk'):
        return 'SD (full)'
    if ':' in src:
        return 'NETBOOT'
    return src or '?'


def ip_addr():
    out = sh("ip -4 -o addr show scope global | awk '{print $4}' | head -1")
    return out.split('/')[0] if out else 'no network'


def chip_temp():
    for d in glob.glob('/sys/bus/iio/devices/iio:device*'):
        if read(d + '/name') == 'xadc':
            try:
                raw = float(read(d + '/in_temp0_raw'))
                off = float(read(d + '/in_temp0_offset', '0'))
                sc = float(read(d + '/in_temp0_scale', '1'))
                return '%.0f C' % ((raw + off) * sc / 1000)
            except ValueError:
                pass
    return '?'


def xadc_lines():
    lines = []
    for d in glob.glob('/sys/bus/iio/devices/iio:device*'):
        if read(d + '/name') != 'xadc':
            continue
        lines.append('  chip temperature   %s' % chip_temp())
        for f in sorted(glob.glob(d + '/in_voltage*_raw')):
            name = os.path.basename(f)[len('in_voltage'):-len('_raw')].split('_', 1)[-1]
            sc = read(f[:-4] + '_scale') or read(d + '/in_voltage_scale', '0')
            try:
                lines.append('  %-18s %.3f V' % (name.upper(), float(read(f)) * float(sc) / 1000))
            except ValueError:
                pass
    return lines or ['  (no XADC found)']


def uptime():
    s = int(float(read('/proc/uptime', '0').split()[0]))
    d, s = divmod(s, 86400)
    h, s = divmod(s, 3600)
    return ('%dd ' % d if d else '') + '%dh%02dm' % (h, s // 60)


# ---------------------------------------------------------------- screens
def board_status():
    mem = sh("free -m | awk '/Mem:/{print $3\" MB used / \"$2\" MB\"}'")
    disk = sh("df -h / | awk 'NR==2{print $3\" used / \"$2\" (\"$5\")\"}'")
    lines = [
        'BOARD STATUS', '',
        '  hostname           %s' % socket.gethostname(),
        '  IP address         %s' % ip_addr(),
        '  MAC                %s' % sh("cat /sys/class/net/*/address | grep -v 00:00:00 | head -1"),
        '  running from       %s' % root_mode(),
        '  kernel             %s' % os.uname().release,
        '  uptime             %s   load %s' % (uptime(), read('/proc/loadavg').split(' ')[0]),
        '  memory             %s' % mem,
        '  root filesystem    %s' % disk,
        '  model              %s' % read('/proc/device-tree/model').replace('\x00', ''),
        '', 'SENSORS (Zynq XADC)',
    ] + xadc_lines() + ['', 'FPGA (ardzy status)'] + ['  ' + ln for ln in sh('ardzy status 2>&1').splitlines()]
    return lines


def network_info():
    return (['NETWORK', ''] + ['  ' + ln for ln in sh('ip -br addr').splitlines()] + ['']
            + ['  default route: ' + sh("ip route | awk '/default/{print $3}'")]
            + ['  DNS: ' + sh("grep -h nameserver /etc/resolv.conf /run/systemd/resolve/resolv.conf 2>/dev/null | awk '{print $2}' | sort -u | tr '\\n' ' '")]
            + ['', '  ping 1.1.1.1:'] + ['    ' + ln for ln in sh('ping -c2 -W2 1.1.1.1 2>&1 | tail -2', 8).splitlines()])


def flash_info():
    if root_mode() == 'NETBOOT':
        src = sh('findmnt -no SOURCE /')
        return ['HOW THIS BOARD BOOTS', '',
                '  This board boots over the network (netboot):',
                '    kernel     from the board\'s NAND flash (NFS-root kernel, CMDLINE_FORCE)',
                '    system     %s  (NFS)' % src,
                '  The netboot server has to be on for this board to start.', '',
                '  It is the same Orphan system as the SD/flash board, with its own hostname.',
                '  The SD/flash installer does not apply here.']
    return ['INSTALL TO FLASH', '',
            '  Orphan boots its kernel from the board\'s NAND flash and picks the root at boot:',
            '    SD card in   -> the full system on the card',
            '    no card      -> the lean system in the flash',
            '    (a file named flash-root on the card\'s FAT partition forces the flash system)', '',
            '  This board right now:  %s' % root_mode(),
            '  NAND partitions:'] + ['    ' + ln for ln in read('/proc/mtd').splitlines()] + [
            '  UBI: ' + (sh('ubinfo -a 2>/dev/null | grep -E "Volume name|Size:" | head -2 | tr -s " " | tr "\\n" " "') or 'not attached'),
            '', '  The one-command installer (s9-install-flash) comes with the public release.',
            '  It must write the NAND with the chip\'s ON-DIE ECC (see the docs).']


def project_meta(name):
    import json
    try:
        return json.load(open('/opt/ardzy/projects/%s/project.json' % name))
    except (OSError, ValueError):
        return {}


def wrap(text, width, indent='  '):
    import textwrap
    return [indent + ln for ln in textwrap.wrap(str(text), max(20, width - len(indent)))] or [indent]


def project_lines(name, width):
    """Detail page for one FPGA project, from its project.json."""
    m = project_meta(name)
    d = '/opt/ardzy/projects/' + name
    files = sorted(os.listdir(d)) if os.path.isdir(d) else []
    kinds = (('FPGA design', any(f.endswith(('.bit', '.bin')) for f in files)), ('Python program', 'main.py' in files),
             ('C program', any(f.endswith('.c') for f in files)), ('Arduino sketch', any(f.endswith('.ino') for f in files)))
    kind = ', '.join(x for x, ok in kinds if ok) or 'files'
    out = [m.get('title', name), '']
    out += wrap(m.get('summary', 'No description yet (no project.json in %s).' % d), width)
    out += ['', '  Folder    %s' % d, '  Contains  %s' % kind]
    if m.get('category') or m.get('level'):
        out += ['  Kind      %s%s' % (m.get('category', ''), ('  ·  ' + m['level']) if m.get('level') else '')]
    if m.get('web'):
        out += ['  Web page  http://%s:%s  (after it loads)' % (ip_addr(), m['web'])]
    if m.get('wiring'):
        out += ['', '  Wiring']
        for w in m['wiring']:
            out += wrap('%s -> %s%s' % (w[0], w[1], ('  (%s)' % w[2]) if len(w) > 2 and w[2] else ''), width, '    ')
    if m.get('parts'):
        out += ['', '  Parts'] + [ln for p_ in m['parts'] for ln in wrap('- ' + p_, width, '    ')]
    if m.get('tested'):
        out += ['', '  Tested'] + wrap(m['tested'], width, '    ')
    return out


# ---------------------------------------------------------------- UI
class Menu:
    # The hotkeys read down the menu as "MY ORPHAN LIFE" (+ S shell, C cooling).
    ITEMS = [
        ('M', 'Midnight Commander', 'file manager'),
        ('Y', 'System info', 'fastfetch with the monkey'),
        ('O', 'Options', 'login settings and Axis BBS'),
        ('R', 'Radio', '4-slice SDR receiver, web panel'),
        ('P', 'Power', 'reboot or power off'),
        ('H', 'htop', 'live processes and CPU'),
        ('A', 'About this board', 'temperature, voltages, memory, FPGA'),
        ('N', 'Network', 'addresses, route, ping'),
        ('L', 'LED toys', 'LED ring, SD activity lights'),
        ('I', 'Install to flash', 'how this board boots'),
        ('F', 'FPGA projects', 'load a design + its program'),
        ('E', 'Exit', 'log out, end this session'),
        ('S', 'Shell', 'drop to the command line'),
        ('C', 'Cooling', 'fan speed (PWM) + live rpm'),
    ]
    GAP_AFTER = (1, 7, 11)          # a blank line after MY / ORPHAN / LIFE
    # Home mode (started by the login hook): Shell opens a subshell and `exit` comes back here;
    # only Log out leaves (exit code 10, the hook then ends the session).
    HOME = bool(os.environ.get('ORPHAN_HOME'))

    def __init__(self, scr):
        self.scr = scr
        self.sel = 0
        self.quote = quote()
        self.slow, self.slow_at = (), 0.0
        curses.curs_set(0)
        curses.start_color()
        curses.use_default_colors()
        many = curses.COLORS >= 256
        gold = 214 if many else curses.COLOR_YELLOW
        blue = 18 if many else curses.COLOR_BLUE
        curses.init_pair(1, gold, -1)                          # logo, title
        curses.init_pair(2, curses.COLOR_WHITE, blue)          # header / status bars
        curses.init_pair(3, curses.COLOR_BLACK, gold)          # lightbar
        curses.init_pair(4, curses.COLOR_CYAN, -1)             # hotkeys, accents
        curses.init_pair(5, 245 if many else curses.COLOR_WHITE, -1)  # dim text
        curses.init_pair(6, curses.COLOR_WHITE, -1)
        try:
            with open(SHARE + '/logo_small.txt', encoding='utf-8') as f:
                self.logo = f.read().rstrip('\n').splitlines()   # fallback art (keep leading spaces)
        except OSError:
            self.logo = []
        # full-color chafa renders (needs 256 colors); color pairs are made on demand
        self.many = many
        self.arts = {w: load_ans('%s/logo_%d.ans' % (SHARE, w)) for w in LOGO_SIZES} if many else {}
        self.pairs = {}

    def pair(self, fg, bg):
        key = (fg, bg)
        if key not in self.pairs:
            n = 20 + len(self.pairs)
            if n >= curses.COLOR_PAIRS:
                return curses.color_pair(1)
            try:
                curses.init_pair(n, fg, bg)
            except curses.error:
                return curses.color_pair(1)
            self.pairs[key] = n
        return curses.color_pair(self.pairs[key])

    def draw_logo(self, top, h, w):
        """Biggest monkey that fits under the title and leaves the menu room. Returns its width."""
        rows_free = h - top - 2
        for size in LOGO_SIZES:
            art = self.arts.get(size)
            if art and len(art) <= rows_free and size + 4 + 30 <= w:
                for y, row in enumerate(art):
                    for x, (ch, fg, bg) in enumerate(row):
                        self.put(top + y, 1 + x, ch, self.pair(fg, bg))
                return size + 1
        for i, ln in enumerate(self.logo[:max(0, rows_free)]):
            self.put(top + i, 1, ln, curses.color_pair(1))
        return 31

    def put(self, y, x, text, attr=0):
        h, w = self.scr.getmaxyx()
        if 0 <= y < h and x < w:
            try:
                self.scr.addstr(y, x, text[:max(0, w - x - 1)], attr)
            except curses.error:
                pass

    def bar(self, y, text):
        w = self.scr.getmaxyx()[1]
        self.put(y, 0, text.ljust(w - 1), curses.color_pair(2) | curses.A_BOLD)

    def draw(self):
        s = self.scr
        s.erase()
        h, w = s.getmaxyx()
        self.bar(0, ' ORPHAN  ·  %s' % TAGLINE + BYLINE.rjust(max(0, w - 14 - len(TAGLINE) - 1)))
        tx = max(0, (w - len(TITLE[0])) // 2)
        for i, ln in enumerate(TITLE):
            self.put(1 + i, tx, ln, curses.color_pair(1) | curses.A_BOLD)
        q = self.quote
        if q:
            self.put(6, max(0, (w - len(q)) // 2), q, curses.color_pair(4) | curses.A_ITALIC)
        top = 8
        lw = self.draw_logo(top, h, w)
        mx = lw + 3 if w >= lw + 33 else 2
        for i, (key, label, hint) in enumerate(self.ITEMS):
            y = top + i + sum(1 for g in self.GAP_AFTER if i > g)
            if i == self.sel:
                self.put(y, mx, (' %s  %-20s' % (key, label)).ljust(25), curses.color_pair(3) | curses.A_BOLD)
            else:
                self.put(y, mx, ' ' + key, curses.color_pair(4) | curses.A_BOLD)
                self.put(y, mx + 4, label, curses.color_pair(6))
            self.put(y, mx + 27, hint, curses.color_pair(5))
        now = time.time()
        if now - self.slow_at > 8:            # these spawn processes: refresh every 8 s, not every second
            self.slow = (socket.gethostname(), ip_addr(), root_mode(), chip_temp())
            self.slow_at = now
            try:                               # is the Orphan Synth running? (its local control port answers)
                socket.create_connection(('127.0.0.1', 8002), timeout=0.3).close()
                self.synth_on = True
            except OSError:
                self.synth_on = False
        left = ' %s  ·  %s  ·  %s  ·  %s  ·  up %s' % (self.slow + (uptime(),))
        clock = time.strftime('%a %b %d  %-I:%M:%S %p ')
        self.bar(h - 2, left + clock.rjust(max(1, w - 1 - len(left))))
        if getattr(self, 'synth_on', False) and h - 3 > top + len(self.ITEMS) + len(self.GAP_AFTER):
            ffp = ' Synth running. Hear it on your PC:  ffplay -nodisp -f s16le -ar 48828 -ch_layout mono'                   ' -fflags nobuffer tcp://%s:8001' % self.slow[1]
            self.put(h - 3, 0, ffp[:w - 1], curses.color_pair(1) | curses.A_BOLD)
        help_txt = ' arrows move · Enter or hotkey selects · Q shell · jmscnc.com'
        self.put(h - 1, 0, help_txt, curses.color_pair(5))
        self.put(h - 1, max(len(help_txt) + 2, w - 24), '[Rev. J. Money - 2026]', curses.color_pair(1) | curses.A_BOLD)
        s.refresh()

    def page(self, lines, footer=' up/down scroll · any other key returns'):
        """Scrollable text screen; any key except arrows / PgUp / PgDn returns (and is returned)."""
        pos = 0
        while True:
            self.scr.erase()
            h, w = self.scr.getmaxyx()
            self.bar(0, ' ORPHAN  ·  ' + (lines[0] if lines else ''))
            for i, ln in enumerate(lines[1 + pos:1 + pos + h - 3]):
                self.put(1 + i, 1, ln, curses.color_pair(6))
            self.bar(h - 1, footer)
            self.scr.refresh()
            k = self.scr.getch()
            if k == -1:                    # the menu's 1 s clock timeout: not a key, keep showing the page
                continue
            if k in (curses.KEY_DOWN, ord('j')) and pos < max(0, len(lines) - h + 3):
                pos += 1
            elif k in (curses.KEY_UP, ord('k')) and pos > 0:
                pos -= 1
            elif k == curses.KEY_NPAGE:
                pos = min(max(0, len(lines) - h + 3), pos + h - 4)
            elif k == curses.KEY_PPAGE:
                pos = max(0, pos - h + 4)
            else:
                return k

    def pick(self, title, options, notes=()):
        """Lightbar list (scrolls when longer than the screen); returns the chosen index or None."""
        sel = top = 0
        while True:
            self.scr.erase()
            h, w = self.scr.getmaxyx()
            rows = max(1, h - 4 - len(notes))
            top = min(max(top, sel - rows + 1), sel)
            self.bar(0, ' ORPHAN  ·  ' + title + ('   (%d of %d)' % (sel + 1, len(options)) if len(options) > rows else ''))
            for i, o in enumerate(options[top:top + rows]):
                attr = curses.color_pair(3) | curses.A_BOLD if top + i == sel else curses.color_pair(6)
                self.put(2 + i, 3, (' ' + o)[:max(10, w - 6)].ljust(min(w - 6, max(40, len(o) + 2))), attr)
            for i, note in enumerate(notes):
                self.put(h - 1 - len(notes) + i, 3, note[:max(0, w - 4)], curses.color_pair(5))
            self.bar(h - 1, ' arrows move · Enter picks · Esc/Q back')
            self.scr.refresh()
            k = self.scr.getch()
            if k in (curses.KEY_DOWN, ord('j')):
                sel = (sel + 1) % len(options)
            elif k in (curses.KEY_UP, ord('k')):
                sel = (sel - 1) % len(options)
            elif k == curses.KEY_NPAGE:
                sel = min(len(options) - 1, sel + rows)
            elif k == curses.KEY_PPAGE:
                sel = max(0, sel - rows)
            elif k in (10, 13, curses.KEY_ENTER):
                return sel
            elif k in (27, ord('q'), ord('Q')):
                return None

    @staticmethod
    def child(args, **kw):
        """Run a child in the foreground. The menu ignores Ctrl-C meanwhile; the child gets normal Ctrl-C."""
        old = signal.signal(signal.SIGINT, signal.SIG_IGN)
        try:
            return subprocess.call(args, preexec_fn=lambda: signal.signal(signal.SIGINT, signal.SIG_DFL), **kw)
        finally:
            signal.signal(signal.SIGINT, old)

    def run_outside(self, cmd, pause=True):
        """Leave curses, run a command in the real terminal, come back. A failure always pauses so it can be read."""
        curses.endwin()
        prog = cmd.split()[0] if cmd.split() else ''
        if prog and not prog.startswith(('clear', 'systemctl', 'for', 'ardzy', 'r=')) and not shutil.which(prog):
            print('\n\x1b[91m%s is not installed on this system.\x1b[0m Install it with: apt install %s' % (prog, prog))
            pause = True
        elif self.child(cmd, shell=True) != 0 and not pause:
            print('\n\x1b[91m"%s" exited with an error.\x1b[0m' % cmd)
            pause = True
        if pause:
            try:                           # drop keys typed while the command ran, so they can't skip the pause
                import termios
                termios.tcflush(0, termios.TCIFLUSH)
            except Exception:  # noqa: BLE001
                pass
            input('\n\x1b[38;5;214mpress Enter to return to the Orphan menu\x1b[0m ')
        self.scr.refresh()

    def fpga(self, only=None):
        projects = sorted(os.path.basename(p) for p in glob.glob('/opt/ardzy/projects/*') if os.path.isdir(p))
        meta = project_meta
        sound = [p for p in projects if str(meta(p).get('category', '')).lower() == 'sound']
        graphics = [p for p in projects if str(meta(p).get('category', '')).lower() == 'graphics']
        games = [p for p in projects if str(meta(p).get('category', '')).lower() == 'games']
        if only:                                       # straight to one project's page (the Radio item)
            if only not in projects:
                self.page(['Radio', '', '  %s is not installed in /opt/ardzy/projects.' % only])
                return
            i = 4 + projects.index(only)
        else:
            opts = ['pin-control (general I/O, PWM, logic analyzer)', 'Sound toys  >', 'Graphics toys: raycast + CYD  >', 'Games: NES and more, in the browser + CYD  >'] + [
                '%-15s %s' % (p, meta(p).get('title', '')) for p in projects]
            i = self.pick('FPGA projects', opts)
        if i is None:
            return
        # The LED ring hammers the FPGA's registers; reprogramming the FPGA under it hangs the board.
        # Stop it for reconfiguration. Only pin-control is compatible with its register map.
        ring_off = 'r=$(systemctl is-active s9-ledring 2>/dev/null); systemctl stop s9-ledring 2>/dev/null; '
        ring_on = '; [ "$r" = active ] && systemctl start s9-ledring'
        if i == 0:
            self.run_outside(ring_off + 'ardzy pin-control' + ring_on + '; ardzy status')
            return
        if i == 1:
            if not sound:
                self.page(['Sound toys', '', '  No sound projects installed in /opt/ardzy/projects.'])
                return
            j = self.pick('Sound toys', ['%s  (%s)' % (meta(p).get('title', p), p) for p in sound])
            if j is None:
                return
            name = sound[j]
        elif i == 2:
            choices = ['%s  (%s)' % (meta(p).get('title', p), p) for p in graphics]
            choices += ['Replay CYD raycast preview for 2 minutes (ARM)', 'FPGA demo source library / port candidates']
            j = self.pick('Graphics toys', choices)
            if j is None:
                return
            if j == len(graphics):
                self.run_outside('python3 /opt/orphan-display/frame_demo.py orphan-remote.local --frames 240')
                return
            if j == len(graphics) + 1:
                self.page(['FPGA graphics source library', '',
                    '  Raybox Zero: a Wolfenstein-style hardware raycaster.',
                    '  https://github.com/algofoogle/raybox-zero', '',
                    '  Project F: FPGA graphics and visual demo examples.',
                    '  https://github.com/projf/projf-explore', '',
                    '  Original Doom game source (CPU engine):',
                    '  https://github.com/id-Software/DOOM', '',
                    '  These are source references, not S9-ready bitstreams.',
                    '  Orphan Graphics Toys above is the local S9/CYD design.'])
                return
            name = graphics[j]
        elif i == 3:
            if not games:
                self.page(['Games', '', '  No game consoles installed in /opt/ardzy/projects.'])
                return
            j = self.pick('Games: the console runs in the FPGA, you play in the browser or on the CYD',
                          ['%s  (%s)' % (meta(p).get('title', p), p) for p in games])
            if j is None:
                return
            name = games[j]
        else:
            name = projects[i - 4]
        ring_on = ''  # keep the incompatible register writer stopped for other projects
        w = self.scr.getmaxyx()[1]
        k = self.page(project_lines(name, w - 4), ' Enter or L loads it · up/down scroll · any other key goes back')
        if k not in (10, 13, curses.KEY_ENTER, ord('l'), ord('L')):
            return
        ip = (subprocess.run(['hostname', '-I'], capture_output=True, text=True).stdout.split() or ['<board ip>'])[0]
        web = ('; echo; echo "  Web GUI: http://%s:8000"; echo "  Hear it on your PC: ffplay -nodisp -f s16le -ar 48828'
               ' -ch_layout mono -fflags nobuffer tcp://%s:8001"' % (ip, ip)) if name in sound else ''
        if meta(name).get('web') and name not in sound:
            web = '; echo; echo "  Web page: http://%s:%s"' % (ip, meta(name)['web'])
        term = '/opt/ardzy/projects/%s/term.py' % name
        if os.path.exists(term):                       # sound toy with a terminal keyboard: play it right here
            web += '; sleep 3; python3 %s' % term
        self.run_outside(ring_off + 'ardzy load %s; sleep 2; orphan-fan boot >/dev/null 2>&1%s; ardzy status%s'
                         % (name, ring_on, web))

    def leds(self):
        opts = []
        if os.path.exists('/etc/systemd/system/s9-ledring.service') or os.path.exists('/opt/s9/ledring'):
            opts += ['LED ring: start', 'LED ring: stop']
        if os.path.exists('/etc/systemd/system/s9-sdleds.service'):
            opts += ['SD activity lights: on', 'SD activity lights: off']
        opts += ['All status LEDs off']
        i = self.pick('LED toys', opts)
        if i is None:
            return
        cmd = {
            'LED ring: start': 'systemctl start s9-ledring 2>/dev/null || systemd-run --unit=s9-ledring /opt/s9/ledring 2.8',
            'LED ring: stop': 'systemctl stop s9-ledring',
            'SD activity lights: on': 'systemctl start s9-sdleds',
            'SD activity lights: off': 'systemctl stop s9-sdleds',
            'All status LEDs off': 'for l in green red ps; do ardzy led $l off; done',
        }[opts[i]]
        self.run_outside(cmd + '; echo done')

    def cooling(self):
        """Live fan utility: rpm of all 6 headers every second, set the PWM duty with keys.
        Works with any FPGA project: Ardzy pin-control or the orphan_fan block every Orphan design has."""
        import sys
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        import orphan_fan as fan

        msg = ''
        self.scr.timeout(1000)
        try:
            while True:
                try:
                    f, err = fan.status(), ''
                except Exception as e:  # noqa: BLE001
                    f, err = {}, str(e)
                duty = f.get('duty', 0)
                s = self.scr
                s.erase()
                self.bar(0, ' ORPHAN  ·  Cooling: fan headers (PWM + tach)')
                state = ('PWM %d%%' % duty) if f.get('on') else 'PWM OFF (fans run FULL speed)'
                self.put(2, 2, 'Fan control: ', curses.color_pair(6))
                self.put(2, 15, state, curses.color_pair(1) | curses.A_BOLD)
                if f:
                    self.put(2, 30, '(via %s)' % f['via'], curses.color_pair(5))
                barw = 40
                fill = int(barw * duty / 100) if f.get('on') else barw
                self.put(3, 2, '[' + '█' * fill + '░' * (barw - fill) + ']', curses.color_pair(1))
                self.put(5, 2, 'Header   RPM', curses.color_pair(4) | curses.A_BOLD)
                for i, r in enumerate((f.get('rpm') or [0] * 6)[:6]):
                    txt = ('%5d rpm' % r) if r else '    -    (no tach signal)'
                    self.put(6 + i, 2, 'FAN%d  %s' % (i + 1, txt), curses.color_pair(6 if r else 5))
                self.put(13, 2, 'Keys:  0-9 = 0%-90%   F = 100%   + / - = 5% steps   Q = back', curses.color_pair(5))
                self.put(14, 2, 'The setting is saved and used at every boot (/etc/orphan/fan-duty).', curses.color_pair(5))
                self.put(15, 2, 'Many 4-pin fans idle slowly at 0% instead of stopping; 3-pin fans ignore PWM.', curses.color_pair(5))
                if err:
                    self.put(17, 2, 'No fan control: %s' % err[:72], curses.color_pair(1))
                    self.put(18, 2, 'Press L to load Ardzy pin-control (stops the current FPGA project).',
                             curses.color_pair(4) | curses.A_BOLD)
                elif msg:
                    self.put(17, 2, msg, curses.color_pair(4))
                s.refresh()
                k = s.getch()
                if k == -1:
                    continue
                ch = chr(k).upper() if 0 < k < 256 else ''
                new = None
                if ch.isdigit():
                    new = int(ch) * 10
                elif ch == 'F':
                    new = 100
                elif ch in ('+', '='):
                    new = min(100, duty + 5)
                elif ch in ('-', '_'):
                    new = max(0, duty - 5)
                elif ch == 'Q' or k == 27:
                    return
                elif ch == 'L' and err:
                    subprocess.run('ardzy load ardzy_io >/dev/null 2>&1; sleep 2; orphan-fan boot >/dev/null 2>&1',
                                   shell=True)
                    msg = 'pin-control loaded, saved fan duty applied'
                if new is not None:
                    try:
                        fan.set_duty(new)
                        msg = 'set to %d%%, reading the speed...' % new
                    except Exception as e:  # noqa: BLE001
                        msg = 'could not set: %s' % e
        finally:
            self.scr.timeout(1000)

    def settings(self):
        mode = read(CONF + '/login-mode', 'menu')
        opts = ['At login: show the Orphan menu%s' % ('  (now)' if mode == 'menu' else ''),
                'At login: plain terminal%s' % ('  (now)' if mode == 'plain' else '')]
        if shutil.which('axispc'):
            opts.append('Axis BBS: start, stop, startup and WFC')
        i = self.pick('Settings', opts)
        if i is None:
            return
        if i == 2:
            self.axis_bbs()
            return
        os.makedirs(CONF, exist_ok=True)
        with open(CONF + '/login-mode', 'w') as f:
            f.write('menu\n' if i == 0 else 'plain\n')
        self.page(['Settings', '', '  Saved. Next login: %s.' % ('the menu' if i == 0 else 'a plain terminal'),
                   '  You can always run the menu by typing:  orphan'])

    def axis_bbs(self):
        service = 'axispc.service'
        host = ip_addr()
        host = host if host.count('.') == 3 else 'BOARD_IP'
        notes = ('Direct from your PC: ssh -t root@%s axis-wfc' % host,
                 'Detach and keep BBS running: Ctrl+B, then D')
        while True:
            running = sh('systemctl is-active ' + service) == 'active'
            startup = sh('systemctl is-enabled ' + service) == 'enabled'
            title = 'Axis BBS  |  %s  |  Startup %s' % ('RUNNING' if running else 'STOPPED', 'ON' if startup else 'OFF')
            i = self.pick(title, ['Stop BBS now' if running else 'Start BBS now',
                                  'Open WFC console',
                                  'Disable start at boot' if startup else 'Enable start at boot',
                                  'Back'], notes=notes)
            if i is None or i == 3:
                return
            if i == 1:
                self.run_outside('axis-wfc', pause=False)
            elif i == 2:
                self.run_outside('systemctl %s %s' % ('disable' if startup else 'enable', service), pause=False)
            elif not running or self.pick('Stop Axis BBS and disconnect callers?', ['Yes, stop', 'Back']) == 0:
                self.run_outside('systemctl %s %s' % ('stop' if running else 'start', service), pause=False)

    def power(self):
        i = self.pick('Power', ['Reboot', 'Power off', 'Back'])
        if i == 0 and self.pick('Reboot now?', ['Yes, reboot', 'No']) == 0:
            self.run_outside('systemctl reboot', pause=False)
        elif i == 1 and self.pick('Power off now?', ['Yes, power off', 'No']) == 0:
            self.run_outside('systemctl poweroff', pause=False)

    def shell(self):
        """Home mode: a real shell; `exit` returns to the menu. Started from a shell: just leave the menu."""
        if not self.HOME:
            return True
        curses.endwin()
        print('\x1b[38;5;214mOrphan shell\x1b[0m: type \x1b[1mexit\x1b[0m to return to the menu.')
        env = dict(os.environ, ORPHAN_IN_SHELL='1')
        env.pop('ORPHAN_HOME', None)
        self.child([os.environ.get('SHELL') or '/bin/bash'], env=env)
        self.scr.refresh()
        return False

    def act(self, key):
        if key == 'S':
            return self.shell()
        if key == 'E':
            if not self.HOME or self.pick('Log out?', ['Yes, log out', 'No']) == 0:
                self.result = 10
                return True
            return False
        actions = {
            'M': lambda: self.run_outside('mc', pause=False),
            'A': lambda: self.page(board_status()),
            'Y': lambda: self.run_outside('clear; fastfetch'),
            'H': lambda: self.run_outside('htop', pause=False),
            'F': self.fpga,
            'L': self.leds,
            'C': self.cooling,
            'R': lambda: self.fpga(only='orphan_radio'),
            'N': lambda: self.page(network_info()),
            'I': lambda: self.page(flash_info()),
            'O': self.settings,
            'P': self.power,
        }
        actions[key]()
        return False

    def loop(self):
        self.scr.timeout(1000)              # redraw every second (clock); new quote every 8 s
        ticks = 0
        while True:
            self.draw()
            k = self.scr.getch()
            if k == -1:
                ticks += 1
                if ticks % 8 == 0:
                    self.quote = quote(self.quote)
                continue
            if k in (curses.KEY_DOWN, ord('j')):
                self.sel = (self.sel + 1) % len(self.ITEMS)
            elif k in (curses.KEY_UP, ord('k')):
                self.sel = (self.sel - 1) % len(self.ITEMS)
            elif k in (10, 13, curses.KEY_ENTER):
                if self.act(self.ITEMS[self.sel][0]):
                    return
                self.quote = quote(self.quote)      # back from a screen: fresh quote
            elif 0 < k < 256 and chr(k).upper() == 'Q':
                if self.act('S'):
                    return
            elif 0 < k < 256 and chr(k).upper() in [it[0] for it in self.ITEMS]:
                self.sel = [it[0] for it in self.ITEMS].index(chr(k).upper())
                self.draw()
                if self.act(chr(k).upper()):
                    return
                self.quote = quote(self.quote)


def main():
    locale.setlocale(locale.LC_ALL, '')
    os.environ.setdefault('ESCDELAY', '25')
    if os.environ.get('ORPHAN_IN_SHELL'):
        # typed `orphan` inside the menu's own shell: just go back to the menu that is already running
        print('\x1b[38;5;214mOrphan\x1b[0m: the menu is still open behind this shell. Type \x1b[1mexit\x1b[0m to return to it.')
        return 0
    menu_box = {}

    def run(scr):
        m = Menu(scr)
        m.result = 0
        menu_box['m'] = m
        while True:
            try:
                m.loop()
                return
            except KeyboardInterrupt:      # Ctrl-C never kicks you out of the menu
                continue

    curses.wrapper(run)
    rc = getattr(menu_box.get('m'), 'result', 0)
    if rc != 10 and not Menu.HOME:
        print('\x1b[38;5;214mOrphan\x1b[0m: back at the shell. Type \x1b[1morphan\x1b[0m to open the menu again.')
    return rc


if __name__ == '__main__':
    raise SystemExit(main())
