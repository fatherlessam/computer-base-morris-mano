library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_rej is
	port(
		R :in std_logic;
		E :in std_logic;
		I :in std_logic;
		D :in std_logic_vector(7 downto 0);
		T :in std_logic_vector(7 downto 0);
		IR :in std_logic_vector(15 downto 0);
		DR :in std_logic_vector(15 downto 0);
		AC :in std_logic_vector(15 downto 0);
		FGI :in std_logic;
		CLK :in std_logic;
		PC_in :in std_logic_vector(11 downto 0);
		PC_out :out std_logic_vector(11 downto 0)
		);
end PC_rej;

architecture bhv of PC_rej is
	signal temp: std_logic_vector(11 downto 0);
	signal temp_1: unsigned(11 downto 0);
	signal rr : std_logic;
	signal p : std_logic;
begin 
	process(CLK)
	begin
	rr <= (D(7) and not(I) and T(3));
	p <= (D(7) and I and T(3));
	if (rising_edge(CLK)) then 
		if (D(4)='1' and T(4)='1') or (D(5)='1' and T(5)='1') then 
			temp <= PC_in;
		elsif (not(R)='1' and T(1)='1') or (R='1' and T(2)='1') or ((DR = "0000000000000000") and D(6)='1' and T(6)='1')
		or ((AC(15) = '0') and rr='1' and IR(4)='1') or ((AC(15) = '1') and rr='1' and IR(3)='1')
		or (not(AC)="1111111111111111" and rr='1' and IR(2)='1') or (not(E)='1' and rr='1' and IR(1)='1')
		or ((FGI = '1') and p='1' and IR(9)='1') or ((FGI = '1') and p='1' and IR(8)='1')  then 
			temp_1 <= unsigned(PC_in);
			temp <= std_logic_vector(temp_1 + 1);
		elsif (R='1' and T(1)='1') then 
			temp <= (others => '0');
		end if;
	end if;
	end process;
	PC_out <= temp;
end bhv;
