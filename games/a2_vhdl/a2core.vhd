-- Orphan Games: the Apple IIe machine (apple2.vhd + the Disk II controller) as one entity for GHDL -> Verilog.
-- RAM, ROMs, the track buffer, the keyboard latch and the paddle timers live in the Verilog block around it
-- (games/orphan_a2/orphan_a2_block.v). Wiring as in MiSTer's apple2_top.vhd (W. Soltys, GPL-3), without the extra
-- cards (Mockingboard, serial, clock, hard disk) and the PS/2 keyboard.
-- by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity a2core is
  port (
    CLK_14M     : in  std_logic;
    reset       : in  std_logic;
    -- RAM: lo byte main, hi byte aux (read one clock after the address)
    ram_addr    : out unsigned(17 downto 0);
    ram_di      : out unsigned(7 downto 0);
    ram_do      : in  unsigned(15 downto 0);
    ram_we      : out std_logic;
    ram_aux     : buffer std_logic;
    -- ROMs (read one clock after the address)
    rom_a       : out unsigned(13 downto 0);
    rom_d       : in  unsigned(7 downto 0);
    vrom_a      : out unsigned(12 downto 0);
    vrom_d      : in  unsigned(7 downto 0);
    drom_a      : out unsigned(7 downto 0);
    drom_d      : in  unsigned(7 downto 0);
    -- video: one bit per 14 MHz clock
    VIDEO       : out std_logic;
    COLOR_LINE  : out std_logic;
    TEXT_MODE   : buffer std_logic;
    HBL         : out std_logic;
    VBL         : buffer std_logic;
    -- keyboard: K(7) = strobe, K(6 downto 0) = ASCII; READ_KEY pulses when the program clears the strobe
    K           : in  unsigned(7 downto 0);
    READ_KEY    : buffer std_logic;
    AKD         : in  std_logic;
    -- game port: 7..4 paddle timers, 3..1 push buttons, 0 cassette in
    GAMEPORT    : in  std_logic_vector(7 downto 0);
    PDL_STROBE  : buffer std_logic;
    CLK_2M      : out std_logic;
    speaker     : out std_logic;
    -- Disk II drive 1: the track buffer (6656 bytes of nibbles)
    DISK_READY  : in  std_logic;
    D1_WP       : in  std_logic;
    D1_ACTIVE   : out std_logic;
    TRACK1      : out unsigned(5 downto 0);
    TRACK1_ADDR : out unsigned(12 downto 0);
    TRACK1_DI   : out unsigned(7 downto 0);
    TRACK1_DO   : in  unsigned(7 downto 0);
    TRACK1_WE   : out std_logic
  );
end a2core;

architecture rtl of a2core is
  signal clk2m, phase_zero, pz_r, pz_f, cpu_we, d1a, d2a : std_logic;
  signal flash : unsigned(22 downto 0) := (others => '0');
  signal ADDR : unsigned(15 downto 0);
  signal D, DISK_DO : unsigned(7 downto 0);
  signal IO_SELECT, DEVICE_SELECT : std_logic_vector(7 downto 0);
  signal io_strobe : std_logic;
  signal t2_addr : unsigned(12 downto 0);
  signal t2_di : unsigned(7 downto 0);
  signal t2_we : std_logic;
  signal t2 : unsigned(5 downto 0);
  signal dready : std_logic_vector(1 downto 0);
begin
  process (CLK_14M) begin
    if rising_edge(CLK_14M) then flash <= flash + 1; end if;
  end process;

  core : entity work.apple2 port map (
    CLK_14M => CLK_14M, CLK_2M => clk2m, PALMODE => '0', ROMSWITCH => '0', CPU_WAIT => '0',
    PHASE_ZERO => phase_zero, PHASE_ZERO_R => pz_r, PHASE_ZERO_F => pz_f, FLASH_CLK => flash(22),
    reset => reset, cpu => '1', ADDR => ADDR, ram_addr => ram_addr, D => D, ram_do => ram_do, aux => ram_aux,
    PD => DISK_DO, CPU_WE => cpu_we, IRQ_N => '1', NMI_N => '1', ram_we => ram_we,
    VIDEO => VIDEO, COLOR_LINE => COLOR_LINE, TEXT_MODE => TEXT_MODE, HBL => HBL, VBL => VBL,
    K => K, read_key => READ_KEY, AKD => AKD, AN => open, GAMEPORT => GAMEPORT, PDL_strobe => PDL_STROBE,
    STB => open, IO_SELECT => IO_SELECT, DEVICE_SELECT => DEVICE_SELECT, IO_STROBE => io_strobe,
    rom_a => rom_a, rom_d => rom_d, vrom_a => vrom_a, vrom_d => vrom_d, speaker => speaker);

  ram_di <= D;
  CLK_2M <= clk2m;
  drom_a <= ADDR(7 downto 0);

  disk : entity work.disk_ii port map (
    CLK_14M => CLK_14M, CLK_2M => clk2m, PHASE_ZERO => phase_zero, IO_SELECT => IO_SELECT(6),
    DEVICE_SELECT => DEVICE_SELECT(6), RESET => reset, DISK_READY => dready, A => ADDR, D_IN => D,
    D_OUT => DISK_DO, DROM_D => drom_d, D1_ACTIVE => d1a, D2_ACTIVE => d2a, D1_WP => D1_WP, D2_WP => '1',
    TRACK1 => TRACK1, TRACK1_ADDR => TRACK1_ADDR, TRACK1_DI => TRACK1_DI, TRACK1_DO => TRACK1_DO,
    TRACK1_WE => TRACK1_WE, TRACK1_BUSY => '0',
    TRACK2 => t2, TRACK2_ADDR => t2_addr, TRACK2_DI => t2_di, TRACK2_DO => x"00", TRACK2_WE => t2_we,
    TRACK2_BUSY => '1');
  D1_ACTIVE <= d1a;
  dready <= '0' & DISK_READY;
end rtl;
