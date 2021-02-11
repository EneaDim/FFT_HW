Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

Entity Butterfly is
Port(
     B,W,A: in signed(15 downto 0);
	  Clk,Start,Rst: in Std_logic;
	  A_I_finale,B_I_finale,A_R_finale,B_R_finale: out signed(15 downto 0);--A_continua e B_continua sono i risultati di A e B se si lavora in continua
	  Done:out std_logic);
end Entity;

Architecture behavior of Butterfly is

component reg_nbit_d IS
GENERIC ( N : integer);
PORT (R : IN SIGNED(N-1 DOWNTO 0);
Clock, Resetn,load : IN STD_LOGIC;
Q : buffer SIGNED(N-1 DOWNTO 0));
END component;

component mux2to1 IS 
generic( N : integer);
PORT( s: IN STD_LOGIC;
      x : IN Signed (N-1 DOWNTO 0);
		y : IN Signed (N-1 DOWNTO 0);
		m : OUT Signed (N-1 DOWNTO 0));
END component;

component mux4to1 IS
generic( N : integer);
PORT( s: IN unsigned(1 downto 0);
      x : IN Signed(N-1 DOWNTO 0);
		y : IN Signed (N-1 DOWNTO 0);
		w : IN Signed(N-1 DOWNTO 0);
		z : IN Signed (N-1 DOWNTO 0);
		m : OUT Signed(N-1 DOWNTO 0));
END component;

component add_sub_arr Is
generic( N : integer);
Port( X: IN signed(N-1 downto 0);
      Y: IN signed(N-1 downto 0);
      Cin: IN std_logic;
		result: OUT SIGNED(N-1 downto 0));
End component;

component signed_mult is
port 
   (
      a : in signed (15 downto 0);
      b : in signed (15 downto 0);
		Clock: IN STD_LOGIC;
      result : out signed (30 downto 0)
   );

end component;

Component xor_port is
PORT (A: in signed (32 downto 0);
      neg: in std_logic;
		B: out signed (32 downto 0));
end component;

Component nor_port is
PORT (A: in signed (28 downto 0);
      neg: in std_logic;
		B: out std_logic);
end Component;

COMPONENT RippleCarryAdder_pipeline IS
		GENERIC(M: INTEGER);
		PORT (A, B: IN SIGNED (M-1 DOWNTO 0);
				c_in: IN STD_LOGIC; 
				clk: IN STD_LOGIC;
				SUM: OUT SIGNED (M-1 DOWNTO 0);
				c_out: OUT STD_LOGIC);
END COMPONENT;

COMPONENT micro_CU IS
	PORT(
			IN_STATUS: IN STD_LOGIC;
			CLOCK, RESET_N: IN STD_LOGIC;
			CONTROL_SIGNAL: OUT STD_LOGIC_VECTOR(34 DOWNTO 0));
END COMPONENT;

--Load dei reg di ingresso
signal load_Br,load_BI,load_Ar,load_AI,load_Wr,load_WI:std_logic;
--Rst reg di ingresso
signal rstn_Br,rstn_BI,rstn_Ar,rstn_AI,rstn_Wr,rstn_WI:std_logic;
--uscite reg di ingresso
signal Out_reg_Br,Out_reg_Bi,Out_reg_Wr,Out_reg_Wi,Out_reg_Ar,Out_reg_Ai:signed(15 downto 0);

--selettori mux A e W
signal sel_B,sel_W: std_logic;
--segnali in uscita dal mux
signal Out_mux_B,Out_mux_W:signed(15 downto 0);

--segnali per il moltiplicatore e pipe
signal load_mpy,rstn_mpy:std_logic;

--uscita mpy e pipe e  reg mpy
signal Out_mpy,Out_reg_mpy:signed(30 downto 0);

--out mpy da 33 bit
signal Out_Reg_mult_33bit:signed(32 downto 0);
--selettore xnor
signal cin_sum1,cin_sum2:std_logic;
--uscite xnor
signal Out_xor_sum1,Out_xor_sum2:signed(32 downto 0);
--segnali ingresso mux 4 to1
signal Enter_Ar_mux,Enter_Ai_mux,useless1:signed(32 downto 0);

--selettori mux4to1
signal sel_sum1,sel_sum2:unsigned (1 downto 0);
--uscite mux4to1
signal Out_mux_sum1,Out_mux_sum2:signed(32 downto 0);

