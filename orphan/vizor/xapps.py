#!/usr/bin/env python3
"""Installed X programs for VIZOR, read from the standard .desktop launchers that packages install
(/usr/share/applications), so anything you `apt install` shows up in the menus by itself.

  xapps.py              list them
  xapps.py --jwm        rebuild JWM's menu (~/.jwmrc of the X desktop) and tell JWM to reload it
                        (run by the apt hook /etc/apt/apt.conf.d/99orphan-xapps after every install or removal)
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
"""
import glob
import html
import json
import os
import re
import subprocess
import sys

DIRS = ['/usr/share/applications', '/usr/local/share/applications']
HERE = os.path.dirname(os.path.abspath(__file__))
XHOME = '/var/lib/vizor-x'
# freedesktop main categories -> the menu's sections, in this order
SECTIONS = [('Science', 'Science & electronics'), ('Development', 'Development'), ('Engineering', 'Science & electronics'),
            ('Electronics', 'Science & electronics'), ('Graphics', 'Graphics'), ('AudioVideo', 'Sound & video'),
            ('Audio', 'Sound & video'), ('Video', 'Sound & video'), ('Network', 'Internet'), ('Office', 'Office'),
            ('Education', 'Education'), ('Game', 'Games'), ('Utility', 'Accessories'), ('Settings', 'Settings'),
            ('System', 'System')]
ORDER = ['Science & electronics', 'Development', 'Graphics', 'Sound & video', 'Internet', 'Office', 'Education',
         'Games', 'Accessories', 'Settings', 'System', 'Other']


def parse(path):
    e, sec = {}, None
    try:
        for line in open(path, encoding='utf-8', errors='replace'):
            line = line.strip()
            if line.startswith('['):
                sec = line
                continue
            if sec != '[Desktop Entry]' or '=' not in line:
                continue
            k, v = line.split('=', 1)
            e.setdefault(k.strip(), v.strip())
    except OSError:
        return None
    if e.get('Type') != 'Application' or e.get('NoDisplay') == 'true' or e.get('Hidden') == 'true' or not e.get('Exec'):
        return None
    if e.get('OnlyShowIn') and 'X-Orphan' not in e['OnlyShowIn']:
        return None
    cats = [c for c in e.get('Categories', '').split(';') if c]
    section = next((name for key, name in SECTIONS if key in cats), 'Other')
    return {'id': os.path.basename(path)[:-8], 'name': e.get('Name', os.path.basename(path)), 'comment': e.get('Comment', ''),
            'exec': e['Exec'], 'terminal': e.get('Terminal') == 'true', 'section': section}


def apps():
    seen, out = set(), []
    for d in DIRS:
        for p in sorted(glob.glob(os.path.join(d, '*.desktop'))):
            a = parse(p)
            if a and a['id'] not in seen:
                seen.add(a['id'])
                out.append(a)
    out.sort(key=lambda a: (ORDER.index(a['section']), a['name'].lower()))
    return out


def command(a):
    """The Exec line without the %f/%u/... field codes; terminal programs run inside xterm."""
    cmd = re.sub(r'%[a-zA-Z%]', '', a['exec']).strip()
    return 'xterm -e ' + cmd if a['terminal'] else cmd


def jwm_menu():
    groups = {}
    for a in apps():
        groups.setdefault(a['section'], []).append(a)
    parts = []
    for sec in ORDER:
        if sec in groups:
            parts.append('    <Menu label="%s">' % html.escape(sec))
            parts += ['      <Program label="%s">%s</Program>' % (html.escape(a['name']), html.escape(command(a)))
                      for a in groups[sec]]
            parts.append('    </Menu>')
    return '\n'.join(parts)


def write_jwmrc(home=XHOME):
    tpl = open(os.path.join(HERE, 'jwmrc'), encoding='utf-8').read()
    bg = os.environ.get('VIZOR_X_BG', '')
    if re.fullmatch(r'#[0-9a-fA-F]{6}', bg):
        tpl = tpl.replace('<Background type="solid">#060809</Background>', '<Background type="solid">%s</Background>' % bg)
    os.makedirs(home, exist_ok=True)
    with open(os.path.join(home, '.jwmrc'), 'w', encoding='utf-8') as f:
        f.write(tpl.replace('<!--APPS-->', jwm_menu()))


if __name__ == '__main__':
    if '--jwm' in sys.argv:
        write_jwmrc()
        subprocess.run(['jwm', '-reload'], env=dict(os.environ, DISPLAY=':1'), stderr=subprocess.DEVNULL)
        print('JWM menu: %d programs' % len(apps()))
    else:
        print(json.dumps(apps(), indent=1))
