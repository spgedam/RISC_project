library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity S3_P3_S4_P4_S5_P5_S6 is
port( PC_in, PC_R7_in : in std_logic_vector(15 downto 0);
      Ra_in,Rb_in,Rc_in,ins2_0_in : in std_logic_vector(2 downto 0);
      dest_sel_in : in std_logic_vector(1 downto 0);
      valid_Ra_in, valid_Rb_in : in std_logic;
      clk,clr,disable_p3, disable_p4, disable_p5 : in std_logic;
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
      IMM_0_ena_in, Z_mod_wb_in : in std_logic;
      WB_mux_in : in std_logic_vector(1 downto 0);
      ----------------misc. blocks----------------
      dest_sel_in_lsma_exe, dest_sel_in_lsma_mem, dest_sel_in_lsma_wb : in std_logic; 
      dest_from_lsma_exe, dest_from_lsma_mem, dest_from_lsma_wb : in std_logic_vector(2 downto 0);
      sel_sma_src, sel_lsma : in std_logic;		----------------lsma
      src_sma : in std_logic_vector(2 downto 0);
--      C_exe, C_mem, C_wb : in std_logic;
--      Z_exe, Z_mem, Z_wb : in std_logic;
      forward_rr1, forward_rr2, for_c, for_z : in std_logic_vector(1 downto 0);
      sel_alu_ra : in std_logic;
      sel_data_in : in std_logic;
      forward_ex_1, forward_ex_2 : in std_logic;
      ---------------outputs----------------------
      Ra_rr, Rb_rr : out std_logic_vector(2 downto 0);
      Ra_exe, Rb_exe : out std_logic_vector(2 downto 0);
      va_rr, va_exe : out std_logic;
      vb_rr, vb_exe : out std_logic;
      ALU_result,PC_rb : out std_logic_vector(15 downto 0);
      PC_R7, PC_plus_1 :out std_logic_vector(15 downto 0);
      beq_out : out std_logic;
      jmp_out : out std_logic_vector(1 downto 0);
      dest_exe, dest_mem, dest_wb : out std_logic_vector(2 downto 0);
      C_mod_out_exe , Z_mod_out_exe, C_mod_out_mem , Z_mod_out_mem, C_mod_out_wb , Z_mod_out_wb : out std_logic;
      C_mod_out , Z_mod_out  : out std_logic;
--      c_out, z_out : out std_logic;
      eq : out std_logic
);
end S3_P3_S4_P4_S5_P5_S6;

architecture arch of S3_P3_S4_P4_S5_P5_S6 is

component S3 is
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
      sel_sma_src, sel_lsma : in std_logic;		----------------lsma
      src_sma : in std_logic_vector(2 downto 0);
      dest_exe, dest_mem, dest_wb, alu_out : in std_logic_vector(15 downto 0);				----------------lsma except alu_out
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
end component;

----------------temp signals for stage 3-----------
signal C_exe, C_mem, C_wb : std_logic;
signal Z_exe, Z_mem, Z_wb : std_logic;
signal Rc_wb_in : std_logic_vector(2 downto 0);
signal d3_wb_tmp : std_logic_vector(15 downto 0);
signal PC_wb_tmp : std_logic_vector(15 downto 0);
signal PC_out_tmp : std_logic_vector(15 downto 0);
signal Ra_out_tmp,Rb_out_tmp,Rc_out_tmp : std_logic_vector(2 downto 0);
signal dest_sel_out_tmp : std_logic_vector(1 downto 0);
signal valid_Ra_out_tmp, valid_Rb_out_tmp : std_logic;
      -------------------EX--------------------------------------
signal R1_out_tmp, R2_out_tmp : std_logic_vector(15 downto 0);
signal se_data_tmp : std_logic_vector(15 downto 0);
signal sel_d1_d2_out_tmp , ls_out_tmp , sel_ls_imm_out_tmp , sel_plus1_out_tmp , sel_PC_out_tmp, C_mod_out_tmp , Z_mod_out_tmp : std_logic;
signal beq_out_tmp : std_logic;
signal jmp_out_tmp : std_logic_vector(1 downto 0);
signal op_out_tmp : std_logic_vector(2 downto 0);
      -----------Mem------------------------------
signal DM_wr_ena_out_tmp : std_logic;
      -----------WB-------------------------------
signal RF_wr_ena_out_tmp, RF_wr_ena_wb : std_logic;
signal C_out_tmp, Z_out_tmp : std_logic;
signal IMM_0_ena_out_tmp, Z_mod_wb_out_tmp : std_logic;
signal WB_mux_out_tmp : std_logic_vector(1 downto 0);

