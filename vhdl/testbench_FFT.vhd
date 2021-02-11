LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY testbench_FFT IS
END ENTITY;

ARCHITECTURE test OF testbench_FFT IS

COMPONENT Butterfly is
Port(
     B,W,A: in signed(15 downto 0);
	  Clk,Start,Rst: in Std_logic;
	  A_I_finale,B_I_finale,A_R_finale,B_R_finale: out signed(15 downto 0);--A_continua e B_continua sono i risultati di A e B se si lavora in continua
	  Done:out std_logic);
end COMPONENT;

signal B, W,A: signed(15 downto 0);
signal Clk,Start,Rst: Std_logic;
signal A_R_finale,B_R_finale,A_I_finale,B_I_finale: signed(15 downto 0);--A_continua e B_continua sono i risultati di A e B se si lavora in continua
signal Done: std_logic;
signal Br_int, Bi_int, Wr_int, Wi_int, Ar_int, Ai_int, A_R_finale_int ,B_R_finale_int ,A_I_finale_int ,B_I_finale_int: INTEGER;
begin

clk_p: process
begin
for i in 0 to 100 loop
clk <= '1'; wait for 25 ns;
clk <= '0'; wait for 25 ns;
end loop;
end process;

reset_p: process
begin
Rst <='0'; wait for 204 ns;
Rst <= '1'; wait for 100 ns;
Rst<= '0'; wait for 100 ns;
Rst <= '1'; wait;
end process;

Start_p: process
begin
start <= '0';wait for 510 ns;
start <='1'; wait for 50 ns;
start <= '0'; wait;
end process;


data_p: process
begin
B <=  "1000000000000000";
W <=  "0100000000000000"; 
A <=  "0000000000000000";wait for 620 ns;--parti reali
W <=  "1000000000010000"; 
B <=  "0000000000000000";
A <=  "1110001111100000";wait for 50 ns; --parti immaginarie 

end process;

Br_int <= to_integer(B);
Ar_int <=  to_integer(A);
Wr_int <= to_integer(W);
Bi_int <= to_integer(B);
Ai_int <=  to_integer(A);
Wi_int <= to_integer(W);
B_R_finale_int <= to_integer(B_R_finale);
A_R_finale_int <=  to_integer(A_R_finale);
B_I_finale_int <= to_integer(B_I_finale);
A_I_finale_int <= to_integer(A_I_finale);

DUT: Butterfly
PORT MAP (B,W,A,Clk,Start,Rst, A_I_finale,B_I_finale,A_R_finale,B_R_finale,Done);

END ARCHITECTURE;