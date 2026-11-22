"""Run while the TOY1 FPGA is loaded and its display program is stopped."""
import math,struct,sys,time
from pathlib import Path
sys.path.insert(0,'/opt/ardzy/projects/orphan_toys')
from blocks import Bus,Life,life_step
bus=Bus()
assert bus.rd(0,1)==0x544f5931
assert bus.rd(15,0)==0x46414e31
angle=.37
for col in range(160):
    camera=(col/160-.5)*1.1
    dx=round((math.cos(angle)-math.sin(angle)*camera)*16)
    dy=round((math.sin(angle)+math.cos(angle)*camera)*16)
    bus.wr(3,col,(dx&65535)|((dy&65535)<<16))
bus.wr(2,5,1920);bus.wr(2,6,1408);bus.wr(2,7,29)
for mode in range(3):
    bus.wr(2,2,mode);bus.wr(2,1,1);deadline=time.monotonic()+2
    while bus.rd(2,1)&1:
        if time.monotonic()>deadline:raise TimeoutError('capture stalled')
    expected=[int(v,16) for v in Path('sim/expected%d.mem'%mode).read_text().split()]
    got=[bus.m.read(0x4000+i*4) for i in range(9600)]
    wrong=[i for i,(a,b) in enumerate(zip(got,expected)) if a!=b]
    assert not wrong,(mode,wrong[:8],[(hex(got[i]),hex(expected[i])) for i in wrong[:3]])
    print('PASS hardware mode %d: 19200 exact pixels, %.2f us render'%(mode,bus.rd(2,4)/100),flush=True)
life=Life(bus);life.clear();life.place('glider',2,2);life.place('pulsar',25,25)
expected=life.read()
for _ in range(100):expected=life_step(expected)
life.steps(100)
assert life.read()==expected
print('PASS hardware Life: 100 generations match CPU',flush=True)
life.run();time.sleep(2.1);rate=life.per_second();life.stop()
print('Life hardware rate: %d generations/second'%rate,flush=True)
