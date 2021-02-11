LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY FullAdder IS
		PORT(A, B: IN STD_LOGIC;
			  c_in: IN STD_LOGIC;
			  c_out, sum: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behave OF FullAdder IS

SIGNAL P, G: STD_LOGIC;

BEGIN

P <= A AND B;
G <= (A XOR B) AND c_in;
c_out <= P OR G;
sum <= A XOR B XOR c_in;

END ARCHITECTURE;