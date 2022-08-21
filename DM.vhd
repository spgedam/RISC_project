library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write and read ops required
entity DM is
port( addr, din : in std_logic_vector( 15 downto 0);
      dout : out std_logic_vector( 15 downto 0);
      clk, wr_ena  : in std_logic);
end DM;

architecture DM_arch of DM is
	type matrix is array (0 to 255) of std_logic_vector( 15 downto 0);
	signal instr_mem : matrix := (others => (others => '0'));
begin
	dout <= instr_mem(to_integer(unsigned(addr)));
	process(clk) begin
		if(clk'event and clk = '1') then
			if(wr_ena = '1') then
				instr_mem(to_integer(unsigned(addr))) <= din;
			end if; 
		end if; 
	end process;
end DM_arch;