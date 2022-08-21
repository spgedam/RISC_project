library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IP is
port(clk, clr, disable : in std_logic;
     IP_in : in std_logic_vector(15 downto 0);
     IP_out : out std_logic_vector(15 downto 0)
);
end IP;

architecture arch of IP is
begin
	process(clk,clr,disable,IP_in)
	begin
		if(clr = '1') then
			IP_out <= (others => '0');
		elsif(disable = '1') then
			null;
		elsif(rising_edge(clk)) then
			IP_out <= IP_in;
		else 
			null;
		end if;
	end process;
end arch;