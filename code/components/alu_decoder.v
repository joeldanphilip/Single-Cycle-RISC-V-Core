module alu_decoder (
    input            opb5,        // Opcode bit 5 for I-type/R-type differentiation
    input [2:0]      funct3,      // funct3 to differentiate the operation
    input            funct7b5,    // funct7[5] for shifts
    input [1:0]      ALUOp,       // ALUOp from the main decoder
    output reg [2:0] ALUControl   // ALU control signal
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 3'b000;             // Addition (e.g., ADD)
        2'b01: ALUControl = 3'b001;             // Subtraction (e.g., SUB)
        default: begin
            case (funct3) // R-type or I-type ALU
                3'b000: begin
                    // Handle R-type ADD and SUB
                    ALUControl = (funct7b5 & opb5) ? 3'b001 : 3'b000; // SUB / ADD
                end
                3'b001: ALUControl = 3'b111;    // Shift Left (SLL)
                3'b010: ALUControl = 3'b010;    // SLT (Set Less Than)
                3'b011: ALUControl = 3'b110;    // SLTU (Set Less Than Unsigned)
                3'b100: ALUControl = 3'b100;    // XOR (XORI)
                3'b101: begin
                    // Check for Shift Right (SRL or SRA)
                    ALUControl = 3'b101 ; // SRA / SRL
                end
                3'b110: ALUControl = 3'b011;    // OR (ORI)
                3'b111: ALUControl = 3'b010;    // AND (ANDI)
                default: ALUControl = 3'bxxx;   // Undefined
            endcase
        end
    endcase
end

endmodule

