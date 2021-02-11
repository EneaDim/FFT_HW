library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_mult is
port 
   (
      a : in signed (15 downto 0);
      b : in signed (15 downto 0);
		Clock : IN STD_LOGIC;
      result : out signed (30 downto 0)
   );

end entity;

architecture rtl of signed_mult is
begin
PROCESS(Clock) 
BEGIN
   IF(Clock=  '1' AND Clock' EVENT ) THEN
	result <= to_signed(to_integer(a)*to_integer(b), 2*16-1);
	END IF;
END PROCESS;
end rtl;