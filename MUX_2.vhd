library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2 is
generic(N: integer:=16);
port( A,B : in std_logic_vector(N-1 downto 0);
      sel : in std_logic;
      O : out std_logic_vector(N-1 downto 0));
end MUX_2;

architecture MUX_2_arch of MUX_2 is 
begin
	O <= A when sel = '0' else
	     B;
end MUX_2_arch;