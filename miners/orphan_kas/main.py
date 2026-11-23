"""Orphan KAS web control service; one owner for all FPGA accesses."""
import argparse,http.server,json,queue,threading,time,traceback,collections
from pathlib import Path
from driver import Engine,self_test
import settings,devfee
from stratum import Session
from earnings import Earnings

HERE=Path(__file__).resolve().parent
SETTINGS_READ_ERROR='Cannot read saved wallet/pool settings. Check the SD card and filesystem.'
class Controller:
    def __init__(self):
        self.lock=threading.Lock();self.cancel=threading.Event();self.commands=queue.Queue(maxsize=1)
        self.logs=collections.deque(maxlen=300);self.log_sequence=0
        self.state={'mode':'idle','message':'Ready','job':None,'hardware':{},'test':None,'last_result':None,'error':None,'settings':settings.DEFAULT.copy(),'mining':{}}
        self.state['settings']['password']=''
        try:
            self.state['settings']=settings.public()
        except OSError:
            self.update(error=SETTINGS_READ_ERROR, message='Wallet/pool settings unavailable')
        self.earnings=Earnings(lambda:self.state['settings'])
        self.active=False
        resume=False
        marker=HERE/'resume.local.json'
        if marker.exists():
            try:
                saved=json.loads(marker.read_text());resume=bool(saved.get('mining'));self.state['mining']=saved.get('totals',{})
            finally:marker.unlink(missing_ok=True)
        threading.Thread(target=self.worker,daemon=True).start()
        if resume:threading.Thread(target=self.resume_mining,daemon=True).start()
    def resume_mining(self):
        for _ in range(100):
            if self.snapshot()['hardware']:
                self.submit({'action':'mine'});self.log('Resumed the active mining session after service update');return
            time.sleep(.1)
        self.log('Could not resume: FPGA did not become available','error')
    def _append_log(self,message,level='info'):
        self.log_sequence+=1
        self.logs.append({'seq':self.log_sequence,'time':time.time(),'level':level,'message':str(message)[:700]})
    def log(self,message,level='info'):
        with self.lock:self._append_log(message,level)
    def snapshot(self):
        with self.lock:state=json.loads(json.dumps({**self.state,'logs':list(self.logs)}))
        state['earnings']=self.earnings.snapshot(state['settings'],state['hardware'],state['mining'],state['mode'])
        return state
    def update(self,**kw):
        event=kw.pop('log_message',None);level=kw.pop('log_level','info')
        with self.lock:
            if event:self._append_log(event,level)
            if kw.get('message') and kw['message']!=self.state['message']:self._append_log(kw['message'])
            if kw.get('error') and kw['error']!=self.state['error']:self._append_log(kw['error'],'error')
            self.state.update(kw)
    def submit(self,command):
        with self.lock:
            if self.active:raise ValueError('A task is already running. Stop it first.')
            if not self.state['hardware']:raise ValueError('Load the Orphan KAS FPGA project before starting a task.')
            self.active=True
        self.cancel.clear();self.commands.put_nowait(command)
        self.log('Queued command: '+command['action'])
    def worker(self):
        engine=None
        while True:
            try:
                if engine is None:engine=Engine()
                try:cmd=self.commands.get(timeout=.2)
                except queue.Empty:
                    self.update(hardware=engine.status());continue
                self.update(error=None,mode=cmd['action'],message='Preparing FPGA job')
                try:
                    if cmd['action']=='selftest':
                        result=self_test(engine,self.cancel)
                        self.update(test=result,message=f"PASS: {result['passed']} hash vectors and {result['range_tests']} ranges")
                    elif cmd['action']=='fan':engine.fan(cmd['duty'])
                    elif cmd['action']=='mine':
                        try:
                            pool_settings=settings.load()
                        except OSError as exc:
                            raise RuntimeError(SETTINGS_READ_ERROR) from exc
                        fee=devfee.Schedule()
                        while not self.cancel.is_set():
                            # 3 % dev fee, opt-out ("devfee" setting): 3 of every 100 minutes to the developer's wallet
                            role,secs=fee.next() if pool_settings.get('devfee',True) else ('user',3600)
                            cfg=devfee.dev_settings(pool_settings) if role=='dev' else pool_settings
                            self.update(devfee={'enabled':bool(pool_settings.get('devfee',True)),'active':role=='dev',
                                                'percent':devfee.PERCENT},
                                        log_message=('Dev fee: mining %d s for the Orphan developer (3 %%, opt-out in settings)'%secs) if role=='dev' else None)
                            began=time.monotonic()
                            try:
                                Session(engine,cfg,self.cancel,self.update,self.snapshot()['mining'],until=began+secs).run()
                            except (ConnectionError,OSError,TimeoutError) as exc:
                                self.update(message=str(exc)+'; retrying pool in 5 seconds')
                                if self.cancel.wait(5):break
                            finally:
                                if pool_settings.get('devfee',True):fee.add(role,time.monotonic()-began)
                        self.update(devfee={'enabled':bool(pool_settings.get('devfee',True)),'active':False,'percent':devfee.PERCENT})
                        self.update(message='Mining stopped')
                    else:
                        seed=bytes.fromhex(cmd.get('seed','2a'*32));ts=int(cmd.get('timestamp','5435345234'))
                        start=int(cmd.get('start','0'));end=int(cmd.get('end','999999'))
                        target=int(cmd.get('target','0'),16)
                        engine.configure(seed,ts,start,end,target)
                        self.update(job={'seed':seed.hex(),'timestamp':str(ts),'start':str(start),'end':str(end),'target':f'{target:064x}'},message='Searching nonce range')
                        engine.start();deadline=time.monotonic()+float(cmd.get('timeout',300))
                        while engine.r(2)&1:
                            self.update(hardware=engine.status())
                            if self.cancel.wait(.1):engine.stop();break
                            if time.monotonic()>deadline:engine.stop();raise TimeoutError('Job time limit reached')
                        result=engine.result()
                        self.update(hardware=result,last_result=result,message='CPU-verified result' if result.get('verified') else 'Stopped')
                    self.update(mode='idle',hardware=engine.status())
                except Exception as exc:
                    engine.stop()
                    self.update(mode='idle',error=str(exc),message='Task failed')
                finally:
                    with self.lock:self.active=False
            except Exception as exc:
                self.update(error=str(exc),message='Load the orphan_kas FPGA project to continue')
                engine=None
                with self.lock:self.active=False
                time.sleep(1)

