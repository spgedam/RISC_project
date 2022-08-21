library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IITB_RISC_22_TB is
end IITB_RISC_22_TB;

architecture arch of IITB_RISC_22_TB is

component IITB_RISC_22 is
port( clk, reset : in std_logic);
end component;

signal clk : std_logic :='0';
signal reset : std_logic := '1';
begin
	CORE_I0 : IITB_RISC_22 port map(clk, reset);
	
	process 
	begin
		wait for 3 ns;
		clk <= not(clk);
	end process;
	
	process 
	begin
		wait for 25 ns;
		reset <= '0';
	end process;
	
end arch;