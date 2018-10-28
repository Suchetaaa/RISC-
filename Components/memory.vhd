library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ProcessorComponents.all;

--Memory basically takes in the memory read and write signals along with the data in(if needed) and address in to give out data(if needed)
entity memory is
  port (

  	--Clock 
	clk : in std_logic_1164;

	--Memory read and write signals 
	memory_read : in std_logic_1164;
	memory_write : in std_logic_1164;

	--Address in 
	address_in : in std_logic_vector(15 downto 0);

	--Data in 
	data_in : in std_logic_vector(15 downto 0);

	--Data out of the memory 
	data_out : out std_logic_vector(15 downto 0)

  ) ;
end entity ; -- memory

architecture memroy_comp of memory is

	signal 

begin

end architecture ; -- memroy_comp