library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----
entity ID_RR is
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
      -----------Misc-----------------------------
end ID_RR;

architecture ID_RR_arch of ID_RR is
begin
	process(PC_in,clk,clr,Ra_in,Rb_in,Rc_in,ins2_0_in,beq_in,jmp_in,disable,RF_wr_ena_in,sel_d1_d2_in , 
		ls_in , sel_ls_imm_in , sel_plus1_in , C_mod_in , Z_mod_in,
		op_in,DM_wr_ena_in,IMM_0_ena_in,WB_mux_in,Z_mod_wb_in)
	begin
		if(clr = '1') then
			PC_out <= (others => '0');
      			Ra_out <= (others => '0');
      			Rb_out <= (others => '0');
      			Rc_out <= (others => '0');
      			ins2_0_out <= (others => '0');
      			dest_sel_out <= (others =>'0');
      			valid_Ra_out <= '0';
      			valid_Rb_out <= '0';
      			-----------RR-------------------------------
      			opc_out <= "0000";
      			lsma_out <= '0';
     			RF_wr_ena_out <= '0';
     			se_out <= "00";
      			-----------Ex-------------------------------
      			sel_d1_d2_out <= '0'; 
      			ls_out <= '0'; 
      			sel_ls_imm_out <= '0'; 
      			sel_plus1_out <= '0'; 
      			sel_PC_out <= '0';
      			C_mod_out <= '0'; 
      			Z_mod_out <= '0';
      			op_out <= (others => '0');
      			beq_out <= '0';
      			jmp_out <= "00";
      			-----------Mem------------------------------
      			DM_wr_ena_out <= '0';
      			-----------WB-------------------------------
      			IMM_0_ena_out <= '0';
      			WB_mux_out <= (others => '0');
      			Z_mod_wb_out <= '0';
      		elsif( disable = '1' ) then
      			null;
		elsif(clk'event and clk = '1') then
			PC_out <= PC_in;
      			Ra_out <= Ra_in;
      			Rb_out <= Rb_in;
      			Rc_out <= Rc_in;
      			ins2_0_out <= ins2_0_in;
      			dest_sel_out <= dest_sel_in;
      			valid_Ra_out <= valid_Ra_in; 
      			valid_Rb_out <= valid_Rb_in;
      			-----------RR-------------------------------
      			opc_out <= opc_in;
      			lsma_out <= lsma_in ;
     			RF_wr_ena_out <= RF_wr_ena_in;
     			se_out <= se_in;
      			-----------Ex-------------------------------
      			sel_d1_d2_out <= sel_d1_d2_in; 
      			ls_out <= ls_in; 
      			sel_ls_imm_out <= sel_ls_imm_in; 
      			sel_plus1_out <= sel_plus1_in; 
      			sel_PC_out <= sel_PC_in;
      			C_mod_out <= C_mod_in; 
      			Z_mod_out <= Z_mod_in;
      			op_out <= op_in;
      			beq_out <= beq_in;
      			jmp_out <= jmp_in;
      			-----------Mem------------------------------
      			DM_wr_ena_out <= DM_wr_ena_in;
      			-----------WB-------------------------------
      			IMM_0_ena_out <= IMM_0_ena_in;
      			WB_mux_out <= WB_mux_in;
      			Z_mod_wb_out <= Z_mod_wb_in;
      		else
      			null;
      		end if;
      	end process;
end ID_RR_arch;