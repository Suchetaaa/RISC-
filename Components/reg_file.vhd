library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ProcessorComponents.all;

entity reg_file is
  port (

  	--Clock 
	clk : in std_logic_1164;

	--Register file read and write signals 
	--1 corresponds to read and 0 nothing for both
	reg_file_read : in std_logic_1164; 
	reg_file_write : in std_logic_1164;

	--PC in to check if some other source is writing to PC (pc_select = "00" corresponds to none)
	PC_write_rf : in std_logic_vector(1 downto 0);

	--Address - 1 signal value 
	address_1 : in std_logic_vector(15 downto 0);
	--Address - 2 signal value 
	address_2 : in std_logic_vector(15 downto 0);
	--Address - 3 signal value for writing to A3
	address_3 : in std_logic_vector(15 downto 0);

	--Data in and out signal values 
	data_in : in std_logic_vector(15 downto 0);
	data_out_1 : out std_logic_vector(15 downto 0);
	data_out_2 : out std_logic_vector(15 downto 0)

  ) ;
end entity ; -- reg_file

architecture rf of reg_file is

	signal reg_0 : std_logic_vector(15 downto 0);
	signal reg_1 : std_logic_vector(15 downto 0);
	signal reg_2 : std_logic_vector(15 downto 0);
	signal reg_3 : std_logic_vector(15 downto 0);
	signal reg_4 : std_logic_vector(15 downto 0);
	signal reg_5 : std_logic_vector(15 downto 0);
	signal reg_6 : std_logic_vector(15 downto 0);
	signal reg_7 : std_logic_vector(15 downto 0);

begin
	--Process and clock is given only for writing to registers as writing occurs at the clock edge
	process(clk) is 
	begin
		--Rising edge of the clock
		if (clk'event and clk = '1') then 
			if (reg_file_write = '1') and PC_write_rf /= "00" then 
				if address_3 = "000" then 
					reg_0 <= data_in;
				end if;
				if address_3 = "001" then 
					reg_1 <= data_in;
				end if;
				if address_3 = "010" then 
					reg_2 <= data_in;
				end if;
				if address_3 = "011" then 
					reg_3 <= data_in;
				end if;
				if address_3 = "100" then 
					reg_4 <= data_in;
				end if;
				if address_3 = "101" then 
					reg_5 <= data_in;
				end if;
				if address_3 = "110" then 
					reg_6 <= data_in;
				end if;
			end if;
			if (reg_file_write = '1') and PC_write_rf = "00" then 
				reg_7 <= data_in;
			end if;
		end if;
		--Writing to registers done!!!
	end process;

	--Reading from registers can happen anytime, so no process
	if (reg_file_read = '1')
		if address_1 = "000" then
			data_out_1 <= reg_0;
		end if;
		if address_1 = "001" then
			data_out_1 <= reg_1;
		end if;
		if address_1 = "010" then
			data_out_1 <= reg_2;
		end if;
		if address_1 = "011" then
			data_out_1 <= reg_3;
		end if;
		if address_1 = "100" then
			data_out_1 <= reg_4;
		end if;
		if address_1 = "101" then
			data_out_1 <= reg_5;
		end if;
		if address_1 = "110" then
			data_out_1 <= reg_6;
		end if;
		if address_1 = "111" then
			data_out_1 <= reg_7;
		end if;
		--Address 2 
		if address_2 = "000" then
			data_out_2 <= reg_0;
		end if;
		if address_2 = "001" then
			data_out_2 <= reg_1;
		end if;
		if address_2 = "010" then
			data_out_2 <= reg_2;
		end if;
		if address_2 = "011" then
			data_out_2 <= reg_3;
		end if;
		if address_2 = "100" then
			data_out_2 <= reg_4;
		end if;
		if address_2 = "101" then
			data_out_2 <= reg_5;
		end if;
		if address_2 = "110" then
			data_out_2 <= reg_6;
		end if;
		if address_2 = "111" then
			data_out_2 <= reg_7;
		end if;

end architecture

		






end architecture ; -- rf