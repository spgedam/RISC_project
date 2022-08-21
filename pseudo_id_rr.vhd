library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pseudo_id_rr is
port( clk,clr, invalid_in: in std_logic;
      invalid_out : out std_logic;
      -------------------RR---------------------------------
      --opcode_in : in std_logic_vector(3 downto 0);
      --opcode_out : out std_logic_vector(3 downto 0);
      sel_sm_sa_src_in : in std_logic;
      sel_sm_sa_src_out : out std_logic;
      --sel_lsma_in : inout std_logic;   ------ 0 for normal operation
      --sel_lsma_out : inout std_logic;
      -------------------EX---------------------------------
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
end pseudo_id_rr;

architecture beh of pseudo_id_rr is
begin
	process(clk,clr,invalid_in)
	begin
		if(rising_edge(clk)) then
			if(clr = '1') then
				--opcode_out <= "0000";
				sel_sm_sa_src_out <= '0';
				--sel_lsma_out <= '0';
				--sel_ad_da_out <= '0';
				dest_reg_out <= "000";
				invalid_out <= '0';
				dest_addr_out <= '0';
				--sel_alu_ra_out <= '0';
      				--sel_alura_rb_out <= '0';
      				sel_data_out <= '0';--
			else	
				--opcode_out <= opcode_in;
				sel_sm_sa_src_out <= sel_sm_sa_src_in;
				--sel_lsma_out <= sel_lsma_in;
				--sel_ad_da_out <= sel_ad_da_in;
				dest_reg_out <= dest_reg_in;
				invalid_out <= invalid_in;
				dest_addr_out <= dest_addr_in;
				--sel_alu_ra_out <= sel_alu_ra_in;
      				--sel_alura_rb_out <= sel_alura_rb_in;
      				sel_data_out <= sel_data_in;
			end if;
		end if;
	end process;
end beh;