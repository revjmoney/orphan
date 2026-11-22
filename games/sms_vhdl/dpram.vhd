-- (Orphan) A plain VHDL stand-in for MiSTer's Intel altsyncram wrapper: port A reads and writes, port B reads
-- (the VDP never writes through B). Synchronous reads like altsyncram's registered address. Infers block RAM.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity dpram is
	generic (init_file : string := " "; widthad_a : natural; width_a : natural := 8;
	         mixed_port_rdwr : string := "DONT_CARE"; outdata_reg_a : string := "UNREGISTERED"; outdata_reg_b : string := "UNREGISTERED");
	port (address_a : in std_logic_vector(widthad_a-1 downto 0); address_b : in std_logic_vector(widthad_a-1 downto 0);
	      clock_a : in std_logic; clock_b : in std_logic;
	      data_a : in std_logic_vector(width_a-1 downto 0); data_b : in std_logic_vector(width_a-1 downto 0);
	      wren_a : in std_logic := '1'; wren_b : in std_logic := '1';
	      q_a : out std_logic_vector(width_a-1 downto 0); q_b : out std_logic_vector(width_a-1 downto 0));
end dpram;
architecture rtl of dpram is
	-- (Orphan) at most 16 KB: the Master System's VRAM (the 32 KB form is for System E, not used here)
	constant AB : natural := minimum(widthad_a, 14);
	type mem_t is array (0 to 2**AB - 1) of std_logic_vector(width_a-1 downto 0);
	signal mem : mem_t;
begin
	process (clock_a) begin
		if rising_edge(clock_a) then
			if wren_a = '1' then mem(to_integer(unsigned(address_a(AB-1 downto 0)))) <= data_a; end if;
			q_a <= mem(to_integer(unsigned(address_a(AB-1 downto 0))));
		end if;
	end process;
	process (clock_b) begin
		if rising_edge(clock_b) then q_b <= mem(to_integer(unsigned(address_b(AB-1 downto 0)))); end if;
	end process;
end rtl;
