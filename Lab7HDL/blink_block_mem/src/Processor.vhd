-------------------------------------------------------------------------------
-- nick
-- Processor top level
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


entity Processor is
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    execute : in  std_logic;
    ones	: out std_logic_vector(6 downto 0);
    tens	: out std_logic_vector(6 downto 0);
    hundreds	: out std_logic_vector(6 downto 0)	
  );
end Processor;

architecture beh of Calculator_top is


signal input1 : std_logic_vector(7 downto 0);
signal input2 : std_logic_vector(7 downto 0);
signal alu_op 	  :	std_logic_vector(1 downto 0);
signal execute_sync : std_logic;



component synchronizer_8bit is

	port (
		clk               : in std_logic;
		reset             : in std_logic;
		async_in          : in std_logic_vector(7 downto 0);
		sync_out          : out std_logic_vector(7 downto 0)
	);  
end component;


component double_dabble is
    port (
      binary_in       : in std_logic_vector(11 downto 0);
      ones            : out std_logic_vector(3 downto 0);
      tens            : out std_logic_vector(3 downto 0);
      hundreds        : out std_logic_vector(3 downto 0)
    );  
  end component;
  
  component alu is
    port (
      reset         : in  std_logic;
      a             : in  std_logic_vector(7 downto 0); 
      b             : in  std_logic_vector(7 downto 0);
      op            : in  std_logic_vector(1 downto 0); -- 00: add, 01: sub, 10: mult, 11: div
      result        : out std_logic_vector(7 downto 0)
    );  
  end component;
  
  component synchronizer_1bit is 
    port (
      clk               : in std_logic;
      reset             : in std_logic;
      async_in          : in std_logic;
      sync_out          : out std_logic
    );
  end component;
  
  component seven_seg is
    port (
	  clk               : in std_logic;
      reset             : in std_logic;
      bcd             : in std_logic_vector(3 downto 0);
      seven_seg_out   : out std_logic_vector(6 downto 0)
    );  
  end component; 
  
   component memory is 
    generic (addr_width : integer := 2;
            data_width : integer := 8);
    port (
      clk               : in std_logic;
      we                : in std_logic;
      execute 			: in  std_logic;
      din               : in std_logic_vector(data_width - 1 downto 0);
      dout              : out std_logic_vector(data_width - 1 downto 0)
    );
  
begin



  u_alu : alu
    port map (
      reset  => reset,
      a      => memory_out,
      b      => input_sync(7 downto 0),
      op     => alu_op,
      result => ALU_output
    );
	
  u_execute_sync : synchronizer_1bit
    port map (
      clk      => clk,
      reset    => reset,
      async_in => execute,
      sync_out => execute_sync
    );
	
  u_instructions : blink_block_mem
	port map (
		clk => clk,
		reset => reset,
		output => input1,
		op	=> alu_op
	);
	
  u_mem : memory
    generic map (addr_width => 2, data_width => 8)
    port map (
      clk  => clk,
      execute   => execute_sync,
      din  => result_sync,
      dout => memory_out
    );

  u_result_sync : synchronizer_8bit
    port map (
      clk      => clk,
      reset    => reset,
      async_in => ALU_output,
      sync_out => result_sync
    );
	
	result_padded <= "0000" & memory_out;
	
  u_dd : double_dabble
    port map (
      binary_in => result_padded,
      ones      => ones,
      tens      => tens,
      hundreds  => hundreds
    );

	 u_seg_ones : seven_seg
    port map (
		clk    => clk,
		reset  => reset,
		bcd    => ones,
		seven_seg_out  => bcd_0
	);  
	
	 u_seg_tens : seven_seg
    port map (
		clk    => clk,
		reset  => reset,
		bcd    => tens,
		seven_seg_out  => bcd_1
	);  
	
	
	 u_seg_hundreds : seven_seg
    port map (
		clk    => clk,
		reset  => reset,
		bcd    => hundreds,
		seven_seg_out  => bcd_2
	);  
	
	
	

end beh;