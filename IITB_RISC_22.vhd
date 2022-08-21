library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IITB_RISC_22 is
port( clk, reset : in std_logic);
end IITB_RISC_22;

architecture arch of IITB_RISC_22 is
---------------------------------processor-------------------------------------------------------------
component proc is
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
end component; 

signal clr, disable_pc, disable_p1, disable_p2, disable_p3, disable_p4, disable_p5, stall_NOP : std_logic;
signal PC_in, PC_R7_in : std_logic_vector(15 downto 0);
signal dest_sel_in_lsma_exe, dest_sel_in_lsma_mem, dest_sel_in_lsma_wb : std_logic; 
signal dest_from_lsma_exe, dest_from_lsma_mem, dest_from_lsma_wb : std_logic_vector(2 downto 0);
signal sel_sma_src, sel_lsma : std_logic;		----------------lsma
signal src_sma : std_logic_vector(2 downto 0);
signal forward_rr1, forward_rr2, for_c, for_z : std_logic_vector(1 downto 0);
signal sel_alu_ra : std_logic;
signal sel_data_in : std_logic;
signal forward_ex_1, forward_ex_2 : std_logic;

signal Ra_dec, Rb_dec : std_logic_vector(2 downto 0);
signal va_dec , vb_dec : std_logic;
signal Ra_rr, Rb_rr : std_logic_vector(2 downto 0);
signal Ra_exe, Rb_exe : std_logic_vector(2 downto 0);
signal va_rr, va_exe : std_logic;
signal vb_rr, vb_exe : std_logic; 
signal lsma_id, lsma_rr : std_logic;

signal imm_8 : std_logic_vector(7 downto 0);
signal opc, opcode_lsma : std_logic_vector( 3 downto 0);
signal PC_adv, PC_plus_1 : std_logic_vector(15 downto 0);
signal beq_out : std_logic;
signal jmp_out : std_logic_vector(1 downto 0);
signal dest_exe, dest_mem, dest_wb : std_logic_vector(2 downto 0);
signal C_mod_out_exe , Z_mod_out_exe, C_mod_out_mem , Z_mod_out_mem, C_mod_out_wb , Z_mod_out_wb : std_logic;
signal ALU_result, PC_rb : std_logic_vector(15 downto 0); 
signal eq : std_logic;
---------------------------------end of processor------------------------------------------------------
---------------------------------branch prediction-----------------------------------------------------
component branch_pred is 
port(PC_if, PC_exe, PC_ALU : in std_logic_vector(15 downto 0);
     beq, eq : in std_logic; ---------------both are from EXE stage
     HB : out std_logic;-------------------------------------History bit
     beq_flush, mispred : out std_logic;-------to be required when misprediction happens
     btb_hit : out std_logic;
     PC_out : out std_logic_vector(15 downto 0)
);
end component; 

-- signal beq, eq : std_logic; ---------------both are from EXE stage
signal HB : std_logic;-------------------------------------History bit
signal beq_flush, mispred : std_logic;-------to be required when misprediction happens
signal btb_hit : std_logic;
signal PC_out, PC_btb : std_logic_vector(15 downto 0);
---------------------------------end of branch prediction-----------------------------------------------------
---------------------------------IP_update-----------------------------------------------------
component IP_update is 
port( PC_if, PC_btb, PC_exe, PC_alu, PC_rb : in std_logic_vector(15 downto 0);
      jmp : in std_logic_vector(1 downto 0);
      beq_flush, mispred, btb_hit, HB : in std_logic;
      PC_out : out std_logic_vector(15 downto 0)
); 
end component;

--signal PC_if, PC_btb, PC_exe, PC_alu, PC_rb : std_logic_vector(15 downto 0);
--signal jmp : std_logic_vector(1 downto 0);
--signal beq_flush, mispred, btb_hit : std_logic;
---signal PC_out : std_logic_vector(15 downto 0);
--------------------------------end of IP_update-----------------------------------------------

---------------------------------LM_SM_LA_SA---------------------------------------------------
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
---------------------------------end of LM_SM_LA_SA--------------------------------------------

