library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components_init.all;

entity priority_encoder is
  port (
	pe_in : in std_logic_vector(8 downto 0);
	pe_out : out std_logic_vector(2 downto 0)
  ) ;
end entity ; -- priority_encoder

architecture PE of priority_encoder is 

begin

process(pe_in)
variable pe_out_var : std_logic_vector(2 downto 0);
begin
	if pe_in(0) = "1" then 
		pe_out_var := "000";
	elsif pe_in(1) = "1" then
		pe_out_var := "001";
	elsif pe_in(2) = "1" then
		pe_out_var := "010";
	elsif pe_in(3) = "1" then
		pe_out_var := "011";
	elsif pe_in(4) = "1" then
		pe_out_var := "100";
	elsif pe_in(5) = "1" then
		pe_out_var := "101";
	elsif pe_in(6) = "1" then
		pe_out_var := "110";
	elsif pe_in(7) = "1" then
		pe_out_var := "111";
	end if;
pe_out <= pe_out_var;
end process;
end architecture ; -- PE