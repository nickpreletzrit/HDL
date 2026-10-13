-------------------------------------------------------------------------------
-- nick preletz
-- counter test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity counter_tb is
end counter_tb;

architecture arch of counter_tb is

component counter_top is
  generic (
    max_count       : integer := 49999999
  );
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    seven_seg_out          : out std_logic_vector(6 downto 0)
  );  
end component;  

signal output       : std_logic_vector(6 downto 0);
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

uut: counter_top
  generic map (
    max_count => 7
  )
  port map(
    clk       => clk,
    reset     => reset,
    seven_seg_out    => output
  );
end arch;