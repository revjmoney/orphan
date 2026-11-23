"""Orphan FPGA graphics toys. FPGA renders; ARM transports completed captures."""
import http.server,json,math,os,socket,struct,threading,time,urllib.request
from pathlib import Path
from blocks import Bus,Life,life_step

HERE=Path(__file__).resolve().parent
LEVEL=json.loads((HERE/'level.json').read_text())
bus=Bus();life=Life(bus,1)
if bus.rd(0,1)!=0x544f5931:raise SystemExit('Load Orphan Toys (TOY1) first')
lock=threading.Lock();frame=bytes(160*120*2)
try:display=Path('/etc/orphan/display-target').read_text().strip()
except OSError:display='orphan-remote.local'
state=dict(mode='raycast',angle=0.0,x=7.5,y=5.5,auto=True,display=display,send=True,fps=0,fpga_us=0,read_ms=0,wifi_ms=0,temperature=None,error=None,frames=0,benchmark=False,life_benchmark=None)

def temperature():
    for p in Path('/sys/bus/iio/devices').glob('iio:device*/in_temp0_raw'):
        try:return (int(p.read_text())+float(p.with_name('in_temp0_offset').read_text()))*float(p.with_name('in_temp0_scale').read_text())/1000
        except (OSError,ValueError):pass
    return None

def move(direction):
    state['auto']=False
    if direction=='left':state['angle']-=.15
    if direction=='right':state['angle']+=.15
    if direction in ('forward','back'):
        step=.2 if direction=='forward' else -.2
        x=state['x']+math.cos(state['angle'])*step;y=state['y']+math.sin(state['angle'])*step
        if 1<=x<15 and 1<=y<15 and LEVEL[int(y)][int(x)]=='0':state['x']=x;state['y']=y

def inputs():
    cursor=0;initialized=False
    while True:
        try:
            with urllib.request.urlopen('http://127.0.0.1:8090/api/events?after='+str(cursor),timeout=1) as r:events=json.load(r)['events']
            for event in events:
                if initialized and event['type']=='touch' and event['y']<205:
                    with lock:move('left' if event['x']<100 else 'right' if event['x']>220 else 'forward' if event['y']<140 else 'back')
                cursor=max(cursor,event['seq'])
            initialized=True
        except Exception:pass
        time.sleep(.2)

class Display:
    def __init__(self):
        self.host=None
        self.address=None
        self.scaled=False
        self.refresh_at=0

    def send(self,host,data,smooth):
        if self.host!=host or time.monotonic()>=self.refresh_at:
            self.address=socket.gethostbyname(host)
            self.host=host
            try:
                with urllib.request.urlopen(f'http://{self.address}/status',timeout=.7) as response:
                    self.scaled=bool(json.load(response).get('scale2'))
            except (OSError,ValueError):
                self.scaled=False
            self.refresh_at=time.monotonic()+30
        if self.scaled:
            rect=f'w=160&h=120&scale=2&smooth={int(smooth)}'
        else:
            rect='w=320&h=240'
            data=self.expand(data)
        request=(f'POST /rect?x=0&y=0&{rect} HTTP/1.1\r\nHost: {host}\r\n'
                 f'Content-Length: {len(data)}\r\nConnection: close\r\n\r\n').encode()
        try:
            with socket.create_connection((self.address,8091),timeout=2) as c:
                c.settimeout(3)
                c.sendall(request+data)
                with c.makefile('rb') as response:
                    if not response.readline(128).startswith(b'HTTP/1.1 200 '):
                        raise RuntimeError('CYD rejected frame')
        except (OSError,RuntimeError):
            self.refresh_at=0
            raise

    @staticmethod
    def expand(data):
        # Compatibility with receivers that expect panel-sized RGB565 frames.
        expanded=bytearray(320*240*2)
        for y in range(120):
            source=data[y*320:(y+1)*320]
            row=bytearray(640)
            row[0::4]=row[2::4]=source[0::2]
            row[1::4]=row[3::4]=source[1::2]
            expanded[y*1280:(y+1)*1280]=row+row
        return expanded

