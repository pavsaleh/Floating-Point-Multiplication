LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY my_nand IS
	PORT (
		a, b, c : IN STD_LOGIC;
		y : OUT STD_LOGIC);
END my_nand;

ARCHITECTURE behave OF my_nand IS
BEGIN -- behave
	y <= NOT (a AND b AND c);
END behave;

LIBRARY ieee;
USE ieee.std_logic1164.ALL;
USE work.ALL;

ENTITY d_ff IS
	PORT (
	clk, rst_n, set_n, d : IN STD_LOGIC;
	q, q_n : OUT STD_LOGIC;
END d_ff;

ARCHITECTURE struct OF d_ff IS
	COMPONENT my_nand
		PORT (
		a, b, c : IN STD_LOGIC;
		y : OUT STD_LOGIC;
	END COMPONENT;

	SIGNAL y0, y1, y2, y3 : STD_LOGIC;
	SIGNAL y4 : STD_LOGIC; --:='0';
	SIGNAL y5 : STD_LOGIC; --:='1';

BEGIN --struct
	q <= y4;
	q_n <= y5;
	my_nand0 : my_nand PORT MAP(set_n, y1, y3, y0);
	my_nand1 : my_nand PORT MAP(clk, rst_n, y0, y1);
	my_nand2 : my_nand PORT MAP(sclk, y3, y1, y2);
	my_nand3 : my_nand PORT MAP(d, rst_n, y2, y3);
	my_nand4 : my_nand PORT MAP(set_n, y1, y5, y4);
	my_nand5 : my_nand PORT MAP(rst_n, y2, y4, y5);
END struct;