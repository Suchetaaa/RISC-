library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ProcessorComponents.all;

entity decoder is
  port (
	
	--Doesn't need a clock as it is a combinational circuit
	decoder_input : in std_logic_vector(2 downto 0);
	decoder_output : out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- decoder

architecture DEC of decoder is

begin
	decoder_output <= "01111111" when decoder_input = '000' else
		"10111111" when decoder_input = '001' else
		"11011111" when decoder_input = '010' else 
		"11101111" when decoder_input = '011' else
		"11110111" when decoder_input = '100' else
		"11111011" when decoder_input = '101' else
		"11111101" when decoder_input = '110' else
		"11111110" when decoder_input = '111';

end architecture ; -- DEC