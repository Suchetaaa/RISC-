library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components_init.all;

entity PE_loopout is
  port (
	pe_loopout_in : in std_logic_vector(15 downto 0);
	pe_loopout_out : out std_logic_1164
  ) ;
end entity ; -- PE_loopout

architecture arch of PE_loopout is

begin
	pe_out <= "1" when pe_loopout_in = "0000000000000000" else "0";

end architecture ; -- arch