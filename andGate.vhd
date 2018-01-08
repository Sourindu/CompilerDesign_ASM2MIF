library ieee;
use ieee.std_logic_1164.all;

Entity andgate Is

Port ( SW0, SW1 : In std_logic;
			LEDR1 : Out std_logic);
			
End Entity;

Architecture rtl of andgate Is

Begin

LEDR1 <= SW0 and SW1;

END rtl;