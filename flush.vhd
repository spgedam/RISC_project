library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------done when instruction is in execute stage
----------------should be asynchronous
entity flush is
port( jump, mispred : in std_logic;
      clr_p1_p2_pc : out std_logic
);
end flush;

architecture arch of flush is
begin
	process(jump, mispred) 
	begin
		if(jump = '1' or mispred = '1') then
			clr_p1_p2_pc <= '1';
		else
			clr_p1_p2_pc <= '0';
		end if;
	end process;
end arch;