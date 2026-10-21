library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_addOR is
  generic (
    bits : integer := 3
  );
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    a     : in  std_logic_vector(bits-1 downto 0);
    b     : in  std_logic_vector(bits-1 downto 0);
    add   : in  std_logic;
    sub   : in  std_logic;
    sum   : out std_logic_vector(bits downto 0)
  );
end entity generic_addOR;

architecture beh of generic_addOR is
begin
  process (reset, clk)
  begin
    if reset = '1' then
      sum <= (others => '0');
    elsif rising_edge(clk) then
      if add = '1' then
        sum <= std_logic_vector(resize(unsigned(a), bits + 1) + resize(unsigned(b), bits + 1));
      elsif sub = '1' then
        sum <= std_logic_vector(resize(unsigned(a), bits + 1) - resize(unsigned(b), bits + 1));
      end if;
    end if;
  end process;
end beh;