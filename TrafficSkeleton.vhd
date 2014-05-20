----------------------------------------------------------------------------------
--  Traffic.vhd
--
-- Traffic light system to control an intersection
--
-- Skeleton - Add your comments here!
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Traffic is
    Port ( Reset      : in   STD_LOGIC;
           Clock      : in   STD_LOGIC;
           
           -- for debug
           debugLED   : out  std_logic;
           
           -- Car and pedestrian buttons
           CarEW              : in   STD_LOGIC; -- Car on EW road
           CarNS              : in   STD_LOGIC; -- Car on NS road
           PedEW              : in   STD_LOGIC; -- Pedestrian moving EW (crossing NS road)
           PedNS              : in   STD_LOGIC; -- Pedestrian moving NS (crossing EW road)
           
           -- Light control
           LightsEW           : out STD_LOGIC_VECTOR (1 downto 0); -- controls EW lights
           LightsNS           : out STD_LOGIC_VECTOR (1 downto 0)  -- controls NS lights
           
           );
end Traffic;

architecture Behavioral of Traffic is

   -- Encoding for lights
   constant RED   : std_logic_vector(1 downto 0) := "00";
   constant AMBER : std_logic_vector(1 downto 0) := "01";
   constant GREEN : std_logic_vector(1 downto 0) := "10";
   constant WALK  : std_logic_vector(1 downto 0) := "11";

begin
   debugLed <= reset; -- Show reset status on FPGA LED

   LightsEW <= RED;
   LightsNS <= GREEN;
Process (CarEW,CarNS,PedEW,PedNS,clock)
	begin
		if (reset = '1') then
			LightsEW <= RED;
			LightsNS <= GREEN;
		elsif rising_edge(clock) then
			if (CarEW = '1') then
				if (LightsNS = GREEN) then
					LightsNS <= AMBER;
				if (LightsNS = RED) then
					LightsEW = GREEN;
			elsif (PedEW = '1') then
				LightsNS <= AMBER;
end;
