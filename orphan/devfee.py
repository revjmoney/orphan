"""Orphan dev fee: 3 % of mining time goes to the Orphan developer (Rev. J. Money), ON by default, opt-out.

How it works: mining time is split into slices. For every 97 minutes mined to YOUR wallet, the miner reconnects to
the same pool with the developer's wallet for 3 minutes, then switches back. Nothing else changes: same pool, same
hardware, and the page shows when a dev-fee slice is running. Turn it off with the "3 % dev fee" checkbox in the page
(setting "devfee": false). Time already mined is remembered across restarts so stopping early never skips the fee
or charges it twice. Every Orphan mining core uses this same rule: copy this file next to the miner, add the
coin's developer wallet to DEV_WALLETS, call Schedule().next() before each pool session and Schedule().add() after,
and show the opt-out checkbox + a DEV FEE SLICE badge in its page (miners/orphan_btc is the reference).
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import json
import os
import tempfile
from pathlib import Path

PERCENT = 3
USER_SLICE = 97 * 60          # seconds mined to the user's wallet between dev-fee slices
DEV_SLICE = 3 * 60            # seconds mined to the developer's wallet
DEV_WALLETS = {'kaspa': 'kaspa:qpqy4jv6f4wmhsp6aurpnz86ntm7jqzv8nycxrjampf0jtaar3577vtlrvl8q',
               'bitcoin': 'bc1q9cpt3lzge8qedd2evx2lmr47xkxnkecunc78xc'}
DEV_WORKER = 'orphan-devfee'
# Miners whose users may pick any pool (several coins, multipools) send the dev-fee slice to the developer's own pool
# account instead of the user's pool: SHA-256 -> Rev's Mining-Dutch account (auto-exchange multipool).
DEV_POOLS = {'sha256': {'pool': 'stratum+tcp://americas.mining-dutch.nl:9996', 'wallet': 'revjmoney',
                        'worker': DEV_WORKER, 'password': 'd=10', 'suggest_diff': 0}}  # d=10: its floor
LEDGER = Path(__file__).with_name('devfee.local.json')


class Schedule:
    """Decides the next slice from the time mined so far: ('user' | 'dev', seconds)."""

    def __init__(self, path=LEDGER):
        self.path = path
        try:
            d = json.loads(self.path.read_text())
            self.user, self.dev = float(d.get('user', 0)), float(d.get('dev', 0))
        except (OSError, ValueError):
            self.user = self.dev = 0.0

    def owed(self):
        """Dev-fee seconds owed for the user time mined so far."""
        return self.user * PERCENT / (100 - PERCENT) - self.dev

    def next(self):
        owed = self.owed()
        if owed >= DEV_SLICE * 0.5:
            return 'dev', min(DEV_SLICE * 2, owed)
        return 'user', USER_SLICE

    def add(self, role, seconds):
        if seconds <= 0:
            return
        if role == 'dev':
            self.dev += seconds
        else:
            self.user += seconds
        settled = min(self.user, self.dev * (100 - PERCENT) / PERCENT)   # drop the part already paid in full
        self.user -= settled
        self.dev -= settled * PERCENT / (100 - PERCENT)
        try:
            fd, name = tempfile.mkstemp(prefix='.devfee-', dir=self.path.parent)
            with os.fdopen(fd, 'w') as f:
                json.dump({'user': self.user, 'dev': self.dev}, f)
            os.replace(name, self.path)
        except OSError:
            pass


def dev_settings(cfg, coin='kaspa'):
    """The pool settings for a dev-fee slice: the developer's own pool account when the algorithm has one
    (DEV_POOLS), else the same pool with the developer's wallet and worker name."""
    if coin in DEV_POOLS:
        return {**cfg, **DEV_POOLS[coin]}
    return {**cfg, 'wallet': DEV_WALLETS[coin], 'worker': DEV_WORKER}
