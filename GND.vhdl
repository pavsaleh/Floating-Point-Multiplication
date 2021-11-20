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

--The GND component (U0) is assigned to the STD_LOGIC ‘U’ which stands for Uninitialized. Here, it means, that we are yet to initialize the signal.