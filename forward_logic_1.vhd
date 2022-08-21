library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forward_logic_1 is
port( opd : in std_logic_vector(3 downto 0);----------------------------------------- from stall_NOP
      cond : in std_logic_vector(1 downto 0);
      valid_rr_1, valid_rr_2, valid_exe_1, valid_exe_2 : in std_logic;
      dest_exe, dest_mem, dest_wb : in std_logic_vector(2 downto 0);
      src_rr_1, src_rr_2 : in std_logic_vector(2 downto 0);
      src_exe_1, src_exe_2 : in std_logic_vector(2 downto 0);
      c_mod_exe, c_mod_mem, c_mod_wb : in std_logic;
      z_mod_exe, z_mod_mem, z_mod_wb : in std_logic;
      rr_mux1, rr_mux2, rr_c, rr_z : out std_logic_vector(1 downto 0);
      exe_mux1, exe_mux2 : out std_logic
      );
end forward_logic_1;

architecture FR_arch of forward_logic_1 is

signal cond_rr1, cond_rr2, cond_exe1, cond_exe2 : std_logic; 
begin
	---------------------------------carry forward----------------------------------------------
	process(valid_rr_1, valid_rr_2, dest_exe, dest_mem, dest_wb, src_rr_1, src_rr_2,src_exe_1,
		c_mod_exe, c_mod_mem, c_mod_wb, z_mod_exe, z_mod_mem, z_mod_wb , src_exe_2, opd, cond) 
      	begin
		if((opd = "0001" or opd = "0010") and cond = "10") then
			if(c_mod_exe = '1') then
				rr_c <= "01";
			elsif(c_mod_mem = '1') then
				rr_c <= "10";
			elsif(c_mod_wb = '1') then
				rr_c <= "11";
			else
				rr_c <= "00";
			end if;
		else
			rr_c <= "00";
		end if;
	end process;
	--------------------------------zero forward-------------------------------------------------
	process(valid_rr_1, valid_rr_2, dest_exe, dest_mem, dest_wb, src_rr_1, src_rr_2,src_exe_1,
		c_mod_exe, c_mod_mem, c_mod_wb, z_mod_exe, z_mod_mem, z_mod_wb,  src_exe_2, opd, cond) 
      	begin
		if((opd = "0001" or opd = "0010") and cond = "01") then
			if(z_mod_exe = '1') then
				rr_z <= "01";
			elsif(z_mod_mem = '1') then
				rr_z <= "10";
			elsif(z_mod_wb = '1') then
				rr_z <= "11";
			else
				rr_z <= "00";
			end if;
		else
			rr_z <= "00";
		end if;
	end process;
	--------------------------------------Forward RR----------------------------------------------
--	process(valid_rr_1, valid_rr_2, dest_exe, dest_mem, dest_wb, src_rr_1, src_rr_2,src_exe_1,
--		c_mod_exe, c_mod_mem, c_mod_wb, z_mod_exe, z_mod_mem, z_mod_wb , src_exe_2, opd, cond) 
--      	begin
--      		if(valid_rr_1 ='1' and (src_rr_1 /= "000" or src_rr_1 /= "111")) then
--			-------------------
--				----------------------
--					---------------------------Draw diagrams and proceed for forwarding logic
--			if(dest_exe = src_rr_1) then
--				rr_mux1 <= "01";
--			elsif(dest_mem = src_rr_1) then
--				rr_mux1 <= "10";
--			elsif(dest_wb = src_rr_1) then
--				rr_mux1 <= "11";
--			else
--				rr_mux1 <= "00";
--			end if;
--		else
--			rr_mux1 <= "00";
--		end if;
--	end process;
	
	cond_rr1 <= '1' when (valid_rr_1 ='1' and (src_rr_1 /= "000" or src_rr_1 /= "111")) else
		    '0';
		    
	rr_mux1 <= "01" when (cond_rr1='1' and (dest_exe = src_rr_1)) else
		   "10" when (cond_rr1='1' and (dest_mem = src_rr_1)) else
		   "11" when (cond_rr1='1' and (dest_wb = src_rr_1)) else
		   "00";
		   
		