--uscite sommatore 1 e 2
signal Out_sum1,Out_sum2:signed(32 downto 0);

--comandi sommatori 1 e 2
signal rstn_s1,load_s1,rstn_s2,load_s2:std_logic;
--uscita registri di somma 1 e 2
signal Out_reg_sum1,Out_reg_sum2:signed(32 downto 0);

--entrate della nor A e B
signal Enter_nor_A,Enter_nor_B:signed(28 downto 0);

--segnali di controllo mux 0.5
signal Cntrl_A_0_5,Cntrl_B_0_5:std_logic;

--0.5 e -0.5
signal plus_0_5,minus_0_5:signed(32 downto 0); 

--uscite mu 0.5 e -0.5
signal Out_mux_minus_A,Out_mux_minus_B:signed(32 downto 0);

--numero 0.000..5
signal sum_0_5:signed(32 downto 0);--AGGIUNGERE VALORE

--uscita mux arrotondamtento
signal Out_mux_ctr_A_0_5,Out_mux_ctrl_B_0_5:signed(32 downto 0);

--uscite sommatori A e B
signal Out_sum_arrA,Out_add_arrB:signed(32 downto 0);

--Dati buoni A e B
signal Date_goodA,Date_goodB:signed(15 downto 0);

--comandi registri continua
signal rstn_Ar_final,load_reg_Ar_final,rstn_Br_final,load_reg_Br_final:std_logic;

--uscite registri in continua
signal Out_reg_A_continua,Out_reg_B_continua:signed (15 downto 0);

-- comandiregistri finali
signal rstn_reg_Ai_final,load_reg_Ai_final,rstn_reg_Bi_final,load_reg_Bi_final:std_logic;

--uscite registri finali 
signal Out_reg_A_final,Out_reg_B_final:signed (15 downto 0);
signal out_reg_sum1_int, out_reg_sum2_int, out_reg_mpy_int: integer;

signal outReg_Ar_final, outReg_Ai_final, outReg_Br_final, outReg_Bi_final : signed (15 downto 0);

begin
plus_0_5<="000100000000000000000000000000000";--0,5   prime tre cifre dopo la virgola zero
minus_0_5<="111100000000000000000000000000000";-- meno 0,5 prime tre cifre dopo la virgola uno
sum_0_5 <= "000000000000000010000000000000000";-- 0,00000000000005 per l'arrotondamento
useless1 <= "000000000000000000000000000000000";
out_reg_sum1_int <= to_integer(out_reg_sum1);
out_reg_sum2_int <= to_integer(out_reg_sum2);
out_reg_mpy_int <= to_integer(out_reg_mpy);

--Registri di ingresso
Reg_Br: reg_nbit_d 
Generic map (16) PORT MAP(B,Clk,rstn_Br,load_Br,Out_reg_Br);
Reg_Bi: reg_nbit_d 
Generic map (16) PORT MAP(B,Clk,rstn_Bi,load_Bi,Out_reg_Bi);
Reg_Wr: reg_nbit_d 
Generic map (16) PORT MAP(W,Clk,rstn_Wr,load_Wr,Out_reg_Wr);
Reg_Wi: reg_nbit_d 
Generic map (16) PORT MAP(W,Clk,rstn_Wi,load_Wi,Out_reg_Wi);
Reg_Ar: reg_nbit_d 
Generic map (16) PORT MAP(A,Clk,rstn_Ar,load_Ar,Out_reg_Ar);
Reg_Ai: reg_nbit_d 
Generic map (16) PORT MAP(A,Clk,rstn_Ai,load_Ai,Out_reg_Ai);

--MUX A e B
Mux_B:mux2to1
Generic map (16) PORT MAP(sel_B,Out_reg_Br,Out_reg_Bi,Out_mux_B);
Mux_W:mux2to1
Generic map (16) PORT MAP(sel_W,Out_reg_Wr,Out_reg_Wi,Out_mux_W);

--Moltiplicatore
Multiplier:signed_mult
PORT MAP(Out_mux_B,Out_mux_W, Clk, Out_mpy);

--Reg_mult
Reg_mult:reg_nbit_d 
Generic map (31) PORT MAP(Out_mpy,Clk,rstn_mpy,load_mpy,Out_reg_mpy);

