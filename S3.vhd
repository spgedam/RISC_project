library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity S3 is
port( PC_in : in std_logic_vector(15 downto 0);
      Ra_in,Rb_in,Rc_in,ins2_0_in : in std_logic_vector(2 downto 0);
      dest_sel_in : in std_logic_vector(1 downto 0);
      valid_Ra_in, valid_Rb_in : in std_logic;
      clk,clr,disable : in std_logic;
      -----------RR-------------------------------
      RF_wr_ena_in : in std_logic;
      se_in : in std_logic_vector(1 downto 0);
      -----------Ex-------------------------------
      sel_d1_d2_in , ls_in , sel_ls_imm_in , sel_plus1_in , sel_PC_in, C_mod_in , Z_mod_in  : in std_logic;
      beq_in : in std_logic;
      jmp_in : in std_logic_vector(1 downto 0);
      op_in : in std_logic_vector(2 downto 0);
      -----------Mem------------------------------
      DM_wr_ena_in : in std_logic;
      -----------WB-------------------------------
      IMM_0_ena_in, Z_mod_wb_in, RF_wr_ena_wb : in std_logic;
      WB_mux_in : in std_logic_vector(1 downto 0);
      Rc_wb_in : in std_logic_vector(2 downto 0);
      d3_wb : in std_logic_vector(15 downto 0);
      PC_wb : in std_logic_vector(15 downto 0);
      C_in, Z_in : in std_logic;---------------from wb
      C_mod_wb , Z_mod_wb  : in std_logic;
      ----------------misc. blocks----------------
      sel_sma_src, sel_lsma : in std_logic;
      src_sma : in std_logic_vector(2 downto 0);
      dest_exe, dest_mem, dest_wb, alu_out : in std_logic_vector(15 downto 0);
      C_exe, C_mem, C_wb : in std_logic;
      Z_exe, Z_mem, Z_wb : in std_logic;
      forward_rr1, forward_rr2, for_c, for_z : in std_logic_vector(1 downto 0);
      PC_out : out std_logic_vector(15 downto 0);
      Ra_out,Rb_out,Rc_out : out std_logic_vector(2 downto 0);
      dest_sel_out : out std_logic_vector(1 downto 0);
      valid_Ra_out, valid_Rb_out : out std_logic;
      -------------------EX--------------------------------------
      R1_out, R2_out : out std_logic_vector(15 downto 0);
      se_data : out std_logic_vector(15 downto 0);
      sel_d1_d2_out , ls_out , sel_ls_imm_out , sel_plus1_out , sel_PC_out, C_mod_out , Z_mod_out : out std_logic;
      beq_out : out std_logic;
      jmp_out : out std_logic_vector(1 downto 0);
      op_out : out std_logic_vector(2 downto 0);
      -----------Mem------------------------------
      DM_wr_ena_out : out std_logic;
      -----------WB-------------------------------
      RF_wr_ena_out : out std_logic;
      C_out, Z_out : out std_logic;
      IMM_0_ena_out, Z_mod_wb_out : out std_logic;
      WB_mux_out : out std_logic_vector(1 downto 0)       
);
end S3;

architecture arch of S3 is

component SE6_9 is 
port( imm_val : in std_logic_vector( 8 downto 0);
      se : in std_logic_vector(1 downto 0); -- 00 for no se, 01 for 9 bit se, 10 for 6 bit se
      dout : out std_logic_vector(15 downto 0));
end component;

component RF is
port( a1,a2,a3 : in std_logic_vector( 2 downto 0); -------a3 and d3 from wb
      d3, PC_WB : in std_logic_vector(15 downto 0);
      d1,d2 : out std_logic_vector( 15 downto 0);
      clk, wr_ena  : in std_logic);
end component; 

component CZ is
port( clk : in std_logic;
      Ci, Zi : in std_logic;
      C_mod,Z_mod: in std_logic;
      Co, Zo : out std_logic);
end component;
 
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

signal se_tmp : std_logic_vector(15 downto 0);
signal d1,d2,d11,d22,d111 : std_logic_vector(15 downto 0);
signal imm_val : std_logic_vector( 8 downto 0);
signal a2 : std_logic_vector(2 downto 0);
signal C1,Z1,C_out_tmp, Z_out_tmp : std_logic;


