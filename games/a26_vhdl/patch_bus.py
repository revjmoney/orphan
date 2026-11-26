"""Orphan patch of the MiSTer Atari 2600 core (A2601 by Retromaster, GPL-3) for GHDL synthesis -> Verilog:
the shared 8-bit data bus (inout ports with 'Z' drivers in the CPU, RIOT, TIA and the cart) becomes one
multiplexer in A2601 (A2601Core.vhd): every part gets the resolved bus as an input and drives its own output.
The RIOT ports (pa / pb) become inputs, its never-firing PA7 edge interrupt is tied off, and A2601top gets the
TIA colour index (O_COLU) for the frame buffer. Run once on the copied MiSTer sources:  py -3 patch_bus.py
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later (patches to GPL-3 files)."""
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))


def edit(name, fn):
    p = os.path.join(HERE, name)
    s = open(p, encoding='latin-1', newline='').read().replace('\r\n', '\n')
    t = fn(s)
    assert t != s, name
    open(p, 'w', encoding='latin-1', newline='').write(t)
    print('patched', name)


def rep(s, old, new, count=1):
    assert s.count(old) == count, (old[:80], s.count(old))
    return s.replace(old, new)


# ---------------------------------------------------------------- CPU: di in, do out, we out
def a6507(s):
    s = rep(s, 'd: inout std_logic_vector(7 downto 0);',
            'di: in std_logic_vector(7 downto 0);\n         do: out std_logic_vector(7 downto 0);\n         we: out std_logic;')
    s = rep(s, "cpuDi <= d when cpuWe = '0' else std_logic_vector(cpuDo);", 'cpuDi <= di;')
    s = rep(s, 'd <= std_logic_vector(cpuDo) when cpuWe = \'1\' else "ZZZZZZZZ";', 'do <= std_logic_vector(cpuDo);\n    we <= cpuWe;')
    return s


# ---------------------------------------------------------------- RIOT: din in, dout out, ports in
def a6532(s):
    head, body = s.split('entity A6532 is', 1)
    body = rep(body, 'd: inout std_logic_vector(7 downto 0) := "ZZZZZZZZ";',
               'din: in std_logic_vector(7 downto 0);\n         dout: out std_logic_vector(7 downto 0);')
    body = rep(body, 'pa: inout std_logic_vector(7 downto 0);', 'pa: in std_logic_vector(7 downto 0);')
    body = rep(body, 'pb: inout std_logic_vector(7 downto 0);', 'pb: in std_logic_vector(7 downto 0);')
    body = rep(body, "        pa(i) <= 'Z';\n        pb(i) <= 'Z';\n", '')
    body = rep(body, 'ram: work.ramx8 port map(clk, ram_r, d, ram_d_out, a);', 'ram: work.ramx8 port map(clk, ram_r, din, ram_d_out, a);')
    body = re.sub(r'\bd <= "ZZZZZZZZ";', 'dout <= x"FF";', body)
    body = rep(body, 'd <= "--------";', 'dout <= x"00";')
    body = re.sub(r'(\s)d <= ', r'\1dout <= ', body)
    body = re.sub(r'<= d;', '<= din;', body)
    body = rep(body, 'timer <= d - 1;', 'timer <= din - 1;')
    # PA7 never changes (riot_pa7 is a constant): no edge interrupts, no flip-flops clocked by it
    i = body.index('    process(pa7, intr_read)')
    j = body.index('end process;', i) + len('end process;')
    body = body[:i] + "    edge_intr_lo <= '0';\n    edge_intr_hi <= '0';" + body[j:]
    return head + 'entity A6532 is' + body


# ---------------------------------------------------------------- TIA: din in, dout out (only in entity TIA)
def tia(s):
    head, body = s.split('entity TIA is', 1)
    body = rep(body, 'd: inout std_logic_vector(7 downto 0);',
               'din: in std_logic_vector(7 downto 0);\n         dout: out std_logic_vector(7 downto 0);')
    body = rep(body, 'd(7 downto 6) <= "--";', 'dout(7 downto 6) <= floating_bus(7 downto 6);')
    body = rep(body, 'd <= "ZZZZZZZZ";', 'dout <= floating_bus;')
    body = re.sub(r'(\s)d(\([0-9]+( downto [0-9]+)?\)) <= ', r'\1dout\2 <= ', body)
    body = re.sub(r'\bd\b(?!out)', 'din', body)          # every remaining use reads the bus
    body = body.replace('dinout', 'dout')                # (in case)
    return head + 'entity TIA is' + body


# ---------------------------------------------------------------- A2601: the bus multiplexer
def core(s):
    s = rep(s, 'd: inout std_logic_vector(7 downto 0);',
            'd: in std_logic_vector(7 downto 0);   -- from the cart\n\t\tdbus: out std_logic_vector(7 downto 0);  -- the resolved bus')
    s = rep(s, 'pa: inout std_logic_vector(7 downto 0);', 'pa: in std_logic_vector(7 downto 0);')
    s = rep(s, 'pb: inout std_logic_vector(7 downto 0);', 'pb: in std_logic_vector(7 downto 0);')
    s = rep(s, 'signal ph2_en: std_logic;',
            'signal ph2_en: std_logic;\nsignal bus_d, cpu_do, riot_do, tia_do: std_logic_vector(7 downto 0);\nsignal cpu_we: std_logic;')
    s = rep(s, '    d       => d,\n    ad      => cpu_a,', '    di      => bus_d,\n    do      => cpu_do,\n    we      => cpu_we,\n    ad      => cpu_a,')
    s = rep(s, '    d       => d,\n    pa      => pa,', '    din     => bus_d,\n    dout    => riot_do,\n    pa      => pa,')
    s = re.sub(r'\td\s+=> d,\n', '\tdin        => bus_d,\n\tdout       => tia_do,\n', s, count=1)
    s = rep(s, "tia_cs <= '1' when", "bus_d <= cpu_do when cpu_we = '1' else\n         tia_do when tia_cs = '1' else\n"
               "         riot_do when riot_cs = '1' else\n         d;\ndbus <= bus_d;\n\ntia_cs <= '1' when")
    return s


