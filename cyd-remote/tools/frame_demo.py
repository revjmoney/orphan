"""CPU raycasting demo for the CYD's generic RGB565 transport. No dependencies."""
import argparse,math,socket,struct,time
MAP=['1111111111111111','1000000000000001','1011100000111001','1000100000100001',
     '1000100000100001','1000000000000001','1000001111000001','1000001001000001',
     '1000001001000001','1000000000000001','1011100000111001','1000000000000001',
     '1000000000000001','1000000000000001','1000000000000001','1111111111111111']
def rgb565(red,green,blue):
    return ((red>>3)<<11)|((green>>2)<<5)|(blue>>3)

def render(angle,width=320,height=240):
    data=bytearray(width*height*2)
    horizon=height//2
    sky=[rgb565(10+y*22//horizon,22+y*30//horizon,39+y*39//horizon) for y in range(horizon)]
    floor=[rgb565(17+y*26//horizon,23+y*21//horizon,30+y*16//horizon) for y in range(height-horizon)]
    for y,value in enumerate(sky+floor):
        offset=y*width*2
        data[offset:offset+width*2]=struct.pack('<H',value)*width
    for x in range(width):
        ray=angle+(x/width-.5)*1.1
        dx,dy=math.cos(ray),math.sin(ray)
        distance=.05
        while distance<20:
            px,py=7.5+dx*distance,5.5+dy*distance
            if not 0<=px<16 or not 0<=py<16 or MAP[int(py)][int(px)]=='1':break
            distance+=.04
        z=max(.08,distance*math.cos(ray-angle));wall=max(1,int(height*2/3/z))
        top=(height-wall)//2;bottom=top+wall
        face_x=int(px)!=int(px-dx*.04)
        wall_u=(py if face_x else px)%1
        base=(226,168,88) if (int(px)+int(py))%2 else (96,166,179)
        light=max(.15,1/(1+z*.14))*(.78 if face_x else 1)
        trim=max(1,wall//28)
        mortar_color=rgb565(*(int(component*light*.57) for component in base))
        brick_colors=[]
        for course in range(4):
            texture=.88+.12*((int(wall_u*8)+course)%3)/2
            brick_colors.append(mortar_color if (wall_u+course*.5)%1<.045 else
                                rgb565(*(int(component*light*texture) for component in base)))
        for y in range(max(0,top),min(height,bottom)):
            v=y-top
            course=4*v//wall
            value=mortar_color if (v*4)%wall<trim*4 else brick_colors[course]
            struct.pack_into('<H',data,(y*width+x)*2,value)
    return data
def send(host,data,scale2=False):
    rect='w=160&h=120&scale=2&smooth=1' if scale2 else 'w=320&h=240'
    with socket.create_connection((host,8091),timeout=5) as sock:
        sock.settimeout(5)
        sock.sendall((f'POST /rect?x=0&y=0&{rect} HTTP/1.1\r\nHost: {host}\r\nContent-Length: {len(data)}\r\nConnection: close\r\n\r\n').encode()+data)
        with sock.makefile('rb') as stream:response=stream.readline(128)
        if not response.startswith(b'HTTP/1.1 200'):raise RuntimeError(response.decode(errors='replace'))
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('host');p.add_argument('--frames',type=int,default=1);p.add_argument('--scale2',action='store_true',default=None)
    args=p.parse_args()
    if args.scale2 is None:
        import json,urllib.request
        try:
            with urllib.request.urlopen(f'http://{args.host}/status',timeout=1) as response:
                args.scale2=bool(json.load(response).get('scale2'))
        except (OSError,ValueError):
            args.scale2=False
    host=socket.gethostbyname(args.host)
    started=time.perf_counter()
    for i in range(args.frames):
        angle=(time.perf_counter()-started)*.75
        data=render(angle,160,120) if args.scale2 else render(angle)
        begin=time.perf_counter();send(host,data,args.scale2)
        print('frame %d: %.3f s transfer'%(i,time.perf_counter()-begin),flush=True)
