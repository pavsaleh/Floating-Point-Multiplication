----------------------------------------------------------------------------------
-- Company: Drexel University
-- Engineer: Rob Taglang
-- 
-- Module Name: ieee754_fp_multiplier - Structural
-- Description: Multiplies two IEEE-754 floating point numbers
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ieee754_fp_multiplier IS
    PORT (
        x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        y : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        z : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ieee754_fp_multiplier;

ARCHITECTURE Structural OF ieee754_fp_multiplier IS
    SIGNAL x_sign, y_sign, z_sign : STD_LOGIC;
    SIGNAL x_exponent, y_exponent, z_exponent : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL x_mantissa, y_mantissa : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL z_mantissa : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    x_sign <= x(15);
    y_sign <= y(15);
    z(15) <= z_sign;
    -- output sign is negative if only one input is negative
    z_sign <= x_sign XOR y_sign;

    x_mantissa(8) <= '1';
    x_mantissa(7 DOWNTO 0) <= x(7 DOWNTO 0);
    y_mantissa(8) <= '1';
    y_mantissa(7 DOWNTO 0) <= y(7 DOWNTO 0);
    z(7 DOWNTO 0) <= z_mantissa;

    x_exponent <= x(15 DOWNTO 8);
    y_exponent <= y(15 DOWNTO 8);
    z(15 DOWNTO 8) <= z_exponent;

    PROCESS (x_exponent, y_exponent, x_mantissa, y_mantissa)
        VARIABLE add, msb : INTEGER;
        VARIABLE multiply, shift_multiply : unsigned(17 DOWNTO 0);
        VARIABLE mantissa : unsigned(7 DOWNTO 0);
    BEGIN
        IF (x_exponent = x"00" AND x_mantissa = "1") OR (y_exponent = x"00" AND y_mantissa = "100000000000000000000000") THEN
            z_exponent <= x"00";
            z_mantissa <= "00000000000000000000000";
        ELSE
            -- add the exponents
            add := to_integer(unsigned(x_exponent) + unsigned(y_exponent)) - 127;
            --  multiply the mantissas
            multiply := unsigned(x_mantissa) * unsigned(y_mantissa);
            msb := 0;
            FOR i IN 0 TO 47 LOOP
                IF multiply(i) = '1' THEN
                    msb := i;
                END IF;
            END LOOP;
            shift_multiply := multiply SRL msb - 8;
            mantissa := shift_multiply(7 DOWNTO 0);
            IF mantissa = "11111111111111111111111" THEN
                z_mantissa <= STD_LOGIC_VECTOR(mantissa + 1);
                z_exponent <= STD_LOGIC_VECTOR(to_unsigned(add + (msb - 46) + 1, 8));
            ELSE
                z_mantissa <= STD_LOGIC_VECTOR(shift_multiply(7 DOWNTO 0));
                z_exponent <= STD_LOGIC_VECTOR(to_unsigned(add + (msb - 46), 8));
            END IF;
        END IF;
    END PROCESS;
END Structural;