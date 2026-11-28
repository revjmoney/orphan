#!/usr/bin/env python3
"""Orphan's generic Linux status/display service. No FPGA MMIO access.

Scene API is intentionally renderer-independent; touch events are queued for clients.
"""
import collections,http.server,json,math,os,socket,subprocess,threading,time,urllib.request,zlib
from pathlib import Path
events=collections.deque(maxlen=64)
lock=threading.Lock();seq=0
sample_lock=threading.Lock()
samples={key:collections.deque(maxlen=60) for key in ('temperature','rate')}
latest_system={}
latest_miner={}
def is_miner(project):
    """A loaded project counts as a miner when its project.json puts it in the mining branch (or category)."""
    try:
        meta=json.load(open('/opt/ardzy/projects/%s/project.json'%project))
    except (OSError,ValueError):return False
    return str(meta.get('branch') or meta.get('category','')).lower() in ('mining','compute')

def json_get(url):
    try:
        with urllib.request.urlopen(url,timeout=.4) as r:return json.load(r)
    except Exception:return {}
def temperature():
    for path in Path('/sys/bus/iio/devices').glob('iio:device*/in_temp0_raw'):
        try:
            raw=int(path.read_text());offset=float(path.with_name('in_temp0_offset').read_text());scale=float(path.with_name('in_temp0_scale').read_text())
            return (raw+offset)*scale/1000
        except (OSError,ValueError):pass
    return None
def system(project='unknown'):
    mem={k:int(v.split()[0]) for k,v in (line.split(':',1) for line in Path('/proc/meminfo').read_text().splitlines())}
    disk=os.statvfs('/')
    return dict(host=socket.gethostname(),uptime=float(Path('/proc/uptime').read_text().split()[0]),
                load=os.getloadavg()[0],temperature=temperature(),memory_used=(mem['MemTotal']-mem['MemAvailable'])/1024,
                memory_total=mem['MemTotal']/1024,disk_free=disk.f_bavail*disk.f_frsize/1073741824,project=project)
def collect():
    global latest_system,latest_miner
    project='unknown';next_project=0
    while True:
        now=time.monotonic()
        if now>=next_project:
            try:
                result=subprocess.run(['ardzy','status'],capture_output=True,text=True,timeout=1).stdout
                project=next((line.split(':',1)[1].strip() for line in result.splitlines() if line.startswith('project')),'unknown')
            except (OSError,subprocess.TimeoutExpired):project='unknown'
            next_project=now+5
        current=system(project)
        miner=json_get('http://127.0.0.1:8000/api/status') if is_miner(project) else {}
        if 'hardware' not in miner:miner={}
        else:miner={key:miner[key] for key in ('mode','message','hardware','mining','earnings') if key in miner}
        hardware=miner.get('hardware',{})
        with sample_lock:
            latest_system=current;latest_miner=miner
            samples['temperature'].append(current['temperature'])
            samples['rate'].append(round(float(hardware.get('hashrate',0))/1000,1) if hardware.get('busy') else 0 if miner else None)
        time.sleep(max(0,now+1-time.monotonic()))

