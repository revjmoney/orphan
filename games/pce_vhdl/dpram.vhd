-- Orphan: a plain dual-port block RAM for the MiSTer TurboGrafx16 core (its dpram.vhd wraps Altera's altsyncram).
-- Same ports and generics; both ports on one clock, reads registered (as altsyncram with unregistered outputs
-- after its registered address). mem_init_file picks a power-on image from pce_init_pkg (make_init_pkg.py).
-- by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pce_init_pkg.all;

entity dpram is
	generic (
		addr_width    : integer := 8;
		data_width    : integer := 8;
		mem_init_file : string := " ";
		disable_value : std_logic := '1'
	);
	port (
		clock     : in  std_logic;
		address_a : in  std_logic_vector(addr_width-1 downto 0);
		data_a    : in  std_logic_vector(data_width-1 downto 0) := (others => '0');
		enable_a  : in  std_logic := '1';
		wren_a    : in  std_logic := '0';
		q_a       : out std_logic_vector(data_width-1 downto 0);
		cs_a      : in  std_logic := '1';
		address_b : in  std_logic_vector(addr_width-1 downto 0) := (others => '0');
		data_b    : in  std_logic_vector(data_width-1 downto 0) := (others => '0');
		enable_b  : in  std_logic := '1';
		wren_b    : in  std_logic := '0';
		q_b       : out std_logic_vector(data_width-1 downto 0);
		cs_b      : in  std_logic := '1'
	);
end entity;

architecture rtl of dpram is
	type ram_t is array(0 to 2**addr_width-1) of std_logic_vector(data_width-1 downto 0);
	function init return ram_t is
		variable r : ram_t := (others => (others => '0'));
	begin
		if data_width = 24 and addr_width = 12 then
			for i in 0 to 4095 loop r(i) := VOLTAB(i)(data_width-1 downto 0); end loop;
		elsif data_width = 9 and addr_width = 9 and mem_init_file'length > 8 then
			for i in 0 to 511 loop r(i) := PALTAB(i)(data_width-1 downto 0); end loop;
		end if;
		return r;
	end function;
	shared variable ram : ram_t := init;
	signal q0, q1 : std_logic_vector(data_width-1 downto 0);
begin
	process (clock) begin
		if rising_edge(clock) then
			if enable_a = '1' then
				if wren_a = '1' then ram(to_integer(unsigned(address_a))) := data_a; end if;
				q0 <= ram(to_integer(unsigned(address_a)));
			end if;
		end if;
	end process;
	process (clock) begin
		if rising_edge(clock) then
			if enable_b = '1' then
				if wren_b = '1' then ram(to_integer(unsigned(address_b))) := data_b; end if;
				q1 <= ram(to_integer(unsigned(address_b)));
			end if;
		end if;
	end process;
	q_a <= q0 when cs_a = '1' else (others => disable_value);
	q_b <= q1 when cs_b = '1' else (others => disable_value);
end architecture;