# ---------------------------------------------------------------- A2601top: the cart drives cart_d, the bus comes back
def top(s):
    s = rep(s, '\t\tO_VIDEO_B : out std_logic_vector(7 downto 0);',
            '\t\tO_VIDEO_B : out std_logic_vector(7 downto 0);\n\t\tO_COLU    : out std_logic_vector(6 downto 0);')
    s = rep(s, 'signal cpu_d: std_logic_vector(7 downto 0);', 'signal cpu_d: std_logic_vector(7 downto 0);\nsignal cart_d: std_logic_vector(7 downto 0);')
    s = rep(s, '\td           => cpu_d,', '\td           => cart_d,\n\tdbus        => cpu_d,')
    s = rep(s, '\tcolu        => open,', '\tcolu        => O_COLU,')
    i = s.index('-- ROM and SC output')
    j = s.index('end process;', i)
    blk = s[i:j]
    blk = blk.replace('cpu_d <= "ZZZZZZZZ";', 'cart_d <= x"FF";').replace('cpu_d <= ', 'cart_d <= ')
    return s[:i] + blk + s[j:]


edit('A6507.vhd', a6507)
edit('A6532.vhd', a6532)
edit('TIA/TIA.vhd', tia)
edit('A2601Core.vhd', core)
edit('A2601top.vhd', top)


# ---------------------------------------------------------------- Quartus-style "label: work.X" -> "label: entity work.X"
for root, _, files in os.walk(HERE):
    for f in files:
        if f.endswith('.vhd'):
            p = os.path.join(root, f)
            s = open(p, encoding='latin-1', newline='').read()
            t = re.sub(r'(\w+\s*:\s*)work\.', r'\1entity work.', s)
            if t != s:
                open(p, 'w', encoding='latin-1', newline='').write(t)
                print('entity work.', os.path.relpath(p, HERE))


# ---------------------------------------------------------------- unreachable "when others => null" in combinational
# cases: GHDL keeps the old value there, which Yosys makes a latch (nextpnr for the Zynq has no latch cells)
def no_latch(name, line_no, stmt):
    p = os.path.join(HERE, name)
    s = open(p, encoding='latin-1', newline='').read().replace('\r\n', '\n').split('\n')
    i = line_no - 1
    assert s[i].strip() == 'when others =>' and s[i + 1].strip() == 'null;', (name, s[i], s[i + 1])
    s[i + 1] = s[i + 1].replace('null;', stmt)
    open(p, 'w', encoding='latin-1', newline='').write('\n'.join(s))
    print('no latch', name, line_no)


no_latch('TIA/audio_argh2600.vhd', 202, "w <= '1';")          # ctrl's 16 values are all listed above
no_latch('A6532.vhd', 138, 'dout <= pb_ddr;')                  # a(1 downto 0)'s 4 values are all listed above


# ---------------------------------------------------------------- audio: start values (the FPGA starts every flip-flop
# at 0 anyway; this only stops the simulation from carrying 'X' through the noise generators forever)
p = os.path.join(HERE, 'TIA', 'audio_argh2600.vhd')
s = open(p, encoding='latin-1', newline='').read()
for old, new in (('signal toggled, toggled_next : std_logic;', "signal toggled : std_logic := '0';\nsignal toggled_next : std_logic;"),
                 ('signal cnt3, cnt3_next : std_logic_vector(1 downto 0);', 'signal cnt3 : std_logic_vector(1 downto 0) := "00";\nsignal cnt3_next : std_logic_vector(1 downto 0);'),
                 ('signal lfsr4, lfsr4_next : std_logic_vector(3 downto 0);', 'signal lfsr4 : std_logic_vector(3 downto 0) := "0000";\nsignal lfsr4_next : std_logic_vector(3 downto 0);'),
                 ('signal lfsr5, lfsr5_next : std_logic_vector(4 downto 0);', 'signal lfsr5 : std_logic_vector(4 downto 0) := "00000";\nsignal lfsr5_next : std_logic_vector(4 downto 0);'),
                 ('signal lfsr9, lfsr9_next : std_logic_vector(8 downto 0);', 'signal lfsr9 : std_logic_vector(8 downto 0) := "000000000";\nsignal lfsr9_next : std_logic_vector(8 downto 0);')):
    assert s.count(old) == 1, old
    s = s.replace(old, new)
open(p, 'w', encoding='latin-1', newline='').write(s)
print('audio start values')


# ---------------------------------------------------------------- TIA audio registers: start values (simulation only
# matters: the generators' counters never leave 'X' once AUDF/AUDC were unknown for a clock)
p = os.path.join(HERE, 'TIA', 'TIA.vhd')
s = open(p, encoding='latin-1', newline='').read()
for ch in '01':
    for old, new in (('signal a%s_freq: std_logic_vector(4 downto 0);' % ch, 'signal a%s_freq: std_logic_vector(4 downto 0) := "00000";' % ch),
                     ('signal a%s_ctrl: std_logic_vector(3 downto 0);' % ch, 'signal a%s_ctrl: std_logic_vector(3 downto 0) := "0000";' % ch)):
        assert s.count(old) == 1, old
        s = s.replace(old, new)
open(p, 'w', encoding='latin-1', newline='').write(s)
print('TIA audio start values')
