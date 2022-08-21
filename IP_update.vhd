library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IP_update is 
port( PC_if, PC_btb, PC_exe, PC_alu, PC_rb : in std_logic_vector(15 downto 0);
      jmp : in std_logic_vector(1 downto 0);
      beq_flush, mispred, btb_hit, HB : in std_logic;
      PC_out : out std_logic_vector(15 downto 0)
);
end IP_update;

architecture arch of IP_update is
begin
	process(PC_if, PC_btb, PC_exe, PC_alu, PC_rb, jmp, beq_flush, mispred, btb_hit)
	variable PC_if_int, PC_exe_int : integer := 0;
	begin
		PC_if_int := to_integer(unsigned(PC_if));
		PC_exe_int := to_integer(unsigned(PC_exe));
		if(beq_flush = '1') then
			if(mispred = '1') then
				PC_out <= PC_alu;
			else
				PC_out <= std_logic_vector(to_unsigned(PC_exe_int,16));
			end if;
		elsif(jmp(1) = '1') then
			if(jmp(0) = '1') then
				PC_out <= PC_alu;
			else
				PC_out <= PC_rb;
			end if;
		elsif(btb_hit = '1' and HB = '1') then
			PC_out <= PC_btb;
		else
			PC_out <= std_logic_vector(to_unsigned(PC_if_int + 1,16));
		end if;
	end process;
end arch;