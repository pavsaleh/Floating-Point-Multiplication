LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALU IS
    GENERIC (
        nbit : INTEGER := 16;
        exponent_bits : INTEGER := 7;
        mantissa_bits : INTEGER := 8
    );
    PORT (
        clk : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
        output_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        logic_sel : IN STD_LOGIC;
        left_sel : IN STD_LOGIC;
        rotate_sel : IN STD_LOGIC;
        sub_sel : IN STD_LOGIC;
        O, M, D : OUT STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0)
    );
END ALU;

ARCHITECTURE structural OF ALU IS

    SIGNAL sum_diff_out : STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
    COMPONENT adder IS
    END COMPONENT adder;

    SIGNAL mul_out : STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
    COMPONENT multiplier IS
    END COMPONENT multiplier;

    SIGNAL div_out : STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
    COMPONENT divider IS
    END COMPONENT divider;

    SIGNAL shift_out : STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
    COMPONENT shifter_rotator IS
    END COMPONENT shifter_rotator;

    SIGNAL FP_sub_ctrl : STD_LOGIC;
    SIGNAL FP_sum_diff_out : STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
    COMPONENT FP_adder_subtractor IS
        GENERIC (
            -- Lab 1 floating point standard.
            nbit : NATURAL := 16;
            exponent : NATURAL := 7;
            mantissa : NATURAL := 8
        );
        PORT (
            clk : IN STD_LOGIC;
            A : IN STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
            sub : IN STD_LOGIC;
            S, M, D : OUT STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0)
        );
    END COMPONENT FP_adder_subtractor;

    SIGNAL FP_mul_out : STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
    COMPONENT FP_multiplier IS
        GENERIC (
            -- Lab 1 floating point standard.
            nbit : NATURAL := 16;
            exponent : NATURAL := 7;
            mantissa : NATURAL := 8
        );
        PORT (
            clk : IN STD_LOGIC;
            A : IN STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
            S, M, D : OUT STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0)
        );
    END COMPONENT FP_multiplier;

    SIGNAL FP_div_out : STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
    COMPONENT FP_divider IS
        GENERIC (
            -- Lab 1 floating point standard.
            nbit : NATURAL := 16;
            exponent : NATURAL := 7;
            mantissa : NATURAL := 8
        );
        PORT (
            clk : IN STD_LOGIC;
            A : IN STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0);
            S, M, D : OUT STD_LOGIC_VECTOR(nbit - 1 DOWNTO 0)
        );
    END COMPONENT FP_divider;

BEGIN
    --ADDER:  adder port map();

    --MULTIPLIER: multiplier port map();

    --DIVIDER:    divider port map();

    --SH_ROT: shifter_rotator port map();
    --FP_sub_ctrl <=  '1' when sub_sel = '1'
    --'0';

    adder1 : FP_adder_subtractor
    GENERIC MAP(
        nbit => nbit,
        exponent => exponent_bits,
        mantissa => mantissa_bits
    )
    PORT MAP(
        clk => clk,
        A => A,
        B => B,
        sub => FP_sub_ctrl,
        S => FP_sum_diff_out
    );

    multiplier1 : FP_multiplier
    GENERIC MAP(
        nbit => nbit,
        exponent => exponent_bits,
        mantissa => mantissa_bits
    )
    PORT MAP(
        clk => clk,
        A => A,
        B => B,
        M => FP_mul_out
    );

    divider1 : FP_divider
    GENERIC MAP(
        nbit => nbit,
        exponent => exponent_bits,
        mantissa => mantissa_bits
    )
    PORT MAP(
        clk => clk,
        A => A,
        B => B,
        D => FP_div_out
    );

    O <= sum_diff_out WHEN output_sel = "000" ELSE
        mul_out WHEN output_sel = "001" ELSE
        div_out WHEN output_sel = "010" ELSE
        shift_out WHEN output_sel = "011" ELSE
        FP_sum_diff_out WHEN output_sel = "100" ELSE
        FP_mul_out WHEN output_sel = "101" ELSE
        FP_div_out WHEN output_sel = "110" ELSE
        (OTHERS => '0');

END ARCHITECTURE structural;