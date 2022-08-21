library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proc is
port( clk, clr, reset, disable_pc, disable_p1, disable_p2, disable_p3, disable_p4, disable_p5, stall_NOP : in std_logic;
      PC_in, PC_R7_in : in std_logic_vector(15 downto 0);
      dest_sel_in_lsma_exe, dest_sel_in_lsma_mem, dest_sel_in_lsma_wb : in std_logic; 
      dest_from_lsma_exe, dest_from_lsma_mem, dest_from_lsma_wb : in std_logic_vector(2 downto 0);
      sel_sma_src, sel_lsma : in std_logic;		----------------lsma
      src_sma : in std_logic_vector(2 downto 0);
      forward_rr1, forward_rr2, for_c, for_z : in std_logic_vector(1 downto 0);
      sel_alu_ra : in std_logic;
      sel_data_in : in std_logic;
      forward_ex_1, forward_ex_2 : in std_logic;
      Ra_dec, Rb_dec : out std_logic_vector(2 downto 0);
      va_dec , vb_dec : out std_logic;
      Ra_rr, Rb_rr : out std_logic_vector(2 downto 0);
      Ra_exe, Rb_exe : out std_logic_vector(2 downto 0);
      va_rr, va_exe : out std_logic;
      vb_rr, vb_exe : out std_logic; 
      lsma_id, lsma_rr : out std_logic;
      imm_8 : out std_logic_vector(7 downto 0);
      opc, opcode_lsma : out std_logic_vector( 3 downto 0);
      PC_adv, PC_plus_1 :out std_logic_vector(15 downto 0);
      beq_out : out std_logic;
      jmp_out : out std_logic_vector(1 downto 0);
      dest_exe, dest_mem, dest_wb : out std_logic_vector(2 downto 0);
      C_mod_out_exe , Z_mod_out_exe, C_mod_out_mem , Z_mod_out_mem, C_mod_out_wb , Z_mod_out_wb : out std_logic;
      ALU_result, PC_rb : out std_logic_vector(15 downto 0); 
      eq : out std_logic
);
end proc;

architecture arch of proc is

component S1_P1_S2_P2 is
port( clk, clr, disable_pc, disable_p1, disable_p2, stall_NOP : in std_logic;
      PC_in : in std_logic_vector(15 downto 0);
      Ra_dec, Rb_dec : out std_logic_vector(2 downto 0);
      va_dec , vb_dec : out std_logic;
      imm_8 : out std_logic_vector(7 downto 0);
      opc, opcode_lsma : out std_logic_vector( 3 downto 0);
      PC_adv, PC_out : out std_logic_vector(15 downto 0);
      Ra_out,Rb_out,Rc_out,ins2_0_out : out std_logic_vector(2 downto 0);
      dest_sel_out : out std_logic_vector(1 downto 0);
      valid_Ra_out, valid_Rb_out : out std_logic;
      -----------RR-------------------------------
      lsma_id, lsma_rr : out std_logic;
      RF_wr_ena_out : out std_logic;
      se_out : out std_logic_vector(1 downto 0);
      -----------Ex-------------------------------
      sel_d1_d2_out, ls_out, sel_ls_imm_out, sel_plus1_out, sel_PC_out , C_mod_out, Z_mod_out : out std_logic;
      beq_out : out std_logic;
      jmp_out : out std_logic_vector(1 downto 0);
      op_out : out std_logic_vector(2 downto 0);
      -----------Mem------------------------------
      DM_wr_ena_out : out std_logic;
      -----------WB-------------------------------
      IMM_0_ena_out, Z_mod_wb_out : out std_logic;
      WB_mux_out : out std_logic_vector(1 downto 0)
      );
end component; 
-------------------internal signals for S1_P1_S2_P2------------------
signal PC_out : std_logic_vector(15 downto 0);
signal Ra_out,Rb_out,Rc_out,ins2_0_out : std_logic_vector(2 downto 0);
signal dest_sel_out : std_logic_vector(1 downto 0);
signal valid_Ra_out, valid_Rb_out : std_logic;
      -----------RR-------------------------------
signal RF_wr_ena_out : std_logic;
signal se_out : std_logic_vector(1 downto 0);
      -----------Ex-------------------------------