component S4 is
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
      PC_out,PC_plus_1 : out std_logic_vector(15 downto 0);
      imm_out : out std_logic_vector(8 downto 0);
      dest : out std_logic_vector( 2 downto 0);
      Ra_out,Rb_out,Rc_out : out std_logic_vector(2 downto 0);
      C_mod_out , Z_mod_out : out std_logic;
      dest_sel_out : out std_logic_vector(1 downto 0);
      valid_Ra_out, valid_Rb_out : out std_logic;
      -----------RR-------------------------------
      RF_wr_ena_out : out std_logic;
      -----------Ex-------------------------------
      ALU_result, PC_rb : out std_logic_vector(15 downto 0);
      eq : out std_logic;
      -----------Mem------------------------------
      addr, data : out std_logic_vector(15 downto 0);
      DM_wr_ena_out : out std_logic;
      c_out, z_out : out std_logic;
      -----------WB-------------------------------
      IMM_0_ena_out, Z_mod_wb_out : out std_logic;
      WB_mux_out : out std_logic_vector(1 downto 0) 
      );
end component;

---------------------temp signals for Stage 4-------
signal data_mem, data_exe, data_wb : std_logic_vector(15 downto 0); 
signal PC_out_t1 : std_logic_vector(15 downto 0);
signal imm_out_t1 : std_logic_vector(8 downto 0);
signal Ra_out_t1,Rb_out_t1,Rc_out_t1 : std_logic_vector(2 downto 0);
signal C_mod_out_t1 , Z_mod_out_t1 : std_logic;
signal dest_sel_out_t1 : std_logic_vector(1 downto 0);
signal valid_Ra_out_t1, valid_Rb_out_t1 : std_logic;
      -----------RR-------------------------------
signal RF_wr_ena_out_t1 : std_logic;
      -----------Ex-------------------------------
      -----------Mem------------------------------
signal addr_t1, data_t1 : std_logic_vector(15 downto 0);
signal DM_wr_ena_out_t1 : std_logic;
signal c_out_t1, z_out_t1 : std_logic;
      -----------WB-------------------------------
signal IMM_0_ena_out_t1, Z_mod_wb_out_t1 : std_logic;
signal WB_mux_out_t1 : std_logic_vector(1 downto 0);
signal C_mod_wb , Z_mod_wb : std_logic;



component S5 is
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
end component;

