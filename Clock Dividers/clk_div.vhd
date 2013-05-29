library IEEE;
use IEEE.std_logic_1164.all;

entity clk_div is
	generic(MAXD: natural:=5);		--upper bound on divisor
	port( 	clk:	in std_logic;	--input clock
		reset:	in std_logic;	--asynchronous counter reset
		div:	in integer range 0 to MAXD;	--divisor magnitude
		div_clk:out std_logic
	);
end clk_div;

architecture ARCH of clk_div is
	signal counter: integer:=0;
	signal ref: std_logic;
begin
	process(clk, reset)
	begin
		if reset='1' then --asynchronous reset
			counter<=0;			--resets counter
			ref<='0';
		elsif rising_edge(clk) then
			if (counter<(div-1)) then
				counter<=counter+1;
				ref<='0';
			else
				counter<=0;
				ref<='1';
			end if;
		end if;
	end process;
div_clk<=ref;
end ARCH;