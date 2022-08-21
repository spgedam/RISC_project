library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LM_SM_LA_SA is 
port( opcode : in std_logic_vector(3 downto 0); 
      R0_R7 : in std_logic_vector( 7 downto 0);
      clk, clr : in std_logic;
      lsma_id, lsma_rr : in std_logic;
      invalid_prienc : out std_logic;
      -------------------RR---------------------------------
      --sel_lsma_in : in std_logic_vector(1 downto 0);   ------ 0 for normal operation
      sel_sm_sa_src : out std_logic;
      sel_lsma_out : out std_logic;
      dest_reg_out_rr : out std_logic_vector(2 downto 0);
      --dest_reg_rr :out std_logic;
      -------------------EX---------------------------------
      --sel_ra_rb_in : in std_logic;
      --sel_ra_rb_out : out std_logic;
      sel_alu_ra : out std_logic;
      --sel_alura_rb : out std_logic;
      sel_data : out std_logic;
      dest_reg_out_ex : out std_logic_vector(2 downto 0);
      dest_reg_ex :out std_logic;
      -------------------MEM--------------------------------
      --sel_ad_da_in : in std_logic;
      --sel_ad_da_out : out std_logic;
      dest_reg_out_mem : out std_logic_vector(2 downto 0);
      dest_reg_mem :out std_logic;
      -------------------WB---------------------------------
      --dest_reg_in : in std_logic_vector(2 downto 0);
      dest_reg_out_wb : out std_logic_vector(2 downto 0);
      dest_reg_wb :out std_logic);
end LM_SM_LA_SA;

architecture LM_SM_LA_SA_arch of LM_SM_LA_SA is
-------------------component declaration--------------------
component pri_enc is
port( clr : in std_logic;
      I : in std_logic_vector(7 downto 0);
      O : out std_logic_vector(2 downto 0);
      invalid : out std_logic);
end component;

component pri_dec is
port( ena_delay : in std_logic;
      I : in std_logic_vector(2 downto 0);
      O : out std_logic_vector(7 downto 0));
end component;

component OR_gates is 
generic( I_O_length : integer := 8);
port( A , B : in std_logic_vector(I_O_length-1 downto 0);
      O : out std_logic_vector(I_O_length-1 downto 0));
end component;

component AND_gates is 
generic( I_O_length : integer := 8);
port( A , B : in std_logic_vector(I_O_length-1 downto 0);
      O : out std_logic_vector(I_O_length-1 downto 0));
end component;
--____________________Psuedo pip reg_____________________--
component pseudo_id_rr is
port( clk,clr ,invalid_in: in std_logic;
      invalid_out : out std_logic;
      -------------------RR---------------------------------
      --opcode_in : in std_logic_vector(3 downto 0);
      --opcode_out : out std_logic_vector(3 downto 0);
      sel_sm_sa_src_in : in std_logic;
      sel_sm_sa_src_out : out std_logic;
      --sel_lsma_in : inout std_logic;   ------ 0 for normal operation
      --sel_lsma_out : inout std_logic;
      -------------------EX---------------------------------
      --sel_ra_rb_in : in std_logic;
      --sel_ra_rb_out : out std_logic;
      --sel_alu_ra_in : in std_logic;
      --sel_alu_ra_out : out std_logic;
      --sel_alura_rb_in : in std_logic;
      --sel_alura_rb_out : out std_logic;
      sel_data_in : in std_logic;
      sel_data_out : out std_logic;
      -------------------MEM--------------------------------
      --sel_ad_da_in : in std_logic;
      --sel_ad_da_out : out std_logic;
      -------------------WB---------------------------------
      dest_reg_in : in std_logic_vector(2 downto 0);
      dest_reg_out : out std_logic_vector(2 downto 0);
      dest_addr_in : in std_logic;
      dest_addr_out : out std_logic
      );
end component;

component pseudo_rr_exe is
port( clk,clr, invalid_in: in std_logic;
      invalid_out : out std_logic;
      -------------------EX---------------------------------
      opcode_in : in std_logic_vector(3 downto 0);
      opcode_out : out std_logic_vector(3 downto 0);
      --sel_ra_rb_in : in std_logic;
      --sel_ra_rb_out : out std_logic;
      --sel_alu_ra_in : in std_logic;
      --sel_alu_ra_out : out std_logic;
      --sel_alura_rb_in : in std_logic;
      --sel_alura_rb_out : out std_logic;
      sel_data_in : in std_logic;
      sel_data_out : out std_logic;
      -------------------MEM--------------------------------
      --sel_ad_da_in : in std_logic;
      --sel_ad_da_out : out std_logic;
      -------------------WB---------------------------------
      dest_reg_in : in std_logic_vector(2 downto 0);
      dest_reg_out : out std_logic_vector(2 downto 0);
      dest_addr_in : in std_logic;
      dest_addr_out : out std_logic
      );
end component;

