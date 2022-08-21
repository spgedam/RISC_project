library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pseudo_mem_wb is
port( clk, clr: in std_logic;
      -------------------WB---------------------------------
      dest_reg_in : in std_logic_vector(2 downto 0);
      dest_reg_out : out std_logic_vector(2 downto 0);
      dest_addr_in : in std_logic;
      dest_addr_out : out std_logic
      );
end pseudo_mem_wb;

architecture beh of pseudo_mem_wb is
begin
	process(clk,clr)
	begin
		if(rising_edge(clk)) then
			if(clr = '1') then
				dest_reg_out <= "000";
				--invalid_out <= '0';
				dest_addr_out <= '0';
			else
				dest_reg_out <= dest_reg_in;
				--invalid_out <= invalid_in;
				dest_addr_out <= dest_addr_in;
			end if;
		end if;
	end process;
end beh;