def compact_scene(view):
    with sample_lock:
        s=latest_system.copy();m=latest_miner.copy();history={key:list(values) for key,values in samples.items()}
    if not s:s=system()
    if view not in ('system','mining','projects','radio','synth'):view='system'
    tiles=[]
    muted='#8ea5b8'; bright='#eaf3fa';gold='#f3b64d';teal='#61dbc4'
    def tile(y,height,background):
        items=[];tiles.append(dict(y=y,h=height,background=background,items=items));return items
    def text(items,x,y,value,size=1,color=bright):
        items.append(dict(type='text',x=x,y=y,text=str(value),size=size,color=color))
    def trend(items,name,label,low,high,color):
        text(items,9,5,label,1,muted)
        text(items,263,5,f'{low:g}-{high:g}',1,muted)
        points=[None]*(60-len(history[name]))+history[name]
        samples_display=[None if v is None else round(100*max(0,min(1,(v-low)/(high-low)))) for v in points]
        items.append(dict(type='graph',x=9,y=17,w=302,h=43,color=color,points=samples_display))
    header=tile(0,30,'#13212d')
    text(header,9,7,'ORPHAN',2,gold);text(header,98,7,view.upper(),2)
    temp=s['temperature'];text(header,257,10,f'{temp:.1f} C' if temp is not None else '-- C',1,teal)
    info=tile(31,56,'#0c1014')
    plot=tile(88,64,'#101c25')
    detail=tile(153,59,'#0c1014')
    if view=='mining':
        h=m.get('hardware',{});p=m.get('mining',{});active=h.get('busy',False)
        rate=float(h.get('hashrate',0))/1000
        text(info,9,3,'LIVE RATE' if active else 'LAST RUN' if rate else 'HASHRATE',1,muted)
        text(info,9,16,f'{rate:,.1f}',3,teal);text(info,9,43,'kH/s',1,muted)
        text(info,191,3,'ACCEPTED / REJECTED',1,muted)
        text(info,191,20,f"{p.get('accepted',0)} / {p.get('rejected',0)}",2)
        text(info,191,43,m.get('mode','offline').upper(),1,gold)
        peak=max((v or 0 for v in history['rate']),default=0)
        trend(plot,'rate','LIVE kH/s  |  LAST 60s',0,max(100,math.ceil(peak/100)*100),teal)
        e=m.get('earnings',{});quote=e.get('market',{});pool=e.get('pool',{})
        effective=p.get('effective_hashrate') if m.get('mode')=='mine' else None
        daily=quote.get('kas_per_day_after_pool_fee',quote.get('kas_per_day'))
        if daily is not None:
            text(detail,9,4,f"EST {daily:.8f} KAS/day"+(' (stale)' if e.get('market_stale') else ''),1,teal)
        else:text(detail,9,4,'EST revenue pending',1,muted)
        if effective is not None:text(detail,201,4,f"WALL {effective/1000:.1f} kH/s",1,muted)
        balance=pool.get('balance_kas');minimum=pool.get('minimum_kas');paid=pool.get('paid_week_kas')
        if minimum is not None:
            text(detail,9,19,'POOL '+(f'{balance:.6g}' if balance is not None else '--')+f'/{minimum:.6g} KAS',1)
        else:text(detail,9,19,'Pool payout '+pool.get('status','pending'),1,muted)
        if paid is not None:text(detail,173,19,f'PAID 7d {paid:.6g} KAS'[:23],1)
        text(detail,9,34,'JOB '+str(p.get('job_id','--'))[:14],1,muted)
        text(detail,130,34,'HASHES '+str(h.get('hashes','0'))[:23],1,muted)
        text(detail,9,47,m.get('message','Miner offline')[:49],1,gold)
    else:
        text(info,9,3,'ZYNQ DIE',1,muted)
        text(info,9,17,f'{temp:.1f} C' if temp is not None else '-- C',3,teal)
        text(info,194,3,'CPU LOAD / RAM',1,muted)
        text(info,194,17,f"{s['load']:.2f}",2)
        text(info,194,43,f"{s['memory_used']:.0f} / {s['memory_total']:.0f} MB",1)
        valid=[v for v in history['temperature'] if v is not None]
        low=math.floor(min(valid,default=45)/5)*5-5;high=math.ceil(max(valid,default=55)/5)*5+5
        trend(plot,'temperature','DIE TEMP C  |  LAST 60s',low,high,gold)
        text(detail,9,4,'FPGA PROJECT',1,muted)
        text(detail,9,18,s['project'][:25],2,gold)
        text(detail,9,43,f"SD {s['disk_free']:.1f} GB free",1);text(detail,166,43,f"Uptime {s['uptime']/3600:.1f} h",1)
    nav=tile(213,27,'#13212d')
    text(nav,9,10,'< PREV',1,teal);text(nav,109,10,'JMSCNC / ROTATOCAM',1,muted);text(nav,277,10,'NEXT >',1,teal)
    for entry in tiles:entry['revision']=zlib.crc32(json.dumps(entry,separators=(',',':')).encode())
    return dict(version=1,width=320,height=240,background='#0c1014',view=view,tiles=tiles)

