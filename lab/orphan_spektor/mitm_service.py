"""[orphan] INTERSEKTOR service: the UART man-in-the-middle bridge's side of the web service (main.py imports it).
Keeps the heartbeat, reads the FPGA log, runs the HOLD rule engines, saves the settings. GO is never saved: the
bridge's outputs always start off.
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""
import collections
import json
import os
import threading
import time

from intersektor_hw import DEFAULT_DIRS, Intersektor, RuleEngine


def unescape(s):
    """Rule / inject text: plain text with \\n \\r \\t \\xNN escapes, or 'hex:' followed by hex bytes."""
    s = str(s)
    if s.lower().startswith('hex:'):
        return bytes.fromhex(s[4:].replace(' ', ''))
    return s.encode('latin-1', 'replace').decode('unicode_escape').encode('latin-1', 'replace')


class MitmService:
    def __init__(self, bus, lock, here):
        self.ik = Intersektor(bus)
        self.lock = lock                                    # the bus lock shared with SPEKTOR
        self.file = os.path.join(here, 'mitm.local.json')   # directions + rules
        self.dirs = [dict(d) for d in DEFAULT_DIRS]
        self.test = False
        self.rules = []
        self.paused = [False, False]
        self.pending = [bytearray(), bytearray()]
        self.seq = 0
        self.log = collections.deque(maxlen=6000)          # {'s': seq, 't': us, 'k': kind, 'd': dir, 'b': byte, 'o': sent}
        self.engines = [RuleEngine(), RuleEngine()]
        self.mlock = threading.Lock()
        self.load()
        threading.Thread(target=self.loop, daemon=True).start()

    # ---- settings
    def apply_cfg(self):
        with self.lock:
            for d, c in enumerate(self.dirs):
                self.ik.set_dir(d, baud=c['baud'], rx=c['rx'], tx=c['tx'], mode=c['mode'])
            self.ik.set_ctrl(test=self.test)

    def apply_rules(self):
        """1-byte rules also go into the FPGA swap tables (RELAY); every rule feeds the HOLD engine."""
        for d in range(2):
            rs = [(unescape(r['find']), unescape(r['repl'])) for r in self.rules if r.get('on', True) and r['dir'] == d]
            self.engines[d].set_rules(rs)
            with self.lock:
                self.ik.clear_table(d)
                for f, r in rs:
                    if len(f) == 1 and len(r) <= 1:
                        self.ik.table(d, f[0], r[0] if r else None, drop=not r)

    def save(self):
        json.dump({'dirs': self.dirs, 'test': self.test, 'rules': self.rules}, open(self.file, 'w'))

    def load(self):
        try:
            c = json.load(open(self.file))
            for d in range(2):
                self.dirs[d].update({k: int(v) for k, v in c['dirs'][d].items() if k in ('mode', 'baud', 'rx', 'tx')})
            self.rules = [self.clean_rule(r) for r in list(c.get('rules', []))[:64]]
            self.test = bool(c.get('test'))
        except (OSError, ValueError, KeyError, IndexError, TypeError):
            pass
        self.apply_cfg()
        self.apply_rules()

    @staticmethod
    def clean_rule(r):
        unescape(r.get('find', ''))                         # raises on a bad escape
        unescape(r.get('repl', ''))
        return {'dir': int(r.get('dir', 0)) & 1, 'find': str(r.get('find', ''))[:200],
                'repl': str(r.get('repl', ''))[:200], 'on': bool(r.get('on', True))}

    # ---- the loop
    def send(self, d, data, timeout=5.0):
        """Queue bytes on direction d, as fast as its 512-byte queue takes them (the bus lock is not held while
        waiting, so SPEKTOR keeps working)."""
        data, t, reg = bytes(data), time.time(), 16 + 8 * d + 3
        while data:
            with self.lock:
                n = min(len(data), 512 - self.ik.rd(reg))
                for x in data[:n]:
                    self.ik.wr(reg, x)
            data = data[n:]
            if data:
                if time.time() - t > timeout:
                    return False
                time.sleep(0.002)
        return True

    def loop(self):
        """Heartbeat, log, HOLD rules: every 2 ms while the bridge is in use, 50 ms while it is all OFF."""
        while True:
            busy = (self.ik.ctrl & 1) or any(c['mode'] for c in self.dirs)
            time.sleep(0.002 if busy else 0.05)
            try:
                with self.lock:
                    self.ik.heartbeat()
                    ents = self.ik.log()
                now = time.time()
                outs = [b'', b'']
                with self.mlock:
                    for k, d, b, o, t in ents:
                        self.seq += 1
                        self.log.append({'s': self.seq, 't': t, 'k': k, 'd': d, 'b': b, 'o': o})
                        if k == 4:                          # HELD: the ARM decides
                            if self.paused[d]:
                                if len(self.pending[d]) < 4096:
                                    self.pending[d].append(b)
                            else:
                                outs[d] += self.engines[d].feed(bytes([b]), now)
                    for d in range(2):
                        if not self.paused[d]:
                            outs[d] += self.engines[d].flush_due(now)
                for d in range(2):
                    if outs[d]:
                        self.send(d, outs[d])
            except Exception as e:  # noqa: BLE001  (keep the heartbeat alive whatever happens)
                print('[intersektor] loop:', e, flush=True)
                time.sleep(0.1)

    # ---- the web API
    def state(self, since=0):
        with self.lock:
            st = self.ik.status()
        with self.mlock:
            st.update(cfg=self.dirs, rules=self.rules, paused=self.paused, pending=[p.hex() for p in self.pending],
                      hits=[e.hits for e in self.engines], log=[e for e in self.log if e['s'] > since][-1500:],
                      seq=self.seq)
        return st

    def action(self, d):
        """POST {action: 'mitm', op: ...}."""
        op = d.get('op')
        if op == 'cfg':                                     # {dirs: [{mode, baud, rx, tx}, ...], test}
            for i, c in enumerate((d.get('dirs') or [])[:2]):
                for k in ('mode', 'baud', 'rx', 'tx'):
                    if k in c:
                        self.dirs[i][k] = int(c[k])
                self.dirs[i]['mode'] = max(0, min(3, self.dirs[i]['mode']))
                self.dirs[i]['rx'] = max(0, min(35, self.dirs[i]['rx']))
                self.dirs[i]['tx'] = max(0, min(35, self.dirs[i]['tx']))
                self.dirs[i]['baud'] = max(96, min(6250000, self.dirs[i]['baud']))
            if 'test' in d:
                self.test = bool(d['test'])
            self.apply_cfg()
            self.save()
            return {'conflict': self.conflicts()}
        if op == 'go':
            with self.lock:
                self.ik.set_ctrl(go=bool(d.get('on')))
            return {'conflict': self.conflicts()}
        if op == 'rules':
            self.rules = [self.clean_rule(r) for r in (d.get('rules') or [])[:64]]
            self.apply_rules()
            self.save()
            return {}
        i = int(d.get('dir', 0)) & 1
        if op == 'pause':
            with self.mlock:
                self.paused[i] = bool(d.get('on'))
            return {}
        if op == 'forward':                                 # send the (edited) held bytes, empty the queue
            with self.mlock:
                data = bytes.fromhex(d['hex']) if 'hex' in d else bytes(self.pending[i])
                self.pending[i] = bytearray()
            return {'sent': len(data), 'ok': self.send(i, data)}
        if op == 'discard':
            with self.mlock:
                self.pending[i] = bytearray()
            return {}
        if op == 'inject':
            data = unescape(d.get('data', ''))
            return {'sent': len(data), 'ok': self.send(i, data)}
        if op == 'testsend':
            data = unescape(d.get('data', ''))
            with self.lock:
                ok = self.ik.test_send(i, data)
            return {'sent': len(data), 'ok': ok}
        if op == 'clearlog':
            with self.lock:
                self.ik.clear_log()
                self.ik.clear_counts()
            with self.mlock:
                self.log.clear()
            return {}
        raise ValueError('unknown mitm op')

    def conflicts(self):
        """Directions that are on and whose transmit pin is a receive pin in use or the other one's transmit pin."""
        on = [c for c in self.dirs if c['mode']]
        bad = []
        for i, c in enumerate(self.dirs):
            if c['mode'] and (c['tx'] in [x['rx'] for x in on] or
                              any(x['tx'] == c['tx'] for j, x in enumerate(self.dirs) if j != i and x['mode'])):
                bad.append(i)
        return bad
