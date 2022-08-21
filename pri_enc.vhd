library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pri_enc is
port( clr, lsma_rr : in std_logic;
      I : in std_logic_vector(7 downto 0);
      O : out std_logic_vector(2 downto 0);
      invalid : out std_logic);
end pri_enc;

architecture pri_enc_arch of pri_enc is
--signal O_temp : std_logic_vector(2 downto 0);
signal invalid_temp : std_logic ;
begin
	O <= "000" when I(7)='1' else
	     	  "001" when I(7 downto 6)="01" else
	    	  "010" when I(7 downto 5)="001" else
	     	  "011" when I(7 downto 4)="0001" else
	     	  "100" when I(7 downto 3)="00001" else
	     	  "101" when I(7 downto 2)="000001" else
	     	  "110" when I(7 downto 1)="0000001" else
	     	  "111" when I(7 downto 1)="00000001" else
	     	  "000" when I="00000000" else
	     	  "000";
	invalid_temp <= '1' when (I="00000000" or clr = '1' or lsma_rr = '0')  else
		        '0';
--	O <= O_temp when clr = '0' else 
--	     "000";
	invalid <= invalid_temp;
end pri_enc_arch;