component RR_EX is 
port( PC_in : in std_logic_vector(15 downto 0);
      se_in : in std_logic_vector(15 downto 0);
      Ra_in,Rb_in,Rc_in: in std_logic_vector(2 downto 0);
      dest_sel_in : in std_logic_vector(1 downto 0);
      valid_Ra_in, valid_Rb_in : in std_logic;
      clk,clr,disable : in std_logic;
      -----------RR-------------------------------
      RF_wr_ena_in : in std_logic; -----------------------------------------> This signal is for WB stage
      R1_in, R2_in : in std_logic_vector(15 downto 0);
      -----------Ex-------------------------------
      sel_d1_d2_in , ls_in , sel_ls_imm_in , sel_plus1_in , sel_PC_in, C_mod_in , Z_mod_in  : in std_logic;
      c_in, z_in : in std_logic;
      beq_in : in std_logic;
      jmp_in : in std_logic_vector(1 downto 0);
      op_in : in std_logic_vector(2 downto 0);
      -----------Mem------------------------------
      DM_wr_ena_in : in std_logic;
      -----------WB-------------------------------
      IMM_0_ena_in, Z_mod_wb_in  : in std_logic;
      WB_mux_in : in std_logic_vector(1 downto 0);
      ----------OUTPUTS---------------------------
      --------------------------------------------
      PC_out : out std_logic_vector(15 downto 0);
      se_out : out std_logic_vector(15 downto 0);
      Ra_out,Rb_out,Rc_out : out std_logic_vector(2 downto 0);
      dest_sel_out : out std_logic_vector(1 downto 0);
      valid_Ra_out, valid_Rb_out : out std_logic;
      -----------RR-------------------------------
      RF_wr_ena_out : out std_logic;
      R1_out, R2_out : out std_logic_vector(15 downto 0);
      -----------Ex-------------------------------
      sel_d1_d2_out , ls_out , sel_ls_imm_out , sel_plus1_out , sel_PC_out, C_mod_out , Z_mod_out : out std_logic;
      c_out, z_out : out std_logic;
      beq_out : out std_logic;
      jmp_out : out std_logic_vector(1 downto 0);
      op_out : out std_logic_vector(2 downto 0);
      -----------Mem------------------------------
      DM_wr_ena_out : out std_logic;
      -----------WB-------------------------------
      IMM_0_ena_out, Z_mod_wb_out : out std_logic;
      WB_mux_out : out std_logic_vector(1 downto 0)
      );
      -----------Misc-----------------------------
end component;


begin
	imm_val <= Rb_in & Rc_in & ins2_0_in;
	SE_I0 : SE6_9 port map(imm_val, se_in, se_tmp);
	MUX2_I0 : MUX_2
		       generic map(N => 3)
		       port map(Rb_in,src_sma,sel_sma_src,a2);
	RF_I0 : RF port map(Ra_in,a2,Rc_wb_in, d3_wb, PC_wb, d1,d2,clk, RF_wr_ena_wb);
	
	CZ_I0 : CZ port map(clk, C_in, Z_in, C_mod_wb, Z_mod_wb, C_out_tmp, Z_out_tmp);
	
	MUX4_I0_RA : MUX_4 port map(d1,dest_exe,dest_mem,dest_wb,forward_rr1,d11);
	MUX4_I1_RB : MUX_4 port map(d2,dest_exe,dest_mem,dest_wb,forward_rr2,d22);
	---------------carry and zero forwarding implemented------------------------------
	C1<= C_out_tmp when for_c = "00" else
	     C_exe when for_c = "01" else
	     C_mem when for_c = "10" else
	     C_wb;
	     
	Z1<= Z_out_tmp when for_z = "00" else
	     Z_exe when for_z = "01" else
	     Z_mem when for_z = "10" else
	     C_wb;
	----------------------------------------------------------------------------------
	RR_EX_I0 : RR_EX port map( PC_in,
      				   se_tmp,
      				   Ra_in,Rb_in,Rc_in,
      				   dest_sel_in,
      				   valid_Ra_in, valid_Rb_in,
      				   clk,clr,disable,
      				   -----------RR-------------------------------
      				   RF_wr_ena_in,-----------------------------------------> This signal is for WB stage
      				   d1,d2,
     				   -----------Ex-------------------------------
      				   sel_d1_d2_in , ls_in , sel_ls_imm_in , sel_plus1_in , sel_PC_in, C_mod_in , Z_mod_in,
      				   C1, Z1,
      				   beq_in,
      				   jmp_in,
      				   op_in,
      				   -----------Mem------------------------------
      				   DM_wr_ena_in,
      				   -----------WB-------------------------------
      				   IMM_0_ena_in, Z_mod_wb_in,
      				   WB_mux_in,
      				   ----------OUTPUTS---------------------------
      				   --------------------------------------------
      				   PC_out,
      				   se_data,
      				   Ra_out,Rb_out,Rc_out,
      				   dest_sel_out ,
      				   valid_Ra_out, valid_Rb_out,
      				   -----------RR-------------------------------
      				   RF_wr_ena_out,
      				   R1_out,R2_out,
      				   -----------Ex-------------------------------
      				   sel_d1_d2_out , ls_out , sel_ls_imm_out , sel_plus1_out , sel_PC_out, C_mod_out , Z_mod_out,
      				   c_out, z_out,
      				   beq_out,
      				   jmp_out,
      				   op_out,
      				   -----------Mem------------------------------
      				   DM_wr_ena_out,
      				   -----------WB-------------------------------
      				   IMM_0_ena_out, Z_mod_wb_out,
      				   WB_mux_out
);
	
end arch;