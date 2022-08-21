library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pseudo_rr_exe is
port( clk,clr: in std_logic;
      -------------------EX---------------------------------
      inv_in : in std_logic;
      inv_out : out std_logic;
      sel_alu_ra_in : in std_logic;
      sel_alu_ra_out : out std_logic;
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
end pseudo_rr_exe;

architecture beh of pseudo_rr_exe is
begin
	process(clk,clr)--,invalid_in)
	begin
		if(rising_edge(clk)) then
			if(clr = '1') then
				inv_out <= '0';
				--sel_ra_rb_out <= '0';
				--sel_ad_da_out <= '0';
				dest_reg_out <= "000";
				--invalid_out <= '0';
				dest_addr_out <= '0';
				sel_alu_ra_out <= '0';
      				--sel_alura_rb_out <= '0';
      				sel_data_out <= '0';
			else
				inv_out <= inv_in;
				--sel_ra_rb_out <= sel_ra_rb_in;
				--sel_ad_da_out <= sel_ad_da_in;
				dest_reg_out <= dest_reg_in;
				--invalid_out <= invalid_in;
				dest_addr_out <= dest_addr_in;
				sel_alu_ra_out <= sel_alu_ra_in;
      				--sel_alura_rb_out <= sel_alura_rb_in;
      				sel_data_out <= sel_data_in;
			end if;
		end if;
	end process;
end beh;
