library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF is
port( a1,a2,a3 : in std_logic_vector( 2 downto 0);
      d3, PC_WB : in std_logic_vector(15 downto 0);
      d1,d2 : out std_logic_vector( 15 downto 0);
      clk, wr_ena  : in std_logic);
end RF;

architecture RF_arch of RF is
	type matrix is array(0 to 7) of std_logic_vector(15 downto 0);
	signal regs : matrix := (others => (others => '0'));
begin
	d1 <= regs(to_integer(unsigned(a1)));
	d2 <= regs(to_integer(unsigned(a2)));
	process(clk)
	variable wr_addr : integer;
	begin
		wr_addr := to_integer(unsigned(a3));
		if(clk'event and clk = '1') then
			if(wr_ena = '1') then
				if( wr_addr /= 0 or wr_addr /= 7) then
					regs(wr_addr) <= d3;
				end if;
			end if; 
		end if; 
	end process;
	regs(0) <= X"0000";
	regs(7) <= PC_WB;
end RF_arch;