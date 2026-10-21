-------------------------------------------------------------------------------
-- nick preletz
-- addOR test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addOR_tb is
end addOR_tb;

architecture arch of addOR_tb is

component addOR_top is
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    add             : in  std_logic;
    sub             : in  std_logic;
    a     	        : in  std_logic_vector(2 downto 0);
    b      	        : in  std_logic_vector(2 downto 0);
    hex_a           : out  std_logic_vector(6 downto 0);
    hex_b           : out  std_logic_vector(6 downto 0);
    hex_sumOR       : out  std_logic_vector(6 downto 0)
  );
end component;

signal hex_a, hex_b, hex_sumOR       : std_logic_vector(6 downto 0);
signal a, b		: std_logic_vector(2 downto 0);
signal add, sub	: std_logic;

constant period     : time := 20ns;                                              
signal clk          : std_logic := '0';
signal reset        : std_logic := '1';

begin

-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process; 
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset <= '0';
    wait;
end process; 

 stim : process
begin
  wait for 10 ns;
  for i in 0 to 2 loop
    case i is
      when 0 => add <= '1'; sub <= '0';
      when 1 => add <= '0'; sub <= '1';
      when others => add <= '0'; sub <= '0';
    end case;

    a <= (others => '0');
    for j in 0 to 7 loop
      b <= (others => '0');
      for k in 0 to 7 loop
        wait for 4 * period;
        b <= std_logic_vector(unsigned(b) + 1);
      end loop;
      a <= std_logic_vector(unsigned(a) + 1);
    end loop;
  end loop;
  wait;
end process;

uut: addOR_top
  
  port map(
    clk       => clk,
    reset     => reset,
	a 		=> a,
	b 		=> b,
	add => add,
	sub => sub,
    hex_a    => hex_a,
	hex_b 	=> hex_b,
	hex_sumOR 	=> hex_sumOR
  );
end arch;