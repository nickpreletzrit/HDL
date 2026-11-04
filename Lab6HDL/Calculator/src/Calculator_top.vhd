-------------------------------------------------------------------------------
-- nicky p
--  8 bit addOR top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity addOR8bits_top is
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
end addOR8bits_top;

architecture beh of addOR8bits_top is

signal input_sync 		: std_logic_vector(7 downto 0);
signal sumOR			: std_logic_vector(8 downto 0);
signal diffOR			: std_logic_vector(8 downto 0);
signal sumORdiff     	: std_logic_vector(8 downto 0);
signal sumORdiff_sync	: std_logic_vector(11 downto 0);
signal onesDD			: std_logic_vector(3 downto 0);
signal tensDD			: std_logic_vector(3 downto 0);
signal hundredsDD		: std_logic_vector(3 downto 0);
signal sel				: std_logic_vector(1 downto 0);
signal load				: std_logic_vector(1 downto 0);
signal reg_a 			: std_logic_vector(7 downto 0);
signal reg_b 			: std_logic_vector(7 downto 0);
signal button_sync		: std_logic;



component double_dabble is
  port (
    result_padded		: in std_logic_vector(11 downto 0);
	ones 				: out std_logic_vector(3 downto 0);
	tens 				: out std_logic_vector(3 downto 0);
	hundreds 			: out std_logic_vector(3 downto 0)
  );
end component;
	
component seven_seg is
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
	bcd 			: in std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );  
  
end component;  

component generic_addOR is
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
end component;

component synchronizer_8bit is

	port (
		clk               : in std_logic;
		reset             : in std_logic;
		async_in          : in std_logic_vector(7 downto 0);
		sync_out          : out std_logic_vector(7 downto 0)
	);  
end component;

component synchronizer_9bit is

	port (
		clk               : in std_logic;
		reset             : in std_logic;
		async_in          : in std_logic_vector(8 downto 0);
		sync_out          : out std_logic_vector(11 downto 0)
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

component FSM is
	 port (
    clk               : in std_logic;
    reset             : in std_logic;
    button            : in std_logic;
    LED		          : out std_logic_vector(1 downto 0);
	load			  : out std_logic_vector(1 downto 0);
	sel 			  : out std_logic_vector(1 downto 0)
  );
  end component;

begin

  U_FSM	: FSM
  
  port map(
	clk => clk,
	reset => reset,
	button => button,
	LED => LED,
	load => load,
	sel => sel
  );
  
  U_DOUBLE_DABBLE : double_dabble  

  port map(
    result_padded 	=> sumORdiff_sync,
	ones		  => onesDD,
	tens		  => tensDD,
	hundreds		  => hundredsDD
  );

  U_HEX_ONES : seven_seg  

  port map(
    clk       => clk,
    reset     => reset,
	bcd		  => onesDD,
    seven_seg_out    => hex_ones
  );
  
  U_HEX_TENS : seven_seg  

  port map(
    clk       => clk,
    reset     => reset,
	bcd		  => tensDD,
    seven_seg_out    => hex_tens
  );
  
  U_HEX_HUNDREDS : seven_seg  

  port map(
    clk       => clk,
    reset     => reset,
	bcd		  => hundredsDD,
    seven_seg_out    => hex_hundreds
  );
  
  u_sync_INPUT: synchronizer_8bit 
  
  port map(
    clk       => clk,
    reset     => reset,
	async_in  => input,
    sync_out    => input_sync 
  );
  
   u_sync_sumORdiff: synchronizer_9bit 
  
  port map(
    clk       => clk,
    reset     => reset,
	async_in  => sumORdiff,
    sync_out    => sumORdiff_sync 
  );   
  
     u_sync_button: synchronizer_1bit 
  
  port map(
    clk       => clk,
    reset     => reset,
	async_in  => button,
    sync_out    => button_sync 
  );   
  
  u_generic_addOR: generic_addOR 
	
  port map(
	clk       => clk,
    reset     => reset,
	a 		  => reg_a,
	b 		  => reg_b,
    sum    => sumOR ,
	diff	=> diffOR
  );
 
 MUX : process(sumOR, diffOR, input_sync, sel)
	begin	
		case sel is	
			when "01" => sumORdiff <= sumOR;
			when "10" => sumORdiff <= diffOR;
			when "11" => sumORdiff <= '0' & input_sync;
			when others => sumORdiff <= (others => '0');
		end case;
	end process;
	
			
reg_AA : process (clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            reg_a <= (others => '0');
        elsif load = "01" then
            reg_a <= input_sync;
        end if;
    end if;
end process;
  
  
  reg_BB : process (clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            reg_b <= (others => '0');
        elsif load = "10" then
            reg_b <= input_sync;
        end if;
    end if;
end process;
  
end beh;
