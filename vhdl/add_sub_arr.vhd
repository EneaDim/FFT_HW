Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity add_sub_arr Is
GENERIC ( N : integer);
Port( X: IN signed(N-1 downto 0);
      Y: IN signed(N-1 downto 0);
      Cin: IN std_logic;
		result: OUT SIGNED(N-1 downto 0));
End add_sub_arr;

Architecture behavior of add_sub_arr is
begin
result<= X+Y;

end behavior;