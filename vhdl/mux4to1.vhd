LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mux4to1 IS
generic( N : integer);
PORT( s: IN unsigned(1 downto 0);
      x : IN Signed(N-1 DOWNTO 0);
		y : IN Signed (N-1 DOWNTO 0);
		w : IN Signed(N-1 DOWNTO 0);
		z : IN Signed (N-1 DOWNTO 0);
		m : OUT Signed(N-1 DOWNTO 0));
END mux4to1;

ARCHITECTURE Behavior OF mux4to1 IS
BEGIN
with s select
m<= x when "00",
    y when "01",
	 w when "11",
	 z when others;

END Behavior;