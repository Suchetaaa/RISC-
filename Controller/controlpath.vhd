library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ProcessorComponents.all;
entity controlpath is 
	port (

	--Instruction Register signals
  	ir_enable : out std_logic_1164;

  	-- PC in
  	pc_select : out std_logic_vector(1 downto 0);

  	-- ALU Operation signals
  	alu_op : out std_logic_vector(1 downto 0);
  	-- ALU - a
  	alu_a : out std_logic_vector(1 downto 0);
  	-- ALU - b
  	alu_b : out std_logic_vector(2 downto 0);

  	--Memory address select signals
  	mem_add : out std_logic_vector(1 downto 0);
	--Memory read and write signals
	mem_write : out std_logic_1164;
	mem_read : out std_logic_1164;

	--Register File read and write control signals 
	rf_write : out std_logic_1164;
	rf_read : out std_logic_1164;
	-- Register file - A1
	rf_a1 : out std_logic_1164;
	-- Register file - A3
	rf_a3 : out std_logic_vector(1 downto 0);
	-- Register file - D3
	rf_d3 : out std_logic_vector(1 downto 0);

	--Temporary Registers control signals 
	--T1
	t1 : out std_logic_1164;
	--T2
	t2 : out std_logic_1164;
	--T4
	t4 : out std_logic_1164;
	--T5
	t5 : out std_logic_1164;

	--Carry and Zero flags enable signals
	carry_en : out std_logic_1164;
	zero_en : out std_logic_1164;

	--Continue signal (For instructions like ADC, ADZ etc)
	continue_state : in std_logic_1164;

	--Loop out signal
	loop_out : in std_logic_1164;

	--Zero flag value out 
	zero_out : in std_logic_1164;

	--Carry flag value out
	carry_out : in std_logic_1164;

	--Clock signal in 
	clk : in std_logic_1164;

	--Reset pin 
	rst : in std_logic_1164;

	--Instruction type -----------------------------------------//check
	inst_type: in std_logic_vector(3 downto 0)
);
end entity;

architecture struct of controlpath is
	type FsmState is (S0_reset, S1_hkt, S2_bringregdata, S3_aluopcz, S4_writeback, S5_writebackrb S6_bringimm, S7_storemem, S8_loadfrommem, S9_aluopz, S10_storepc, S11_decpc, S12_pcoff6, S13_pcoff9, S14_t2pc, S15_lmloadreg, S16_checkz2, S17_smstoremem, S18_Pout, S19_dataext, S20_bringimm2);
	signal state: FsmState;
