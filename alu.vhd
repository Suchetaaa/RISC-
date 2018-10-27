library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.ProcessorComponents.all;
entity ALU is
	port(alu1, alu2: in std_logic_vector(15 downto 0);
		opcode: in std_logic(1 downto 0);
		instcode: in std_logic(1 downto 0);
		alu_out: out std_logic_vector(15 downto 0);
		c: out std_logic;
		z:out std_logic);
end entity;

architecture structure of ALU is 	
	signal outputalu : in std_logic_vector(15 downto 0);
	signal two1 : in std_logic_vector(15 downto 0);
	signal two2 : in std_logic_vector(15 downto 0);
	signal twoadd : in std_logic_vector(15 downto 0);
begin
   two: twoc
        port map (
          input => alu1,
          output => two1
        );
   two1: twoc
        port map (
          input => alu2,
          output => two2
        );
alu_out<=outputalu;
z<='1' when outputalu = "0000000000000000" else '0';
carry1 <= '1' when alu1(15) = '1' and alu2(15) = '1' and
                      two1(14 downto 0) > twoadd(14 downto 0) else '0';
carry2 <= '1' when alu1(15) = '0' and alu2(15) = '0' and
                   alu1(14 downto 0) > outputalu(14 downto 0) else '0';
c<= '1' when carry1 = '1' or carry2 = '1' else '0';
process(alu1, alu2, opcode, instcode)
begin
if(opcode='01')
outputalu<= std_logic_vector(unsigned(alu1) + unsigned(two2));
else if(opcode='10')
	if(instcode='0' )
		outputalu<=std_logic_vector(unsigned(alu1) + unsigned(alu2));
	else 
		outputalu<=(alu1) nand (alu2)
else if(opcode = '11')
outputalu<=std_logic_vector(unsigned(alu1) + unsigned(alu2));
	
