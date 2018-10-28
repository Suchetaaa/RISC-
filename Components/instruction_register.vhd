library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ProcessorComponents.all;

--All the signals you want from the instruction used for next state logic, branches etc
--Takes in the instruction and gives the necessary information about the instruction 
entity instruction_register is
  port (
	--Doesnt need a clock, just a decoder type of circuit 
	instruction : in std_logic_vector(15 downto 0);
	instruction_operation : out std_logic_1164;
	instruction_carry : out std_logic_1164;
	instruction_zero : out std_logic_1164
  ) ;
end entity ; -- instruction_register

architecture IR of instruction_register is

	signal OP : std_logic_vector(3 downto 0);

begin
	OP <= instruction(15 downto 12);
	process(OP)
	begin 
		



end architecture ; -- IR

