library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pri_dec is
port( inv : in std_logic;
      I : in std_logic_vector(2 downto 0);
      O : out std_logic_vector(7 downto 0));
end pri_dec;

architecture pri_dec_arch of pri_dec is
begin
	O <="11111111" when inv = '1' else
	    "01111111" when I="000" else
	    "00111111" when I="001" else
	    "00011111" when I="010" else
	    "00001111" when I="011" else
	    "00000111" when I="100" else
	    "00000011" when I="101" else
	    "00000001" when I="110" else
	    "00000000" when I="111" else
	    "11111111";
end pri_dec_arch;