library ieee;
use ieee.std_logic_1164.all;      
use ieee.numeric_std.all;

entity FSM is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    op          	  : in std_logic_vector(1 downto 0);
    LED		          : out std_logic_vector(1 downto 0);
	sel 			  : out std_logic_vector(1 downto 0);
	address 		  : out std_logic_vector(1 downto 0)
  );
end FSM;

architecture beh of FSM is
	type state_t is (ADD, SUB, MULT, DIV);
	signal state, next_state: state_t;
	signal addy : std_logic_vector(1 downto 0);

begin


process (clk)		-- state register
begin
    if rising_edge(clk) then
        if reset = '1' then
            state <= ADD;
        else
            state <= next_state;
        end if;
    end if;
end process;

process (state, reset, op)	-- next state logic
begin
    next_state <= state;
    case state is
    when ADD =>
			if reset = '1' then
        next_state <= ADD;
			else
				case op is
					when "00"   => next_state <= ADD;
					when "01"   => next_state <= SUB;
					when "10"   => next_state <= MULT;
					when "11"   => next_state <= DIV;
					when others => next_state <= ADD;
				end case;
			end if;
    when SUB =>
			if reset = '1' then
        next_state <= ADD;
			else
				case op is
					when "00"   => next_state <= ADD;
					when "01"   => next_state <= SUB;
					when "10"   => next_state <= MULT;
					when "11"   => next_state <= DIV;
					when others => next_state <= ADD;
				end case;
			end if;
	when MULT =>
			if reset = '1' then
        next_state <= ADD;
			else
				case op is
					when "00"   => next_state <= ADD;
					when "01"   => next_state <= SUB;
					when "10"   => next_state <= MULT;
					when "11"   => next_state <= DIV;
					when others => next_state <= ADD;
				end case;
			end if;
	when DIV =>
			if reset = '1' then
        next_state <= ADD;
			else
				case op is
					when "00"   => next_state <= ADD;
					when "01"   => next_state <= SUB;
					when "10"   => next_state <= MULT;
					when "11"   => next_state <= DIV;
					when others => next_state <= ADD;
				end case;
			end if;
    end case;
end process;

process (state) 	-- output logic
begin
    LED <= "00";
	
	addy <= "00";
    case state is
        when ADD => 
			LED <= "11";  sel <= "00"; address <= std_logic_vector(unsigned(addy) + 1);
        when SUB => 
			LED <= "10";  sel <= "01"; address <= std_logic_vector(unsigned(addy) + 1);
		when MULT => 
			LED <= "01";  sel <= "10"; address <= std_logic_vector(unsigned(addy) + 1);
		when DIV => 
			LED <= "00";  sel <= "11"; address <= std_logic_vector(unsigned(addy) + 1);
    end case;
end process;

end beh;
