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