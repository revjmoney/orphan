"""Orphan patch of the MiSTer C64 core (C64_MiSTer 88354ba: FPGA64 by Peter Wendrich, MiSTer work by Sorgelig and
others; T65 CPU) for GHDL synthesis -> Verilog. Run once on the copied sources:  py -3 patch_c64.py
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


def top(s):
    s = rep(s, 'when "11" => turbo_m <= "111"; -- unused', 'when others => turbo_m <= "111"; -- unused')
    # no RGB palette here (fpga64_rgbcolor is not built): the VIC-II's colour number (0..15) goes out on r(3 downto 0);
    # the board's frame buffer keeps the number, the browser has the palette
    i = s.index('c64colors: entity work.fpga64_rgbcolor')
    j = s.index(');', i) + 2
    s = s[:i] + 'r <= "0000" & vicColorIndex;\ng <= (others => \'0\');\nb <= (others => \'0\');' + s[j:]
    return s


edit('fpga64_sid_iec.vhd', top)


def cpu(s):
    return rep(s, 'cpu: work.T65', 'cpu: entity work.T65')


edit('cpu_6510.vhd', cpu)


def cut(s, start, end):
    i = s.index(start)
    j = s.index(end, i) + len(end)
    return s[:i] + s[j:]


def bus(s):
    # one KERNAL + BASIC (16 KB) and one character ROM (4 KB), both written by the ARM (the owner's own ROMs, or
    # MEGA65's Open ROMs); the other kernal / charset choices and the bios input go
    s = rep(s, '		c64rom_wr   : in std_logic;', '		c64rom_wr   : in std_logic;\n		c64rom_char : in std_logic;   -- Orphan: the write goes to the character ROM')
    for name in ('chargen_j: entity work.dprom', 'kernel_c64gs: entity work.dprom', 'kernel_c64std: entity work.dprom',
                 'kernel_c64jap: entity work.dprom'):
        s = cut(s, name, ');\n')
    s = rep(s, '''		rdaddress => std_logic_vector(currentAddr(11 downto 0)),
		q => charData_std''', '''		wren => c64rom_wr and c64rom_char,
		data => c64rom_data,
		wraddress => c64rom_addr(11 downto 0),

		rdaddress => std_logic_vector(currentAddr(11 downto 0)),
		q => charData_std''')
    s = rep(s, '		wren => c64rom_wr,', '		wren => c64rom_wr and not c64rom_char,')
    i = s.index('	romData <= romData_c64jap when')
    j = s.index('charData <= charData_jap when c64jap_ena = ', i)
    j = s.index(';', j) + 1
    s = s[:i] + '	romData <= romData_c64;\n\tcharData <= charData_std;' + s[j:]
    return s


def top2(s):
    s = rep(s, '	c64rom_wr   : in  std_logic;', '	c64rom_wr   : in  std_logic;\n	c64rom_char : in  std_logic;   -- Orphan: the ROM write goes to the character ROM')
    s = rep(s, '	c64rom_wr => c64rom_wr', '	c64rom_wr => c64rom_wr,\n	c64rom_char => c64rom_char')
    return s


edit('fpga64_buslogic.vhd', bus)
edit('fpga64_sid_iec.vhd', top2)
