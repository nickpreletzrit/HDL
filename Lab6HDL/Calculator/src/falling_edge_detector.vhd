-------------------------------------------------------------------------------
-- Nick Preletz falling edge detector
-- ** ASSUMES SYNCHED TO CLOCK ALREADY **
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity falling_edge_detector is
  port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    sync_in  : in  std_logic;
    edge_out : out std_logic
  );
end falling_edge_detector;

architecture beh of falling_edge_detector is

signal sync_in_d : std_logic;  

begin
edge_detect : process(reset, clk)
  begin
    if reset = '1' then
      sync_in_d <= '0';
      edge_out  <= '0';
    elsif rising_edge(clk) then
      sync_in_d <= sync_in;
      edge_out  <= sync_in_d and (not sync_in); 
    end if;
end process;

end beh;