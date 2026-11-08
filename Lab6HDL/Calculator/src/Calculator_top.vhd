-------------------------------------------------------------------------------
-- nick
-- calculator top level
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity Calculator is
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
end Calculator;

architecture beh of Calculator is
  signal op_sync      : std_logic_vector(1 downto 0);
  signal alu_op       : std_logic_vector(1 downto 0);
  signal address      : std_logic_vector(1 downto 0);
  signal address_sync : std_logic_vector(1 downto 0);

  signal input_sync   : std_logic_vector(7 downto 0);
  signal ALU_output   : std_logic_vector(7 downto 0);

  signal we     	  : std_logic;
  signal memory_out   : std_logic_vector(7 downto 0);
  signal result_sync  : std_logic_vector(7 downto 0);
  signal result_padded : std_logic_vector(11 downto 0);

  signal ones         : std_logic_vector(3 downto 0);
  signal tens         : std_logic_vector(3 downto 0);
  signal hundreds     : std_logic_vector(3 downto 0);
  signal thousands    : std_logic_vector(3 downto 0);
  
begin

  u_op_sync : synchronizer_2bit
    port map (
      clk      => clk,
      reset    => reset,
      async_in => op,
      sync_out => op_sync
    );

  u_fsm : FSM
    port map (
      clk     => clk,
      reset   => reset,
      op      => op_sync,
      LED     => led,
      sel     => alu_op,
      address => address
    );

  u_addr_sync : synchronizer_2bit
    port map (
      clk      => clk,
      reset    => reset,
      async_in => address,
      sync_out => address_sync
    );

  u_input_sync : synchronizer_8bit
    port map (
      clk      => clk,
      reset    => reset,
      async_in => input,
      sync_out => input_sync
    );

  u_alu : alu
    port map (
      reset  => reset,
      a      => memory_out,
      b      => input_sync(7 downto 0),
      op     => alu_op,
      result => ALU_output
    );

  u_we_sync : synchronizer_1bit
    port map (
      clk      => clk,
      reset    => reset,
      async_in => execute,
      sync_out => we
    );

  u_mem : memory
    generic map (addr_width => 2, data_width => 8)
    port map (
      clk  => clk,
      we   => we,
      addr => address_sync,
      din  => ALU_output,
      dout => memory_out
    );

  u_result_sync : synchronizer_8bit
    port map (
      clk      => clk,
      reset    => reset,
      async_in => ALU_output,
      sync_out => result_sync
    );
	
	result_padded <= "0000" & result_sync;
	
  u_dd : double_dabble
    port map (
      binary_in => result_padded,
      ones      => ones,
      tens      => tens,
      hundreds  => hundreds,
      thousands => thousands
    );

  u_seg0 : seven_seg port map (bcd => ones,     seven_seg_out => bcd_0);
  u_seg1 : seven_seg port map (bcd => tens,     seven_seg_out => bcd_1);
  u_seg2 : seven_seg port map (bcd => hundreds, seven_seg_out => bcd_2);

end beh;