signal sel_d1_d2_out, ls_out, sel_ls_imm_out, sel_plus1_out, sel_PC_out , C_mod_out, Z_mod_out : std_logic;
signal beq_out_1 : std_logic;
signal jmp_out_1 : std_logic_vector(1 downto 0);
signal op_out : std_logic_vector(2 downto 0);
      -----------Mem------------------------------
signal DM_wr_ena_out : std_logic;
      -----------WB-------------------------------
signal IMM_0_ena_out, Z_mod_wb_out : std_logic;
signal WB_mux_out : std_logic_vector(1 downto 0);


component S3_P3_S4_P4_S5_P5_S6 is
port( PC_in, PC_R7_in  : in std_logic_vector(15 downto 0);
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
      ALU_result, PC_rb : out std_logic_vector(15 downto 0);
      PC_plus_1 :out std_logic_vector(15 downto 0);
      beq_out : out std_logic;
      jmp_out : out std_logic_vector(1 downto 0);
      dest_exe, dest_mem, dest_wb : out std_logic_vector(2 downto 0);
      C_mod_out_exe , Z_mod_out_exe, C_mod_out_mem , Z_mod_out_mem, C_mod_out_wb , Z_mod_out_wb : out std_logic;
--      c_out, z_out : out std_logic;
      eq : out std_logic
);
end component;

begin

	S1_P1_S2_P2_I0 : S1_P1_S2_P2 port map (clk, clr, disable_pc, disable_p1, disable_p2, stall_NOP,
      				   PC_in,
      				   Ra_dec, Rb_dec,
      				   va_dec , vb_dec,
      				   imm_8,
      				   opc,opcode_lsma,
      				   PC_adv, PC_out,
				   Ra_out,Rb_out,Rc_out,ins2_0_out,
      				   dest_sel_out,
      				   valid_Ra_out, valid_Rb_out,
      				   -----------RR-------------------------------
      				   lsma_id, lsma_rr,
      				   RF_wr_ena_out,
      				   se_out,
      				   -----------Ex-------------------------------
      				   sel_d1_d2_out, ls_out, sel_ls_imm_out, sel_plus1_out, sel_PC_out , C_mod_out, Z_mod_out,
      				   beq_out_1,
      				   jmp_out_1,
      				   op_out,
      				   -----------Mem------------------------------
      				   DM_wr_ena_out,
      				   -----------WB-------------------------------
      				   IMM_0_ena_out, Z_mod_wb_out,
      				   WB_mux_out
			);
			
      
	S3_P3_S4_P4_S5_P5_S6_I0 : S3_P3_S4_P4_S5_P5_S6 port map(PC_out, PC_R7_in,
				                                Ra_out,Rb_out,Rc_out,ins2_0_out,
				                                dest_sel_out,
				                                valid_Ra_out, valid_Rb_out,
				                                clk,reset,disable_p3, disable_p4, disable_p5,
				                                -----------RR-------------------------------
				                                RF_wr_ena_out,
				                                se_out,
				                                -----------Ex-------------------------------
				                                sel_d1_d2_out, ls_out, sel_ls_imm_out, sel_plus1_out, sel_PC_out , C_mod_out, Z_mod_out,
				                                beq_out_1,
				                                jmp_out_1,
				                                op_out,
				                                -----------Mem------------------------------
				                                DM_wr_ena_out,
				                                -----------WB-------------------------------
				                                IMM_0_ena_out, Z_mod_wb_out,
				                                WB_mux_out,
				                                dest_sel_in_lsma_exe, dest_sel_in_lsma_mem, dest_sel_in_lsma_wb,
				                                dest_from_lsma_exe, dest_from_lsma_mem, dest_from_lsma_wb,
				                                sel_sma_src, sel_lsma,	----------------lsma
				                                src_sma,
				                                forward_rr1, forward_rr2, for_c, for_z,
				                                sel_alu_ra,
				                                sel_data_in,
				                                forward_ex_1, forward_ex_2,
				                                ------------outputs-------------------------
				                                Ra_rr, Rb_rr,
      								Ra_exe, Rb_exe,
				                                va_rr, va_exe,
				                                vb_rr, vb_exe,
				                                ALU_result, PC_rb,
				                                PC_plus_1,
				                                beq_out,
				                                jmp_out,
				                                dest_exe, dest_mem, dest_wb,
				                                C_mod_out_exe , Z_mod_out_exe, C_mod_out_mem , Z_mod_out_mem, C_mod_out_wb , Z_mod_out_wb,
				                                eq
							);
end arch;