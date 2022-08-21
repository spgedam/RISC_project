library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_4 is
generic(N: integer:=16);
port( A,B,C,D : in std_logic_vector(N-1 downto 0);
      sel : in std_logic_vector(1 downto 0);
      O : out std_logic_vector(N-1 downto 0));
end MUX_4;

architecture MUX_4_arch of MUX_4 is 
begin
	O <= A when sel = "00" else
	     B when sel = "01" else
	     C when sel = "10" else
	     D;
end MUX_4_arch;