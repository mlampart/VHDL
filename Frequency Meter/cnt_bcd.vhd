library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;

entity cnt_bcd is	--3 digit BCD counter
	port( clk:	in std_logic;		--input clock being measured
			m_reset:in std_logic;		--m_reset initializes for new bcd measurement
			bcd_enb:in std_logic;		--counter control starts and stops measurement
			full:	out std_logic;		--overflow indicator goes high when count=all 9's
			bcd_u:	out std_logic_vector(3 downto 0);	--bcd outputs of any desired length fr display
			bcd_d:	out std_logic_vector(3 downto 0);
			bcd_h:	out std_logic_vector(3 downto 0)
			);
end cnt_bcd;

architecture ARCH of cnt_bcd is
	signal u_reg, d_reg, h_reg: unsigned(3 downto 0):="0000";
	signal u_nxt, d_nxt, h_nxt: unsigned(3 downto 0):="0000";
	signal IS_999: std_logic;
begin
	-------------------------------
	process(clk, m_reset, bcd_enb) is
		begin
			if m_reset='1' then
				u_reg<="0000";
				d_reg<="0000";
				h_reg<="0000";
				--IS_999<='0';
			elsif bcd_enb='1' then			--do nothing unless enb is high
				if rising_edge(clk) then	--increment unit on every clock edge
					u_reg<=u_nxt;
					d_reg<=d_nxt;
					h_reg<=h_nxt;
				end if;
			end if;
	end process;
	--------NEXT STATE LOGIC-------
	u_nxt<="0000" when u_reg=9 else u_reg+1;
	d_nxt<="0000" when (u_reg=9 and d_reg=9) else d_reg+1 when u_reg=9 else d_reg;
	h_nxt<="0000" when (u_reg=9 and d_reg=9 and h_reg=9) else h_reg+1 when u_reg=9 and d_reg=9 else h_reg;
	IS_999<='1' when u_reg=9 and d_reg=9 and h_reg=9 else '0'; 
	-------------------------------
	bcd_u<=std_logic_vector(u_reg);
	bcd_d<=std_logic_vector(d_reg);
	bcd_h<=std_logic_vector(h_reg);
	full<=IS_999;
end ARCH;