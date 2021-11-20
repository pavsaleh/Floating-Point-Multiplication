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