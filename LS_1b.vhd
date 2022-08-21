library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LS_1b is
port ( din : in std_logic_vector(15 downto 0);
       ls : in std_logic;
       dout : out std_logic_vector(15 downto 0));
end LS_1b;

architecture LS_arch of LS_1b is
begin
	dout <= din when ls = '1' else din(14 downto 0) & '0';
end LS_arch; 