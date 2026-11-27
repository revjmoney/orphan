"""User-controlled pool settings, stored only on the board."""
import json,os,re,tempfile
from pathlib import Path
PATH=Path(__file__).with_name('settings.local.json')
DEFAULT={'wallet':'','wallets':[],'worker':'orphan-s9','pool':'','password':'x','devfee':True}  # devfee: 3 % opt-out, see devfee.py
def load():
    try:return {**DEFAULT,**json.loads(PATH.read_text())}
    except FileNotFoundError:return dict(DEFAULT)
def validate(data):
    data={k:data.get(k,v) for k,v in DEFAULT.items()}
    if not isinstance(data['wallets'],list) or len(data['wallets'])>16:raise ValueError('At most 16 wallet addresses')
    wallets=list(dict.fromkeys([data['wallet']]+data['wallets']))
    for wallet in wallets:
        # a Kaspa receive address, or a pool account name (Mining-Dutch logs in as account.worker, not an address)
        if wallet and not (re.fullmatch(r'(kaspa|kaspatest|kaspasim):[a-z0-9]{61,63}',wallet)
                           or re.fullmatch(r'[A-Za-z0-9_-]{1,64}',wallet)):
            raise ValueError('Wallet: a full Kaspa address (kaspa:...) or a pool account name (letters, digits, _ or -)')
    data['wallets']=[w for w in wallets if w]
    if not re.fullmatch(r'[A-Za-z0-9_-]{1,32}',data['worker']):raise ValueError('Worker: 1..32 letters, digits, underscore or hyphen')
    from urllib.parse import urlsplit
    if data['pool']:
        u=urlsplit(data['pool'])
        if u.scheme not in ('stratum+tcp','stratum+ssl') or not u.hostname or not u.port or u.path or u.username:
            raise ValueError('Pool must be stratum+tcp://host:port or stratum+ssl://host:port')
    if not isinstance(data['password'],str) or len(data['password'])>128:raise ValueError('Pool password is too long')
    data['devfee']=bool(data['devfee'])
    return data
def save(data):
    data=validate(data)
    fd,name=tempfile.mkstemp(prefix='.settings-',dir=PATH.parent)
    try:
        os.chmod(name,0o600)
        with os.fdopen(fd,'w') as f:json.dump(data,f,indent=2);f.flush();os.fsync(f.fileno())
        os.replace(name,PATH)
    finally:
        if os.path.exists(name):os.unlink(name)
    return data
def public():
    return load()   # the page shows every saved setting, the pool password too (Rev's call; LAN-only page)
