-------------------------------------------------------------------------------
-- nick preletz
-- addOR test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addOR8bits_tb is
end addOR8bits_tb;

architecture arch of addOR8bits_tb is

component addOR8bits_top is
  port (
    clk             : in std_logic; 
    reset           : in std_logic;
	button			: in std_logic;
    input 			: in std_logic_vector(7 downto 0);
	LED 			: out std_logic_vector(1 downto 0);
    hex_hundreds    : out std_logic_vector(6 downto 0);
    hex_tens        : out std_logic_vector(6 downto 0);
    hex_ones        : out std_logic_vector(6 downto 0)
  );
end component;

signal hex_ones, hex_tens, hex_hundreds       : std_logic_vector(6 downto 0);
signal button		: std_logic;
signal LED	: std_logic_vector(1 downto 0);
signal input : std_logic_vector(7 downto 0);
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
  variable a_val : integer;
  variable b_val : integer;
begin
  button <= '0';
  input  <= (others => '0');
  wait until reset = '0';
  wait for 2 * period;

  for i in 0 to 3 loop -- loop through 4 input pairs
    case i is
      when 0 => a_val := 5;   b_val := 2;
      when 1 => a_val := 2;   b_val := 5;
      when 2 => a_val := 200; b_val := 100;
      when others => a_val := 100; b_val := 200;
    end case;

    input <= std_logic_vector(to_unsigned(a_val, 8)); 
    wait for 2 * period;
    button <= '1';
    wait for  period;
    button <= '0';
	input <= std_logic_vector(to_unsigned(b_val, 8));

    wait for 4 * period;

    wait for 2 * period;
    button <= '1';
    wait for 4 * period;
    button <= '0';
    wait for 10 * period;

    button <= '1';
    wait for 4 * period;
    button <= '0';
    wait for 10 * period;

    button <= '1';
    wait for 4 * period;
    button <= '0';
    wait for 4 * period;
  end loop;

  wait;
end process;

uut: addOR8bits_top
  
  port map(
    clk       => clk,
    reset     => reset,
	input 		=> input,
	button 		=> button,
	LED 		=> LED,
    hex_ones    => hex_ones,
	hex_tens 	=> hex_tens,
	hex_hundreds 	=> hex_hundreds
  );
end arch;