class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self,*args):pass
    def send(self,code,data,kind='application/json'):
        data=data if isinstance(data,bytes) else json.dumps(data).encode()
        self.send_response(code);self.send_header('Content-Type',kind);self.send_header('Content-Length',str(len(data)))
        self.send_header('Cache-Control','no-store');self.send_header('X-Content-Type-Options','nosniff');self.end_headers();self.wfile.write(data)
    def do_GET(self):
        if self.path=='/api/status':self.send(200,self.server.control.snapshot())
        elif self.path=='/':self.send(200,(HERE/'index.html').read_bytes(),'text/html; charset=utf-8')
        else:self.send(404,{'error':'Not found'})
    def do_POST(self):
        try:
            origin=self.headers.get('Origin')
            if origin and origin not in ('http://'+self.headers.get('Host',''),'https://'+self.headers.get('Host','')):
                raise ValueError('Cross-origin commands are not accepted')
            if self.path!='/api/command' or self.headers.get_content_type()!='application/json':raise ValueError('Expected JSON command')
            size=int(self.headers.get('Content-Length','0'))
            if not 0<size<=8192:raise ValueError('Invalid request size')
            cmd=json.loads(self.rfile.read(size))
            action=cmd.get('action')
            if action=='stop':self.server.control.cancel.set()
            elif action=='settings':
                with self.server.control.lock:
                    if self.server.control.active:raise ValueError('Stop mining before changing wallet settings')
                    data=cmd['settings']
                    try:
                        if not data.get('password'):data['password']=settings.load()['password']
                        saved=settings.save(data)
                    except OSError:
                        storage_failed=True
                    else:
                        storage_failed=False
                        self.server.control.state['settings']={**saved,'password':''}
                        earnings=getattr(self.server.control,'earnings',None)
                        if earnings is not None:earnings.changed.set()
                if storage_failed:
                    self.send(503,{'error':'Cannot access wallet/pool settings. Check the SD card and filesystem.'})
                    return
                self.server.control.log('Wallet/pool settings saved; passwords are omitted from this log')
            elif action in ('selftest','benchmark','job','fan','mine'):
                if action in ('benchmark','job'):
                    seed=bytes.fromhex(cmd.get('seed','2a'*32))
                    if len(seed)!=32 or seed==bytes(32):raise ValueError('Enter a nonzero 32-byte pre-PoW hash')
                    if not 0<=int(cmd.get('timestamp','5435345234'))<1<<64:raise ValueError('Timestamp exceeds u64')
                    if not 0<=int(cmd.get('start','0'))<=int(cmd.get('end','999999'))<1<<64:raise ValueError('Invalid inclusive nonce range')
                    if not 0<=int(cmd.get('target','0'),16)<1<<256:raise ValueError('Invalid 256-bit target')
                    if not 1<=float(cmd.get('timeout',300))<=3600:raise ValueError('Time limit must be 1..3600 seconds')
                if action=='fan' and not 0<=int(cmd['duty'])<=100:raise ValueError('Fan duty must be 0..100')
                self.server.control.submit(cmd)
            else:raise ValueError('Unknown action')
            self.send(202,{'ok':True})
        except (ValueError,KeyError,TypeError,json.JSONDecodeError) as exc:self.send(400,{'error':str(exc)})

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--bind',default='0.0.0.0');parser.add_argument('--port',type=int,default=8000)
    args=parser.parse_args();server=http.server.ThreadingHTTPServer((args.bind,args.port),Handler)
    server.control=Controller()
    print(f'Orphan KAS | by JMSCNC, makers of RotatoCAM | port {args.port}',flush=True)
    try:server.serve_forever()
    finally:server.control.cancel.set();server.server_close()
