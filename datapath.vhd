LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY altera_mf;
USE altera_mf.ALL;

ENTITY Datapath IS
	PORT (
		valueselect : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		gclock, greset : IN STD_LOGIC;
		muxout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		instructionout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		branchout, zeroout, memwriteout, regwriteout : OUT STD_LOGIC);
END Datapath;
ARCHITECTURE RTL OF Datapath IS
	SIGNAL branchresult : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL readdata1, readdata2, writedata, selectB, selectPC : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL PCtemp, PC, newPC : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL IRSHL2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ZEROsignal : STD_LOGIC;
	SIGNAL writeregout : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL ALUOPERATION : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL DMEMresult : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL ALUresult : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump : STD_LOGIC;
	SIGNAL flags : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL s0 : STD_LOGIC;

	--component LPM_ROM
	--	PORT
	--	(
	--		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	--		clock		: IN STD_LOGIC  := '1';
	--		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	--	);
	--END component;	

	--component instructionmemory
	--port(
	--	address : in std_logic_vector(7 downto 0);
	--	instruction : out std_logic_vector(31 downto 0));
	--end component;

	COMPONENT rom IS
		PORT (
			address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	COMPONENT ram
		PORT (
			address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			clock : IN STD_LOGIC := '1';
			data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			wren : IN STD_LOGIC;
			q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	--component LPM_RAM
	--	PORT
	--	(
	--		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	--		clock		: IN STD_LOGIC  := '1';
	--		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	--		rden		: IN STD_LOGIC  := '1';
	--		wren		: IN STD_LOGIC ;
	--		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	--	);
	--END component;

	COMPONENT controlunit
		PORT (
			Op : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0 : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT mux_8_2 IS
		PORT (
			a, b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			sel : IN STD_LOGIC;
			y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT registerfile IS
		PORT (
			clk, resetBar : IN STD_LOGIC;
			readRegister1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			readRegister2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			writeRegister : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			writeData : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			RegWrite : IN STD_LOGIC;
			readData1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			readData2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT eightbitfulladder IS
		PORT (
			M : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			N : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Cin : IN STD_LOGIC;
			Cout : OUT STD_LOGIC;
			Sum : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ALUcontrol
		PORT (
			f : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			ALUop : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Operation : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;

	COMPONENT smallAlu IS
		PORT (
			selec : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			ValA, ValB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			ValO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			zero : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT mux3x8
		PORT (
			a, b, c, d, e, f : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			s : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT mux21_5bit
		PORT (
			A, B : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			s : IN STD_LOGIC;
			R : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
	END COMPONENT;

	COMPONENT eightbitregister
		PORT (
			i_resetBar, i_en : IN STD_LOGIC;
			i_clock : IN STD_LOGIC;
			i_Value : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			o_Value : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT shiftleft2 IS
		PORT (
			x : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

BEGIN

	--PC <= "00000000";

	ProgramCounter : eightbitregister PORT MAP(greset, '1', gclock, newPC, PC);

	PCplus4 : eightbitfulladder PORT MAP(PC, "00000100", '0', OPEN, PCtemp);

	INSTRUCTION : rom PORT MAP(PC, IR);

	CONTROL : controlunit PORT MAP(IR(31 DOWNTO 26), RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp(1), ALUOp(0));

	WRITEreg : mux21_5bit PORT MAP(IR(20 DOWNTO 16), IR(15 DOWNTO 11), RegDst, writeregout);

	REGISTERS : registerfile PORT MAP(gclock, greset, IR(25 DOWNTO 21), IR(20 DOWNTO 16), writeregout, writedata, RegWrite, readdata1, readdata2);

	SELECTread2 : mux_8_2 PORT MAP(readdata2, IR(7 DOWNTO 0), ALUSrc, selectB);

	ALUCON : ALUcontrol PORT MAP(IR(5 DOWNTO 0), ALUOp, ALUOPERATION);

	ALU : smallAlu PORT MAP(ALUOPERATION, readdata1, selectB, ALUresult, ZEROsignal);

	DATAMEM : ram PORT MAP(ALUresult, gclock, readdata2, MemWrite, DMEMresult); -- MemRead

	SelECTwrite : mux_8_2 PORT MAP(ALUresult, DMEMresult, MEMtoReg, writedata);

	ADDNEXTPC : eightbitfulladder PORT MAP(PCtemp, IR(7 DOWNTO 0), '0', OPEN, branchresult);

	s0 <= ZEROsignal AND Branch;

	BRANCHSELECT : mux_8_2 PORT MAP(PCtemp, branchresult, s0, selectPC);

	SL2 : shiftleft2 PORT MAP(IR(7 DOWNTO 0), IRSHL2);

	JUMPSELECT : mux_8_2 PORT MAP(selectPC, IRSHL2, Jump, newPC);

	flags <= '0' & REgDst & Jump & MemRead & MemtoReg & AluOp & alusrc;

	muxww : mux3x8 PORT MAP(PC, ALUresult, readdata1, readdata2, writedata, flags, valueselect, muxout);

	instructionout <= IR;
	branchout <= Branch;
	zeroout <= ZEROsignal;
	memwriteout <= MemWrite;
	RegWriteOut <= regWrite;

END RTL;