library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity S1 is
port( clk, clr, disable_pc, disable_p1 : in std_logic;
      PC_in : in std_logic_vector(15 downto 0);
      PC_adv, PC_out : out std_logic_vector(15 downto 0);
      instr_out : out std_logic_vector(15 downto 0));
end S1;

architecture arch of S1 is
component IP is
port(clk, clr, disable : in std_logic;
     IP_in : in std_logic_vector(15 downto 0);  ------PC_btb
     IP_out : out std_logic_vector(15 downto 0) ------PC_in_1
);
end component;

component IM is
port( addr : in std_logic_vector( 15 downto 0);
      data : out std_logic_vector( 15 downto 0);
      clk  : in std_logic);
end component;

component IF_ID is
port( PC_in : in std_logic_vector(15 downto 0);
      instr : in std_logic_vector(15 downto 0);
      clk,clr,disable : in std_logic;
      PC_out : out std_logic_vector(15 downto 0); 
      instr_out : out std_logic_vector(15 downto 0));
end component;

signal PC_out_tmp : std_logic_vector(15 downto 0);
signal data_out : std_logic_vector(15 downto 0);

begin
	IP_I0 : IP port map(clk, clr, disable_pc, PC_in, PC_out_tmp);
	IM_I0 : IM port map(PC_out_tmp, data_out, clk);
	PC_adv <= PC_out_tmp;
	
	IF_ID_I0 : IF_ID port map(PC_out_tmp, data_out, clk,clr,disable_p1, PC_out, instr_out);
end arch;