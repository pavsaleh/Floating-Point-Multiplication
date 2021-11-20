LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY ShiftReg4bits_Struct IS
	PORT (
		Din, clk, reset : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END ShiftReg4bits_Struct;

ARCHITECTURE Structural OF ShiftReg4bits_Struct IS
	COMPONENT D_FFP IS
		PORT (
			clk, reset, D : IN STD_LOGIC;
			Q : OUT STD_LOGIC);
	END COMPONENT;

	SIGNAL Q_temp : STD_LOGIC_VECTOR(3 DOWNTO 1);
BEGIN
	DFF3 : D_FFP PORT MAP(clk, reset, Din, Q_temp(3));
	DFF2 : D_FFP PORT MAP(clk, reset, Q_temp(3), Q_temp(2));
	DFF1 : D_FFP PORT MAP(clk, reset, Q_temp(2), Q_temp(1));
	DFF0 : D_FFP PORT MAP(clk, reset, Q_temp(1), Q(0));

	Q(3 DOWNTO 1) <= Q_temp;
END Structural;