def fpga_frame(mode,angle,x,y,phase):
    if mode=='life':
        life.steps(1);read_begin=time.perf_counter();rows=life.read();read_ms=(time.perf_counter()-read_begin)*1000;data=bytearray(160*120*2)
        for row,value in enumerate(rows):
            for col in range(64):
                pixel=0x5ff8 if value>>col&1 else 0x0862
                struct.pack_into('<H',data,((row+28)*160+col+48)*2,pixel)
        return bytes(data),None,read_ms
    index={'raycast':0,'waves':1,'xor':2}[mode]
    bus.wr(2,2,index);bus.wr(2,5,round(x*256));bus.wr(2,6,round(y*256));bus.wr(2,7,phase)
    if index==0:
        for col in range(160):
            camera=(col/160-.5)*1.1
            dx=round((math.cos(angle)-math.sin(angle)*camera)*16)
            dy=round((math.sin(angle)+math.cos(angle)*camera)*16)
            bus.wr(3,col,(dx&0xffff)|((dy&0xffff)<<16))
    bus.wr(2,1,1);deadline=time.monotonic()+1
    while bus.rd(2,1)&1:
        if time.monotonic()>deadline:raise TimeoutError('FPGA graphics capture timed out')
    read_begin=time.perf_counter()
    data=struct.pack('<9600I',*(bus.m.read(0x4000+4*i) for i in range(9600)))
    read_ms=(time.perf_counter()-read_begin)*1000
    return data,bus.rd(2,4)/100,read_ms

def render():
    global frame
    life.clear();life.place('gosper_gun',2,2);life.place('pulsar',35,35)
    phase=0
    receiver=Display()
    last_frame=None
    while True:
        begin=time.monotonic()
        with lock:s=dict(state)
        try:
            if s['benchmark']:
                with lock:state['benchmark']=False
                life.randomize();original=life.read();expected=original
                cpu_begin=time.perf_counter()
                for _ in range(100):expected=life_step(expected)
                cpu_seconds=time.perf_counter()-cpu_begin
                life.steps(100)
                if life.read()!=expected:raise RuntimeError('Life FPGA / CPU mismatch')
                life.run();time.sleep(2.1);gps=life.per_second();life.stop()
                with lock:state['life_benchmark']=dict(correct=True,cpu_generations_per_second=100/cpu_seconds,fpga_generations_per_second=gps)
            data,fpga_us,read_ms=fpga_frame(s['mode'],s['angle'],s['x'],s['y'],phase)
            wifi_begin=time.perf_counter()
            if s['send'] and s['display']:receiver.send(s['display'],data,s['mode']=='raycast')
            wifi_ms=(time.perf_counter()-wifi_begin)*1000
            now=time.monotonic()
            elapsed=now-(last_frame if last_frame is not None else begin)
            last_frame=now
            with lock:
                frame=data;state.update(fps=1/max(.001,elapsed),fpga_us=fpga_us,read_ms=read_ms,wifi_ms=wifi_ms,temperature=temperature(),error=None,frames=state['frames']+1)
                if state['auto']:state['angle']=(state['angle']+.35*min(elapsed,.2))%math.tau
            phase=(phase+3)&255
        except Exception as exc:
            with lock:state['error']=str(exc)
            time.sleep(.5)
        time.sleep(.025)

