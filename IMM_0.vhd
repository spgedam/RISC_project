library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IMM_0 is
port( din : in std_logic_vector(8 downto 0);
      ena : in std_logic;
      dout : out std_logic_vector(15 downto 0));
end IMM_0;

architecture IMM_0_arch of IMM_0 is 
begin
	process(din,ena) begin
	if(ena = '1') then
		dout <= din & "0000000";
	end if; 
	end process;
end IMM_0_arch;