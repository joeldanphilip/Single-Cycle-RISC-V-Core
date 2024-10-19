`timescale 1 ns/1 ns

module tb;

// registers to send data
reg clk;
reg reset;
reg Ext_MemWrite;
reg [31:0] Ext_WriteData, Ext_DataAdr;

// Wire Ouputs from Instantiated Modules
wire [31:0] WriteData, DataAdr, ReadData;
wire MemWrite;
wire [31:0] PC, Result;

// Initialize Top Module
riscv_cpu_unit uut (clk, reset, Ext_MemWrite, Ext_WriteData, Ext_DataAdr, MemWrite, WriteData, DataAdr, ReadData, PC, Result);

// generate clock to sequence tests
always begin
    clk <= 1; # 5; clk <= 0; # 5;
end



// test the book asm program
always @(negedge clk) begin
    # 10;
    if(MemWrite && !reset) begin
        if(DataAdr === 100 & WriteData === 25) begin
            $display("Simulation succeeded");
            $stop;
        end
        else if (DataAdr !== 96) begin
            $display("Simulation failed");
            $stop;
        end
    end
end


endmodule
