library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity S1_P1_S2_P2 is
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
end S1_P1_S2_P2;

architecture arch of S1_P1_S2_P2 is

component MUX_2 is
generic(N: integer:=16);
port( A,B : in std_logic_vector(N-1 downto 0);
      sel : in std_logic;
      O : out std_logic_vector(N-1 downto 0));
end component;

component S1 is
port( clk, clr, disable_pc, disable_p1 : in std_logic;
      PC_in : in std_logic_vector(15 downto 0);
      PC_adv, PC_out : out std_logic_vector(15 downto 0);
      instr_out : out std_logic_vector(15 downto 0));
end component;
signal instr_out : std_logic_vector(15 downto 0);

component Decode_block is
port( opcode : in std_logic_vector( 3 downto 0);
      cond : in std_logic_vector( 1 downto 0);
      dest_sel_out : out std_logic_vector(1 downto 0);
      valid_Ra_out, valid_Rb_out : out std_logic;
      -----------RR-------------------------------
      lsma : out std_logic;
      RF_wr_ena_out : out std_logic;
      se : out std_logic_vector(1 downto 0);
      -----------Ex-------------------------------
      sel_d1_d2_out , ls_out , sel_ls_imm_out , sel_plus1_out , C_mod_out , Z_mod_out , sel_PC : out std_logic;
      jmp : out std_logic_vector(1 downto 0);
      beq : out std_logic;
      op_out : out std_logic_vector(2 downto 0);
      -----------Mem------------------------------
      DM_wr_ena_out : out std_logic;
      -----------WB-------------------------------
      IMM_0_ena_out, Z_mod_wb : out std_logic;
      WB_mux_out : out std_logic_vector(1 downto 0)
      );
end component;

-------------signals_decode_block--------------
signal opcode_tmp : std_logic_vector( 3 downto 0);
signal cond_tmp : std_logic_vector( 1 downto 0);
signal dest_sel_out_tmp : std_logic_vector(1 downto 0);
signal valid_Ra_out_tmp, valid_Rb_out_tmp : std_logic;
      -----------RR-------------------------------
signal RF_wr_ena_out_tmp, RF_wr_ena_out_tmp1 : std_logic;
signal se_tmp : std_logic_vector(1 downto 0);
      -----------Ex-------------------------------
signal sel_d1_d2_out_tmp , ls_out_tmp , sel_ls_imm_out_tmp , sel_plus1_out_tmp , C_mod_out_tmp , Z_mod_out_tmp , sel_PC_tmp : std_logic;
signal C_mod_out_tmp1 , Z_mod_out_tmp1 : std_logic;
signal jmp_tmp : std_logic_vector(1 downto 0);
signal beq_tmp : std_logic;
signal op_out_tmp : std_logic_vector(2 downto 0);
      -----------Mem------------------------------
signal DM_wr_ena_out_tmp, DM_wr_ena_out_tmp1 : std_logic;
      -----------WB-------------------------------
signal IMM_0_ena_out_tmp, Z_mod_wb_tmp : std_logic;
signal WB_mux_out_tmp : std_logic_vector(1 downto 0);

signal lsma_id1 : std_logic;

