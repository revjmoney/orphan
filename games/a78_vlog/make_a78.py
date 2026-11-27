"""Orphan: the MiSTer Atari 7800 core (Jamie Blanks, MIT, MiSTer-devel/Atari7800_MiSTer 0dc8ad2) as one Verilog file
for Yosys, from sv2v's output of its SystemVerilog:
    sv2v -DNO_ARM_MAPPER <every .sv/.v in rtl/, packages first> -w a78_all.v      (sv2v v0.0.13, on the i5)
    py -3 make_a78.py a78_all.v ../orphan_a78/a78_sv2v.v
Keeps the 7800 itself (SALLY 6502, MARIA, TIA sound, RIOT, the 7800 cart mappers + POKEY) and turns these into
empty modules (outputs 0): the 2600 cart mappers and their ARM mapper (Orphan plays 2600 carts on orphan_a26), the
BupChip/Souper player and the 2600 cart RAM, YM2151, Minnie, SN76489, the PS/2 keyboard, composite video and the DDR3 bridge.
video_mux is replaced by Orphan's own: no palette, it hands MARIA's colour code {chroma, luma} out on `red`
(the board's frame buffer keeps the code, the browser has the palette).
by JMSCNC, makers of RotatoCAM. MIT (like the core)."""
import re
import sys

STUBS = {'cart2600', 'cart_ram_tdp', 'composite_out', 'bupchip_subsystem', 'ddram', 'jt51', 'minnie', 'sn76489', 'souper',
         'ps2_to_atari800', 'arm_host'}
src, out = sys.argv[1], sys.argv[2]
s = open(src).read()
mods = {m.group(1): m.group(0) for m in re.finditer(r'^module\s+(\w+)\b.*?^endmodule\b\n?', s + '\n', re.M | re.S)}


def stub(name, text):
    head = re.match(r'module\s+\w+\s*(#\(.*?\)\s*)?\(.*?\);\n', text, re.S).group(0)
    decl = [l for l in text.split('\n') if re.match(r'\t(input|output|inout|parameter)\b', l)]   # (not function arguments)
    body = []
    for l in decl:
        m = re.match(r'(\s*)output\s+(?:reg|wire)?\s*(signed\s+)?(\[[^\]]*\])?\s*(\w+)\s*;', l)
        if m:
            body.append('%soutput wire %s%s %s;' % (m.group(1), m.group(2) or '', m.group(3) or '', m.group(4)))
            body.append('%sassign %s = 0;' % (m.group(1), m.group(4)))
        else:
            body.append(l)
    return head + '\t// Orphan: not used (see make_a78.py)\n' + '\n'.join(body) + '\nendmodule\n'


VMUX = '''	// Orphan: no palette here; MARIA's colour code {chroma, luma} goes out on red, with MARIA's timing
	always @(posedge clk_sys) begin
		pix_ce <= maria_pix_ce;
		if (maria_pix_ce) begin
			red <= {maria_chroma, maria_luma}; green <= 8'd0; blue <= 8'd0;
			hblank <= maria_hblank; vblank <= maria_vblank; hsync <= maria_hsync; vsync <= maria_vsync;
		end
	end
endmodule
'''
for n in STUBS:
    mods[n] = stub(n, mods[n])