---------------------------------Forwarding logic----------------------------------------------
component forward_logic_1 is
port( opd : in std_logic_vector(3 downto 0);----------------------------------------- from stall_NOP
      cond : in std_logic_vector(1 downto 0);-----------------------------------------Also from stall_NOP
      valid_rr_1, valid_rr_2, valid_exe_1, valid_exe_2 : in std_logic;
      dest_exe, dest_mem, dest_wb : in std_logic_vector(2 downto 0);
      src_rr_1, src_rr_2 : in std_logic_vector(2 downto 0);
      src_exe_1, src_exe_2 : in std_logic_vector(2 downto 0);
      c_mod_exe, c_mod_mem, c_mod_wb : in std_logic;
      z_mod_exe, z_mod_mem, z_mod_wb : in std_logic;
      rr_mux1, rr_mux2, rr_c, rr_z : out std_logic_vector(1 downto 0);
      exe_mux1, exe_mux2 : out std_logic
      );
end component;

---------------------------------end of forwarding logic---------------------------------------

---------------------------------staller-------------------------------------------------------
component stall_NOP_block is
port( clk : in std_logic;
      opcode : in std_logic_vector(3 downto 0);
      cond : in std_logic_vector(1 downto 0);
      ra_rr, ra_dec, rb_dec : in std_logic_vector(2 downto 0);
      v1_id, v2_id : in std_logic;
--    alu_a, alu_b : in std_logic; ----------------------tells whether the operand in any instruction passses through ALU or not
      imm8 : in std_logic_vector(7 downto 0);
      opcode_delay : out std_logic_vector(3 downto 0);
      cond_delay : out std_logic_vector(1 downto 0);
      inv : in std_logic;
      stall_NOP : out std_logic;
      dis_p1,dis_p2,dis_p3,dis_p4,dis_p5, dis_pc : out std_logic
);
end component;

signal opcode_delay : std_logic_vector(3 downto 0);
signal cond_delay : std_logic_vector(1 downto 0);
signal invalid_prienc : std_logic;
--signal stall_NOP : std_logic;
signal dis_p1,dis_p2,dis_p3,dis_p4,dis_p5, dis_pc : std_logic;
---------------------------------end of staller------------------------------------------------

---------------------------------flush logic---------------------------------------------------
component flush is
port( jump, mispred : in std_logic;
      clr_p1_p2_pc : out std_logic
);
end component;

signal clr_p1_p2_pc : std_logic;
---------------------------------end of flush logic--------------------------------------------



