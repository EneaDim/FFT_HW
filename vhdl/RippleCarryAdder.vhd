LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RippleCarryAdder IS
		GENERIC(N: INTEGER);
		PORT (A, B: IN SIGNED (N-1 DOWNTO 0);
				c_in: IN STD_LOGIC; 
				c_out: OUT STD_LOGIC;
				SUM: OUT SIGNED (N-1 DOWNTO 0));
END ENTITY;

ARCHITECTURE behave OF RippleCarryAdder IS

SIGNAL int_carry_out: STD_LOGIC_VECTOR (N-2 DOWNTO 0); --this vector contains all carry out from each full adder, incluse the last one 
												 --at the end of the chain

COMPONENT FullAdder IS
		PORT(A, B: IN STD_LOGIC;
			  c_in: IN STD_LOGIC;
			  c_out, sum: OUT STD_LOGIC);
END COMPONENT;

BEGIN

FA0: FullAdder
PORT MAP (A => A(0), B => B(0), c_in => c_in, sum => SUM (0), c_out => int_carry_out(0));

internal_adder: FOR i IN 1 TO N-2 GENERATE
INT_FA: FullAdder
PORT MAP (A => A(i), B => B(i), c_in => int_carry_out (i-1), sum => SUM(i), c_out => int_carry_out(i));
END GENERATE;

FAN: FullAdder
PORT MAP (A => A(N-1), B => B(N-1), c_in => int_carry_out(N-2), sum => SUM (N-1), c_out => c_out);

END ARCHITECTURE;


