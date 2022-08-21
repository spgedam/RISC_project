library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiple_tb is
end Multiple_tb;

architecture tb1 of Multiple_tb is

component Multiple is
port( opcode : in std_logic_vector(3 downto 0);
      R0_R7_I : in std_logic_vector( 7 downto 0);---------from rr
      clk, clr : in std_logic;
      lsma_rr : in std_logic;
      invalid_prienc : out std_logic;
      -------------------RR---------------------------------
      sel_sm_sa_src : out std_logic;
      sel_lsma_out : out std_logic; 
      dest_reg_out_rr : out std_logic_vector(2 downto 0);
      -------------------EX---------------------------------
      sel_alu_ra : out std_logic;
      sel_data : out std_logic;
      dest_reg_out_ex : out std_logic_vector(2 downto 0);
      dest_reg_ex :out std_logic;
      -------------------MEM--------------------------------
      dest_reg_out_mem : out std_logic_vector(2 downto 0);
      dest_reg_mem :out std_logic;
      -------------------WB---------------------------------
      dest_reg_out_wb : out std_logic_vector(2 downto 0);
      dest_reg_wb :out std_logic);
end component; 

signal opcode : std_logic_vector(3 downto 0);
signal R0_R7_I : std_logic_vector( 7 downto 0);---------from rr
signal clk : std_logic := '0';
signal clr : std_logic := '1';
signal lsma_rr : std_logic;
signal invalid_prienc : std_logic;
      -------------------RR---------------------------------
signal sel_sm_sa_src : std_logic;
signal sel_lsma_out : std_logic; 
signal dest_reg_out_rr : std_logic_vector(2 downto 0);
      -------------------EX---------------------------------
signal sel_alu_ra : std_logic;
signal sel_data : std_logic;
signal dest_reg_out_ex : std_logic_vector(2 downto 0);
signal dest_reg_ex : std_logic;
      -------------------MEM--------------------------------
signal dest_reg_out_mem : std_logic_vector(2 downto 0);
signal dest_reg_mem : std_logic;
      -------------------WB---------------------------------
signal dest_reg_out_wb : std_logic_vector(2 downto 0);
signal dest_reg_wb : std_logic;

begin
 	instance : Multiple port map( opcode,
      				      R0_R7_I,
      				      clk, clr,
      				      lsma_rr,
      				      invalid_prienc,
      				      -------------------RR---------------------------------
      				      sel_sm_sa_src,
      				      sel_lsma_out,
      				      dest_reg_out_rr,
      				      -------------------EX---------------------------------
      				      sel_alu_ra,
      				      sel_data,
      				      dest_reg_out_ex ,
      				      dest_reg_ex ,
      				      -------------------MEM--------------------------------
      				      dest_reg_out_mem ,
      				      dest_reg_mem ,
      				      -------------------WB---------------------------------
      				      dest_reg_out_wb ,
      				      dest_reg_wb);
      				      
      	process 
	begin
		wait for 3 ns;
		clk <= not(clk);
	end process;
	
	process 
	begin
		wait for 4 ns;
		clr <= '0';
	end process;
	
	process 
	begin
		wait for 17 ns;
		lsma_rr <= '1';
		wait for 32 ns;
		lsma_rr<= '0';
		wait for 100 ns;
	end process;
	
	
	process 
	begin
		wait for 17 ns;
		R0_R7_I <= "11111000";
	end process;
	
	
      	process
	begin
		wait for 7 ns;
		opcode <= "1000";
		wait for 10 ns;
		opcode <= "1100";
		wait for 100 ns;
	end process;
	
		
end tb1;