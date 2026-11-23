"""Terminal controls use the web service, so there is only one FPGA owner."""
import argparse,json,urllib.request,time
def request(url,data=None):
    req=urllib.request.Request(url,data=json.dumps(data).encode() if data else None,
                              headers={'Content-Type':'application/json'})
    with urllib.request.urlopen(req,timeout=5) as r:return json.load(r)
if __name__=='__main__':
    p=argparse.ArgumentParser(description='Orphan KAS terminal control')
    p.add_argument('action',choices=['status','watch','selftest','benchmark','job','stop','fan','settings','mine'])
    p.add_argument('--url',default='http://127.0.0.1:8000');p.add_argument('--seed',default='2a'*32)
    p.add_argument('--timestamp',default='5435345234');p.add_argument('--start',default='0');p.add_argument('--end',default='999999')
    p.add_argument('--target',default='0');p.add_argument('--duty',type=int,default=0);p.add_argument('--timeout',type=int,default=300)
    p.add_argument('--wallet',default='');p.add_argument('--pool',default='');p.add_argument('--worker',default='orphan-s9')
    args=p.parse_args();data=vars(args).copy();url=data.pop('url');action=data['action']
    if action in ('status','watch'):
        try:
            while True:
                s=request(url+'/api/status')
                if action=='status':print(json.dumps(s,indent=2));break
                print('\033[2J\033[H'+'ORPHAN KAS | by JMSCNC, makers of RotatoCAM\n'+json.dumps(s,indent=2),flush=True);time.sleep(.5)
        except KeyboardInterrupt:pass
    else:
        if action=='settings':data={'action':'settings','settings':{'wallet':args.wallet,'pool':args.pool,'worker':args.worker,'wallets':[]}}
        print(request(url+'/api/command',data))
