library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----
entity EX_MEM is 
port( PC_in : in std_logic_vector(15 downto 0);
      imm_in : in std_logic_vector(8 downto 0);
      Ra_in,Rb_in,Rc_in: in std_logic_vector(2 downto 0);
      dest_sel_in : in std_logic_vector(1 downto 0);
      valid_Ra_in, valid_Rb_in : in std_logic;
      clk,clr,disable : in std_logic;
      -----------RR-------------------------------
      RF_wr_ena_in : in std_logic; -----------------------------------------> This signal is for WB stage
      -----------Mem------------------------------
      alu_res_in, data_mem_in : in std_logic_vector(15 downto 0);
      C_mod_in , Z_mod_in  : in std_logic;
      c_in, z_in : in std_logic;
      DM_wr_ena_in : in std_logic;
      -----------WB-------------------------------
      IMM_0_ena_in, Z_mod_wb_in : in std_logic;
      WB_mux_in : in std_logic_vector(1 downto 0);
      ----------OUTPUTS---------------------------
      --------------------------------------------
      PC_out : out std_logic_vector(15 downto 0);
      imm_out : out std_logic_vector(8 downto 0);
      Ra_out,Rb_out,Rc_out : out std_logic_vector(2 downto 0);
      dest_sel_out : out std_logic_vector(1 downto 0);
      valid_Ra_out, valid_Rb_out : out std_logic;
      -----------RR-------------------------------
      RF_wr_ena_out : out std_logic;
      -----------Mem------------------------------
      alu_res_out, data_mem_out : out std_logic_vector(15 downto 0);
      C_mod_out , Z_mod_out  : out std_logic;
      c_out, z_out : out std_logic;
      DM_wr_ena_out : out std_logic;
      -----------WB-------------------------------
      IMM_0_ena_out, Z_mod_wb_out : out std_logic;
      WB_mux_out : out std_logic_vector(1 downto 0)
      );
      -----------Misc-----------------------------
end EX_MEM;

architecture EX_MEM_arch of EX_MEM is
begin
	process(PC_in,imm_in,Ra_in,Rb_in,Rc_in,clk,clr,disable,RF_wr_ena_in,C_mod_in , Z_mod_in,
		c_in, z_in, DM_wr_ena_in,IMM_0_ena_in,WB_mux_in, Z_mod_wb_in)
	begin
		if(clr = '1') then
			PC_out <= (others => '0');
			imm_out <= (others => '0');
      			Ra_out <= (others => '0');
      			Rb_out <= (others => '0');
      			Rc_out <= (others => '0');
      			dest_sel_out <= (others =>'0');
      			valid_Ra_out <= '0';
      			valid_Rb_out <= '0';
      			-----------RR-------------------------------
     			RF_wr_ena_out <= '0';
      			-----------Mem------------------------------
      			C_mod_out <= '0'; 
      			Z_mod_out <= '0'; 
      			c_out <= '0';
      			z_out <= '0';
      			DM_wr_ena_out <= '0';
      			alu_res_out <= (others =>'0'); 
      			data_mem_out <= (others =>'0');
      			-----------WB-------------------------------
      			IMM_0_ena_out <= '0';
      			WB_mux_out <= (others => '0');
      			Z_mod_wb_out <= '0';
      		elsif( disable = '1') then 
			null;
		elsif(clk'event and clk = '1') then
			PC_out <= PC_in;
			imm_out <= imm_in;
      			Ra_out <= Ra_in;
      			Rb_out <= Rb_in;
      			Rc_out <= Rc_in;
      			dest_sel_out <= dest_sel_in;
      			valid_Ra_out <= valid_Ra_in; 
      			valid_Rb_out <= valid_Rb_in;
      			-----------RR-------------------------------
     			RF_wr_ena_out <= RF_wr_ena_in;
      			-----------Mem------------------------------
      			C_mod_out <= C_mod_in; 
      			Z_mod_out <= Z_mod_in; 
      			c_out <= c_in;
      			z_out <= z_in;
      			DM_wr_ena_out <= DM_wr_ena_in;
      			alu_res_out <=alu_res_in;
      			data_mem_out <= data_mem_in;
      			-----------WB-------------------------------
      			IMM_0_ena_out <= IMM_0_ena_in;
      			WB_mux_out <= WB_mux_in;
      			Z_mod_wb_out <= Z_mod_wb_in;
      		else 
      			null;
      		end if;
      	end process;
end EX_MEM_arch;
