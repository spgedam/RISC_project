library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----
entity S5 is
port( PC_in : in std_logic_vector(15 downto 0);
      imm_in : in std_logic_vector(8 downto 0);
      Ra_in,Rb_in,Rc_in: in std_logic_vector(2 downto 0);
      dest_sel_in : in std_logic_vector(1 downto 0);
      dest_sel_in_lsma_mem, dest_sel_in_lsma_wb : in std_logic; 
      dest_from_lsma_mem, dest_from_lsma_wb : in std_logic_vector(2 downto 0);
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
      data_mem : out std_logic_vector(15 downto 0);
      dest_mem, dest_wb : out std_logic_vector(2 downto 0);
      PC_out, mux_wb_out : out std_logic_vector(15 downto 0);
      RF_wr_ena_out : out std_logic;
      C_mod_out_mem , Z_mod_out_mem, C_mod_out_wb , Z_mod_out_wb : out std_logic; 
      c_out, z_out : out std_logic     
      );
end S5;

architecture arch of S5 is

component MUX_2 is
generic(N: integer:=16);
port( A,B : in std_logic_vector(N-1 downto 0);
      sel : in std_logic;
      O : out std_logic_vector(N-1 downto 0));
end component; 

component MUX_4 is
generic(N: integer:=16);
port( A,B,C,D : in std_logic_vector(N-1 downto 0);
      sel : in std_logic_vector(1 downto 0);
      O : out std_logic_vector(N-1 downto 0));
end component;

component DM is
port( addr, din : in std_logic_vector( 15 downto 0);
      dout : out std_logic_vector( 15 downto 0);
      clk, wr_ena  : in std_logic);
end component; 

component IMM_0 is
port( din : in std_logic_vector(8 downto 0);
      ena : in std_logic;
      dout : out std_logic_vector(15 downto 0));
end component; 

signal dout_tmp : std_logic_vector( 15 downto 0);

signal z_or_out : std_logic := '0';

signal psuedo_data_mem : std_logic_vector(15 downto 0);

component MEM_WB is 
port( PC_in : in std_logic_vector(15 downto 0);
      imm_in : in std_logic_vector(8 downto 0);
      Ra_in,Rb_in,Rc_in : in std_logic_vector(2 downto 0);
      dest_sel_in : in std_logic_vector(1 downto 0);
      valid_Ra_in, valid_Rb_in : in std_logic;
      clk,clr,disable : in std_logic;
      -----------RR-------------------------------
      RF_wr_ena_in : in std_logic; -----------------------------------------> This signal is for WB stage
      -----------WB-------------------------------
      alu_res_in, data_in : in std_logic_vector(15 downto 0);
      C_mod_in , Z_mod_in  : in std_logic;
      c_in, z_in : in std_logic;
      IMM_0_ena_in, Z_mod_wb_in  : in std_logic;
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
      -----------WB-------------------------------
      alu_res_out, data_out : out std_logic_vector(15 downto 0);
      C_mod_out , Z_mod_out  : out std_logic;
      c_out, z_out : out std_logic;
      IMM_0_ena_out, Z_mod_wb_out : out std_logic;
      WB_mux_out : out std_logic_vector(1 downto 0)
      );
      -----------Misc----------------------------- 
end component; 

signal imm_out : std_logic_vector(8 downto 0);
signal Ra_out,Rb_out,Rc_out : std_logic_vector(2 downto 0);
signal dest_sel_out : std_logic_vector(1 downto 0);
signal valid_Ra_out, valid_Rb_out : std_logic;
      -----------RR-------------------------------
      -----------WB-------------------------------
signal IMM_0_ena_out, Z_mod_wb_out : std_logic;
signal WB_mux_out : std_logic_vector(1 downto 0);

signal z_tmp : std_logic;

signal alu_tmp1, imm_0_data : std_logic_vector(15 downto 0);
signal alu_tmp2, dm_data : std_logic_vector(15 downto 0);
signal C_mod_out , Z_mod_out  : std_logic;

signal dest_mem_tmp, dest_wb_tmp : std_logic_vector(2 downto 0);
begin
	------------dest sel for forwarding--------
	MUX4_I0 : MUX_4 
			generic map(N => 3)
			port map(Rc_in, Rb_in, Ra_in,"000",dest_sel_in, dest_mem_tmp);
	MUX2_I0 : MUX_2 
			generic map(N => 3)
			port map(dest_mem_tmp, dest_from_lsma_mem, dest_sel_in_lsma_mem, dest_mem);
	
	-----------DM instantiation----------------
	DM_I0 : DM port map(alu_res_in, data_mem_in, dout_tmp, clk, RF_wr_ena_in);
	
	Zero_flag_gates :for i in 0 to 15 generate
				z_or_out <= z_or_out or dout_tmp(i);
			 end generate Zero_flag_gates;
	---------zero flag modification by DM-------		 
	z_tmp <=  z_or_out when Z_mod_wb_out = '1' else
		  z_in;
		  
	------------substitute for for warding either data_dm or alu result-----------
	MUX2_I_11 : MUX_2 
			generic map(N => 16)
			port map(alu_res_in, dout_tmp, RF_wr_ena_in, data_mem);
	-----------Pipelined reg-------------------
	MEM_WB_I0: MEM_WB port map(PC_in,
      				imm_in,
      				Ra_in,Rb_in,Rc_in,
      				dest_sel_in,
      				valid_Ra_in, valid_Rb_in,
      				clk,clr,disable,
      				-----------RR-------------------------------
     				RF_wr_ena_in, -----------------------------------------> This signal is for WB stage
      				-----------WB-------------------------------
      				alu_res_in, dout_tmp,
      				C_mod_in , Z_mod_in,
      				c_in, z_tmp,
      				IMM_0_ena_in, Z_mod_wb_in,
      				WB_mux_in,
     				----------OUTPUTS---------------------------
      				--------------------------------------------
      				PC_out,
      				imm_out,
      				Ra_out,Rb_out,Rc_out,
      				dest_sel_out,
      				valid_Ra_out, valid_Rb_out,
      				-----------RR-------------------------------
      				RF_wr_ena_out,
      				-----------WB-------------------------------
      				alu_tmp2, dm_data,
      				C_mod_out , Z_mod_out,
      				c_out, z_out,
      				IMM_0_ena_out, Z_mod_wb_out,
      				WB_mux_out	
        );
	------------dest sel for wb--------------
	MUX4_I1 : MUX_4 
			generic map(N => 3)
			port map(Rc_out, Rb_out, Ra_out,"000",dest_sel_out, dest_wb_tmp);
	MUX2_I1 : MUX_2 
			generic map(N => 3)
			port map(dest_wb_tmp, dest_from_lsma_wb, dest_sel_in_lsma_wb, dest_wb);
	------------IMM_0------------------------
	IMM_0_I0 : IMM_0 port map(imm_in, IMM_0_ena_in, imm_0_data);
	------------WB mux-----------------------
	MUX4_I2 : MUX_4 
			generic map(N => 16)
			port map(imm_0_data, alu_tmp2, dm_data, PC_in, WB_mux_out, mux_wb_out);		
	-----------------------carry and zero mod for forwarding----------------
	C_mod_out_mem <= C_mod_in;
	Z_mod_out_mem <= Z_mod_in;
	C_mod_out_wb <= C_mod_out;
	Z_mod_out_wb <= Z_mod_out;
end arch;