# the small two-port RAMs (MARIA's line buffers, RIOT RAM: 128 entries) have a write on each port, which neither
# block RAM nor LUT RAM takes: one write port here (port b wins: only the RIOT's power-on loader writes there, while
# the CPU is held), two read ports, in LUT RAM
CDP = '''module cache_ram_dp (clk_i, addr_a_i, wren_a_i, wdata_a_i, q_a_o, addr_b_i, wren_b_i, wdata_b_i, q_b_o);
	parameter ADDR_WIDTH = 7;
	parameter DATA_WIDTH = 8;
	parameter MEM_INIT_FILE = " ";
	parameter SIM_INIT_FILE = " ";
	parameter DEVICE_FAMILY = "Cyclone V";
	input wire clk_i;
	input wire [ADDR_WIDTH - 1:0] addr_a_i;
	input wire wren_a_i;
	input wire [DATA_WIDTH - 1:0] wdata_a_i;
	output reg [DATA_WIDTH - 1:0] q_a_o;
	input wire [ADDR_WIDTH - 1:0] addr_b_i;
	input wire wren_b_i;
	input wire [DATA_WIDTH - 1:0] wdata_b_i;
	output reg [DATA_WIDTH - 1:0] q_b_o;
	(* ram_style = "distributed" *) reg [DATA_WIDTH - 1:0] mem_q [0:(1 << ADDR_WIDTH) - 1];
	wire [ADDR_WIDTH - 1:0] wa = wren_b_i ? addr_b_i : addr_a_i;
	wire [DATA_WIDTH - 1:0] wd = wren_b_i ? wdata_b_i : wdata_a_i;
	always @(posedge clk_i) begin
		if (wren_a_i || wren_b_i)
			mem_q[wa] <= wd;
		q_a_o <= mem_q[addr_a_i];
		q_b_o <= mem_q[addr_b_i];
	end
endmodule
'''
mods['cache_ram_dp'] = CDP
# MiSTer's RAM wrappers (Quartus): zero-fill initial loops and write-through reads, which Yosys does not map onto
# block RAM; on the chip a block RAM powers up as 0 anyway, and a read during a write returning the old byte is fine
for n in ('cache_ram', 'cache_ram_tdp_dc'):
    t = re.sub(r'\tinitial if \(SIM_INIT_FILE != " "\)\n\t\t\$readmemh\(SIM_INIT_FILE, mem_q\);\n\telse\n\t\tfor \(init_i = 0; init_i < NUM_WORDS; init_i = init_i \+ 1\)\n\t\t\tmem_q\[init_i\] = \{DATA_WIDTH \{1\'b0\}\};\n', '', mods[n])
    t = re.sub(r'if \((wren\w*)\)\n(\t+)(q\w*) <= (wdata\w*);\n\t+else\n\t+\3 <= (mem_q\[\w+\]);', r'\3 <= \5;', t)
    t = re.sub(r'(q\w*) <= \((wren\w*) \? (wdata\w*) : (mem_q\[\w+\])\);', r'\1 <= \4;', t)
    assert 'readmemh' not in t and '? wdata' not in t, n
    mods[n] = t
v = mods['video_mux']
head = v[:v.index('\treg [23:0] out_color;')]
mods['video_mux'] = head.replace('\treg _sv2v_0;\n', '') + VMUX

inst = re.compile(r'^\s*(\w+)\s*(?:#\s*\((?:[^()]|\([^()]*\))*\)\s*)?(\w+)\s*\(', re.M)
keep, todo = [], ['Atari7800']
while todo:
    n = todo.pop()
    if n in keep:
        continue
    keep.append(n)
    todo += [a for a, b in inst.findall(mods[n]) if a in mods and a not in keep]
text = ''.join(mods[n] for n in sorted(keep))
# Altera RAM hints (ramstyle = "M10K" ...) make Yosys look for an Altera block RAM: dropped (ram_style kept)
text = re.sub(r'\(\* ramstyle = "[^"]*" \*\) ', '', text)
# no ROM images: the High Score Cartridge ROM (hsc_en is 0) and the like stay empty
text = re.sub(r'\.(sim_init_file|SIM_INIT_FILE|mem_init_file|MEM_INIT_FILE)\("[^"]*"\)', r'.\1(" ")', text)
open(out, 'w').write('// Generated by games/a78_vlog/make_a78.py from sv2v output of MiSTer Atari7800 0dc8ad2 (MIT, Jamie Blanks).\n'
                     + text)
print('kept %d modules, %d lines' % (len(keep), sum(mods[n].count('\n') for n in keep)))