--Xor_add_1
Out_Reg_mult_33bit<=Out_reg_mpy(30)&Out_reg_mpy(30)&Out_reg_mpy(30 downto 0);
Xor_add_1: xor_port
PORT MAP (Out_Reg_mult_33bit,cin_sum1,Out_xor_sum1);
--Xor_add_2
Xor_add_2: xor_port
PORT MAP (Out_Reg_mult_33bit,cin_sum2,Out_xor_sum2);

--aggiungo i 17 bit che mancano per arrivare a 33
Enter_Ar_mux<=Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar(15)&Out_reg_Ar;
Enter_Ai_mux<=Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai(15)&Out_reg_Ai;

--Mux_4to1 for adder1
Mux_Add1:mux4to1
Generic map(33) PORT MAP(sel_sum1,Enter_Ar_mux,Enter_Ai_mux,Out_reg_sum1,useless1,Out_mux_sum1);
--Mux_4to1 for adder2
Mux_Add2:mux4to1
Generic map(33) PORT MAP(sel_sum2,Enter_Ar_mux,Enter_Ai_mux,Out_reg_sum2,useless1,Out_mux_sum2);
--ho usato lo stesso gli useless tanto il segnale � inutilizzato e perci� sar� lo stesso per tt e 2, si evita di mettere due segnali

--Add1
Add1: RippleCarryAdder_pipeline
Generic map(33) PORT MAP(Out_mux_sum1,Out_xor_sum1,cin_sum1, Clk, Out_sum1);
--Reg_pipe_add1
--Reg_pipe_add1:reg_nbit_d 
--Generic map (33) PORT MAP(Out_sum1,Clk,rsnt_reg_pipe_sum1,load_reg_pipe_sum1,Out_reg_pipe_sum1);
--Reg_add1
Reg_add1:reg_nbit_d 
Generic map (33) PORT MAP(Out_sum1, Clk,rstn_s1,load_s1,Out_reg_sum1);

--Add2
Add2: RippleCarryAdder_pipeline
Generic map(33) PORT MAP(Out_mux_sum2,Out_xor_sum2,cin_sum2,Clk, Out_sum2);
--Reg_pipe_add1
--Reg_pipe_add2:reg_nbit_d 
--Generic map (33) PORT MAP(Out_sum2,Clk,rstn_reg_pipe_sum2,load_reg_pipe_sum2,Out_reg_pipe_sum2);
--Reg_add1
Reg_add2:reg_nbit_d 
Generic map (33) PORT MAP(Out_sum2,Clk,rstn_s2,load_s2,Out_reg_sum2);

--ARROTONDAMENTO PER A
--xnor per segnale di controllo
Enter_nor_A<=Out_reg_sum1(28 downto 0);
nor_p:nor_port
PORT MAP(Enter_nor_A,Out_reg_sum1(29),Cntrl_A_0_5);

--Mux 0.5 o -0.5, segnale di controllo � il 31 bit di Out_reg_add1
Mux_minus:mux2to1
Generic map (33) PORT MAP(Out_reg_sum1(30),minus_0_5,plus_0_5,Out_mux_minus_A);

--Mux control 0.000..5
Mux_A_ctrl_0_5:mux2to1
Generic map (33) PORT MAP(Cntrl_A_0_5,sum_0_5,Out_mux_minus_A,Out_mux_ctr_A_0_5);

--Add_arr1
Add_arrA: add_sub_arr
Generic map(33) PORT MAP(Out_reg_sum1,Out_mux_ctr_A_0_5,'0',Out_sum_arrA);
Date_goodA<=Out_sum_arrA(32 downto 17);--prendo solo i bit buoni di 33

--Reg_A_continua(se siamo in continua � sia Ar che Ai, se siamo alla fine questo � Ai)
Reg_Ar_final:reg_nbit_d 
Generic map (16) PORT MAP(Date_goodA,Clk,rstn_Ar_final,load_reg_Ar_final, outReg_Ar_final);

A_R_finale <= outReg_Ar_final;

--Reg_A_final( se siamo alla fine questo � Ar)
Reg_Ai_final:reg_nbit_d 
Generic map (16) PORT MAP(date_goodA,Clk,rstn_reg_Ai_final,load_reg_Ai_final,outReg_Ai_final);

A_I_finale <= outReg_Ai_final;

