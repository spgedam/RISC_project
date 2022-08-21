library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiple is
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
end Multiple;

architecture arch of Multiple is
signal R0_R7 : std_logic_vector( 7 downto 0);
signal count,i0,i1,i2,i3,i4,i5,i6,i7 : integer := 0;
signal ct : std_logic_vector(3 downto 0) := "0000";



component pri_enc is
port( clr, lsma_rr : in std_logic;
      I : in std_logic_vector(7 downto 0);
      O : out std_logic_vector(2 downto 0);
      invalid : out std_logic);
end component;

component pri_dec is
port( inv : in std_logic;
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


component pseudo_rr_exe is
port( clk,clr: in std_logic;
      -------------------EX---------------------------------
      inv_in : in std_logic;
      inv_out : out std_logic;
      sel_alu_ra_in : in std_logic;
      sel_alu_ra_out : out std_logic;
      sel_data_in : in std_logic;
      sel_data_out : out std_logic;
      -------------------MEM--------------------------------
      -------------------WB---------------------------------
      dest_reg_in : in std_logic_vector(2 downto 0);
      dest_reg_out : out std_logic_vector(2 downto 0);
      dest_addr_in : in std_logic;
      dest_addr_out : out std_logic
      );
end component;

component pseudo_exe_mem is
port( clk,clr: in std_logic;
      -------------------MEM--------------------------------
      -------------------WB---------------------------------
      dest_reg_in : in std_logic_vector(2 downto 0);
      dest_reg_out : out std_logic_vector(2 downto 0);
      dest_addr_in : in std_logic;
      dest_addr_out : out std_logic
      );
end component;

component pseudo_mem_wb is
port( clk,clr: in std_logic;
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
--signal invld_i, invld_o1,invld_o2,invld_o3,invld_o4 : std_logic; 
--signal tmp : std_logic := '0';
--signal instr : std_logic_vector(1 downto 0);  -- 00 for lm, 01 for sm, 10 for la, 11 for sa
-- signal ena_clr : std_logic;
--___________________temp. sigs for pseudo pip regs--------

signal inv_in_pd, inv_out_pd : std_logic;


signal sel_alu_ra_1i : std_logic;
signal sel_data_1i : std_logic;

signal sel_alu_ra_1o : std_logic;
signal sel_data_1o : std_logic;
      
signal dest_reg_out_ex_1i : std_logic_vector(2 downto 0);
signal dest_reg_ex_1i : std_logic;

signal dest_reg_out_ex_1o : std_logic_vector(2 downto 0);
signal dest_reg_ex_1o : std_logic;
-------------------MEM--------------------------------
signal dest_reg_out_mem_1i : std_logic_vector(2 downto 0);
signal dest_reg_mem_1i : std_logic;

signal dest_reg_out_mem_1o : std_logic_vector(2 downto 0);
signal dest_reg_mem_1o : std_logic;
		-------------------WB---------------------------------
signal dest_reg_out_wb_1i : std_logic_vector(2 downto 0);
signal dest_reg_wb_1i : std_logic;

signal dest_reg_out_wb_1o : std_logic_vector(2 downto 0);
signal dest_reg_wb_1o : std_logic;

begin
	R0_R7 <= R0_R7_I when lsma_rr = '1' else
		 "00000000";
	i0 <= 1 when R0_R7(0) = '1' else 0;
	i1 <= 1 when R0_R7(1) = '1' else 0;
	i2 <= 1 when R0_R7(2) = '1' else 0;
	i3 <= 1 when R0_R7(3) = '1' else 0;
	i4 <= 1 when R0_R7(4) = '1' else 0; 
	i5 <= 1 when R0_R7(5) = '1' else 0;
	i6 <= 1 when R0_R7(6) = '1' else 0;
	i7 <= 1 when R0_R7(7) = '1' else 0;
	count <= (i0 + i1 + i2 + i3 + i4 + i5 + i6 + i7) ;
	
	B_or <= "11111111" when (opcode = "1110" or opcode = "1111") else 
		"00000000";
	
	OR_gates_8 : OR_gates generic map(8)
			      port map ( R0_R7, B_or, or_out);
	AND_gates_8 : AND_gates generic map(8)
				port map(or_out, pdec_out, and_out);
	PRI_ENC1 : pri_enc port map(clr, lsma_rr, and_out, penc_out, inv_in_pd);
	
	
	dest_reg_out_ex_1i <= penc_out;
	
	P1 : pseudo_rr_exe port map( clk,clr,
      				     -------------------EX---------------------------------
      				     inv_in_pd, inv_out_pd,
      				     sel_alu_ra_1i,
      				     sel_alu_ra_1o,
      				     sel_data_1i,
      				     sel_data_1o,
      				     -------------------MEM--------------------------------
      				     -------------------WB---------------------------------
      				     penc_out,
      				     dest_reg_out_ex_1o,
      				     dest_reg_ex_1i,
      				     dest_reg_ex_1o
      			);
      	
      	PRI_DEC1 : pri_dec port map(inv_out_pd,dest_reg_out_ex_1o,pdec_out);
      			
      	P2 : pseudo_exe_mem port map( clk,clr,
      				      dest_reg_out_ex_1o,
      				      dest_reg_out_mem_1o,
      				      dest_reg_ex_1o,
      				      dest_reg_mem_1o
      			);
      	P3 : pseudo_mem_wb port map ( clk,clr,
      				      dest_reg_out_mem_1o,
      				      dest_reg_out_wb_1o,
      				      dest_reg_mem_1o,
      				      dest_reg_wb_1o
      			);
      			
      			
      process(opcode, R0_R7_I, clk, clr, lsma_rr)
	begin
	if(ct = "0000" and inv_in_pd = '0') then
		sel_sm_sa_src <= '1';
		sel_lsma_out <= '0';
		dest_reg_out_rr<= penc_out;
		-------------------EX---------------------------------
		sel_alu_ra_1i <= '0';
		sel_data_1i <= '1';
		dest_reg_out_ex_1i <= penc_out;
		dest_reg_ex_1i <= '1';
	elsif( ct > "0000" and inv_in_pd = '0') then
		sel_sm_sa_src <= '1';
		sel_lsma_out <= '1';
		dest_reg_out_rr<= penc_out;
		-------------------EX---------------------------------
		sel_alu_ra_1i <= '1';
		sel_data_1i <= '1';
		dest_reg_out_ex_1i <= penc_out;
		dest_reg_ex_1i <= '1';
	else
		sel_sm_sa_src <= '0';
		sel_lsma_out <= '0';
		dest_reg_out_rr<= penc_out;
		-------------------EX---------------------------------
		sel_alu_ra_1i <= '0';
		sel_data_1i <= '0';
		dest_reg_out_ex_1i <= penc_out;
		dest_reg_ex_1i <= '0';
	end if;
	end process;
	
	
	process(opcode, R0_R7_I, clk, clr, lsma_rr)
	begin
		if(rising_edge(clk) and lsma_rr = '1') then
			if(inv_in_pd = '1') then
				ct <= "0000";
			else
				ct <= std_logic_vector(to_unsigned(to_integer((unsigned(ct)) +1),4)); end if;end if;
	end process;
	
      
      
      -------------------EX---------------------------------
      sel_alu_ra <= sel_alu_ra_1o;
      sel_data <= sel_data_1o;
      dest_reg_out_ex <= dest_reg_out_ex_1o;
      dest_reg_ex <= dest_reg_ex_1o;
      -------------------MEM--------------------------------
      dest_reg_out_mem <= dest_reg_out_mem_1o;
      dest_reg_mem <= dest_reg_mem_1o;
      -------------------WB---------------------------------
      dest_reg_out_wb <= dest_reg_out_wb_1o;
      dest_reg_wb <= dest_reg_wb_1o;	
	
	
end arch;
  