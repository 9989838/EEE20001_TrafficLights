--------------------------------------------------------------------------------
-- Testbench for Traffic intersection
--
-- It will be necessary to change the port definitions of the instantiation of
-- the Traffic module to match the actual ports used.
-- 
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY TrafficTestbench IS
END TrafficTestbench;

ARCHITECTURE behavior OF TrafficTestbench IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT Traffic
	PORT(
		Reset     : IN std_logic;
		Clock     : IN std_logic;
		CarEW     : IN std_logic;
		CarNS     : IN std_logic;
		PedEW     : IN std_logic;
		PedNS     : IN std_logic;          
		debugLED  : OUT std_logic;
		LightsEW  : OUT std_logic_vector(1 downto 0);
		LightsNS  : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

	-- Inputs
	SIGNAL Reset :  std_logic := '0';
	SIGNAL Clock :  std_logic := '0';
	SIGNAL CarEW :  std_logic := '0';
	SIGNAL CarNS :  std_logic := '0';
	SIGNAL PedEW :  std_logic := '0';
	SIGNAL PedNS :  std_logic := '0';

	-- Outputs
	SIGNAL debugLED :  std_logic;
	SIGNAL LightsEW :  std_logic_vector(1 downto 0);
	SIGNAL LightsNS :  std_logic_vector(1 downto 0);
   
   -- Internal
   signal complete : boolean := false;
   signal currentTest : string(1 to 10);

   -- Encoding for lights
   constant RED   : std_logic_vector(1 downto 0) := "00";
   constant AMBER : std_logic_vector(1 downto 0) := "01";
   constant GREEN : std_logic_vector(1 downto 0) := "10";
   constant WALK  : std_logic_vector(1 downto 0) := "11";

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: Traffic PORT MAP(
		Reset    => Reset,
		Clock    => Clock,
		debugLED => debugLED,
		CarEW    => CarEW,
		CarNS    => CarNS,
		PedEW    => PedEW,
		PedNS    => PedNS,
		LightsEW => LightsEW,
		LightsNS => LightsNS
	);

   clkProcess:
   process
   begin
      while not complete loop
         clock <= '1'; wait for 500 ns;
         clock <= '0'; wait for 500 ns;
      end loop;
      
      wait;
   end process clkProcess;
   
   
	tb : PROCESS
	BEGIN

      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0';

		-- Stimulus here
		--==========================================
		
      -- Reset circuit
      currentTest <= "Reset     ";
      reset <= '1';  wait until rising_edge(clock);
      reset <= '0';  wait until rising_edge(clock);
      
      -- Simulation assumes lights start green NS after reset - change if needed
      
      -- Lights currently green NS
		-- EW Car arrives & waits for the lights to change 
		-- Lights should change directly to green EW
      currentTest <= "EW Car    ";
      CarEW <= '1'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- EW car arrives
      wait until LightsEW = GREEN;
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- EW car leaves
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green EW
		-- NS Car arrives & waits for the lights to change 
		-- Lights should change directly to green NS
      currentTest <= "NS Car    ";
      CarEW <= '0'; CarNS <= '1'; PedEW <= '0'; PedNS <= '0'; -- NS car arrives
      wait until LightsNS = GREEN;
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- NS car leaves
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green NS
		-- EW Pedestrian briefly presses button 
		-- Lights should change directly to green+walk EW then green EW
      currentTest <= "EW Ped    ";
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '1'; PedNS <= '0'; -- EW ped presses button
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- ped releases button
      wait until LightsEW = WALK;
      wait until LightsEW = GREEN;
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green EW
		-- EW Pedestrian briefly presses button 
		-- Lights should change directly to green+walk EW then back to green EW
      currentTest <= "EW Ped #2 ";
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '1'; PedNS <= '0'; -- EW ped presses button
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- ped releases button
      wait until LightsEW = WALK;
      wait until LightsEW = GREEN;
      wait for 1 us; -- not a realistic delay but speeds up simulation
      
      -- Lights currently green EW
      -- NS Pedestrian briefly presses button 
		-- Lights should change directly to green+walk NS then to green NS
      currentTest <= "NS Ped    ";
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '1'; -- NS ped presses button
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- ped releases button
      wait until LightsNS = WALK;
      wait until LightsNS = GREEN;
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green NS
		-- NS Pedestrian briefly presses button 
		-- Lights should change directly to green+walk NS then back to green NS
      currentTest <= "NS Ped #2 ";
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '1'; -- NS ped presses button
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- ped releases button
      wait until LightsNS = WALK;
      wait until LightsNS = GREEN;
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green NS
		-- EW & NS Cars arrive & wait for the lights to change  
		-- Lights should cycle green EW <=> green NS
      currentTest <= "Cycling   ";
      CarEW <= '1'; CarNS <= '1'; PedEW <= '0'; PedNS <= '0'; -- EW & NS cars arrives
      for count in 1 to 5 loop
         wait until LightsEW = GREEN;
         wait until LightsNS = GREEN;
      end loop;
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- EW car leaves
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green NS
		-- EW & NS Peds arrive & wait for the lights to change 
		-- Lights should cycle walk+green EW => green EW => walk+green NS => green NS
      currentTest <= "Cycling+W ";
      for count in 1 to 5 loop
         CarEW <= '0'; CarNS <= '0'; PedEW <= '1'; PedNS <= '1'; -- EW & NS peds arrives
         wait until falling_edge(clock);
         wait until LightsEW = GREEN;
         wait until LightsNS = GREEN;
      end loop;
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- EW car leaves
      wait for 1 us; -- not a realistic delay but speeds up simulation
      
      complete <= true; -- end simulation
		wait; -- will wait forever
	END PROCESS;

END;
