LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std. all;

ENTITY mux_2to1_41b IS
	PORT(in0, in1: IN STD_LOGIC_VECTOR(40 DOWNTO 0);
			sel: IN STD_LOGIC;
			output: OUT STD_LOGIC_VECTOR(40 DOWNTO 0));
END ENTITY;

ARCHITECTURE selection OF mux_2to1_41b IS

BEGIN
output <= in0 WHEN sel = '0' ELSE
			 in1 WHEN sel = '1'ELSE
			 in0;
END ARCHITECTURE;