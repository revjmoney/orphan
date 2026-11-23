"""Bounded, CPU-verified driver for the KAS1 FPGA engine."""
import json,struct,time
from pathlib import Path
from reference import matrix_words,kheavyhash
from matrix import generate_matrix

MAX64=(1<<64)-1
class Engine:
    def __init__(self):
        from ardzy import MMIO
        self.mmio=MMIO(0x43c00000,0x10000)
        self.check()
        self.matrix=None

    def r(self,i):return self.mmio.read(0x1000+4*i)
    def w(self,i,v):self.mmio.write(0x1000+4*i,int(v)&0xffffffff)
    def check(self):
        state=Path('/sys/class/fpga_manager/fpga0/state').read_text().strip()
        if state!='operating': raise RuntimeError('FPGA is not operating. Load orphan_kas first.')
        if self.r(0)!=0x4b415331: raise RuntimeError('Load the Orphan KAS1 FPGA project first.')
    def u64(self,i):
        for _ in range(10):
            high=self.r(i+1); low=self.r(i)
            if high==self.r(i+1):return (high<<32)|low
        raise RuntimeError('Counter snapshot failed')
    def words(self,i,data):
        for n,value in enumerate(struct.unpack('<'+'I'*(len(data)//4),data)):self.w(i+n,value)
    def stop(self):
        self.check(); self.w(1,2)
        limit=time.monotonic()+1
        while self.r(2)&1:
            if time.monotonic()>limit:raise TimeoutError('FPGA stop timed out')
            time.sleep(.001)
    def configure(self,seed,timestamp,start,end,target,matrix=None):
        if len(seed)!=32 or seed==bytes(32):raise ValueError('Pre-PoW hash must be 32 nonzero bytes')
        if not 0<=timestamp<=MAX64 or not 0<=start<=end<=MAX64:raise ValueError('Invalid timestamp or nonce range')
        if not 0<=target<(1<<256):raise ValueError('Target must fit 256 bits')
        self.stop()
        self.matrix=matrix if matrix is not None else generate_matrix(seed)
        self.seed,self.timestamp,self.target=seed,timestamp,target
        self.words(64,seed);self.words(72,struct.pack('<QQQ',timestamp,start,end))
        self.words(80,target.to_bytes(32,'little'))
        for i,word in enumerate(matrix_words(self.matrix)):self.w(512+i,word)
        # Read back configuration before starting.
        if bytes().join(self.r(64+i).to_bytes(4,'little') for i in range(8))!=seed:
            raise RuntimeError('FPGA configuration readback failed')
    def start(self):
        self.check(); self.w(1,1)
        if self.r(2)&16:raise RuntimeError('FPGA rejected job')
    def status(self):
        self.check()
        status=self.r(2)
        hashes=self.u64(3);cycles=self.u64(5)
        temp=None
        for path in Path('/sys/bus/iio/devices').glob('iio:device*/in_temp0_raw'):
            try:temp=(int(path.read_text())+float(path.with_name('in_temp0_offset').read_text()))*float(path.with_name('in_temp0_scale').read_text())/1000
            except (OSError,ValueError):pass
        return dict(temperature=temp,busy=bool(status&1),found=bool(status&2),exhausted=bool(status&4),
                    stopped=bool(status&8),error=bool(status&16),hashes=str(hashes),cycles=str(cycles),
                    nonce=str(self.u64(7)),hash=bytes().join(self.r(9+i).to_bytes(4,'little') for i in range(8)).hex(),
                    hashrate=hashes*100000000/max(1,cycles),fan=self.mmio.read(0xf004),
                    rpm=[self.mmio.read(0xf008+4*i)*30 for i in range(6)])
    def result(self):
        state=self.status()
        if state['busy']:raise RuntimeError('Job has not finished')
        if int(state['hashes']):
            expected=kheavyhash(self.seed,self.timestamp,int(state['nonce']),self.matrix).hex()
            if state['hash']!=expected:raise RuntimeError('FPGA hash disagrees with CPU oracle')
            if state['found'] and int.from_bytes(bytes.fromhex(expected),'little')>self.target:
                raise RuntimeError('FPGA returned a hash above target')
            state['verified']=True
        return state
    def wait(self,timeout=10,cancel=None):
        limit=time.monotonic()+timeout
        while self.r(2)&1:
            if cancel and cancel.is_set():self.stop();return self.status()
            if time.monotonic()>limit:self.stop();raise TimeoutError('FPGA job timed out')
            time.sleep(.005)
        return self.result()
    def fan(self,duty):
        self.check()
        duty=int(duty)
        if not 0<=duty<=100:raise ValueError('Fan duty must be 0..100')
        self.mmio.write(0xf004,duty)

def self_test(engine,cancel=None):
    vectors=json.loads(Path(__file__).with_name('vectors.json').read_text())
    passed=0
    for v in vectors:
        seed=bytes.fromhex(v['seed']);ts=int(v['timestamp']);start=int(v['start'])
        matrix=generate_matrix(seed)
        for i,expected in enumerate(v['hashes']):
            if cancel and cancel.is_set():raise RuntimeError('Self-test cancelled')
            nonce=start+i;target=int.from_bytes(bytes.fromhex(expected),'little')
            engine.configure(seed,ts,nonce,nonce,target,matrix)
            engine.start();state=engine.wait(3,cancel)
            if not state.get('verified') or not state['found'] or state['hash']!=expected or int(state['hashes'])!=1:
                raise RuntimeError('Hardware known-answer self-test failed')
            passed+=1
        engine.configure(seed,ts,start,start+len(v['hashes'])-1,0,matrix)
        engine.start();state=engine.wait(3,cancel)
        if not state['exhausted'] or int(state['hashes'])!=len(v['hashes']):raise RuntimeError('Range exhaustion test failed')
    return dict(passed=passed,range_tests=len(vectors),result='PASS')
