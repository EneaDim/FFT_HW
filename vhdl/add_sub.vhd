Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity add_sub Is
GENERIC ( N : integer);
Port( X: IN signed(N-1 downto 0);
      Y: IN signed(N-1 downto 0);
      Cin: IN std_logic;
		Clock: IN STD_LOGIC;
		result: OUT SIGNED(N-1 downto 0));
End add_sub;

Architecture behavior of add_sub is
begin
PROCESS(Clock)
BEGIN
IF (Clock = '1' AND 	Clock' EVENT) THEN
result<= X+Y;
END IF;
END PROCESS;

end behavior;