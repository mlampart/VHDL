library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bcd_ctl is
	port( rclk: in std_logic;
			enable: out std_logic;
			mreset: in std_logic
	);
end bcd_ctl;

architecture ARCH of bcd_ctl is
	signal state: std_logic:='0';
begin
	process(state, rclk, mreset) is
		begin
			if mreset='1' then
				enable<='0';
				state<='0';
			elsif rising_edge(rclk) then
				if state='0' then
					state<='1';
					enable<='1';
				else
					enable<='0';
				end if;
			end if;
	end process;
end ARCH;