component pseudo_exe_mem is
port( clk,clr, invalid_in: in std_logic;
      invalid_out : out std_logic;
      -------------------MEM--------------------------------
      opcode_in : in std_logic_vector(3 downto 0);
      opcode_out : out std_logic_vector(3 downto 0);
      --sel_ad_da_in : in std_logic;
      --sel_ad_da_out : out std_logic;
      -------------------WB---------------------------------
      dest_reg_in : in std_logic_vector(2 downto 0);
      dest_reg_out : out std_logic_vector(2 downto 0);
      dest_addr_in : in std_logic;
      dest_addr_out : out std_logic
      );
end component;

component pseudo_mem_wb is
port( clk,clr, invalid_in: in std_logic;
      invalid_out : out std_logic;
      -------------------WB---------------------------------
      dest_reg_in : in std_logic_vector(2 downto 0);
      dest_reg_out : out std_logic_vector(2 downto 0);
      dest_addr_in : in std_logic;
      dest_addr_out : out std_logic
      );
end component;
-----------------------------------------------------------
----------------------temporary signals--------------------
signal or_out,B_or,and_out,pdec_out : std_logic_vector(7 downto 0);
signal penc_out : std_logic_vector(2 downto 0);
signal invld_i, invld_o1,invld_o2,invld_o3,invld_o4 : std_logic; 
signal tmp : std_logic := '0';
signal instr : std_logic_vector(1 downto 0);  -- 00 for lm, 01 for sm, 10 for la, 11 for sa
-- signal ena_clr : std_logic;
--___________________temp. sigs for pseudo pip regs--------
      -------------------RR1---------------------------------
       --sel_lsma_1i :  std_logic_vector(1 downto 0);   ------ 0 for normal operation
signal opcode_o : std_logic_vector(3 downto 0);
signal sel_sm_sa_src_1i : std_logic;
signal sel_sm_sa_src_1o : std_logic;
--signal sel_lsma_1i :  std_logic;
signal sel_lsma_1o :  std_logic;
       -------------------EX1---------------------------------
       --sel_ra_rb_1i :  std_logic;
       --sel_ra_rb_1o :  std_logic;
--signal sel_alu_ra_1i : std_logic;
--signal sel_alu_ra_1o : std_logic;
      --sel_alura_rb_1i : std_logic;
      --sel_alura_rb_1o : std_logic;
signal sel_data_1i : std_logic;
signal sel_data_1o : std_logic;
      -------------------MEM1--------------------------------
      --sel_ad_da_1i :  std_logic;
      --sel_ad_da_1o :  std_logic;
      -------------------WB1---------------------------------
signal dest_reg_1i :  std_logic_vector(2 downto 0);
signal dest_reg_1o :  std_logic_vector(2 downto 0);
signal dest_addr_1i : std_logic;
signal dest_addr_1o :  std_logic;
      -------------------EX2---------------------------------
signal sel_ra_rb_2o :  std_logic;
signal sel_alu_ra_2o : std_logic;
      --sel_alura_rb_2o : std_logic;
signal sel_data_2o : std_logic;
      -------------------MEM2--------------------------------
      --sel_ad_da_2o :  std_logic;
      -------------------WB2---------------------------------
signal dest_reg_2o :  std_logic_vector(2 downto 0);
signal dest_addr_2o :  std_logic;
      -------------------MEM3--------------------------------
      --sel_ad_da_3o :  std_logic;
      -------------------WB3---------------------------------
signal dest_reg_3o :  std_logic_vector(2 downto 0);
signal dest_addr_3o :  std_logic;
      -------------------WB4---------------------------------
signal dest_reg_4o :  std_logic_vector(2 downto 0);
signal dest_addr_4o :  std_logic;