begin
	--------------------------------branch prediction block--------------------------------
	BRANCH_PRED_I0 : branch_pred port map(PC_adv, PC_plus_1, ALU_result,
     					      beq_out, eq, ---------------both are from EXE stage
     					      HB,-------------------------------------History bit
     					      beq_flush, mispred,-------to be required when misprediction happens
     					      btb_hit,
     					      PC_btb
			);
	--------------------------------IP update block----------------------------------------
	IP_UPDATE_I0 :IP_update port map( PC_adv, PC_btb, PC_plus_1, ALU_result, PC_rb,
      					  jmp_out,
      					  beq_flush, mispred, btb_hit, HB,
      					  PC_out
			); 
	--------------------------------LM_SM_LA_SA block---------------------------------------		

	LM_SM_LA_SA_I0 : Multiple port map( opcode_lsma,  -- not from staller
      					       imm_8,
      					       clk, reset,
      					        lsma_rr,
      					       invalid_prienc,
      					       -------------------RR---------------------------------
      					       --sel_lsma_in : in std_logic_vector(1 downto 0);   ------ 0 for normal operation
      					       sel_sma_src,
      					       sel_lsma,
      					       src_sma,
      					       --dest_reg_rr,
      					       -------------------EX---------------------------------
      					       --sel_ra_rb_in : in std_logic;
      					       --sel_ra_rb_out : out std_logic;
      					       sel_alu_ra,
      					       --sel_alura_rb : out std_logic;
      					       sel_data_in,
      					       dest_from_lsma_exe,
      					       dest_sel_in_lsma_exe,
      					       -------------------MEM--------------------------------
      					       --sel_ad_da_in : in std_logic;
      					       --sel_ad_da_out : out std_logic;
      					       dest_from_lsma_mem,
      					       dest_sel_in_lsma_mem,
      					       -------------------WB---------------------------------
      					       --dest_reg_in : in std_logic_vector(2 downto 0);
      					       dest_from_lsma_wb,
      					       dest_sel_in_lsma_wb 
					);
	--------------------------------stall_NOP_block---------------------------------------
	STALL_NOP_BLOCK_I0 : stall_NOP_block port map( clk,
      						       opc,
      						       imm_8(1 downto 0) ,
      						       Ra_rr, Ra_dec, Rb_dec,
      						       va_dec, va_dec,
      						       imm_8,
      						       opcode_delay,
      						       cond_delay,
      						       invalid_prienc,
      						       stall_NOP,
      						       disable_p1,disable_p2,disable_p3,disable_p4,disable_p5, disable_pc
					);
	--------------------------------forwarding logcic---------------------------------------
	FORWARDING_LOGIC_I0 : forward_logic_1 port map ( opcode_delay ,----------------------------------------- from stall_NOP
      							 cond_delay ,-----------------------------------------Also from stall_NOP
      							 va_rr, vb_rr, va_exe, vb_exe ,
      							 dest_exe, dest_mem, dest_wb ,
      							 Ra_rr, Rb_rr,
      				 			 Ra_exe, Rb_exe,
      							 C_mod_out_exe, C_mod_out_mem, C_mod_out_wb ,
      							 Z_mod_out_exe, Z_mod_out_mem, Z_mod_out_wb ,
      							 forward_rr1, forward_rr2, for_c, for_z ,
      							 forward_ex_1, forward_ex_2
      					);
      	--------------------------------flush---------------------------------------------------				
      	FLUSH_I0 : flush port map( jmp_out(1), mispred,
      				   clr_p1_p2_pc
					);
					
	clr <= reset or clr_p1_p2_pc ; 
	
	----------------------------------block to update R&------------------------------------
			---------------as of now R7 is just PC + 1 from WB-------
	PC_R7_in <= PC_plus_1;
	PC_in <= PC_out ; 
	--------------------------------just pipelined-------------------------------------------
	PROC_I0 : proc port map( clk, clr, reset, disable_pc, disable_p1, disable_p2, disable_p3, disable_p4, disable_p5, stall_NOP,
      				 PC_out, PC_R7_in,
      				 dest_sel_in_lsma_exe, dest_sel_in_lsma_mem, dest_sel_in_lsma_wb,
      				 dest_from_lsma_exe, dest_from_lsma_mem, dest_from_lsma_wb,
      				 sel_sma_src, sel_lsma,		----------------lsma
      				 src_sma,
      				 forward_rr1, forward_rr2, for_c, for_z,
      				 sel_alu_ra,
      				 sel_data_in,
      				 forward_ex_1, forward_ex_2,
      				 Ra_dec, Rb_dec,
      				 va_dec , vb_dec,
      				 Ra_rr, Rb_rr,
      				 Ra_exe, Rb_exe,
      				 va_rr, va_exe,
      				 vb_rr, vb_exe,
      				 lsma_id, lsma_rr, 
      				 imm_8,
      				 opc, opcode_lsma,
      				 PC_adv, PC_plus_1,
      				 beq_out,
      				 jmp_out,
      				 dest_exe, dest_mem, dest_wb,
      				 C_mod_out_exe , Z_mod_out_exe, C_mod_out_mem , Z_mod_out_mem, C_mod_out_wb , Z_mod_out_wb,
      				 ALU_result, PC_rb,
      				 eq
			);	
--	PROC_I0 : proc port map( clk, clr, reset, disable_pc, disable_p1, disable_p2, disable_p3, disable_p4, disable_p5, stall_NOP,
--      				 PC_out, PC_R7_in,
--      				 '0', '0', '0',
--      				 "000", "000", "000",
--      				 '0', '0',		----------------lsma
--      				 "000",
--      				 forward_rr1, forward_rr2, for_c, for_z,
--      				 '0',
--      				 '0',
--      				 forward_ex_1, forward_ex_2,
--      				 Ra_dec, Rb_dec,
--      				 va_dec , vb_dec,
--      				 Ra_rr, Rb_rr,
--      				 Ra_exe, Rb_exe,
--      				 va_rr, va_exe,
--      				 vb_rr, vb_exe,
--      				 lsma_id, lsma_rr, 
--      				 imm_8,
--      				 opc, opcode_lsma,
--      				 PC_adv, PC_plus_1,
--      				 beq_out,
--      				 jmp_out,
--      				 dest_exe, dest_mem, dest_wb,
--      				 C_mod_out_exe , Z_mod_out_exe, C_mod_out_mem , Z_mod_out_mem, C_mod_out_wb , Z_mod_out_wb,
--      				 ALU_result, PC_rb,
--      				 eq
--			);	
end arch;