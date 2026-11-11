library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Calculator_tb is
end Calculator_tb;

architecture arch of Calculator_tb is

  component Calculator is
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      execute : in  std_logic;
      input   : in  std_logic_vector(7 downto 0);
      op      : in  std_logic_vector(1 downto 0);
      led     : out std_logic_vector(1 downto 0);
      bcd_0   : out std_logic_vector(6 downto 0);
      bcd_1   : out std_logic_vector(6 downto 0);
      bcd_2   : out std_logic_vector(6 downto 0)
    );
  end component;

  constant period : time := 20 ns;

  signal clk     : std_logic := '0';
  signal reset   : std_logic := '1';
  signal execute : std_logic := '0';
  signal input   : std_logic_vector(7 downto 0) := (others => '0');
  signal op      : std_logic_vector(1 downto 0) := "00";
  signal led     : std_logic_vector(1 downto 0);
  signal bcd_0   : std_logic_vector(6 downto 0);
  signal bcd_1   : std_logic_vector(6 downto 0);
  signal bcd_2   : std_logic_vector(6 downto 0);

begin

  clock : process
  begin
    clk <= not clk;
    wait for period / 2;
  end process;

    stim : process
    -- one calculator operation: set op/input, let them settle through the
    -- synchronizers, pulse execute, then wait for the result to propagate
    procedure do_op (
      constant op_val : in std_logic_vector(1 downto 0);
      constant in_val : in integer
    ) is
    begin
      op    <= op_val;
      input <= std_logic_vector(to_unsigned(in_val, 8));
      wait for 4 * period;
      execute <= '1';
      wait for 2 * period;
      execute <= '0';
      wait for 6 * period;
    end procedure;
  begin

    wait for period / 4;
    wait for 2 * period;
    reset <= '0';
    wait for 2 * period;

    -- fill all four locations
    do_op("00", 6);    -- addr 0: 0 + 6  = 6
    do_op("00", 8);    -- addr 1: 0 + 8  = 8
    do_op("00", 12);   -- addr 2: 0 + 12 = 12
    do_op("00", 4);    -- addr 3: 0 + 4  = 4

    -- address wraps to 0, memory now holds 6, 8, 12, 4
    do_op("10", 3);    -- addr 0: 6  * 3 = 18
    do_op("01", 3);    -- addr 1: 8  - 3 = 5
    do_op("11", 4);    -- addr 2: 12 / 4 = 3
    do_op("10", 5);    -- addr 3: 4  * 5 = 20

    reset <= '1';
    wait for 2 * period;
    reset <= '0';
    wait for 2 * period;
    do_op("00", 7);

    wait;
  end process;

  uut : Calculator
    port map (
      clk     => clk,
      reset   => reset,
      execute => execute,
      input   => input,
      op      => op,
      led     => led,
      bcd_0   => bcd_0,
      bcd_1   => bcd_1,
      bcd_2   => bcd_2
    );

end arch;