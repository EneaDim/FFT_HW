LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std. all;

ENTITY mux_2to_1b IS
	PORT (in0, in1, sel: IN STD_LOGIC;
			output: OUT STD_LOGIC);
			END ENTITY;
			
ARCHITECTURE behaviour OF mux_2to_1b IS

BEGIN
output <= in0 WHEN sel = '0' ELSE
			 in1 WHEN sel = '1' ELSE
			 in0;
END ARCHITECTURE;
