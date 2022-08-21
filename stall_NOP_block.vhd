library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stall_NOP_block is
port( clk : in std_logic;
      opcode : in std_logic_vector(3 downto 0);
      cond : in std_logic_vector(1 downto 0);
      ra_rr, ra_dec, rb_dec : in std_logic_vector(2 downto 0);
      v1_id, v2_id : in std_logic;
--    alu_a, alu_b : in std_logic; ----------------------tells whether the operand in any instruction passses through ALU or not
      imm8 : in std_logic_vector(7 downto 0);
      opcode_delay : out std_logic_vector(3 downto 0);
      cond_delay : out std_logic_vector(1 downto 0);
      imm8_delay : out std_logic_vector(7 downto 0); 
      inv : in std_logic;
      stall_NOP : out std_logic;
      dis_p1,dis_p2,dis_p3,dis_p4,dis_p5, dis_pc : out std_logic
);
end stall_NOP_block;

architecture arch of stall_NOP_block is
signal opc_delay : std_logic_vector(3 downto 0);
--signal cond_d : std_logic_vector(1 downto 0);
signal stall_z_exe_mem : std_logic;
signal alu_a, alu_b : std_logic;
signal flag : std_logic :='1';
begin
	process(clk, opcode, v1_id, v2_id, ra_rr, ra_dec, rb_dec, imm8, inv,cond) begin
		if(rising_edge(clk) and flag = '1') then
			opc_delay <= opcode;----------------like RR
			cond_delay <= cond;
			imm8_delay <=imm8;
		end if;
	end process;
	
	stall_z_exe_mem <= '1' when (opc_delay = "0100" and ((opcode = "0001" or opcode = "0010") and cond = "01")) else
			   '0';
	
	opcode_delay <= opc_delay;
	
	
	with opcode select
	alu_a <= '1' when "0000"|"0001"|"0010"|"1000"|"1011",
		 '0' when others;
	
	with opcode select
	alu_b <= '1' when "0001"|"0010"|"0100"|"0101",
		 '0' when others;
	
	process(clk, opcode, v1_id, v2_id) -------------------sensitivity list needs to be changed
	begin
		if(stall_z_exe_mem = '1') then
			stall_NOP <= '1';
			flag <= '1';
			dis_p1 <= '0';
			dis_p2 <= '0';
			dis_pc <= '0';	
		elsif(opc_delay = "0100" and opcode(3 downto 2) = "11") then
			if(opcode(1) = '0') then
				if(imm8 = "00000000") then 
					stall_NOP <= '1'; --------------------------------------this will control the mux for DM and RW write enable
				else
					stall_NOP <= '0'; --------------------------------------this will control the mux for DM and RW write enable
				end if;
			else
				stall_NOP <= '0'; --------------------------------------this will control the mux for DM and RW write enable
			end if;
			flag <= '1';
			dis_p1 <= '0';
			dis_p2 <= '0';
			dis_pc <= '0';	
		elsif(opc_delay = "0100") then --- lw
			if((v1_id='1' and ra_rr = ra_dec and alu_a = '1') or (v2_id='1' and ra_rr = rb_dec and alu_b = '1')) then 
				stall_NOP <= '1'; --------------------------------------this will control the mux for DM and RW write enable
			else
				stall_NOP <= '0'; --------------------------------------this will control the mux for DM and RW write enable
			end if;
			flag <= '1';
			dis_p1 <= '0';
			dis_p2 <= '0';
			dis_pc <= '0';
		elsif(opc_delay(3 downto 2) = "11") then ------implies that lsma is currently in RR
			if(opc_delay(1) = '0') then
				if(imm8 = "00000000") then 
					flag <= '1';
					stall_NOP <= '1'; --------------------------------------this will control the mux for DM and RW write enable
					dis_p1 <= '0';
					dis_p2 <= '0';
					dis_pc <= '0';
				elsif(inv = '1') then
					flag <= '1';
					stall_NOP <= '0'; --------------------------------------this will control the mux for DM and RW write enable
					dis_p1 <= '0';
					dis_p2 <= '0';
					dis_pc <= '0';
				else
					flag <= '0';
					stall_NOP <= '0'; --------------------------------------this will control the mux for DM and RW write enable
					dis_p1 <= '1';
					dis_p2 <= '1';
					dis_pc <= '1';
				end if;
			else
				flag <= inv;
				stall_NOP <= '0'; --------------------------------------this will control the mux for DM and RW write enable
				dis_p1 <= '1';
				dis_p2 <= '1';
				dis_pc <= '1';
			end if;
		else
			flag <= '1';
			stall_NOP <= '0'; --------------------------------------this will control the mux for DM and RW write enable
			dis_p1 <= '0';
			dis_p2 <= '0';
			dis_pc <= '0';
		end if;	
	end process;
	dis_p3 <= '0';
	dis_p4 <= '0';
	dis_p5 <= '0';
end arch;