--ARROTONDAMENTO PER B
--xnor per segnale di controllo
Enter_nor_B<=Out_reg_sum2(28 downto 0);
nor_p_B:nor_port
PORT MAP(Enter_nor_B,Out_reg_sum2(29),Cntrl_B_0_5);

--Mux 0.5 o -0.5, segnale di controllo � il 31 bit di Out_reg_add1
Mux_minus_B:mux2to1
Generic map (33) PORT MAP(Out_reg_sum2(30),minus_0_5,plus_0_5,Out_mux_minus_B);

--Mux control 0.000..5
Mux_ctrl_B_0_5:mux2to1
Generic map (33) PORT MAP(Cntrl_B_0_5,sum_0_5,Out_mux_minus_B,Out_mux_ctrl_B_0_5);

--Add_arr2
Add_arrB: add_sub_arr
Generic map(33) PORT MAP(Out_reg_sum2,Out_mux_ctrl_B_0_5,'0',Out_add_arrB);
Date_goodB<=Out_add_arrB(32 downto 17);--prendo solo i bit buoni di 33

--Reg_A_continua(se siamo in continua � sia Ar che Ai, se siamo alla fine questo � Ai)
Reg_Br_final:reg_nbit_d 
Generic map (16) PORT MAP(Date_goodB,Clk,rstn_Br_final,load_reg_Br_final,outReg_Br_final);

B_R_finale <= outReg_Br_final;

--Reg_A_final( se siamo alla fine questo � Ar)
Reg_Bi_final:reg_nbit_d 
Generic map (16) PORT MAP(Date_goodB,Clk,rstn_reg_Bi_final,load_reg_Bi_final,outReg_Bi_final);

B_I_finale <= outReg_Bi_final;

--CONNESSIONE CU DATAPATH

uCU: micro_CU
PORT MAP(IN_STATUS => Start, CLOCK => Clk, RESET_N => Rst,  CONTROL_SIGNAL(34) =>load_Br, 
																				CONTROL_SIGNAL(33) => load_BI,
																				CONTROL_SIGNAL(32) => load_Ar,
																				CONTROL_SIGNAL(31) => load_AI,
																				CONTROL_SIGNAL(30) =>  load_Wr,
																				CONTROL_SIGNAL(29) => load_WI,
																				CONTROL_SIGNAL(28) => rstn_Br, 
																				CONTROL_SIGNAL(27) => rstn_BI, 
																				CONTROL_SIGNAL(26) => rstn_Ar, 
																				CONTROL_SIGNAL(25) => rstn_AI, 
																				CONTROL_SIGNAL(24) => rstn_Wr,	
																				CONTROL_SIGNAL(23) => rstn_WI, 
																				CONTROL_SIGNAL(22) => sel_B, 
																				CONTROL_SIGNAL(21) => sel_W, 
																				CONTROL_SIGNAL(20) => load_mpy, 
																				CONTROL_SIGNAL(19) => rstn_mpy, 
																				CONTROL_SIGNAL(18) => sel_sum1(1), 
																				CONTROL_SIGNAL(17) => sel_sum1(0), 
																				CONTROL_SIGNAL(16) => sel_sum2(1), 
																				CONTROL_SIGNAL(15) => sel_sum2(0), 
																				CONTROL_SIGNAL(14) => cin_sum1, 
																				CONTROL_SIGNAL(13) => cin_sum2, 
																				CONTROL_SIGNAL(12) => load_s1, 
																				CONTROL_SIGNAL(11) => load_s2, 
																				CONTROL_SIGNAL(10) => rstn_s1, 
																				CONTROL_SIGNAL(9) => rstn_s2, 
																				CONTROL_SIGNAL(8) => load_reg_Ar_final, 
																				CONTROL_SIGNAL(7) => load_reg_Ai_final,
																				CONTROL_SIGNAL(6) => load_reg_Br_final, 
																				CONTROL_SIGNAL(5) => load_reg_Bi_final, 
																				CONTROL_SIGNAL(4) => rstn_Ar_final, 
																				CONTROL_SIGNAL(3) => rstn_reg_Ai_final, 
																				CONTROL_SIGNAL(2) => rstn_Br_final, 
																				CONTROL_SIGNAL(1) => rstn_reg_Bi_final, 
																				CONTROL_SIGNAL(0) => DONE);
																	

end behavior;
