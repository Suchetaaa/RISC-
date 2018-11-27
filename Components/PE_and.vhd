library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components_init.all;

entity PE_and is
  port (
	AND_input_1 : in std_logic_vector(15 downto 0);
	AND_input_2 : in std_logic_vector(15 downto 0);
	AND_output : out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- PE_and

architecture AND_loop of PE_and is
begin
	AND_output <= AND_input_1 and AND_input_2;

end architecture ; -- AND