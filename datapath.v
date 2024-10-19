// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         PCSrc, ALUSrc,    // ALUSrc chooses between register and immediate
    input         RegWrite,
    input [1:0]   ImmSrc,
    input [2:0]   ALUControl,
    input         Jalr,
    output        Zero,ALUR31,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

wire [31:0] PCNext, PCJalr, PCPlus4, PCTarget, AuiPC, lAuiPC;
wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult;

// Extend the immediate depending on the instruction type (sign-extended or zero-extended)
imm_extend ext (Instr[31:7], ImmSrc, ImmExt);

// ALU logic: ALUSrc controls whether to pass the immediate or the register value (WriteData) to the ALU
mux2 #(32)     srcbmux(WriteData, ImmExt, ALUSrc, SrcB); // Choose between immediate and rs2

// ALU Operation
alu            alu (SrcA, SrcB, ALUControl, Instr[30], Instr[12], ALUResult, Zero); // ALU takes SrcA and SrcB as inputs

// Remaining Datapath Logic (unchanged)
mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
mux2 #(32)     jalrmux(PCNext, ALUResult, Jalr, PCJalr);

reset_ff #(32) pcreg(clk, reset, PCJalr, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);
adder          pcaddbranch(PC, ImmExt, PCTarget);

reg_file       rf (clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, SrcA, WriteData);
adder #(32)    auipcadder({Instr[31:12], 12'b0}, PC, AuiPC);
mux2 #(32)     lauipcmux (AuiPC,{Instr[31:12], 12'b0}, Instr[5], lAuiPC);

// Result Source
mux4 #(32)     resultmux(ALUResult, ReadData, PCPlus4, lAuiPC, ResultSrc, Result);

assign ALUR31 = ALUResult[31];  // Sign bit of ALU result (for comparisons)
assign Mem_WrData = WriteData;  // Data to be written to memory
assign Mem_WrAddr = ALUResult;  // Memory address to write to

endmodule
