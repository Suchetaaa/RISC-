library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ProcessorComponents.all;

entity continue_decoder is
  port (
	cz_condition : in std_logic_vector(1 downto 0);
	carry_flag : in std_logic_1164;
	zero_flag : in std_logic_1164;
	continue : out std_logic_1164
  ) ;
end entity ; -- continue_decoder

architecture CD of continue_decoder is

	signal 

begin
	process(cz_condition, carry_flag, zero_flag)
	variable continue_var := '0';
	begin
		if cz_condition = '00' then 
			continue := '1';
		end if;
		if cz_condition = '10' then 
			continue := carry_flag;
		end if;
		if cz_condition := '01' then 
			continue := zero_flag;
		end if;
		if cz_condition := '11' then 
			continue := zero_flag and carry_flag;
		end if;
	end process;

end architecture ; -- CD