LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mux2to1 IS
generic( N : integer);
PORT( s: IN STD_LOGIC;
      x : IN Signed (N-1 DOWNTO 0);
		y : IN Signed (N-1 DOWNTO 0);
		m : OUT Signed (N-1 DOWNTO 0));
END mux2to1;

ARCHITECTURE Behavior OF mux2to1 IS
BEGIN
with s select
m<= x when '0',
    y when others;

END Behavior;