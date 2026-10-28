library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_addOR is
  generic (
    bits : integer := 8
  );
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    a     : in  std_logic_vector(bits-1 downto 0);
    b     : in  std_logic_vector(bits-1 downto 0);
    sum   : out std_logic_vector(bits downto 0);
    diff  : out std_logic_vector(bits downto 0)	
  );
end entity generic_addOR;

architecture beh of generic_addOR is
begin
  sum <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
  diff <= std_logic_vector(unsigned('0' & a) - unsigned('0' & b));
end beh;