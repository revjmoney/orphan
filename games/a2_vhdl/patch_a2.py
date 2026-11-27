"""Orphan patch of the MiSTer Apple IIe core (Apple-II_MiSTer 281fd2d, 2024: Stephen A. Edwards' apple2fpga, the //e
work by Gyorgy Szombathelyi) for GHDL synthesis -> Verilog:
 - the main ROM, the video (character) ROM and the Disk II boot ROM leave the core: Apple's ROMs are not in this
   repository, the ARM uploads them (the board owner's own files) into block RAM outside the core (ports rom_a/rom_d,
   vrom_a/vrom_d, drom_d)
 - the CPU is T65 (Daniel Wallner et al., BSD-style licence) in 65C02 mode (the //e enhanced CPU); the R65C02
   choice is dropped: it derives from Peter Wendrich's FPGA64 6502, which is licensed for personal educational use only
 - no Saturn 128K card (ramcard.v): the //e's own 64K + 64K aux RAM only
Run once on the copied MiSTer sources:  py -3 patch_a2.py
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
    """remove from `start` up to and including `end` (first match after start)"""
    i = s.index(start)
    j = s.index(end, i) + len(end)
    return s[:i] + s[j:]


def apple2(s):
    s = rep(s, '''	 -- load different video roms
    ioctl_addr : in  std_logic_vector(24 downto 0);
    ioctl_data : in  std_logic_vector(7 downto 0);
    ioctl_index   : in  std_logic_vector(7 downto 0);
    ioctl_download: in  std_logic;
    ioctl_wr   : in  std_logic;
''', '''    -- ROMs outside the core (Orphan): main ROM C000-FFFF, video ROM
    rom_a          : out unsigned(13 downto 0);
    rom_d          : in  unsigned(7 downto 0);
    vrom_a         : out unsigned(12 downto 0);
    vrom_d         : in  unsigned(7 downto 0);
''')
    s = cut(s, '  component ramcard is', 'end component;')
    s = cut(s, '  ram_card_D: component ramcard', ');\n')
    s = rep(s, '    ram_card_read  <= ROM_SELECT and card_ram_rd;',
            "    card_addr <= (others => '0');\n    card_ram_rd <= '0';\n    card_ram_we <= '0';\n"
            '    ram_card_read  <= ROM_SELECT and card_ram_rd;')
    s = rep(s, '''  video_rom_select <= '1' when ioctl_download='1' and ioctl_wr = '1' and ioctl_index = "00000001" else '0';\n''', '')
    s = rep(s, '''    ioctl_addr => ioctl_addr,
    ioctl_data => ioctl_data,
    ioctl_wr => video_rom_select,
''', '''    vrom_a => vrom_a,
    vrom_d => vrom_d,
''')
    s = rep(s, "  we <= not T65_WE_N when cpu = '0' else not R65C02_WE_N;", '  we <= not T65_WE_N;')
    s = rep(s, "  A <= unsigned(T65_A(15 downto 0)) when cpu = '0' else R65C02_A;", '  A <= unsigned(T65_A(15 downto 0));')
    s = rep(s, "  D_OUT <= unsigned(T65_DO) when cpu = '0' else R65C02_DO;", '  D_OUT <= unsigned(T65_DO);')
    s = rep(s, '      mode     => "00",', '      mode     => "01",                 -- 65C02 (Orphan: the //e enhanced CPU)')
    s = cut(s, '  cpu65c02: entity work.R65C02', ');\n')
    s = cut(s, '  roms : work.spram', 'unsigned(q) => rom_out);')
    s = rep(s, 'end rtl;', '  rom_a <= rom_addr;\n  rom_out <= rom_d;\n\nend rtl;')
    return s


def video(s):
    s = rep(s, '''    -- load different video roms
    ioctl_addr : in  std_logic_vector(24 downto 0);
    ioctl_data : in  std_logic_vector(7 downto 0);
    ioctl_wr   : in  std_logic;
''', '''    -- the video ROM outside the core (Orphan)
    vrom_a     : out unsigned(12 downto 0);
    vrom_d     : in  unsigned(7 downto 0);
''')
    s = rep(s, '  signal video_rom_input_addr: std_logic_vector(12 downto 0);\n', '')
    s = cut(s, '  video_rom_input_addr<=', ';\n')
    s = cut(s, '  videorom : work.spram', 'unsigned(q) => video_rom_out);')
    s = rep(s, '  LS166 : process', '  vrom_a <= ROMSWITCH & video_rom_addr;\n  video_rom_out <= vrom_d;\n\n  LS166 : process')
    return s


def disk(s):
    s = rep(s, '    D_OUT          : out unsigned( 7 downto 0); -- To 6502',
            '    D_OUT          : out unsigned( 7 downto 0); -- To 6502\n'
            '    DROM_D         : in  unsigned( 7 downto 0); -- the boot ROM byte at A(7 downto 0) (Orphan: outside)')
    s = cut(s, '  rom : entity work.disk_ii_rom', 'dout => rom_dout);')
    s = rep(s, 'end rtl;', '  rom_dout <= DROM_D;\n\nend rtl;')
    return s


def timing(s):
    # sim only: the 7 MHz divider has no start value (X forever in a simulator; any value works on the chip)
    s = rep(s, '  signal CLK_7M: std_logic;', "  signal CLK_7M: std_logic := '0';")
    s = rep(s, '  signal COLOR_DELAY_N : std_logic;', "  signal COLOR_DELAY_N : std_logic := '0';")
    return s


def drive(s):
    # sim only: the read latch has no start value; a 6502 branching on an X bit loses its PC in a simulator
    s = rep(s, '  signal data_reg : unsigned(7 downto 0);', "  signal data_reg : unsigned(7 downto 0) := (others => '0');")
    s = rep(s, '  signal reset_data_reg : std_logic;', "  signal reset_data_reg : std_logic := '0';")
    return s


edit('apple2.vhd', apple2)
edit('drive_ii.vhd', drive)
edit('timing_generator.vhd', timing)
edit('video_generator.vhd', video)
edit('disk_ii.vhd', disk)
