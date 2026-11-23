"""Kaspa Stratum bridge dialect: compact u64 jobs and 80-hex-byte jobs.

Protocol basis: rdugan/kaspa-stratum-bridge. No pool connections until Start mining.
Every submitted result is recomputed on ARM before transmission.
"""
import decimal,json,secrets,select,socket,ssl,struct,time
from urllib.parse import urlsplit
from matrix import generate_matrix

DIFF_ONE=(1<<224)-1
def target_for_diff(value):
    with decimal.localcontext() as ctx:
        ctx.prec=100
        diff=decimal.Decimal(str(value))
        if not diff.is_finite() or diff<=0:raise ValueError('Pool sent an invalid difficulty')
        return min((1<<256)-1,int(decimal.Decimal(DIFF_ONE)/diff))
def parse_job(params):
    if not isinstance(params,list) or len(params)<2:raise ValueError('Malformed mining.notify')
    jid=str(params[0])
    if isinstance(params[1],str):
        raw=bytes.fromhex(params[1])
        if len(raw)!=40:raise ValueError('Expected an 80-character Kaspa job')
        seed,ts=raw[:32],int.from_bytes(raw[32:],'little')
    elif len(params)>=3 and isinstance(params[1],list) and len(params[1])==4:
        seed=struct.pack('<4Q',*(int(v) for v in params[1]));ts=int(params[2])
    else:raise ValueError('Unsupported pool job dialect; use Kaspa Stratum bridge')
    if not 0<=ts<(1<<64) or seed==bytes(32):raise ValueError('Invalid job values')
    return jid,seed,ts
def nonce_bounds(prefix):
    if len(prefix)>14 or len(prefix)%2:raise ValueError('Invalid extranonce prefix')
    free=64-4*len(prefix)
    low=int(prefix or '0',16)<<free
    return low,low+((1<<free)-1),free