signal op_p2,op_p3 : std_logic_vector( 3 downto 0);
signal imm8 : std_logic_vector( 7 downto 0);
begin
	-- B_or <= la_sa & la_sa & la_sa & la_sa & la_sa & la_sa & la_sa & la_sa;
	-- signal la_sa is not required, it can be simply extracted from str
	process(instr, R0_R7, clr, clk)
	begin
		if( lsma_id = '1' and lsma_rr = '0') then
			imm8 <= R0_R7;
		elsif(lsma_rr'event and lsma_rr = '1' and lsma_id = '0') then
			null;
		end if;
	end process;
	
	
	B_or <= instr(1) & instr(1) & instr(1) & instr(1) & instr(1) & instr(1) & instr(1) & instr(1);
	
	-------------instr : in std_logic_vector(1 downto 0);  -- 00 for lm, 01 for sm, 10 for la, 11 for sa
	with opcode select
		instr <= "00" when "1100",
			 "01" when "1101",
			 "10" when "1110",
			 "11" when "1111",
			 "00" when others;
--	ena_clr <= '0' when opcode(3 downto 2) = "11" else
--		   '1';
--	
	
	OR_gates_8 : OR_gates generic map(8)
			      port map ( imm8, B_or, or_out);
	AND_gates_8 : AND_gates generic map(8)
				port map(or_out, pdec_out, and_out);
	PRI_ENC1 : pri_enc port map(clr, and_out, penc_out, invld_i);
	invalid_prienc <= invld_i ;
	ID_RR1 : pseudo_id_rr port map(  clk, clr, invld_i,
     			                invld_o1,
      					-------------------RR1---------------------------------
      					--opcode_latch , op_p1,
      					sel_sm_sa_src_1i, sel_sm_sa_src_1o,
      					--sel_lsma_1i, sel_lsma_1o,
      					-------------------EX1---------------------------------
      					--sel_ra_rb_1i,
      					--sel_ra_rb_1o,
      					--sel_alu_ra_1i,
      					--sel_alu_ra_1o,
     				 	--sel_alura_rb_1i,
      					--sel_alura_rb_1o,
      					sel_data_1i,
      					sel_data_1o,
      					-------------------MEM1--------------------------------
      					--sel_ad_da_1i,
      					--sel_ad_da_1o,
      					-------------------WB1---------------------------------
      					penc_out,
      					dest_reg_1o,
      					dest_addr_1i,
      					dest_addr_1o
      					);
  
      	RR_EXE1 : pseudo_rr_exe port map(clk, clr, invld_o2,
     			                invld_o3,
      					-------------------EX2---------------------------------
      					opcode, op_p2,
      					--sel_ra_rb_1o,
      					--sel_ra_rb_2o,
      					--sel_alu_ra_1o,
      					--sel_alu_ra_2o,
      					sel_data_1o,
      					sel_data_2o,
      					-------------------MEM2--------------------------------
      					--sel_ad_da_1o,
      					--sel_ad_da_2o,
      					-------------------WB2---------------------------------
      					dest_reg_1o,
      					dest_reg_2o,
      					dest_addr_1o,
      					dest_addr_2o
      					);
      	
       EXE_MEM1: pseudo_exe_mem port map(clk, clr, invld_o2,
     			                invld_o3,
      					-------------------MEM3--------------------------------
      					op_p2, op_p3,
      					--sel_ad_da_2o,
      					--sel_ad_da_3o,
      					-------------------WB3---------------------------------
      					dest_reg_2o,
      					dest_reg_3o,
      					dest_addr_2o,
      					dest_addr_3o
      					);	
      	
      	
      	MEM_WB1 : pseudo_mem_wb port map(clk, clr, invld_o3,
     			                invld_o4,
      					-------------------WB4---------------------------------
      					dest_reg_3o,
      					dest_reg_4o,
      					dest_addr_3o,
      					dest_addr_4o
      					);	

	PRI_DEC1 : pri_dec port map(invld_o1,dest_reg_1o,pdec_out);
	
	process(instr, R0_R7, clr, clk) begin
		if( opcode /= op_p2 and opcode(3 downto 2) = "11") then
			sel_lsma_1o <= '0';
		elsif( opcode = op_p2 and opcode(3 downto 2) = "11") then
			sel_lsma_1o <= '1';
		else
			sel_lsma_1o <= '0';
		end if;
	end process;
	
	process(instr, R0_R7, clr, clk) begin
		if( op_p2 /= op_p3 and op_p2(3 downto 2) = "11") then
			sel_alu_ra_2o <= '0';
		elsif( op_p2 = op_p3 and op_p2(3 downto 2) = "11") then
			sel_alu_ra_2o <= '1';
		else 
			sel_alu_ra_2o <= '0';
		end if;
	end process;
	
--      	process(instr, R0_R7, clr, clk) begin
--      		if(clr = '1' or invld_i = '1') then
--      			tmp <= '0';
--      		elsif(opcode(3 downto 0) = "11" and opc_stall(3 downto 2) = "11" and invld_i = '1') then
--      			tmp <= '0';
--      		else
--      			null;
--      		end if;
--      	end process;
      	
      	process(instr, R0_R7, clr, clk) begin
      		if(clr = '1') then
      			sel_data_1i <= '0';
      			dest_reg_1i <= "000";
      		else
      			sel_data_1i <= '1';
      			dest_reg_1i <= penc_out;
      		end if;
      	end process;
      	
      	process(instr, R0_R7, clr, clk) begin
      		if(clr = '1') then
      			sel_sm_sa_src_1i <= '0';
      		else 
      			if(instr = "01" or instr = "11") then 
      				sel_sm_sa_src_1i <= '1';
      			else
      				sel_sm_sa_src_1i <= '0';
      			end if;
      		end if;
      	end process;	
      	
      	process(instr, R0_R7, clr, clk, invld_i) begin
      		if(invld_i = '0' and (instr = "00" or instr = "10")) then
      			dest_addr_1i <= '1';
      		else
      			dest_addr_1i <= '0';
      		end if;
      	end process;
      		
      	sel_sm_sa_src <= sel_sm_sa_src_1o;
      	sel_lsma_out <= sel_lsma_1o;
	sel_alu_ra <= sel_alu_ra_2o;
	sel_data <= sel_data_2o;
	dest_reg_out_rr <= dest_reg_1o;
	dest_reg_out_ex <= dest_reg_2o;
	dest_reg_out_mem <= dest_reg_3o;
	dest_reg_out_wb <= dest_reg_4o;
	--dest_reg_rr <= dest_addr_1o;
	dest_reg_ex <= dest_addr_2o;
	dest_reg_mem <= dest_addr_3o;
	dest_reg_wb <= dest_addr_4o;
end LM_SM_LA_SA_arch;