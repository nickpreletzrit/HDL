-------------------------------------------------------------------------------
-- nicky p
--  counter top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity counter_top is
	
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
	seven_seg_out	: out std_logic_vector(6 downto 0)
  );
end counter_top;

architecture beh of counter_top is

signal enable 	: std_logic;
signal sum		: std_logic_vector(3 downto 0);
signal sum_sig	: std_logic_vector(3 downto 0);

constant one : std_logic_vector(3 downto 0) := "0001";

component seven_seg is
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
	bcd 			: in std_logic_vector(3 downto 0);
    seven_seg_out          : out std_logic_vector(6 downto 0)
  );  
end component;  

component generic_adder is
	port (
		a       : in  std_logic_vector(3 downto 0);
		b       : in  std_logic_vector(3 downto 0);
		cin     : in  std_logic;
		sum     : out std_logic_vector(3 downto 0);
		cout    : out std_logic
	  );
end component;

component generic_counter is
generic (
    max_count       : integer := 49999999
  );
	port (
		clk             : in  std_logic; 
		reset           : in  std_logic;
		output          : out std_logic
	);  
end component;


begin

u_seven_seg: seven_seg  

  port map(
    clk       => clk,
    reset     => reset,
	bcd		  => sum_sig,
    seven_seg_out    => seven_seg_out
  );
  
  
  u_counter: generic_counter 
 generic map(
    max_count => max_count
  )
  port map(
    clk       => clk,
    reset     => reset,
    output    => enable 
  );
  
    
  u_adder: generic_adder 

  port map(
	a => sum_sig,
	b => one,
	cin => '0',
	cout => open,
    sum    => sum
  );
  
 process(clk,reset)
  begin
    if (reset = '1') then 
      sum_sig <= "0000";
    elsif (clk'event and clk = '1') then
      if (enable = '1') then
		if (sum_sig = "1001") then
			sum_sig <= "0000";
		else
			sum_sig <= sum;
		end if;
      end if; 
    end if;
  end process;
		
  
  
  
end beh;
