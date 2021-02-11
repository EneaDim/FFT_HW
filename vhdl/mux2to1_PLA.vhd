LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mux2to1_PLA IS
PORT( s: IN STD_LOGIC;
      x : IN STD_LOGIC;
		y : IN STD_LOGIC;
		m : OUT STD_LOGIC);
END mux2to1_PLA;

ARCHITECTURE Behavior OF mux2to1_PLA IS
BEGIN
with s select
m<= x when '0',
    y when others;

END Behavior;