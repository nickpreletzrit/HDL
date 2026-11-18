--------------------------------------------------------------
-- Nick Preletz ----------------------------------------------
--------------------------------------------------------------
entity memory is 
  generic (addr_width : integer := 2;
           data_width : integer := 4);
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    execute : in  std_logic;
    din     : in  std_logic_vector(data_width - 1 downto 0);
    dout    : out std_logic_vector(data_width - 1 downto 0)
  );
end memory;

architecture beh of memory is
type ram_type is array ((2 ** addr_width - 1) downto 0) of std_logic_vector(data_width - 1 downto 0);
signal RAM : ram_type := (others => (others => '0'));

signal address   : unsigned(addr_width - 1 downto 0) := (others => '0');
signal execute_d : std_logic := '0';

begin

process(clk)
begin
  if rising_edge(clk) then
    execute_d <= execute;

    if (reset = '1') then
      address <= (others => '0');
      dout    <= (others => '0');
    elsif (execute = '1' and execute_d = '0') then
      RAM(to_integer(address)) <= din;
      dout    <= din;
      address <= address + 1;
    end if;
  end if;
end process;

end beh;