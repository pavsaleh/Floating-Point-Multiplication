LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY smallAlu IS
	PORT (
		selec : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		ValA, ValB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		ValO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		zero : OUT STD_LOGIC);
END smallAlu;

ARCHITECTURE rtl OF smallAlu IS
	--AND OR SUB ADD SLT

	--ADDER Component
	COMPONENT eightbitfulladder IS
		PORT (
			M : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			N : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Cin : IN STD_LOGIC;
			Cout : OUT STD_LOGIC;
			Sum : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	--Subtractor
	COMPONENT fullSubtractor8Bit IS
		PORT (
			M : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			N : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Din : IN STD_LOGIC;
			Cout : OUT STD_LOGIC;
			Sum : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;
	--AND
	COMPONENT eightBitAND IS
		PORT (
			ValA, ValB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			ValO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT eightBitAND;
	--OR 
	COMPONENT eightBitOR IS
		PORT (
			ValA, ValB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			ValO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT eightBitOR;
	--LST
	COMPONENT eightBitSLT IS
		PORT (
			ValA, ValB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			ValO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT eightBitSLT;

	COMPONENT mux8x3 IS
		PORT (
			a, b, c, d, e, f, g, h : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			selec : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			m : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT mux8x3;
	SIGNAL inSigA, inSigB, inMuxA, inMuxB, inMuxC, inMuxD, inMuxE, outMuxA, inMuxF : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL selectors : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	selectors <= selec;
	inSigA <= ValA;
	inSigB <= ValB;
	sAND : eightBitAND PORT MAP(inSigA, inSigB, inMuxA);
	sOR : eightBitOR PORT MAP(inSigA, inSigB, inMuxB);
	sADD : eightbitfulladder PORT MAP(inSigA, inSigB, '0', OPEN, inMuxC);
	sSUB : fullSubtractor8Bit PORT MAP(inSigA, inSigB, '0', OPEN, inMuxD);
	sSLT : eightBitSLT PORT MAP(inSigA, inSigB, inMuxF);
	mux : mux8x3 PORT MAP(inMuxA, inMuxB, inMuXC, inMuxD, inMuxE, "00000000", "00000000", "00000000", selectors, outMuxA);
	ValO <= outMuxA;
	zero <= NOT(outMuxA(0) OR outMuxA(1) OR outMuxA(2) OR outMuxA(3) OR outMuxA(4) OR outMuxA(5) OR outMuxA(6) OR outMuxA(7));

END ARCHITECTURE rtl;