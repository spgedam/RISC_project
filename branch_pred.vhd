library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_pred is 
port(PC_if, PC_exe, PC_ALU : in std_logic_vector(15 downto 0);
     beq, eq : in std_logic; ---------------both are from EXE stage
     HB : out std_logic;-------------------------------------History bit
     beq_flush, mispred : out std_logic;-------to be required when misprediction happens
     btb_hit : out std_logic;
     PC_out : out std_logic_vector(15 downto 0)
);
end branch_pred;

architecture arch of branch_pred is
type BTB_line is array(0 to 63) of std_logic_vector(26 downto 0);
signal BTB: BTB_line := (others => (others =>'0'));
begin
	-----------------------Reading through BTB-------------------------
	PC_out <= BTB(to_integer(unsigned(PC_if(5 downto 0))))(16 downto 1);
	HB <= BTB(to_integer(unsigned(PC_if(5 downto 0))))(0);
	-------------------------------------------------------------------
	-----------------------Histroy bit modification--------------------
--	process(PC_if, PC_exe, PC_ALU, beq, eq) 
--	variable hb_temp : std_logic := '0';
--	begin
--		hb_temp := BTB(to_integer(unsigned(PC_if(5 downto 0))))(0);
--		if( beq = '1') then---------------------------beq from EXE stage
--			if( eq = '1') then
--				if(hb_temp = '0') then
--					BTB(to_integer(unsigned(PC_if(5 downto 0))))(0) <= '1';
--				end if;
--			else
--				if(hb_temp = '1') then
--					BTB(to_integer(unsigned(PC_if(5 downto 0))))(0) <= '0';
--				end if;
--			end if;
--		end if;
--	end process;
--	-------------------------------------------------------------------
	----------------------Logic to update BTB with PC not present in BTB----
--	process(PC_if, PC_exe, PC_ALU, beq, eq) 
--	variable pc_target : std_logic_vector(15 downto 0);
--	variable pc_tag : std_logic_vector(9 downto 0);
--	variable hb_temp : std_logic := '0';
--	begin
--		pc_target := BTB(to_integer(unsigned(PC_exe(5 downto 0))))(16 downto 1);
--		pc_tag := BTB(to_integer(unsigned(PC_exe(5 downto 0))))(26 downto 17);
--		hb_temp := BTB(to_integer(unsigned(PC_if(5 downto 0))))(0);
--		if(beq = '1') then 
--			if(pc_tag /= PC_exe(15 downto 6)) then
--				BTB(to_integer(unsigned(PC_exe(5 downto 0)))) <= PC_exe(15 downto 6) & PC_ALU & eq;
--			elsif(pc_target /= PC_ALU) then
--				BTB(to_integer(unsigned(PC_exe(5 downto 0))))(16 downto 0) <= PC_ALU & eq;
--			elsif( eq = '1') then
--				if(hb_temp = '0') then
--					BTB(to_integer(unsigned(PC_exe(5 downto 0))))(0) <= '1';
--				end if;
--			else
--				if(hb_temp = '1') then
--					BTB(to_integer(unsigned(PC_exe(5 downto 0))))(0) <= '0';
--				end if;
--			end if;
--		end if;		
--	end process;		
	
--	BTB(to_integer(unsigned(PC_exe(5 downto 0))))(26 downto 1) <= (PC_exe(15 downto 6) & PC_ALU) when (beq = '1' and 
--		 				 			((BTB(to_integer(unsigned(PC_exe(5 downto 0))))(26 downto 17) /= PC_exe(15 downto 6))
--		 				 			or (BTB(to_integer(unsigned(PC_exe(5 downto 0))))(16 downto 1) /= PC_ALU))) else
--		 				 		      BTB(to_integer(unsigned(PC_exe(5 downto 0))))(26 downto 1);
	process( PC_if, PC_exe, PC_ALU, beq, eq)
	variable pc_target : std_logic_vector(15 downto 0); 
	variable pc_tag : std_logic_vector(9 downto 0);
	begin
		pc_target := BTB(to_integer(unsigned(PC_exe(5 downto 0))))(16 downto 1);
		pc_tag := BTB(to_integer(unsigned(PC_exe(5 downto 0))))(26 downto 17);
		if( beq = '1' and (pc_tag /= PC_exe(15 downto 6) or pc_target /= PC_ALU)) then
			BTB(to_integer(unsigned(PC_exe(5 downto 0))))(26 downto 1) <= (PC_exe(15 downto 6) & PC_ALU);
		end if;
	end process;
		
		
		
--	BTB(to_integer(unsigned(PC_exe(5 downto 0))))(0) <= '1' when (eq = '1' and BTB(to_integer(unsigned(PC_if(5 downto 0))))(0) ='0') else --Misprediction
--							    '1' when (eq = '1' and BTB(to_integer(unsigned(PC_if(5 downto 0))))(0) ='1') else
--							    '0' when (eq = '0' and BTB(to_integer(unsigned(PC_if(5 downto 0))))(0) ='1') else --Misprediction
--							    '0';
--							    
	process( PC_if, PC_exe, PC_ALU, beq, eq)
	variable pred : std_logic;
	begin
		pred := BTB(to_integer(unsigned(PC_if(5 downto 0))))(0);
		if((eq = '1' and pred = '0') or (eq = '1' and pred = '0')) then
			BTB(to_integer(unsigned(PC_exe(5 downto 0))))(0) <= not(pred);
		end if;
	end process;
		
	
	beq_flush <= '1' when (eq = '1' and BTB(to_integer(unsigned(PC_if(5 downto 0))))(0) ='0') else --Misprediction PC = PC_ALU
		     '0' when(eq = '1' and BTB(to_integer(unsigned(PC_if(5 downto 0))))(0) ='1') else
		     '1' when (eq = '0' and BTB(to_integer(unsigned(PC_if(5 downto 0))))(0) ='1') else --Misprediction PC = PC + 1
		     '0';	
		     
	mispred <= '1' when (eq = '1' and BTB(to_integer(unsigned(PC_if(5 downto 0))))(0) ='0') else --Misprediction PC = PC_ALU
		   '0' when (eq = '0' and BTB(to_integer(unsigned(PC_if(5 downto 0))))(0) ='1') else --Misprediction PC = PC + 1
		   '0';--------------------------------Here it doesn't matter
		   
	btb_hit <= '1' when (BTB(to_integer(unsigned(PC_exe(5 downto 0))))(26 downto 17) = PC_exe(15 downto 6)) else
		   '0';
end arch;