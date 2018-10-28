library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ProcessorComponents.all;

entity data_extension is
  port (
	--Doesn't need a clock as whenever the input comes, output should be given. It is a combinational circuit

	data_in : in std_logic_vector(8 downto 0);
	data_out : out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- sign_extender_6

architecture DE of data_extension is

begin
data_out(8 downto 0) <= data_in(8 downto 0);
data_out(15 downto 9) <= "0000000";

end architecture ; -- DE
