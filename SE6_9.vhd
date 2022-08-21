library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SE6_9 is
port( imm_val : in std_logic_vector( 8 downto 0);
      se : in std_logic_vector(1 downto 0); -- 00 for no se, 01 for 9 bit se, 10 for 6 bit se
      dout : out std_logic_vector(15 downto 0));
end SE6_9;

architecture SE_arch of SE6_9 is
begin
	process(imm_val,se)
	variable x : std_logic_vector(6 downto 0);
	variable y : std_logic_vector(9 downto 0);
	begin
		x := imm_val(8) & imm_val(8) & imm_val(8) & imm_val(8) & imm_val(8) & imm_val(8) & imm_val(8);
		y := imm_val(5) & imm_val(5) & imm_val(5) & imm_val(5) & imm_val(5) & imm_val(5) 
			& imm_val(5) & imm_val(5) & imm_val(5) & imm_val(5) ;
		if(se = "00") then
			dout <= (others => '0');
		elsif(se = "01") then
			dout <=  y & imm_val(5 downto 0);
		elsif(se = "10") then
			dout <= x & imm_val;           
		else
			dout <= (others => '0');
		end if;
	end process;
end SE_arch;