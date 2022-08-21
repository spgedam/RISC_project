library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CZ is
port( clk : in std_logic;
      Ci, Zi : in std_logic;
      C_mod,Z_mod: in std_logic;
      Co, Zo : out std_logic);
end CZ;

architecture CZ_arch of CZ is
begin
	process(Ci,Zi,C_mod,Z_mod)
	begin
		if(rising_edge(clk)) then
			if(C_mod = '1') then
				Co <= Ci; end if; end if;
	end process;
	
	process(Ci,Zi,C_mod,Z_mod)
	begin
		if(rising_edge(clk)) then
			if(Z_mod = '1') then
				Zo <= Zi; 
			end if;
		end if;
	end process;
end CZ_arch;