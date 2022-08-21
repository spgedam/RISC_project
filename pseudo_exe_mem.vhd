library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pseudo_exe_mem is
port( clk,clr : in std_logic;
      -------------------MEM--------------------------------
      -------------------WB---------------------------------
      dest_reg_in : in std_logic_vector(2 downto 0);
      dest_reg_out : out std_logic_vector(2 downto 0);
      dest_addr_in : in std_logic;
      dest_addr_out : out std_logic
      );
end pseudo_exe_mem;

architecture beh of pseudo_exe_mem is
begin
	process(clk,clr)
	begin
		if(rising_edge(clk)) then
			if(clr = '1') then
				
				--sel_ad_da_out <= '0';
				dest_reg_out <= "000";
				--invalid_out <= '0';
				dest_addr_out <= '0';
			else
				
				--sel_ad_da_out <= sel_ad_da_in;
				dest_reg_out <= dest_reg_in;
				--invalid_out <= invalid_in;
				dest_addr_out <= dest_addr_in;
			end if;
		end if;
	end process;
end beh;