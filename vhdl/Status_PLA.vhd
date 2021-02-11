LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std. all;

ENTITY Status_PLA IS
	PORT(Status, CC, LSB_in: IN STD_LOGIC;
		  CC_Validation, LSB_out: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behaviour OF Status_PLA IS

BEGIN
LSB_OUT<= NOT(lsb_IN) AND (NOT(CC) OR Status);
CC_Validation<= Status AND CC;


END ARCHITECTURE;


	
	