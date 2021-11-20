LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY srlatch IS
    PORT (
        s, r, clk : IN STD_LOGIC;
        q, qo : OUT STD_LOGIC);
END srlatch;

ARCHITECTURE srlatch_arch OF srlatch IS
    COMPONENT nand_gate IS
        PORT (
            a, b : IN STD_LOGIC;
            y : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL x, y, m, n : STD_LOGIC;

BEGIN
    r1 : nand_gate PORT MAP(s, clk, x);
    r2 : nand_gate PORT MAP(r, clk, y);
    r3 : nand_gate PORT MAP(x, n, m);
    r4 : nand_gate PORT MAP(y, m, n);
    q <= m;
    qo <= n;
END srlatch_arch;