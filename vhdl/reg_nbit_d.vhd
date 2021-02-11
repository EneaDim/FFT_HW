LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY reg_nbit_d IS
GENERIC ( N : integer);
PORT (R : IN SIGNED(N-1 DOWNTO 0);
Clock, Resetn,load : IN STD_LOGIC;
Q : buffer SIGNED(N-1 DOWNTO 0));
END reg_nbit_d;

ARCHITECTURE Behavior OF reg_nbit_d IS
BEGIN
PROCESS (Clock, Resetn)

BEGIN
IF (Resetn = '0') THEN
	Q <= (OTHERS => '0');
ELSIF (Clock'EVENT AND Clock = '1') THEN
	IF load='1' then
		Q <= R;
	else 
		Q <= Q;
	end if;
END IF;
END PROCESS;

END Behavior;