class Session:
    def __init__(self,engine,settings,cancel,update,totals=None,until=None):
        self.engine,self.settings,self.cancel,self.update=engine,settings,cancel,update
        self.until=until  # monotonic deadline: the session ends cleanly there (dev-fee slices, see devfee.py)
        self.stats=dict(connected=False,authorized=False,accepted=0,rejected=0,submitted=0,jobs=0,difficulty=None,job_id=None)
        for key in ('accepted','rejected','submitted','jobs'):
            self.stats[key]=(totals or {}).get(key,0)
        self.sock=None;self.buffer=b'';self.seq=10;self.pending={};self.job=None;self.current=None;self.prefix='';self.target=None
        self.work_started=time.monotonic()
        self.completed_hashes=0
        self.counting_run=False

    def account_run(self):
        if self.counting_run:
            self.completed_hashes+=self.engine.u64(3)
            self.counting_run=False

    def update_rate(self,hardware=None):
        running=int(hardware['hashes']) if self.counting_run and hardware else 0
        hashed=self.completed_hashes+running
        elapsed=time.monotonic()-self.work_started
        self.stats.update(session_hashes=str(hashed),session_seconds=elapsed,
                          effective_hashrate=hashed/elapsed if elapsed>=2 else None)

    def publish(self,**kw):self.update(mining=dict(self.stats),**kw)
    def send(self,method,params,rid):
        self.sock.sendall((json.dumps({'id':rid,'method':method,'params':params})+'\n').encode())
    def handle(self,msg):
        method=msg.get('method');params=msg.get('params',[])
        event=None
        if method=='mining.notify':
            self.job=parse_job(params);self.stats['jobs']+=1
            event='Received job '+self.job[0]+' timestamp='+str(self.job[2])
        elif method=='mining.set_difficulty':
            self.target=target_for_diff(params[0]);self.stats['difficulty']=str(params[0]);self.engine.stop();self.current=None
            self.stats['expected_hashes_per_share']=(1<<256)/(self.target+1)
            event='Pool difficulty '+str(params[0])+'; expected hashes/share %.3g'%self.stats['expected_hashes_per_share']
        elif method=='mining.set_target':
            self.target=int(params[0],16)
            if not 0<self.target<(1<<256):raise ValueError('Invalid pool target')
            self.engine.stop();self.current=None
            self.stats['expected_hashes_per_share']=(1<<256)/(self.target+1)
            event='Pool supplied explicit share target 0x%064x'%self.target
        elif method=='mining.set_extranonce':
            nonce_bounds(params[0]);self.prefix=params[0];self.engine.stop();self.current=None
            event='Pool assigned extranonce '+self.prefix
        elif not method:
            rid=msg.get('id')
            if rid==2:
                if msg.get('result') is not True or msg.get('error'):raise RuntimeError('Pool rejected wallet/worker authorization')
                self.stats['authorized']=True
                event='Wallet/worker authorized by pool'
            elif rid==1:
                if msg.get('error'):raise RuntimeError('Pool rejected subscription')
                result=msg.get('result')
                if isinstance(result,list) and len(result)>=3 and isinstance(result[1],str):
                    nonce_bounds(result[1]);self.prefix=result[1]
                event='Subscription accepted; extranonce prefix '+(self.prefix or '(none)')
            elif rid in self.pending:
                self.pending.pop(rid)
                self.stats['accepted' if msg.get('result') is True and not msg.get('error') else 'rejected']+=1
                event='Share accepted by pool' if msg.get('result') is True and not msg.get('error') else 'Share rejected: '+str(msg.get('error'))
        self.publish(log_message=event)
    def run(self):
        cfg=self.settings
        if not cfg.get('wallet') or not cfg.get('pool'):raise ValueError('Save a wallet and pool before mining')
        u=urlsplit(cfg['pool'])
        user=cfg['wallet']+'.'+cfg['worker']
        try:
            self.publish(log_message='Connecting to '+cfg['pool'])
            self.sock=socket.create_connection((u.hostname,u.port),timeout=8)
            if u.scheme=='stratum+ssl':self.sock=ssl.create_default_context().wrap_socket(self.sock,server_hostname=u.hostname)
            self.sock.settimeout(5)
            self.sock.setsockopt(socket.IPPROTO_TCP,socket.TCP_NODELAY,1)
            self.send('mining.subscribe',['OrphanKAS/1.0'],1)
            self.send('mining.authorize',[user,cfg.get('password','x')],2)
            self.stats['connected']=True;self.publish(message='Connected; waiting for Kaspa work')
            received=time.monotonic()
            while not self.cancel.is_set():
                if self.until is not None and time.monotonic()>=self.until and not self.pending:break
                readable,_,_=select.select([self.sock],[],[],.05)
                if self.cancel.is_set():break
                if readable:
                    chunk=self.sock.recv(65536)
                    if not chunk:raise ConnectionError('Pool closed the connection')
                    self.buffer+=chunk
                    if len(self.buffer)>262144:raise ValueError('Pool message exceeded limit')
                    while b'\n' in self.buffer:
                        line,self.buffer=self.buffer.split(b'\n',1)
                        if line:self.handle(json.loads(line))
                    received=time.monotonic()
                if time.monotonic()-received>120:raise TimeoutError('Pool stopped sending messages')
                if self.stats['authorized'] and self.job and self.target is not None:
                    jid,seed,ts=self.job
                    key=(jid,seed,ts,self.prefix,self.target)
                    if self.current!=key:
                        if self.counting_run:
                            self.engine.stop()
                            self.account_run()
                        matrix=generate_matrix(seed)
                        lo,hi,free=nonce_bounds(self.prefix)
                        start=lo+secrets.randbits(free)
                        self.engine.configure(seed,ts,start,hi,self.target,matrix)
                        self.engine.start();self.counting_run=True;self.current=key;self.stats['job_id']=jid
                        self.publish(message='Mining on FPGA; new job '+jid)
                    if not self.engine.r(2)&1:
                        result=self.engine.result()
                        if result['found']:
                            nonce=int(result['nonce'])
                            self.seq+=1;self.send('mining.submit',[user,jid,f'{nonce:016x}'],self.seq)
                            self.pending[self.seq]=time.monotonic();self.stats['submitted']+=1
                            self.publish(log_message='CPU-verified nonce %016x submitted for job %s'%(nonce,jid))
                            if nonce<(1<<64)-1 and nonce<self.engine.u64(76):
                                self.account_run()
                                self.engine.words(74,struct.pack('<Q',nonce+1));self.engine.start();self.counting_run=True
                            else:self.job=None
                            self.publish()
                        elif result['exhausted']:self.job=None
                    hardware=self.engine.status()
                    self.update_rate(hardware)
                    self.publish(hardware=hardware)
                if any(time.monotonic()-when>30 for when in self.pending.values()):raise TimeoutError('Pool did not acknowledge a submitted share')
        finally:
            self.engine.stop()
            self.account_run()
            self.update_rate()
            if self.sock:self.sock.close()
            self.stats['connected']=False;self.publish(message='Mining stopped')
