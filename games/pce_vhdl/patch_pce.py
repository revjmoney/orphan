"""Orphan patch of the MiSTer TurboGrafx16 core (pce_top.vhd, commit 827d45f) for GHDL synthesis -> Verilog, HuCards only:
 - LITE build (no Game Genie codes, no SuperGrafx second VDC)
 - no CD-ROM unit, no Arcade Card, no Populous RAM: their selects tied off
 - 8 KB work RAM (the PC Engine's; the 32 KB was for the SuperGrafx)
 - dpram.vhd is Orphan's own (block RAM inference, .mif images from pce_init_pkg.vhd)
Run once on the copied MiSTer sources:  py -3 patch_pce.py
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os

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


def cut(s, start, end):
    i = s.index(start)
    j = s.index(end, i) + len(end)
    return s[:i] + s[j:]


def top(s):
    s = rep(s, 'LITE : integer := 0', 'LITE : integer := 1')
    s = cut(s, 'CD : entity work.cd', ');\n')
    s = cut(s, 'AC : ARCADE_CARD', ');\n')
    s = cut(s, 'PRAM : entity work.dpram generic map (15,8)', ');\n')
    s = rep(s, "CPU_PRAM_SEL_N <= CPU_A(20) or not CPU_A(19) or not ROM_POP;",
            "CPU_PRAM_SEL_N <= '1';\nPRAM_DO <= (others => '1');\n"
            "-- Orphan: no CD-ROM unit and no Arcade Card\n"
            "CD_DO <= (others => '1'); CD_SEL_N <= '1'; CD_IRQ_N <= '1'; CD_RAM_CS_N <= '1'; CD_BRAM_EN <= '0';\n"
            "CDDA_SL <= (others => '0'); CDDA_SR <= (others => '0'); ADPCM_S <= (others => '0');\n"
            "CD_COMM <= (others => '0'); CD_COMM_SEND <= '0'; CD_DOUT <= (others => '0'); CD_DOUT_SEND <= '0';\n"
            "CD_DATA_END <= '0'; CD_RESET <= '0';\n"
            "AC_DO <= (others => '1'); AC_SEL_N <= '1'; AC_RAM_CS_N <= '1'; AC_RAM_A <= (others => '0');")
    s = rep(s, 'RAM : entity work.dpram generic map (15,8)', 'RAM : entity work.dpram generic map (13,8)')
    s = rep(s, '	address_a=> RAM_A(14 downto 0),', '	address_a=> RAM_A(12 downto 0),')
    s = rep(s, "RAM_A(14 downto 13) <= CPU_A(14 downto 13) when SGX = '1' else \"00\";", 'RAM_A(14 downto 13) <= "00";')
    # the RAM's clear port is 13 bits now
    i = s.index('RAM : entity work.dpram generic map (13,8)')
    j = s.index(');', i)
    seg = rep(s[i:j], '	address_b=> CLR_A,', '	address_b=> CLR_A(12 downto 0),')
    return s[:i] + seg + s[j:]


edit('pce_top.vhd', top)


def vdc(s):
    # the sprite cache's reset aggregate gives the 4-bit PAL field "00" (Quartus lets it pass, GHDL does not)
    return rep(s, """'0',"00",'0','0',"00",'0','0','0','0','0'))""", """'0',(others=>'0'),'0','0',(others=>'0'),'0','0','0','0','0'))""", s.count(""""00",'0','0',"00",'0','0','0','0','0'))"""))


edit('huc6270.vhd', vdc)


def psg(s):
    # three processes drive different fields of the one CH array (Quartus allows it, GHDL synthesis does not):
    # give each process its own copy of the array, every field read from the process that writes it
    import re
    own = {f: 'CHR' for f in ('FREQ', 'DDA', 'CHON', 'AL', 'LAL', 'RAL', 'NG_FREQ', 'NE', 'WF_DATA', 'DA_OUT', 'WF_RES',
                             'WF_INC', 'LFO_FREQ', 'LFCTL', 'LFTRG')}
    own.update({f: 'CHG' for f in ('GL_OUT', 'WF_CNT', 'LFSR', 'NG_CNT', 'LFO_CNT', 'WF_ADDR', 'WF_OUT', 'NG_OUT')})
    own['LFO_ADD'] = 'CHL'
    s = rep(s, 'signal CH		: chanarray_t;', 'signal CHR, CHG, CHL : chanarray_t;   -- Orphan: one copy per process (see patch_pce.py)')
    s, n = re.subn(r'\bCH(\([^()]*(?:\([^()]*\))?[^()]*\))\.(\w+)', lambda m: own[m.group(2)] + m.group(1) + '.' + m.group(2), s)
    assert n > 50 and not re.search(r'\bCH\(', s), n
    # the LFO's wave sample is 5 bits: to signed by flipping its top bit (Quartus read "1000" as 5 bits)
    s = rep(s, 'xor "1000";', 'xor "10000";')
    return s


edit('psg.vhd', psg)


def cpu(s):
    # combinational case statements with "when others => null" (only reached by X / U values) make latches in
    # GHDL's netlist, and nextpnr has no latches: give the others branch the first branch's assignment
    s = rep(s, """				ADDR_BUS <= DH & Y;
			when others => null;""", """				ADDR_BUS <= DH & Y;
			when others =>
				ADDR_BUS <= PC;""")
    return s


def alu(s):
    s = rep(s, """				CR <= SavedC;
			when others => null;""", """				CR <= SavedC;
			when others =>
				IntL <= L; IntR <= x"00";""")
    s = rep(s, """					Result <= IntR or IntL;
				end if;
			when others => null;""", """					Result <= IntR or IntL;
				end if;
			when others =>
				CO <= CR; Result <= IntL;""")
    return s


edit('HUC6280_CPU.vhd', cpu)
edit('HUC6280_ALU.vhd', alu)