def scene(view):
    with sample_lock:s=latest_system.copy();m=latest_miner.copy()
    if not s:s=system()
    items=[]
    def text(x,y,value,size=1,color='#dce8f2'):items.append(dict(type='text',x=x,y=y,text=str(value),size=size,color=color))
    text(12,12,'ORPHAN',3,'#f3b64d');text(12,43,'by JMSCNC / RotatoCAM',1,'#91a3b5')
    text(12,66,s['host']+'  /  '+view.upper(),1,'#61dbc4')
    if view!='system' and s['temperature'] is not None:text(228,66,'%.1f C'%s['temperature'],1,'#f3b64d')
    if view=='mining':
        h=m.get('hardware',{});p=m.get('mining',{})
        text(12,88,'%.1f kH/s'%(float(h.get('hashrate',0))/1000),3)
        text(12,120,'Shares %s / %s'%(p.get('accepted',0),p.get('rejected',0)),2)
        text(12,147,'Hashes '+str(h.get('hashes','0')),1)
        text(12,166,m.get('message','Miner not loaded')[:45],1,'#f3b64d')
        text(12,187,'Job '+str(p.get('job_id','-'))[:25],1)
    elif view=='projects':
        text(12,92,'FPGA PROJECT',1);text(12,112,s['project'][:23],2,'#f3b64d')
        text(12,150,'CPU load %.2f'%s['load'],2)
        text(12,181,'%d hours uptime'%(s['uptime']/3600),1)
    elif view in ('radio','synth'):
        text(12,94,view.upper()+' VIEW',2,'#f3b64d')
        text(12,128,'Loaded: '+s['project'][:30],1)
        text(12,151,'Open board web UI on port 8000',1)
        text(12,177,'Live view adapter is reserved',1,'#91a3b5')
    else:
        text(12,88,('%.1f C'%s['temperature']) if s['temperature'] is not None else 'TEMP --',3)
        text(180,98,'LOAD %.2f'%s['load'],1,'#61dbc4')
        text(12,126,'RAM %.0f / %.0f MB'%(s['memory_used'],s['memory_total']),2)
        text(12,154,'SD free %.1f GB'%s['disk_free'],2)
        text(12,181,'FPGA '+s['project'][:33],1,'#f3b64d')
    text(12,220,'< PREV       TAP: VIEW        NEXT >',1,'#91a3b5')
    return dict(version=1,width=320,height=240,background='#0c1014',view=view,items=items,system=s)
class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self,*a):pass
    def send(self,status,data):
        b=json.dumps(data).encode();self.send_response(status);self.send_header('Content-Type','application/json')
        self.send_header('Content-Length',str(len(b)));self.end_headers();self.wfile.write(b)
    def do_GET(self):
        from urllib.parse import urlsplit,parse_qs
        u=urlsplit(self.path);q=parse_qs(u.query)
        if u.path=='/api/display':
            renderer=compact_scene if q.get('tiles')==['1'] else scene
            self.send(200,renderer(q.get('view',['system'])[0]))
        elif u.path=='/api/system':
            with sample_lock:s=latest_system.copy()
            self.send(200,s or system())
        elif u.path=='/api/temperature':self.send(200,{'temperature':temperature(),'sensor':'zynq-xadc','unit':'C'})
        elif u.path=='/api/events':
            after=int(q.get('after',['0'])[0])
            with lock:self.send(200,{'events':[e for e in events if e['seq']>after]})
        else:self.send(404,{'error':'Use /api/display, /api/system or /api/events'})
    def do_POST(self):
        global seq
        try:
            if self.path!='/api/input':raise ValueError('Unknown endpoint')
            size=int(self.headers.get('Content-Length','0'))
            if not 0<size<=2048:raise ValueError('Invalid size')
            data=json.loads(self.rfile.read(size))
            if data.get('type') not in ('touch','button'):raise ValueError('Unsupported event')
            with lock:
                seq+=1;events.append(dict(seq=seq,time=time.time(),device=str(data.get('device','cyd'))[:40],
                    type=data['type'],x=int(data.get('x',0)),y=int(data.get('y',0)),view=str(data.get('view','system'))[:32]))
            self.send(200,{'ok':True,'seq':seq})
        except Exception as exc:self.send(400,{'error':str(exc)})
def announce():
    """Tell the ORPHAN Remote (the CYD named in /etc/orphan/cyd) that this board is here, every 30 s, so a double
    tap can switch to it even when the CYD's mDNS lookup misses it (GET /hello?name=<this board's hostname>)."""
    while True:
        try:
            cyd=open('/etc/orphan/cyd').read().strip()
            if cyd:
                urllib.request.urlopen('http://%s/hello?name=%s'%(cyd,socket.gethostname()[:19]),timeout=3).read()
        except Exception:
            pass
        time.sleep(30)


if __name__=='__main__':
    threading.Thread(target=collect,daemon=True).start()
    threading.Thread(target=announce,daemon=True).start()
    http.server.ThreadingHTTPServer(('0.0.0.0',8090),Handler).serve_forever()
