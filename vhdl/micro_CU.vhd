LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std. all;

ENTITY micro_CU IS
	PORT(IN_STATUS: IN STD_LOGIC;
				CLOCK, RESET_N: IN STD_LOGIC;
			CONTROL_SIGNAL: OUT STD_LOGIC_VECTOR(34 DOWNTO 0));
END ENTITY;

ARCHITECTURE control OF micro_CU IS

SIGNAL address, next_address: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL lsb_out, lsb_in, cc, cc_validation, in0_mux_jump, sel_mux_add: STD_LOGIC;
SIGNAL out_mem_odd, out_mem_even, out_mux_mem: STD_LOGIC_VECTOR(40 DOWNTO 0);
SIGNAL out_micro_instr: STD_LOGIC_VECTOR(40 DOWNTO 0);

COMPONENT micro_ROM_even IS
		PORT(ADDRESS: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				DATA_OUT_EVEN: OUT STD_LOGIC_VECTOR (40 DOWNTO 0));
END COMPONENT;

COMPONENT micro_ROM_odd IS
		PORT(ADDRESS: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
				DATA_OUT_ODD: OUT STD_LOGIC_VECTOR (40 DOWNTO 0));
END COMPONENT;

COMPONENT mux_2to1_41b IS
	PORT(in0, in1: IN STD_LOGIC_VECTOR(40 DOWNTO 0);
			sel: IN STD_LOGIC;
			output: OUT STD_LOGIC_VECTOR(40 DOWNTO 0));
END COMPONENT;

COMPONENT mux_2to_1b IS
	PORT (in0, in1, sel: IN STD_LOGIC;
			output: OUT STD_LOGIC);
END COMPONENT;

COMPONENT Status_PLA IS
	PORT(Status, CC, LSB_in: IN STD_LOGIC;
		  CC_Validation, LSB_out: OUT STD_LOGIC);
END COMPONENT;

COMPONENT reg_nbit_Rom IS
GENERIC ( N : integer);
PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
Clock, Resetn,load : IN STD_LOGIC;
Q : buffer STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END COMPONENT;

COMPONENT reg_nbit_rom_falling_edge IS
GENERIC ( N : integer);
PORT (R : IN STD_logic_vector(N-1 DOWNTO 0);
Clock, Resetn,load : IN STD_LOGIC;
Q : buffer STD_logic_vector(N-1 DOWNTO 0));
END COMPONENT;

BEGIN

--segnali di ingresso e uscita dalla Status PLA
PLA: Status_PLA
PORT MAP(Status => IN_STATUS, CC => cc, LSB_in => lsb_in, LSB_OUT => lsb_out,  CC_Validation => cc_validation);

micro_ADD_REG: reg_nbit_Rom_falling_edge
GENERIC MAP (5)
PORT MAP(R(4 DOWNTO 1) => next_address , R(0) => lsb_out, clock => CLOCK, Resetn => RESET_N, load => '1', Q(4 DOWNTO 1) => address, Q(0) => in0_mux_jump);

--segnali in ingresso e uscita dal uinstruction register
micro_instruction_reg: reg_nbit_Rom
GENERIC MAP (41)
PORT MAP(R => out_mux_mem, clock => CLOCK, Resetn => RESET_N, load => '1', Q => out_micro_instr);

cc <= out_micro_instr(40);
next_address <= out_micro_instr(39 DOWNTO 36);
lsb_in <= out_micro_instr(35);
CONTROL_SIGNAL <= out_micro_instr(34 DOWNTO 0);

MUX_JUMP: mux_2to_1b
PORT MAP (in0 => in0_mux_jump, in1 => lsb_out, sel => cc_validation, output => sel_mux_add);

MUX_ADD: mux_2to1_41b
PORT MAP (in0 => out_mem_even, in1 => out_mem_odd, sel => sel_mux_add, output => out_mux_mem);

ROM_even: micro_ROM_even
PORT MAP(ADDRESS => address, DATA_OUT_EVEN => out_mem_even);

ROM_odd: micro_ROM_odd
PORT MAP(ADDRESS => address, DATA_OUT_ODD => out_mem_odd);

END ARCHITECTURE;
