library ieee;
use ieee.std_logic_1164.all;      

entity FSM is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    button            : in std_logic;
    LED		          : out std_logic_vector(1 downto 0);
	load			  : out std_logic_vector(1 downto 0);
	sel 			  : out std_logic_vector(1 downto 0)
  );
end FSM;

architecture beh of FSM is
	type state_t is (INPUT_A, INPUT_B, SUM, DIFF);
	signal state, next_state: state_t;


begin


process (clk)		-- state register
begin
    if rising_edge(clk) then
        if reset = '1' then
            state <= INPUT_A;
        else
            state <= next_state;
        end if;
    end if;
end process;

process (state, reset, button)	-- next state logic
begin
    next_state <= state;
    case state is
        when INPUT_A =>
            if reset = '1' then
				next_state <= INPUT_A;
            elsif button = '1' then
                next_state <= INPUT_B;
            end if;
        when INPUT_B =>
			if reset = '1' then
				next_state <= INPUT_A;
            elsif button = '1' then
                next_state <= SUM;
            end if;
		when SUM =>
            if reset = '1' then
				next_state <= INPUT_A;
            elsif button = '1' then
                next_state <= DIFF;
            end if;
		when DIFF =>
            if reset = '1' then
				next_state <= INPUT_A;
            elsif button = '1' then
                next_state <= INPUT_A;
            end if;
    end case;
end process;

process (state) 	-- output logic
begin
    LED <= "00";
	sel <= "00";
	load <= "00";
    case state is
        when INPUT_A => 
			LED <= "11"; load <= "01"; sel <= "00";
        when INPUT_B => 
			LED <= "10"; load <= "10"; sel <= "00";
		when SUM => 
			LED <= "01"; load <= "00"; sel <= "01";
		when DIFF => 
			LED <= "00"; load <= "00"; sel <= "10";
    end case;
end process;

end beh;
