LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.STD_LOGIC_ARITH.ALL;

USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY mux IS

    PORT (
        A1, A2, A3, A4 : IN STD_LOGIC;

        S : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

        X : OUT STD_LOGIC);

END mux;

ARCHITECTURE dataflow OF MUX IS

BEGIN

    WITH S SELECT

        X <= A1 WHEN "00",

        A2 WHEN "01",

        A3 WHEN "10",

        A4 WHEN OTHERS;

END dataflow;