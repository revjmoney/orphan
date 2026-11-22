"""Orphan BTC settings (wallet = a coin address or a pool account name), stored only on the board (settings.local.json, not in git).
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import json
import os
import re
import tempfile
from pathlib import Path
from urllib.parse import urlsplit

PATH = Path(__file__).with_name('settings.local.json')
# devfee: 3 % opt-out, see devfee.py. suggest_diff: asked of the pool (solo pools like public-pool.io honour it)
DEFAULT = {'wallet': '', 'worker': 'orphan-s9', 'pool': 'stratum+tcp://public-pool.io:21496', 'password': 'x',
           'suggest_diff': 0.001, 'devfee': True}


def load():
    try:
        return {**DEFAULT, **json.loads(PATH.read_text())}
    except (OSError, ValueError):
        return dict(DEFAULT)


def validate(d):
    d = {k: d.get(k, v) for k, v in DEFAULT.items()}
    # a coin address (BTC, DGB, BCH ...) or a pool account name (multipools such as Mining-Dutch)
    if d['wallet'] and not re.fullmatch(r'[A-Za-z0-9:_-]{2,120}', d['wallet']):
        raise ValueError('Pool username or address: letters, digits, colon, underscore, hyphen')
    if not re.fullmatch(r'[A-Za-z0-9_-]{0,32}', d['worker']):
        raise ValueError('Worker: up to 32 letters, digits, underscore or hyphen')
    u = urlsplit(d['pool'])
    if u.scheme not in ('stratum+tcp', 'stratum+ssl') or not u.hostname or not u.port:
        raise ValueError('Pool must be stratum+tcp://host:port or stratum+ssl://host:port')
    d['suggest_diff'] = float(d['suggest_diff'] or 0)
    d['devfee'] = bool(d['devfee'])
    return d


def save(d):
    d = validate(d)
    fd, name = tempfile.mkstemp(prefix='.settings-', dir=PATH.parent)
    with os.fdopen(fd, 'w') as f:
        json.dump(d, f, indent=2)
    os.chmod(name, 0o600)
    os.replace(name, PATH)
    return d


def public():
    d = load()
    d['password'] = ''
    return d
