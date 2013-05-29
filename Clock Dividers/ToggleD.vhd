library IEEE;
use IEEE.std_logic_1164.all;
use WORK.MyDeclares.all;

entity ToggleD is
	port( clk50: in std_logic;
			S: in std_logic; --S input will come from an active low push button
			reset: 	in std_logic; --reset =>'1' reset Q to '0'.
			Q: 	 	out std_logic --output state toggles when S goes low 
	);
end ToggleD;

architecture ToggleD_ARCH of ToggleD is
-------------------
signal LFSR: std_logic_vector(2 downto 0); --this guy will sample the switch signal
signal BUFF: std_logic; --buffer output
signal debouncedQ: std_logic; --this is the final correct signal output
signal ref: std_logic; --the divided clock
signal output: std_logic;
-------------------
constant ONES: STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS=>'1'); --constants for shift register comparison
constant ZEROES: STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS=>'0');
-------------------
begin	
--==Clock Divider==--
	DIV: clk_div  --clock divider from Lab2B
		generic map(MAXD=>100_000_000)
		port map(
			clk=>clk50, 
			reset=>reset,
			div=>(50_000/30), --dividing clock down to 1000Hz, or a 1msec sample rate
			div_clk=>ref
		);
--==Latch State==--
	MIKE_DFACE: DFACE --need this to start and stop everything
		port map( 
			D=>not output,
			CE=>'1',
			CLR=>reset,
			Q=>output,
			C=>debouncedQ
		);
--==Output Signal Process==--
process(ref)is
begin
	if rising_edge(ref) then
		LFSR<=LFSR(1 downto 0) & BUFF; --shift in values of the switch signal on the clock edge
	end if;
end process;
---==NEXT STATE LOGIC==--
process(ref, LFSR) is
begin
	if rising_edge(ref) then			--compare to all 1's or all 0's and set signal accordingly
		if LFSR=ONES then
			debouncedQ<='1';
		else
			debouncedQ<='0'; 
		end if;
	end if;
end process;
Q<=output;	
---------------------------------
BUFF<=not S;
end ToggleD_ARCH;