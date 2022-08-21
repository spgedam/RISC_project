library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_ID is
port( PC_in : in std_logic_vector(15 downto 0);
      instr : in std_logic_vector(15 downto 0);
      clk,clr,disable : in std_logic;
      PC_out : out std_logic_vector(15 downto 0);
      instr_out : out std_logic_vector(15 downto 0));
end IF_ID;

architecture IF_ID_arch of IF_ID is
begin
	process(PC_in,instr,clk,clr,disable) begin
	if( clr = '1') then
		PC_out <=(others=>'0');
		instr_out <=(others=>'0');
	elsif( disable = '1') then 
		null;
	elsif(clk'event and clk = '1') then
		PC_out <= PC_in;
		instr_out <= instr;
	else 
		null;
	end if;
	end process;
end IF_ID_arch;