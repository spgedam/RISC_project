library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----
entity AND_gates is 
generic( I_O_length : integer := 8);
port( A , B : in std_logic_vector(I_O_length-1 downto 0);
      O : out std_logic_vector(I_O_length-1 downto 0));
end AND_gates;

architecture AND_gates_arch of AND_gates is
begin
	AND_gate: for i in 0 to I_O_length-1 generate
		 	O(i) <= A(i) AND B(i);
		 end generate;
end AND_gates_arch;
