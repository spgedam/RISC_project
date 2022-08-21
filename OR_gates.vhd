library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----
entity OR_gates is 
generic( I_O_length : integer := 8);
port( A , B : in std_logic_vector(I_O_length-1 downto 0);
      O : out std_logic_vector(I_O_length-1 downto 0));
end OR_gates;

architecture OR_gates_arch of OR_gates is
begin
	OR_gate: for i in 0 to I_O_length-1 generate
		 	O(i) <= A(i) OR B(i);
		 end generate;
end OR_gates_arch;