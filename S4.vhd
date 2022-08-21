library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----
entity S4 is
port( PC_in : in std_logic_vector(15 downto 0);
      se_in : in std_logic_vector(15 downto 0);
      dest_sel_in : in std_logic_vector(1 downto 0);
      Ra_in,Rb_in,Rc_in: in std_logic_vector(2 downto 0);
      valid_Ra_in, valid_Rb_in : in std_logic;
      clk,clr,disable : in std_logic; 
      -----------RR-------------------------------
      RF_wr_ena_in : in std_logic;
      R1_in, R2_in : in std_logic_vector(15 downto 0);
      -----------Ex-------------------------------
      sel_d1_d2_in , ls_in , sel_ls_imm_in , sel_plus1_in , sel_PC_in, C_mod_in , Z_mod_in : in std_logic;
      c_in, z_in : in std_logic;
      op_in : in std_logic_vector(2 downto 0);
      -----------Mem------------------------------
      DM_wr_ena_in : in std_logic;
      -----------WB-------------------------------
      IMM_0_ena_in, Z_mod_wb_in : in std_logic;
      WB_mux_in : in std_logic_vector(1 downto 0);
      ------------Misc. blocks--------------------
      dest_sel_in_lsma : in std_logic; 
      dest_from_lsma : in std_logic_vector(2 downto 0);
      sel_alu_ra : in std_logic;
      sel_data_in : in std_logic;
      forward_ex_1, forward_ex_2 : in std_logic;
      dest_mem : in std_logic_vector(15 downto 0); 
      PC_out, PC_plus_1,PC_plus0 : out std_logic_vector(15 downto 0);
      imm_out : out std_logic_vector(8 downto 0);
      dest : out std_logic_vector( 2 downto 0);
      Ra_out,Rb_out,Rc_out : out std_logic_vector(2 downto 0);
      C_mod_out , Z_mod_out : out std_logic;
      dest_sel_out : out std_logic_vector(1 downto 0);
      valid_Ra_out, valid_Rb_out : out std_logic;
      -----------RR-------------------------------
      RF_wr_ena_out : out std_logic;
      -----------Ex-------------------------------
      ALU_result,PC_rb : out std_logic_vector(15 downto 0);
      eq : out std_logic;
      -----------Mem------------------------------
      addr, data : out std_logic_vector(15 downto 0);
      DM_wr_ena_out : out std_logic;
      c_out, z_out : out std_logic;
      -----------WB-------------------------------
      IMM_0_ena_out, Z_mod_wb_out : out std_logic;
      WB_mux_out : out std_logic_vector(1 downto 0) 
      );
end S4;

architecture arch of S4 is
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

component LS_1b is
port ( din : in std_logic_vector(15 downto 0);
       ls : in std_logic;
       dout : out std_logic_vector(15 downto 0));
end component;

component ALU is 
port( A, B : in std_logic_vector(15 downto 0);
      Ci, Zi: in std_logic;
      Co, Zo, beq: out std_logic;
      op : in std_logic_vector(2 downto 0);
      result : inout std_logic_vector(15 downto 0));
end component;

component CZ is
port( Ci, Zi : in std_logic;
      C_mod,Z_mod, Z_mod_mem : in std_logic;
      ra_mem : in std_logic_vector(15 downto 0);
      Co, Zo : out std_logic);
end component;

signal for_mux_out_a, for_mux_out_b : std_logic_vector(15 downto 0);
signal d1_d2,PC_d1_d2, ls_d2, ls_imm, ls_plus_1, alu_res, alu_ra, data_mem, PC_plus_1_tmp : std_logic_vector(15 downto 0);
signal co_tmp,zo_tmp : std_logic;

component EX_MEM is 
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
end component;

signal dest_tmp : std_logic_vector(2 downto 0);


begin
	-------forward mux--
	MUX2_I0 : MUX_2 port map(R1_in,dest_mem,forward_ex_1,for_mux_out_a);
	MUX2_I1 : MUX_2 port map(R2_in,dest_mem,forward_ex_2,for_mux_out_b);
	
	PC_rb <= for_mux_out_b;
	-------d1 or d2-----
	MUX2_I2 : MUX_2 port map(for_mux_out_a,for_mux_out_b,sel_d1_d2_in,d1_d2);
	--------PC_or_d1----
	MUX2_I3 : MUX_2 port map(d1_d2,PC_in,sel_PC_in,PC_d1_d2);
	--------Ls block----
	LS_I0 : LS_1b port map(for_mux_out_b, ls_in, ls_d2);
	--------imm_d2------
	MUX2_I4 : MUX_2 port map(ls_d2, se_in, sel_ls_imm_in, ls_imm);
	--------plus 1 mux--
	MUX2_I5 : MUX_2 port map(ls_imm, std_logic_vector(to_unsigned(1,16)), sel_plus1_in, ls_plus_1);
	--------ALU---------
	ALU_I0 : ALU port map(PC_d1_d2, ls_plus_1, c_in, z_in, co_tmp,zo_tmp, eq, op_in, alu_res);
	ALU_result <= alu_res;
	-------Ra_ALU-------
	MUX2_I6 : MUX_2 port map(alu_res,d1_d2, sel_alu_ra, alu_ra);
	------PC+1----------
	PC_plus_1_tmp <= std_logic_vector(to_unsigned(to_integer(unsigned(PC_in))+1,16));
	PC_plus_1 <= PC_plus_1_tmp;
	-------data---------
	MUX2_I7 : MUX_2 port map(for_mux_out_a, for_mux_out_b, sel_data_in, data_mem);
	-------dest_control-
	MUX4_I0 : MUX_4 
			generic map(N => 3)
			port map(Rc_in, Rb_in, Ra_in,"000",dest_sel_in, dest_tmp);
	MUX2_I8 : MUX_2 
			generic map(N => 3)
			port map(dest_tmp,dest_from_lsma,dest_sel_in_lsma, dest);
	-------Ex_mem-------
	EX_MEM_I0 : EX_MEM port map(PC_plus_1_tmp,
      				se_in(8 downto 0),
      				Ra_in,Rb_in,Rc_in,
      				dest_sel_in,
      				valid_Ra_in, valid_Rb_in,
      				clk,clr,disable,
      				-----------RR-------------------------------
      				RF_wr_ena_in, -----------------------------------------> This signal is for WB stage
      				-----------Mem------------------------------
      				alu_ra, data_mem,
      				C_mod_in , Z_mod_in ,
      				co_tmp, zo_tmp,
      				DM_wr_ena_in,
      				-----------WB-------------------------------
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
      				-----------Mem------------------------------
      				addr, data,
      				C_mod_out , Z_mod_out ,
      				c_out, z_out,
     				DM_wr_ena_out,
      				-----------WB-------------------------------
      				IMM_0_ena_out, Z_mod_wb_out,
      				WB_mux_out
      );
	
end arch;