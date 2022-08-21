library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forward_CZ is 
port( C_mod_rr, C_mod_exe, C_mod_mem, C_mod_wb : in std_logic;
      Z_mod_rr, Z_mod_exe, Z_mod_mem, Z_mod_wb : in std_logic;
      for_rr_c, for_rr_z : out std_logic_vector(1 downto 0)
);
end entity;

architecture arch of forward_CZ is
begin
	for_rr_c <= "01" when ( C_mod_rr = '1' and C_mod_exe = '1') else
		    "10" when ( C_mod_rr = '1' and C_mod_mem = '1') else
		    "11" when ( C_mod_rr = '1' and C_mod_wb = '1') else
		    "00";
	
	for_rr_z <= "01" when ( Z_mod_rr = '1' and Z_mod_exe = '1') else
		    "10" when ( Z_mod_rr = '1' and Z_mod_mem = '1') else
		    "11" when ( Z_mod_rr = '1' and Z_mod_wb = '1') else
		    "00";
end arch; 