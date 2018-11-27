library std;
library ieee;
use ieee.std_logic_1164.all;

entity incrementer is
  port (
	data_in : in std_logic_vector(15 downto 0);
	data_out : out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- incrementer

architecture INC of incrementer is

begin

	data_out <= std_logic_vector(unsigned(data_in) + 1);

end architecture ; -- INC