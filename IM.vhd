library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IM is
port( addr : in std_logic_vector( 15 downto 0);
      data : out std_logic_vector( 15 downto 0);
      clk  : in std_logic);
end IM;

architecture IM_arch of IM is
	type matrix is array (0 to 256 - 1) of std_logic_vector( 15 downto 0);
	signal instr_mem : matrix := (  0 => "0011010000000011",
--					1 => "0000010011000010",
--					2 => "0001010011100000", 
					others => (others => '0'));
begin
	data <= instr_mem(to_integer(unsigned(addr)));
end IM_arch;