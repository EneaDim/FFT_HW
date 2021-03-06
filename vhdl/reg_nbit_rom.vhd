LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY reg_nbit_rom IS
GENERIC ( N : integer);
PORT (R : IN STD_logic_vector(N-1 DOWNTO 0);
Clock, Resetn,load : IN STD_LOGIC;
Q : buffer STD_logic_vector(N-1 DOWNTO 0));
END reg_nbit_rom;

ARCHITECTURE Behavior OF reg_nbit_rom IS
BEGIN
PROCESS (Clock, Resetn)

BEGIN
IF (Resetn = '0') THEN
	Q <= (OTHERS => '0');
ELSE IF (Clock'EVENT AND Clock = '1') THEN
	IF load='1' then
	Q <= R;
	else Q<=Q;
	end if;
end if;

END IF;
END PROCESS;

END Behavior;