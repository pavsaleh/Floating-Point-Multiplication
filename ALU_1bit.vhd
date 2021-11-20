LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.STD_LOGIC_ARITH.ALL;

USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY HA IS

      PORT (
            HAA, HAB : IN STD_LOGIC;

            SUM, CARRY : OUT STD_LOGIC);

END HA;

ARCHITECTURE dataflow OF HA IS

BEGIN

      SUM <= HAA XOR HAB;

      CARRY <= HAA AND HAB;

END dataflow;

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.STD_LOGIC_ARITH.ALL;

USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY HS IS

      PORT (
            HSA, HSB : IN STD_LOGIC;

            DIFFERENCE, BORROW : OUT STD_LOGIC);

END HS;

ARCHITECTURE dataflow OF HS IS

BEGIN

      DIFFERENCE <= HSA XOR HSB;

      BORROW <= (NOT HSA) AND HSB;

END dataflow;

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.STD_LOGIC_ARITH.ALL;

USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY multiplier IS

      PORT (
            MA, MB : IN STD_LOGIC;

            PRODUCT : OUT STD_LOGIC);

END multiplier;

ARCHITECTURE dataflow OF multiplier IS

BEGIN

      PRODUCT <= MA AND MB;

END dataflow;

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.STD_LOGIC_ARITH.ALL;

USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY MUX IS

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

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.STD_LOGIC_ARITH.ALL;

USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY ground IS

      PORT (N : INOUT STD_LOGIC);

END ground;

ARCHITECTURE dataflow OF ground IS

BEGIN

      N <= 'U';

END dataflow;

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.STD_LOGIC_ARITH.ALL;

USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY ALU IS

      PORT (
            A, B, SEL1, SEL2 : IN STD_LOGIC;

            ALU1, ALU2 : OUT STD_LOGIC);

END ALU;

ARCHITECTURE Structural OF ALU IS
      COMPONENT HA IS

            PORT (
                  HAA, HAB : IN STD_LOGIC;

                  SUM, CARRY : OUT STD_LOGIC);

      END COMPONENT;
      COMPONENT HS IS

            PORT (
                  HSA, HSB : IN STD_LOGIC;

                  DIFFERENCE, BORROW : OUT STD_LOGIC);

      END COMPONENT;
      COMPONENT multiplier IS

            PORT (
                  MA, MB : IN STD_LOGIC;

                  PRODUCT : OUT STD_LOGIC);

      END COMPONENT;
      COMPONENT MUX IS

            PORT (
                  A1, A2, A3, A4 : IN STD_LOGIC;

                  S : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

                  X : OUT STD_LOGIC);

      END COMPONENT;
      COMPONENT ground IS

            PORT (N : INOUT STD_LOGIC);

      END COMPONENT;
      SIGNAL S0, S1, S2, S3, S4, S5 : STD_LOGIC;
BEGIN

      U0 : ground PORT MAP(N => S5);

      U1 : HA PORT MAP(HAA => A, HAB => B, SUM => S0, CARRY => S3);

      U2 : HS PORT MAP(HSA => A, HSB => B, DIFFERENCE => S1, BORROW => S4);

      U3 : multiplier PORT MAP(MA => A, MB => B, PRODUCT => S2);

      U4 : MUX PORT MAP(A1 => S0, A2 => S1, A3 => S2, A4 => S5, X => ALU1, S(0) => SEL1, S(1) => SEL2);

      U5 : MUX PORT MAP(A1 => S3, A2 => S4, A3 => S5, A4 => S5, X => ALU2, S(0) => SEL1, S(1) => SEL2);

END Structural;