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
    variable op_val : std_logic_vector(1 downto 0);
    variable in_val : integer;
  begin
    wait for 2 * period;
    reset <= '0';
    wait for 2 * period;

    for i in 0 to 5 loop
      case i is
        when 0 => op_val := "00"; in_val := 5;
        when 1 => op_val := "00"; in_val := 10;
        when 2 => op_val := "10"; in_val := 3;
        when 3 => op_val := "01"; in_val := 50;
        when 4 => op_val := "11"; in_val := 5;
        when others => op_val := "10"; in_val := 10;
      end case;

      op    <= op_val;
      input <= std_logic_vector(to_unsigned(in_val, 8));
      wait for 4 * period;
      execute <= '1';
      wait for 4 * period;
      execute <= '0';
      wait for 10 * period;
    end loop;

    reset <= '1';
    wait for 2 * period;
    reset <= '0';
    wait for 2 * period;

    op    <= "00";
    input <= std_logic_vector(to_unsigned(7, 8));
    wait for 4 * period;
    execute <= '1';
    wait for 4 * period;
    execute <= '0';
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