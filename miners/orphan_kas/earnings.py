"""Read-only market and pool telemetry, independent of the mining worker."""
import json
import math
import threading
import time
from urllib.parse import urlencode, urlsplit
from urllib.request import Request, urlopen

NETWORK = 'https://api.kaspa.org/info/'
HERO = 'https://kaspa.herominers.com/api/'
# https://tazmining.ch/coins/Kaspa/solo
TAZ_KASPA_SOLO_PORTS = {7110, 7112, 7114, 7116, 7118}
REFRESH_SECONDS = 120


def read_json(url):
    request = Request(url, headers={'Accept': 'application/json', 'User-Agent': 'OrphanKAS/1.0'})
    with urlopen(request, timeout=5) as response:
        return json.loads(response.read(2_000_000))


def number(value):
    try:
        value = float(value)
    except (TypeError, ValueError, OverflowError):
        return None
    return value if math.isfinite(value) and value >= 0 else None


def market():
    # The Kaspa REST service reports hashrate in TH/s and reward in KAS.
    net_th = number(read_json(NETWORK + 'hashrate').get('hashrate'))
    reward = number(read_json(NETWORK + 'blockreward').get('blockreward'))
    price = number(read_json(NETWORK + 'price').get('price'))
    if not net_th or reward is None or price is None:
        raise ValueError('Missing Kaspa market inputs')
    return dict(network_hs=net_th * 1e12, reward_kas=reward, usd_per_kas=price, updated_at=time.time())


def pool_stats(wallet, host, port=None):
    if wallet and host == 'pool.tazmining.ch' and port in TAZ_KASPA_SOLO_PORTS:
        return dict(status='wallet payouts unavailable', name='Taz Mining', mode='solo',
                    fee_percent=0.5, minimum_kas=1)
    if not wallet or not (host == 'kaspa.herominers.com' or host.endswith('.kaspa.herominers.com')):
        return {'status': 'unsupported' if wallet and host else 'not configured'}
    config = read_json(HERO + 'stats').get('config', {})
    units = number(config.get('coinUnits'))
    if not units:
        raise ValueError('Missing pool coin units')

    def kas(value):
        amount = number(value)
        return amount / units if amount is not None else None

    account = read_json(HERO + 'stats_address?' + urlencode({'address': wallet}))
    stats = account.get('stats')
    stats = stats if isinstance(stats, dict) else None
    pool = dict(status='ready' if stats is not None else 'no wallet data', name='HeroMiners',
                mode=config.get('rewardScheme'), fee_percent=number(config.get('fee')),
                minimum_kas=kas(config.get('minPaymentThreshold')), updated_at=time.time())
    if stats is not None:
        pool.update(balance_kas=kas(stats.get('balance')), paid_kas=kas(stats.get('paid')),
                    paid_week_kas=kas(stats.get('payments_7d')),
                    wallet_hashrate_24h=number(stats.get('hashrate_24h')))
        wallet_minimum = kas(stats.get('minPayoutLevel'))
        if wallet_minimum:
            pool['minimum_kas'] = wallet_minimum
    return pool


class Earnings:
    def __init__(self, config):
        self.config = config
        self.lock = threading.Lock()
        self.changed = threading.Event()
        self.market = {}
        self.pool = {}
        self.pool_key = None
        self.market_stale = False
        threading.Thread(target=self._poll, daemon=True, name='earnings').start()

    @staticmethod
    def key(config):
        pool = urlsplit(config.get('pool', ''))
        return config.get('wallet', ''), pool.hostname or '', pool.port

    def _poll(self):
        while True:
            self.changed.clear()
            key = self.key(self.config())
            with self.lock:
                need_market = time.time() - self.market.get('updated_at', 0) >= REFRESH_SECONDS
            if need_market:
                try:
                    fresh = market()
                except (OSError, ValueError, TypeError):
                    with self.lock:
                        self.market_stale = True
                else:
                    with self.lock:
                        self.market, self.market_stale = fresh, False
            try:
                fresh_pool = pool_stats(*key)
            except (OSError, ValueError, TypeError):
                with self.lock:
                    fresh_pool = {**self.pool, 'status': 'stale'} if key == self.pool_key else {'status': 'unavailable'}
            with self.lock:
                self.pool, self.pool_key = fresh_pool, key
            self.changed.wait(REFRESH_SECONDS)

    def snapshot(self, settings, hardware, mining, mode):
        with self.lock:
            data = self.market.copy()
            stale = self.market_stale
            pool = self.pool.copy() if self.pool_key == self.key(settings) else {'status': 'loading'}
        effective = number(mining.get('effective_hashrate')) if mode == 'mine' else None
        live = effective is not None and mining.get('connected', False)
        rate = effective if live else number(hardware.get('hashrate'))
        if data and rate is not None:
            # Crescendo targets ten blocks per second. The estimate excludes transaction fees.
            daily = rate / data['network_hs'] * data['reward_kas'] * 864_000
            data.update(kas_per_day=daily, usd_per_day=daily * data['usd_per_kas'],
                        rate_hs=rate, rate_source='wall clock' if live else 'FPGA rate')
            fee = pool.get('fee_percent')
            if fee is not None and 0 <= fee <= 100:
                data['kas_per_day_after_pool_fee'] = daily * (1 - fee / 100)
                data['usd_per_day_after_pool_fee'] = data['kas_per_day_after_pool_fee'] * data['usd_per_kas']
        return {'market': data, 'market_stale': stale, 'pool': pool}
