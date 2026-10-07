-------------------------------------------------------------------------------
-- Nick Preletz
-- Lab 7 BCD
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      

entity bcd is
  port (
    input           : in std_logic_vector(3 downto 0);
    reset           : in  std_logic;
    output          : out std_logic_vector(3 downto 0);
  );  
end bcd;  

architecture beh of bcd is
	
begin 
	process(reset)
		begin	
		case input is	
			when "0000" => output <= "7b1000000";
			when "0001" => output <= "7b1111001";
			when "0010" => output <= "7b0100100";
			when "0011" => output <= "7b0110000";
			when "0100" => output <= "7b0011001";
			when "0101" => output <= "7b0010010";
			when "0110" => output <= "7b0000010";
			when "0111" => output <= "7b1111000";
			when "1000" => output <= "7b0000000";
			when "1001" => output <= "7b0011000";
		end case;
	end process;

end beh;