--	process(valid_rr_1, valid_rr_2, dest_exe, dest_mem, dest_wb, src_rr_1, src_rr_2,src_exe_1,
--		c_mod_exe, c_mod_mem, c_mod_wb, z_mod_exe, z_mod_mem, z_mod_wb , src_exe_2, opd, cond) 
--      	begin
--		if(valid_rr_2 ='1' and (src_rr_2 /= "000" or src_rr_2 /= "111")) then
--			-------------------
--				----------------------
--					---------------------------Draw diagrams and proceed for forwarding logic
--			if(dest_exe = src_rr_2) then
--				rr_mux2 <= "01";
--			elsif(dest_mem = src_rr_2) then
--				rr_mux2 <= "10";
--			elsif(dest_wb = src_rr_2) then
--				rr_mux2 <= "11";
--			else
--				rr_mux2 <= "00";
--			end if;
--		else
--			rr_mux2 <= "00";
--		end if;
--	end process;
	
	cond_rr2 <= '1' when (valid_rr_2 ='1' and (src_rr_2 /= "000" or src_rr_2 /= "111")) else
		    '0';
		    
	rr_mux2 <= "01" when (cond_rr2='1' and (dest_exe = src_rr_2)) else
		   "10" when (cond_rr2='1' and (dest_mem = src_rr_2)) else
		   "11" when (cond_rr2='1' and (dest_wb = src_rr_2)) else
		   "00";
	-------------------------------------------end forward RR---------------------------------------------
	
	-------------------------------------------Forward EXE------------------------------------------------
--	process(valid_rr_1, valid_rr_2, dest_exe, dest_mem, dest_wb, src_rr_1, src_rr_2,src_exe_1,
--		c_mod_exe, c_mod_mem, c_mod_wb, z_mod_exe, z_mod_mem, z_mod_wb , src_exe_2, opd, cond) 
--      	begin
--      		if(valid_exe_1 ='1' and (src_exe_1 /= "000" or src_exe_1 /= "111")) then
--			-------------------
--				----------------------
--					---------------------------Draw diagrams and proceed for forwarding logic
--			if(dest_mem = src_exe_1) then
--				exe_mux1 <= '1';
--			else
--				exe_mux1 <= '0';
--			end if;
--		else
--			exe_mux1 <= '0';
--		end if;
--	end process;
	
	cond_exe1 <= '1' when (valid_exe_1 ='1' and (src_exe_1 /= "000" or src_exe_1 /= "111")) else
		    '0';
	
	exe_mux1 <= '1' when (cond_exe1='1' and (dest_mem = src_exe_1)) else
		    '0';    
	
	
--	process(valid_rr_1, valid_rr_2, dest_exe, dest_mem, dest_wb, src_rr_1, src_rr_2,src_exe_1,
--		c_mod_exe, c_mod_mem, c_mod_wb, z_mod_exe, z_mod_mem, z_mod_wb , src_exe_2, opd, cond) 
--      	begin
--      		if(valid_exe_2 ='1' and (src_exe_2 /= "000" or src_exe_2 /= "111")) then
--			-------------------
--				----------------------
--					---------------------------Draw diagrams and proceed for forwarding logic
--			if(dest_mem = src_exe_2) then
--				exe_mux2 <= '1';
--			else
--				exe_mux2 <= '0';
--			end if;
--		else
--			exe_mux2 <= '0';
--		end if;
--	end process;
	
	cond_exe2 <= '1' when (valid_exe_2 ='1' and (src_exe_2 /= "000" or src_exe_2 /= "111")) else
		    '0';
	
	exe_mux2 <= '1' when (cond_exe2='1' and (dest_mem = src_exe_2)) else
		    '0'; 
end FR_arch;