begin
	--determining next state
	process(clk, rst, state, continue_state, loop_out, zero_out, carry_out, inst_type)
  		variable statenext: FsmState;
	begin
		statenext:=S0_reset;
	case state is
		when S0_reset =>  -- First state whenever the code is loaded
        	statenext := S1_hkt;   -- Always the first state of every instruction.
		when S1_hkt =>
        	   if inst_type = '0000' or inst_type = '0100' then
         	   statenext := S2_bringregdata;
       		   elsif inst_type = '0111' or inst_type = '1000' then
          	   statenext := S16_checkz2;
        	   elsif inst_type = '0011' or inst_type = '0011' then
         	   statenext := S6_bringimm;
        	   elsif inst_type = '0101' or inst_type = '0110' then
        	   statenext := S10_storepc;
        	   elsif inst_type = '0010'
		   statenext := S20_bringimm2;
		   else
		   statenext := S0_reset;
                   end if;
		when S2_bringregdata =>  -- For ALU operations: ADD,ADC,ADZ,NDU,NDZ,NDC
		   if continue = '1' then
		   statenext := S3_aluopcz;
		   else 
		   statenext := S1_hkt;
	----------statenext := S9_aluopz
		when S3_aluopcz =>
		statenext := S4_writeback;
	----------statenext := S5_writebackrb
		when S4_writeback => --elementary instructions
		statenext := S1_hkt;
		when S5_writebackrb => -- from ADI
		statenext := S1_hkt;
		when S6_bringimm => --from ADI
		statenext := S3_aluopcz;
	-----------statenext := S9_aluopz
		when s7_storemem
		statenext := S1_hkt; --from Sw
		when S8_loadfrommem
		statenext := S1_hkt; --from Lw
		when S9_aluopz
		statenext := S4_writeback;
	-------------statenext := S8_loadfrommem
		when S10_storepc
		statenext := S13_pcoff9;
		when S11_decpc
		statenext := S1_hkt;
		when S12_pcoff6
		statenext := S11_decpc;
		when S13_pcoff9
		statenext := S1_hkt;
		when S14_t2pc
		statenext := S1_hkt;
		when S15_lmloadreg
		statenext := S1_hkt;
	---------------statenext := S16_lmloadreg
		when S16_checkz2
		statenext := S1_hkt;
	----------------statenext := S15_lmloadreg;
		when S17_smstoremem
		statenext := S18_pout;
		when S18_Pout
		statenext := S1_hkt;
		when S19_dataext
		statenext := S1_hkt;
		when S20_bringimm2
		statenext := S9_aluopz;
	end case;

 if(clk'event and clk = '1') then
      if(rst = '1') then
        state <= S0_reset;
      else
        state <= nstate;
      end if;
    end if;
  end process;
		


------control signal assignments

process(state, zero_flag, zero_out, rst, loop_out)
--Instruction Register signals
  	variable nir_enable : std_logic_1164;
  	variable npc_select : std_logic_vector(1 downto 0);
  	variable nalu_op : std_logic_vector(1 downto 0);
  	variable nalu_a : std_logic_vector(1 downto 0);
  	variable nalu_b : std_logic_vector(2 downto 0);
  	variable nmem_add : std_logic_vector(1 downto 0);
	variable nmem_write : std_logic_1164;
	variable nmem_read : std_logic_1164; 
	variable nrf_write : std_logic_1164;
	variable nrf_read : std_logic_1164;
	variable nrf_a1 : std_logic_1164;
	variable nrf_a3 : std_logic_vector(1 downto 0);
	variable nrf_d3 : std_logic_vector(1 downto 0);
	variable nt1 : std_logic_1164;
	variable nt2 : std_logic_1164;
	variable nt4 : std_logic_1164;
	variable nt5 : std_logic_1164;
	variable ncarry_en : std_logic_1164;
	variable nzero_en : std_logic_1164;
begin

	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';

case state is
	when S0_reset =>
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S1_hkt =>
	nir_enable := '1';
  	npc_select := '01';
  	nalu_op := '11';
  	nalu_a := '01';
  	nalu_b := '001';
	nmem_read := '1';
------------------------------------------------------------------------
  	nmem_add := '00';
	nmem_write := '0';	 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0'; 
	when S2_bringregdata =>
	nrf_write := '1';
	nrf_a1 := '1';
----------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_read := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0'; 
	when S3_aluopcz =>
	ncarry_en := '1';
	nzero_en := '1';
  	nalu_op := '10';
  	nalu_a := '10';
  	nalu_b := '010';
-----------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	
	when S4_writeback =>
	nrf_write : '1';
	nrf_d3 : '01';
-----------------------------------------------------------------------
	nir_enable : '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a : '00';
  	nalu_b : '000';
  	nmem_add : '00';
	nmem_write : '0';
	nmem_read : '0'; 
	nrf_read : '0';
	nrf_a1 : '0';
	nrf_a3 : '00';
	nt1 : '0';
	nt2 : '0';
	nt4 : '0';
	nt5 : '0';
	ncarry_en : '0';
	nzero_en : '0';
	when S5_writebackrb =>
	nrf_a3 := '01';
	nrf_d3 := '01';
	nrf_write := '1';
-----------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_read := '0';
	nrf_a1 := '0';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S6_bringimm =>
	nrf_read := '1';
	nrf_a1 := '1';
	nt2 := '1';
-----------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S7_storemem =>
	nrf_a1 := '1';
	nrf_write := '1';
  	nmem_add := '01';
-----------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_read := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S8_loadfrommem =>
	nrf_a3 := '10';
	nrf_d3 := '11';
  	nmem_add := '01';
	nmem_read := '1'; 
	nrf_write := '1';
-----------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
	nmem_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S9_aluopz =>
  	nalu_op := '10';
  	nalu_a := '10';
  	nalu_b := '010';
	ncarry_en := '1';
------------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	nzero_en := '0';
	when S10_storepc =>
  	nalu_op := '01';
  	nalu_a := '01';
  	nalu_b := '001';
	nrf_a3 := '10';
	nrf_d3 := '10';
	nrf_write := '1';
-----------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_read := '0';
	nrf_a1 := '0';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S11_decpc =>
  	npc_select := '01';
  	nalu_op := '01';
  	nalu_a := '01';
  	nalu_b := '001';
-----------------------------------------------------------------------
	nir_enable := '0';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S12_pcoff6 =>
  	npc_select := '01';
  	nalu_op := '11';
  	nalu_a := '01';
  	nalu_b := '011';
------------------------------------------------------------------------
	nir_enable := '0';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S13_pcoff9 =>
  	npc_select := '01';
  	nalu_op := '11';
  	nalu_a := '01';
  	nalu_b := '100';
--------------------------------------------------------------------------
	nir_enable := '0';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S14_t2pc =>
  	npc_select := '01';
---------------------------------------------------------------------
	nir_enable := '0';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S15_lmloadreg =>
	nrf_a3 := '11';
	nrf_d3 := '11';
  	nmem_add := '10';
	nmem_read := '1'; 
	nrf_write := '1';
	nt4 := '1';
	nt5 := '1';
----------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
	nmem_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nt1 := '0';
	nt2 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S16_checkz2 =>
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S17_smstoremem =>
	nt4 := '1';
	nt5 := '1';
  	nmem_add := '10';
	nmem_write := '1';
	nrf_read := '1';
-------------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S18_Pout =>
	nt4 := '1';
----------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S19_dataext =>
	nrf_write := '1';
	nrf_a3 := '10';
-------------------------------------------------------------------------
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_read := '0';
	nrf_a1 := '0';
	nrf_d3 := '00';
	nt1 := '0';
	nt2 := '0';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
	when S20_bringimm2 =>
	nt1 := '1';
	nt2 := '1';
	nrf_read := '1';
-----------------------------------------------------------------------	
	nir_enable := '0';
  	npc_select := '00';
  	nalu_op := '00';
  	nalu_a := '00';
  	nalu_b := '000';
  	nmem_add := '00';
	nmem_write := '0';
	nmem_read := '0'; 
	nrf_write := '0';
	nrf_a1 := '0';
	nrf_a3 := '00';
	nrf_d3 := '00';
	nt4 := '0';
	nt5 := '0';
	ncarry_en := '0';
	nzero_en := '0';
end case;

if reset = '1'
	ir_enable <= nir_enable;
  	pc_select <= npc_select;
  	alu_op <= nalu_op;
  	alu_a <= nalu_a;
  	alu_b <= nalu_b;
  	mem_add <= nmem_add;
	mem_write <= nmem_write;
	mem_read <= nmem_read; 
	rf_write <= nrf_write;
	rf_read <= nrf_read;
	rf_a1 <= nrf_a1;
	rf_a3 <= nrf_a3;
	rf_d3 <= nrf_d3;
	t1 <= nt1;
	t2<= nt2;
	t4 <= nt4;
	t5 <= nt5;
	carry_en <= ncarry_en;
	zero <= nzero_en;
else
end if;
end process;
end struct;