PAGE='''<!doctype html><html><meta name="viewport" content="width=device-width"><title>Orphan Graphics Toys</title><style>
body{background:#080a0c;color:#eaf3fa;font:15px Consolas,"IBM Plex Mono",ui-monospace,monospace;margin:30px auto;max-width:850px;padding:20px}h1{color:#d2ff51}button,input{background:#16201a;color:white;border:1px solid #47584d;border-radius:6px;padding:12px;margin:4px}canvas{width:100%;image-rendering:pixelated;border:1px solid #435364}pre{white-space:pre-wrap;color:#61dbc4}small{color:#9eafbf}.bmc{display:inline-block;color:#1a1200!important;background:linear-gradient(#ffe27a,#ffcc2e);border:1px solid #ffdd55;border-radius:4px;padding:3px 10px;font-weight:700;font-size:12px;text-decoration:none;white-space:nowrap;box-shadow:0 0 12px #ffcc2e55;vertical-align:middle}.bmc:hover{color:#000!important;box-shadow:0 0 18px #ffcc2e99}</style>
<h1>ORPHAN GRAPHICS TOYS</h1><p>[orphan] · by <a href="https://jmscnc.com">JMSCNC</a>, makers of RotatoCAM</p><p><a class="bmc" href="https://buymeacoffee.com/revjmoney" target="_blank" rel="noopener">&#9749; Buy me a coffee</a></p><p>Ray stepping, projection and shading on the FPGA. ARM transports the completed frame.</p>
<div><button onclick="cmd({mode:'raycast'})">FPGA Raycast</button><button onclick="cmd({mode:'waves'})">FPGA Color Waves</button><button onclick="cmd({mode:'xor'})">FPGA XOR Field</button><button onclick="cmd({mode:'life'})">FPGA Game of Life</button><button onclick="cmd({mode:'life',benchmark:true})">Benchmark Life vs CPU</button></div>
<p id="metrics">Reading live FPGA timings and Zynq temperature...</p><canvas id="screen" width="160" height="120"></canvas><div><button onclick="cmd({move:'left'})">Turn left</button><button onclick="cmd({move:'forward'})">Forward</button><button onclick="cmd({move:'back'})">Back</button><button onclick="cmd({move:'right'})">Turn right</button><button onclick="cmd({auto:true})">Auto rotate</button><button onclick="cmd({auto:false})">Manual</button></div>
<p>CYD host <input id="host" placeholder="orphan-remote.local"><button onclick="cmd({display:document.getElementById('host').value,send:true})">Send to CYD</button><button onclick="cmd({send:false})">Browser only</button></p><pre id="status"></pre><small>W/A/S/D controls. The graphics core shares the FPGA with fan control and Life. Loading another Orphan project replaces this design.</small>
<script>async function cmd(d){await fetch('/api',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(d)});}document.onkeydown=e=>{const m={w:'forward',s:'back',a:'left',d:'right'}[e.key];if(m&&e.target.tagName!=='INPUT'){e.preventDefault();cmd({move:m});}};async function tick(){try{const s=await(await fetch('/api')).json();document.getElementById('status').textContent=JSON.stringify(s,null,2);document.getElementById('metrics').textContent='Zynq '+(s.temperature==null?'-':s.temperature.toFixed(1))+' C | '+s.fps.toFixed(1)+' FPS | FPGA '+(s.fpga_us==null?'-':s.fpga_us.toFixed(1))+' us | Readback '+s.read_ms.toFixed(1)+' ms | Wi-Fi '+s.wifi_ms.toFixed(1)+' ms';const b=new Uint8Array(await(await fetch('/frame')).arrayBuffer()),im=new ImageData(160,120);for(let i=0;i<19200;i++){const v=b[i*2]|(b[i*2+1]<<8);im.data[i*4]=(v>>11)*255/31;im.data[i*4+1]=((v>>5)&63)*255/63;im.data[i*4+2]=(v&31)*255/31;im.data[i*4+3]=255;}document.getElementById('screen').getContext('2d').putImageData(im,0,0);}finally{setTimeout(tick,200);}}tick();</script><footer style="margin-top:24px;font-size:13px;color:#a2afbd"><a class="bmc" href="https://buymeacoffee.com/revjmoney" target="_blank" rel="noopener">&#9749; Buy me a coffee</a> <b>[Rev. J. Money - 2026]</b> · Orphan · FPGA Dev Linux for the S9 Control Board · by <a href="https://jmscnc.com">JMSCNC</a>, makers of RotatoCAM</footer><script>(function(){var s=document.createElement('script');s.src='http://'+location.hostname+':8080/fan.js';s.async=1;document.head.appendChild(s)})()</script></html>'''

class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self,*a):pass
    def reply(self,status,data,kind):
        self.send_response(status);self.send_header('Content-Type',kind);self.send_header('Content-Length',str(len(data)));self.send_header('Cache-Control','no-store');self.end_headers();self.wfile.write(data)
    def do_GET(self):
        if self.path=='/':self.reply(200,PAGE.encode(),'text/html')
        elif self.path=='/api':
            with lock:data=json.dumps(state).encode()
            self.reply(200,data,'application/json')
        elif self.path=='/frame':
            with lock:data=frame
            self.reply(200,data,'application/octet-stream')
        else:self.reply(404,b'Not found','text/plain')
    def do_POST(self):
        try:
            if self.path!='/api':raise ValueError('Unknown endpoint')
            size=int(self.headers.get('Content-Length','0'))
            if not 0<size<=2048:raise ValueError('Invalid size')
            d=json.loads(self.rfile.read(size))
            with lock:
                if 'mode' in d:
                    if d['mode'] not in ('raycast','waves','xor','life'):raise ValueError('Invalid mode')
                    state['mode']=d['mode']
                if 'display' in d:
                    import re
                    if not re.fullmatch(r'[A-Za-z0-9.-]{1,128}',d['display']):raise ValueError('Invalid display host')
                    state['display']=d['display']
                for key in ('auto','send','benchmark'):
                    if key in d:state[key]=bool(d[key])
                if 'move' in d:
                    move(d['move'])
            self.reply(200,b'{"ok":true}','application/json')
        except (ValueError,KeyError,TypeError) as exc:self.reply(400,json.dumps({'error':str(exc)}).encode(),'application/json')

threading.Thread(target=render,daemon=True).start()
threading.Thread(target=inputs,daemon=True).start()
print('Orphan FPGA Graphics Toys: web port 8000; CYD '+display,flush=True)
http.server.ThreadingHTTPServer(('0.0.0.0',8000),Handler).serve_forever()
