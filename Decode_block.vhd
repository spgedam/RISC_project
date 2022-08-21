library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decode_block is
port( opcode : in std_logic_vector( 3 downto 0);
      cond : in std_logic_vector( 1 downto 0);
      dest_sel_out : out std_logic_vector(1 downto 0);
      valid_Ra_out, valid_Rb_out : out std_logic;
      -----------RR-------------------------------
      lsma : out std_logic;
      RF_wr_ena_out : out std_logic;
      se : out std_logic_vector(1 downto 0);
      -----------Ex-------------------------------
      sel_d1_d2_out , ls_out , sel_ls_imm_out , sel_plus1_out , C_mod_out , Z_mod_out , sel_PC : out std_logic;
      jmp : out std_logic_vector(1 downto 0);
      beq : out std_logic;
      op_out : out std_logic_vector(2 downto 0);
      -----------Mem------------------------------
      DM_wr_ena_out : out std_logic;
      -----------WB-------------------------------
      IMM_0_ena_out, Z_mod_wb : out std_logic;
      WB_mux_out : out std_logic_vector(1 downto 0)
      );
end Decode_block;

architecture Dec_arch of Decode_block is
begin
	process(opcode,cond) 
	begin
		dest_sel_out <= "11";
      		valid_Ra_out <= '1';
      		valid_Rb_out <= '1';
      		RF_wr_ena_out <= '1';
      		se <= "00";
      		sel_d1_d2_out <= '0';
      		ls_out <= '0';
      		sel_ls_imm_out <= '0';
      		sel_plus1_out <= '0';
      		sel_PC <= '0';
      		jmp <= "00";
      		beq <= '0';
      		C_mod_out <= '0';
      		Z_mod_out <= '0';
      		op_out <= "000";
      		DM_wr_ena_out <= '0';
      		IMM_0_ena_out <= '0';
      		WB_mux_out <= "01";
      		lsma <= '0';
      		
		case opcode is
			when "0001" =>
				if(cond = "00") then
					dest_sel_out <= "00";
				elsif( cond = "10") then
					dest_sel_out <= "00";
					op_out <= "001";
				elsif( cond = "01") then
					dest_sel_out <= "00";
					op_out <= "010";
				else
					ls_out <= '1';
					dest_sel_out <= "00";
				end if;
				C_mod_out <= '1';
				Z_mod_out <= '1';
			when "0000" =>
				dest_sel_out <= "01";
				valid_Rb_out <= '0';
				sel_ls_imm_out <= '1';
				se <= "01";
				C_mod_out <= '1';
				Z_mod_out <= '1';
			when "0010" =>
				dest_sel_out <= "00";
				Z_mod_out <= '1';
				if( cond = "00") then
					op_out <= "011";
				elsif( cond = "10") then
					op_out <= "100";
				elsif( cond = "01") then
					op_out <= "101";
				end if;
			when "0011" =>
				dest_sel_out <= "10";
				valid_Ra_out <= '0';
      				valid_Rb_out <= '0';
      				WB_mux_out <= "00";
      				se <= "10";
      			when "0100" =>
      				dest_sel_out <= "10";
      				valid_Ra_out <= '0';
      				sel_d1_d2_out <= '1';
				sel_ls_imm_out <= '1';
				sel_plus1_out <= '1';
				se <= "01";
				WB_mux_out <= "10";
			when "0101" =>
				RF_wr_ena_out <= '0';
				sel_d1_d2_out <= '1';
				sel_plus1_out <= '1';
				DM_wr_ena_out <= '1';
			when "1100" =>
				valid_Rb_out <= '0';
				sel_plus1_out <= '1';
				WB_mux_out <= "10";
				lsma <= '1';
			when "1101" =>
				RF_wr_ena_out <= '0';
				sel_plus1_out <= '1';
				DM_wr_ena_out <= '1';
				WB_mux_out <= "10";
				lsma <= '1';
			when "1110" =>
				valid_Rb_out <= '0';
				sel_plus1_out <= '1';
				WB_mux_out <= "10";
				lsma <= '1';
			when "1111" =>
				RF_wr_ena_out <= '0';
				sel_plus1_out <= '1';
				DM_wr_ena_out <= '1';
				WB_mux_out <= "10";
				lsma <= '1';
			when "1000" =>
				RF_wr_ena_out <= '0';
				op_out <= "110";
				se <= "01";
				beq <= '1';
			when "1001" =>
				dest_sel_out <= "10";
				valid_Ra_out <= '0';
				valid_Rb_out <= '0';
				sel_ls_imm_out <= '1';
				sel_PC <= '1';
				WB_mux_out <= "11";
				se <= "10";
				jmp <= "11";
			when "1010" =>
				valid_Ra_out <= '0';
				sel_PC <= '1';
				WB_mux_out <= "11";
				jmp <= "10";
			when "1011" =>
				valid_Rb_out <= '0';
				RF_wr_ena_out <= '0';
				sel_ls_imm_out <= '1';
				se <= "10";
				jmp <= "11";
			when others =>
				RF_wr_ena_out <= '0';
		end case;
	end process;
end Dec_arch;