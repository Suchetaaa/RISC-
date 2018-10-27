library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ProcessorComponents.all;

entity data_path is
  port (

  	--Instruction Register signals
  	ir_enable : in std_logic_1164;

  	-- PC in
  	pc_select : in std_logic_vector(1 downto 0);

  	-- ALU Operation signals
  	alu_op : in std_logic_vector(1 downto 0);
  	-- ALU - a
  	alu_a : in std_logic_vector(1 downto 0);
  	-- ALU - b
  	alu_b : in std_logic_vector(2 downto 0);

  	--Memory address select signals
  	mem_add : in std_logic_vector(1 downto 0);
	--Memory read and write signals
	mem_write : in std_logic_1164;
	mem_read : in std_logic_1164;

	--Register File read and write control signals 
	rf_write : in std_logic_1164;
	rf_read : in std_logic_1164;
	-- Register file - A1
	rf_a1 : in std_logic_1164;
	-- Register file - A3
	rf_a3 : in std_logic_vector(1 downto 0);
	-- Register file - D3
	rf_d3 : in std_logic_vector(1 downto 0);

	--Temporary Registers control signals 
	--T1
	t1 : in std_logic_1164;
	--T2
	t2 : in std_logic_1164;
	--T4
	t4 : in std_logic_1164;
	--T5
	t5 : in std_logic_1164;

	--Carry and Zero flags enable signals
	carry_en : in std_logic_1164;
	zero_en : in std_logic_1164;

	--Continue signal (For instructions like ADC, ADZ etc)
	continue_state : out std_logic_1164;

	--Loop out signal
	loop_out : out std_logic_1164;

	--Zero flag value out 
	zero_out : out std_logic_1164;

	--Carry flag value out
	carry_out : out std_logic_1164;

	--Clock signal in 
	clk : in std_logic_1164;

	--Reset pin 
	rst : in std_logic_1164;

	--Instruction type -----------------------------------------//check
	inst_type: out OperationCode;

	--Data coming into datapath (for testbench only, no other purpose as such)
	ext_address : n std_logic_vector(15 downto 0);
	ext_data: in std_logic_vector(15 downto 0);
    ext_memorywrite_enable: in std_logic_1164;
    ext_pc: out std_logic_vector(15 downto 0);
    ext_ir: out std_logic_vector(15 downto 0);
    ext_r0: out std_logic_vector(15 downto 0);
    ext_r1: out std_logic_vector(15 downto 0);
    ext_r2: out std_logic_vector(15 downto 0);
    ext_r3: out std_logic_vector(15 downto 0);
    ext_r4: out std_logic_vector(15 downto 0);
    ext_r5: out std_logic_vector(15 downto 0);
    ext_r6: out std_logic_vector(15 downto 0)
	
  ) ;
end entity ; -- data_path

architecture compute of data_path is

	-- The signals defined here are the data values moving in the wires inside the datapath

	-- ALU signals 
	signal alu_operation : std_logic_vector(1 downto 0); 
	signal alu_in_a : std_logic_vector(15 downto 0);
	signal alu_in_b : std_logic_vector(15 downto 0);
	signal alu_out : std_logic_vector(15 downto 0);
	signal alu_carryflag : std_logic_1164;
	signal alu_zeroflag : std_logic_1164;

	--Signals for temporary registers 
	--T1
	signal T1_data : std_logic_vector(15 downto 0);
	--T2
	signal T2_data : std_logic_vector(15 downto 0);
	--T3
	signal T3_data : std_logic_vector(15 downto 0);
	--T4
	signal T4_data : std_logic_vector(15 downto 0);
	--T5 
	signal T5_data : std_logic_vector(15 downto 0);
	--T6 
	signal T6_data : std_logic_vector(15 downto 0);

	--Register file signal/wire values
	signal adr1_read : std_logic_vector(2 downto 0);
	signal adr2_read : std_logic_vector(2 downto 0);
	signal data1_read : std_logic_vector(15 downto 0);
	signal data2_read : std_logic_vector(15 downto 0);
	signal adr3_write : std_logic_vector(2 downto 0);
	signal data3_write : std_logic_vector(15 downto 0);

	--PC in and out signal values 
	signal PC_in : std_logic_vector(15 downto 0);
	signal PC_out : std_logic_vector(15 downto 0);

	--Memory signal values 
	signal mem_addr_in : std_logic_vector(15 downto 0);
	signal mem_data_in : std_logic_vector(15 downto 0);
	signal mem_data_out : std_logic_vector(15 downto 0);

	--LM, SM instruction loop signal values 
	signal PE_out : std_logic_vector(15 downto 0);
	--Inputs and outputs of AND gate present in the LM,SM circuit
	signal AND_a : std_logic_vector(15 downto 0);
	signal AND_b : std_logic_vector(15 downto 0);
	signal AND_out : std_logic_vector(15 downto 0);
	--Output of the decoder which is going into the AND gate
	signal decoder_out : std_logic_vector(15 downto 0);

	--Sign extender output values 
	signal SE6_out : std_logic_vector(15 downto 0);
	signal SE9_out : std_logic_vector(15 downto 0);

begin
	
	--Assigning values to the signals based on the input control signals given as port-in

	--ALU inputs - a and b
	

end architecture ; -- compute