--------------------iD_RR-------------------------
component ID_RR is
port( PC_in : in std_logic_vector(15 downto 0);
      Ra_in,Rb_in,Rc_in,ins2_0_in : in std_logic_vector(2 downto 0);
      dest_sel_in : in std_logic_vector(1 downto 0);
      valid_Ra_in, valid_Rb_in : in std_logic;
      clk,clr,disable : in std_logic;
      -----------RR-------------------------------
      opc_in : in std_logic_vector(3 downto 0);
      lsma_in : in std_logic;
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
      ----------OUTPUTS---------------------------
      --------------------------------------------
      PC_out : out std_logic_vector(15 downto 0);
      Ra_out,Rb_out,Rc_out,ins2_0_out : out std_logic_vector(2 downto 0);
      dest_sel_out : out std_logic_vector(1 downto 0);
      valid_Ra_out, valid_Rb_out : out std_logic;
      -----------RR-------------------------------
      opc_out : out std_logic_vector(3 downto 0);
      lsma_out : out std_logic;
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
      ------------Misc-----------------------------
end component;

signal Ra_in,Rb_in,Rc_in,ins2_0_in : std_logic_vector(2 downto 0);


begin
	S1_I0 : S1 port map(clk, clr, disable_pc, disable_p1, PC_in, PC_adv, PC_out, instr_out);
	
	opcode_tmp <= instr_out(15 downto 12);
	opc<= instr_out(15 downto 12); 
	cond_tmp <= instr_out(1 downto 0);
	
	Dec_I0 : Decode_block port map( opcode_tmp,
					cond_tmp,
      					dest_sel_out_tmp,
      					valid_Ra_out_tmp, valid_Rb_out_tmp,
      					-----------RR-------------------------------
      					lsma_id1,
      					RF_wr_ena_out_tmp,
      					se_tmp,
      					-----------Ex-------------------------------
      					sel_d1_d2_out_tmp , ls_out_tmp , sel_ls_imm_out_tmp , sel_plus1_out_tmp , C_mod_out_tmp , Z_mod_out_tmp , sel_PC_tmp,
      					jmp_tmp,
      					beq_tmp,
      					op_out_tmp,
      					-----------Mem------------------------------
      					DM_wr_ena_out_tmp,
      					-----------WB-------------------------------
      					IMM_0_ena_out_tmp, Z_mod_wb_tmp,
      					WB_mux_out_tmp
      		);
      		
      	Ra_in <= instr_out(11 downto 9);
      	Rb_in <= instr_out(8 downto 6);
      	Rc_in <= instr_out(5 downto 3);
      	ins2_0_in <= instr_out(2 downto 0);
      	imm_8 <= instr_out(7 downto 0);
      	
      	
      	Ra_dec <= Ra_in;
      	Rb_dec <= Rb_in;
      	
      	va_dec <= valid_Ra_out_tmp;
        vb_dec <= valid_Rb_out_tmp;
      	------------------stall mux for Reg write enable--------------
      	RF_wr_ena_out_tmp1 <= RF_wr_ena_out_tmp when stall_NOP = '0' else
		 	      '0';
	------------------stall mux for carry mod---------------------
	Z_mod_out_tmp1 <= Z_mod_out_tmp when stall_NOP = '0' else
		 	  '0';
	------------------stall mux for zero mod----------------------
	C_mod_out_tmp1 <= C_mod_out_tmp when stall_NOP = '0' else
		 	  '0';
	------------------stall mux for DM write enable---------------
	DM_wr_ena_out_tmp1 <= DM_wr_ena_out_tmp when stall_NOP = '0' else
		 	      '0'; 	   
      	lsma_id <= lsma_id1;
      	P2_I0 : ID_RR port map( PC_in,
      				Ra_in,Rb_in,Rc_in,ins2_0_in,
      				dest_sel_out_tmp,
      				valid_Ra_out_tmp, valid_Rb_out_tmp,
      				clk,clr,disable_p2,
      				-----------RR-------------------------------
      				opcode_tmp,
      				lsma_id1,
     				RF_wr_ena_out_tmp1,
      				se_tmp,
      				-----------Ex-------------------------------
      				sel_d1_d2_out_tmp , ls_out_tmp , sel_ls_imm_out_tmp , sel_plus1_out_tmp , C_mod_out_tmp1 , Z_mod_out_tmp1 , sel_PC_tmp,
      				beq_tmp,
      				jmp_tmp,
      				op_out_tmp,
      				-----------Mem------------------------------
      				DM_wr_ena_out_tmp1,
      				-----------WB-------------------------------
      				IMM_0_ena_out_tmp, Z_mod_wb_tmp,
      				WB_mux_out_tmp,
      				PC_out,
      				Ra_out,Rb_out,Rc_out,ins2_0_out,
      				dest_sel_out,
      				valid_Ra_out, valid_Rb_out,
      				-----------RR-------------------------------
      				opcode_lsma,
      				lsma_rr,
      				RF_wr_ena_out,
      				se_out,
      				-----------Ex-------------------------------
      				sel_d1_d2_out, ls_out, sel_ls_imm_out, sel_plus1_out, sel_PC_out , C_mod_out, Z_mod_out,
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