signal c_out_t2, z_out_t2 : std_logic;
begin
	dest_wb <= Rc_wb_in;
	d3_wb_tmp <= data_wb;
	
	Ra_rr <= Ra_in;
	Rb_rr <= Rb_in;
	va_rr <= valid_Ra_in;
	vb_rr <= valid_Rb_in;
	S3_I0 : S3 port map(    PC_in,
      				Ra_in,Rb_in,Rc_in,ins2_0_in,
      				dest_sel_in,
      				valid_Ra_in, valid_Rb_in,
      				clk,clr,disable_p3,
      				-----------RR-------------------------------
      				RF_wr_ena_in ,
     		 		se_in,
      				-----------Ex-------------------------------
      				sel_d1_d2_in , ls_in , sel_ls_imm_in , sel_plus1_in , sel_PC_in, C_mod_in , Z_mod_in ,
      				beq_in,
      				jmp_in,
      				op_in ,
      				-----------Mem------------------------------
      				DM_wr_ena_in,
      				-----------WB-------------------------------
      				IMM_0_ena_in, Z_mod_wb_in, RF_wr_ena_wb ,
      				WB_mux_in,
      				Rc_wb_in ,
      				d3_wb_tmp ,
      				PC_R7_in ,
      				c_out_t2, z_out_t2 ,
      				C_mod_wb , Z_mod_wb,
      				----------------misc. blocks----------------
      				sel_sma_src, sel_lsma ,		----------------lsma
      				src_sma,
      				data_exe, data_mem, data_wb, addr_t1 ,				----------------lsma except alu_out
      				C_exe, C_mem, C_wb,
      				Z_exe, Z_mem, Z_wb,
      				forward_rr1, forward_rr2, for_c, for_z ,
      				PC_out_tmp,
      				Ra_out_tmp,Rb_out_tmp,Rc_out_tmp,
      				dest_sel_out_tmp,
      				valid_Ra_out_tmp, valid_Rb_out_tmp,
      				-------------------EX--------------------------------------
      				R1_out_tmp, R2_out_tmp,
      				se_data_tmp ,
      				sel_d1_d2_out_tmp , ls_out_tmp , sel_ls_imm_out_tmp , sel_plus1_out_tmp , sel_PC_out_tmp, C_mod_out_tmp , Z_mod_out_tmp,
      				beq_out_tmp,
      				jmp_out_tmp,
      				op_out_tmp ,
      				-----------Mem------------------------------
      				DM_wr_ena_out_tmp,
      				-----------WB-------------------------------
      				RF_wr_ena_out_tmp,
      				C_out_tmp, Z_out_tmp,
      				IMM_0_ena_out_tmp, Z_mod_wb_out_tmp,
      				WB_mux_out_tmp
			);
 
	C_mod_out_exe <= C_mod_out_tmp;
	Z_mod_out_exe <= Z_mod_out_tmp;
	
	
	Ra_exe <= Ra_out_tmp;
	Rb_exe <= Rb_out_tmp;
	va_exe <= valid_Ra_out_tmp;
	vb_exe <= valid_Rb_out_tmp;
	
	S4_I0 : S4 port map(		  PC_out_tmp,
				se_data_tmp,
				dest_sel_out_tmp,
      				Ra_out_tmp,Rb_out_tmp,Rc_out_tmp,
      				valid_Ra_out_tmp, valid_Rb_out_tmp,
      				clk,clr,disable_p4,
      				-----------RR-------------------------------
      				RF_wr_ena_out_tmp,
      				R1_out_tmp, R2_out_tmp,
      				-------------------EX-----------------------
      				sel_d1_d2_out_tmp , ls_out_tmp , sel_ls_imm_out_tmp , sel_plus1_out_tmp , sel_PC_out_tmp, C_mod_out_tmp , Z_mod_out_tmp, 
      				C_out_tmp, Z_out_tmp,     				
      				op_out_tmp ,
      				-----------Mem------------------------------
      				DM_wr_ena_out_tmp,
      				-----------WB-------------------------------
      				IMM_0_ena_out_tmp, Z_mod_wb_out_tmp,
      				WB_mux_out_tmp	,
      				------------Misc. blocks--------------------
      				dest_sel_in_lsma_exe,
      				dest_from_lsma_exe,
      				sel_alu_ra,
      				sel_data_in,
      				forward_ex_1, forward_ex_2,
      				data_mem,
      				PC_out_t1, PC_plus_1,
                                imm_out_t1,
                                dest_exe,
                                Ra_out_t1,Rb_out_t1,Rc_out_t1,
                                C_mod_out_t1 , Z_mod_out_t1,
                                dest_sel_out_t1,
                                valid_Ra_out_t1, valid_Rb_out_t1,
                                -----------RR-------------------------------
                         				RF_wr_ena_out_t1,
                                -----------Ex-------------------------------
                                ALU_result,PC_rb,
                                eq,
                                -----------Mem------------------------------
                                addr_t1, data_t1,
                                DM_wr_ena_out_t1,
                                c_out_t1, z_out_t1,
                                -----------WB-------------------------------
                                IMM_0_ena_out_t1, Z_mod_wb_out_t1,
                                WB_mux_out_t1
			);
			
	-------------------------------beq and jmp for pc-----------------------
	beq_out <= beq_out_tmp;
	jmp_out <= jmp_out_tmp;
	
	C_mod_out_exe <= C_mod_out_t1;
	Z_mod_out_exe <= Z_mod_out_t1;
	
	S5_I0 : S5 port map(    PC_out_t1,
                                imm_out_t1,
                                Ra_out_t1,Rb_out_t1,Rc_out_t1,
                                dest_sel_out_t1,
                                dest_sel_in_lsma_mem, dest_sel_in_lsma_wb,
      				dest_from_lsma_mem, dest_from_lsma_wb,
                                valid_Ra_out_t1, valid_Rb_out_t1,
                                clk,clr,disable_p5,
                                -----------RR-------------------------------
                         				RF_wr_ena_out_t1,
                                -----------Mem------------------------------
                                addr_t1, data_t1,
                                C_mod_out_t1 , Z_mod_out_t1,
                                c_out_t1, z_out_t1,
                                DM_wr_ena_out_t1,
                                -----------WB-------------------------------
                                IMM_0_ena_out_t1, Z_mod_wb_out_t1,
                                WB_mux_out_t1,
                                ----------Misc.-----------------------------
                                data_mem,--- Rc_wb_in,
                                dest_mem, dest_wb,
                                PC_wb_tmp, data_wb,
                                RF_wr_ena_wb,
                                C_mod_out_mem , Z_mod_out_mem, C_mod_out_wb , Z_mod_out_wb,
                                c_out_t2, z_out_t2
			); 
			
	PC_R7 <= PC_wb_tmp;
	C_mod_out_wb <= C_mod_wb;
	Z_mod_out_wb <= Z_mod_wb;                               								
end arch;