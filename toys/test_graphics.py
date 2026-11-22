"""Generate independent fixed-point render expectations and a bus-level RTL test."""
import json,math,struct
from pathlib import Path
from generate_rom import LEVEL
ROOT=Path(__file__).resolve().parent
angle=.37;phase=29
rays=[]
for col in range(160):
    camera=(col/160-.5)*1.1
    rays.append((round((math.cos(angle)-math.sin(angle)*camera)*16),round((math.sin(angle)+math.cos(angle)*camera)*16)))
def render(mode):
    pixels=[0]*(160*120)
    for col,(dx,dy) in enumerate(rays):
        px,py=1920,1408;distance=0
        while distance<255 and 0<=px<4096 and 0<=py<4096 and LEVEL[py>>8][px>>8]=='0':
            px+=dx;py+=dy;distance+=1
        height=min(120,1920//max(1,distance));top=(120-height)//2
        shade=31-(distance>>4)
        for y in range(120):
            ax=(col+phase)&255;ay=(y*2+phase)&255;az=(col+y-phase)&255
            def wave(a):return ((~((a&127)<<1))&255) if a&128 else (a&127)<<1
            if mode==1:v=((wave(ax)>>3)<<11)|((wave(ay)>>2)<<5)|(wave(az)>>3)
            elif mode==2:v=(((ax^ay)&31)<<11)|(((ax^az)&63)<<5)|((ay^az)&31)
            elif y<top:v=0x0863
            elif y>=top+height:v=0x1945 if bool(y&8)^bool(col&16) else 0x2127
            elif bool(y&8)^bool(col&8):v=(shade<<11)|((shade*2)<<5)|5
            else:v=(4<<11)|((shade*2)<<5)|shade
            pixels[y*160+col]=v
    return pixels
tb=['''`timescale 1ns/1ps
module tb_graphics;
 reg clk=0,rstn=0,we=0,re=0;reg[15:0]addr=0;reg[31:0]wd=0;wire[31:0]rd;
 always #5 clk=~clk;
 toy_graphics dut(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_we(we),.bus_re(re),.bus_rdata(rd));
 reg[31:0] expected[0:9599];integer i;
 task wr(input[15:0] a,input[31:0]v);begin @(negedge clk);addr=a;wd=v;we=1;@(negedge clk);we=0;end endtask
 task check(input[15:0]a,input[31:0]v);begin @(negedge clk);addr=a;re=1;@(negedge clk);re=0;repeat(2)@(negedge clk);if(rd!==v)$fatal(1,"capture mismatch addr=%h got=%h expected=%h",a,rd,v);end endtask
 initial begin #25;rstn=1;
 check(16'h2000,32'h544f5931);
''']
for i,(dx,dy) in enumerate(rays):tb.append(f"wr(16'h{0x3000+4*i:04x},32'h{((dx&65535)|((dy&65535)<<16)):08x});")
tb.append(f"wr(16'h201c,32'd{phase});")
for mode in range(3):
    pixels=render(mode)
    (ROOT/'sim'/f'expected{mode}.mem').write_text('\n'.join(f'{pixels[i]|pixels[i+1]<<16:08x}' for i in range(0,len(pixels),2)))
    tb+= [f"$readmemh(\"expected{mode}.mem\",expected);",f"wr(16'h2008,32'd{mode});","wr(16'h2004,32'd1);","@(negedge clk);wait(!dut.busy);",
          "for(i=0;i<9600;i=i+1)check(16'h4000+i*4,expected[i]);",f'$display("PASS graphics mode {mode}: 19200 exact FPGA pixels");']
tb+=['$finish;end','initial begin #5000000;$fatal(1,"watchdog");end','endmodule']
(ROOT/'sim'/'tb_graphics.v').write_text('\n'.join(tb))
print('Generated graphics oracle and full framebuffer readback tests')
