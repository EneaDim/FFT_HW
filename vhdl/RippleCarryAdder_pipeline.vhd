LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RippleCarryAdder_pipeline IS
		GENERIC(M: INTEGER);
		PORT (A, B: IN SIGNED (M-1 DOWNTO 0);
				c_in: IN STD_LOGIC; 
				clk: IN STD_LOGIC;
				SUM: OUT SIGNED (M-1 DOWNTO 0);
				c_out: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE sum_pipe OF RippleCarryAdder_pipeline IS

COMPONENT RippleCarryAdder IS
		GENERIC(N: INTEGER );
		PORT (A, B: IN SIGNED (N-1 DOWNTO 0);
				c_in: IN STD_LOGIC; 
				c_out: OUT STD_LOGIC;
				SUM: OUT SIGNED (N-1 DOWNTO 0));
END COMPONENT;

SIGNAL out_add: SIGNED (M-1 DOWNTO 0);

BEGIN
PROCESS(Clk)
BEGIN
IF(Clk= '1' AND Clk'EVENT)THEN
SUM <= out_add;
END IF;
END PROCESS;

Add_pipe: RippleCarryAdder
GENERIC MAP (N => M)
PORT MAP(A => A, B => B, c_in => c_in, c_out => c_out, SUM => out_add );

END ARCHITECTURE;