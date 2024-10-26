# Single Cycle RISC-V Core

## Description
This project implements a single-cycle RISC-V CPU based on *Digital Design and Computer Architecture* by Sarah Harris. It supports the RV32I base instruction set and executes each instruction in one clock cycle. The project utilizes Intel Quartus for synthesis and ModelSim-Altera for simulation, targeting the Cyclone IV E FPGA device, specifically the EP4CE22F17C6. The testbench for the core is ad hoc and does not rigorously test all the implemented instructions.

## Documentation

### riscv_cpu_unit Module

Top module for testing the `riscv_cpu`, integrating instruction and data memory while handling external memory write operations and data address management.

### riscv_cpu Module

Single-cycle RISC-V CPU processor module that orchestrates instruction fetching, execution, and memory operations. Integrates a controller for instruction decoding and a datapath for executing instructions, supporting the RV32I instruction set.

### data_mem Module

Data memory module that implements a data memory unit for a RISC-V processor. Supports byte, halfword, and word store/load operations with parameterizable data width, address width, and memory size.

### instr_mem Module

Instruction memory module that fetches 32-bit instructions based on a provided address. Initializes memory with instructions from a hexadecimal file and supports word-aligned memory access.

### reg_file Module

Register file for a single-cycle RISC-V CPU with 32 registers (32 bits each), featuring two combinational read ports and one synchronous write port, where register 0 is hardwired to zero.

### main_decoder Module

Logic for the main decoder in a RISC-V CPU, controlling operation based on the opcode and funct3 signals, handling branching, memory writes, and ALU configurations.

### alu_decoder Module

Decodes the ALU operation based on the opcode, funct3, funct7[5], and ALUOp inputs to generate the corresponding ALU control signals for a RISC-V CPU.

### alu Module

Performs arithmetic and logical operations based on the provided operands, ALU control signals, and flags, generating the ALU output and a zero flag for a RISC-V CPU.

### controller Module

Coordinates the control signals for the RISC-V CPU by decoding instruction opcodes and functions, and generating control signals for ALU operations, memory access, and branching.

### datapath Module

Implements the data processing path of the RISC-V CPU, managing instruction execution, memory access, and control flow, while handling immediate values and ALU operations.

### imm_extend Module

Performs sign extension for various instruction types (I, S, B, J) based on the immediate source selection, producing a 32-bit extended immediate value.
