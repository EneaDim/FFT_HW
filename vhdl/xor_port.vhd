Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity xor_port is
PORT (A: in signed (32 downto 0);
      neg: in std_logic;
		B: out signed (32 downto 0));
end xor_port;

Architecture behavior of xor_port is
begin

B(0)<=A(0) xor neg;
B(1)<=A(1) xor neg;
B(2)<=A(2) xor neg;
B(3)<=A(3) xor neg;
B(4)<=A(4) xor neg;
B(5)<=A(5) xor neg;
B(6)<=A(6) xor neg;
B(7)<=A(7) xor neg;
B(8)<=A(8) xor neg;
B(9)<=A(9) xor neg;
B(10)<=A(10) xor neg;
B(11)<=A(11) xor neg;
B(12)<=A(12) xor neg;
B(13)<=A(13) xor neg;
B(14)<=A(14) xor neg;
B(15)<=A(15) xor neg;
B(16)<=A(16) xor neg;
B(17)<=A(17) xor neg;
B(18)<=A(18) xor neg;
B(19)<=A(19) xor neg;
B(20)<=A(20) xor neg;
B(21)<=A(21) xor neg;
B(22)<=A(22) xor neg;
B(23)<=A(23) xor neg;
B(24)<=A(24) xor neg;
B(25)<=A(25) xor neg;
B(26)<=A(26) xor neg;
B(27)<=A(27) xor neg;
B(28)<=A(28) xor neg;
B(29)<=A(29) xor neg;
B(30)<=A(30) xor neg;
B(31)<=A(31) xor neg;
B(32)<=A(32) xor neg;



end behavior;