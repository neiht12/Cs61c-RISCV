# Start simulation
vsim work.Single_Cycle_Top_Tb

# Configure wave window
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -justifyvalue left

# Clock and Reset signals
add wave -divider "Clock & Reset"
add wave -label "clk" /Single_Cycle_Top_Tb/clk
add wave -label "rst_n" /Single_Cycle_Top_Tb/rst_n

# PC and Instruction Fetch
add wave -divider "Program Counter & Instruction"
add wave -label "PC" -radix hex /Single_Cycle_Top_Tb/dut/pc
add wave -label "next_pc" -radix hex /Single_Cycle_Top_Tb/dut/next_pc
add wave -label "pc_plus4" -radix hex /Single_Cycle_Top_Tb/dut/pc_plus4
add wave -label "Instruction" -radix hex /Single_Cycle_Top_Tb/dut/inst

# Instruction Fields
add wave -divider "Instruction Decode"
add wave -label "opcode" -radix bin /Single_Cycle_Top_Tb/dut/inst[6:0]
add wave -label "funct3" -radix bin /Single_Cycle_Top_Tb/dut/inst[14:12]
add wave -label "funct7" -radix bin /Single_Cycle_Top_Tb/dut/inst[31:25]
add wave -label "rs1" -radix unsigned /Single_Cycle_Top_Tb/dut/rs1
add wave -label "rs2" -radix unsigned /Single_Cycle_Top_Tb/dut/rs2
add wave -label "rd" -radix unsigned /Single_Cycle_Top_Tb/dut/rd

# Control Signals
add wave -divider "Control Signals"
add wave -label "RegWEn" /Single_Cycle_Top_Tb/dut/RegWEn
add wave -label "MemRW" /Single_Cycle_Top_Tb/dut/MemRW
add wave -label "ASel" /Single_Cycle_Top_Tb/dut/ASel
add wave -label "BSel" /Single_Cycle_Top_Tb/dut/BSel
add wave -label "PCSel" /Single_Cycle_Top_Tb/dut/PCSel
add wave -label "Jump" /Single_Cycle_Top_Tb/dut/Jump
add wave -label "ALUControl" -radix bin /Single_Cycle_Top_Tb/dut/ALUControl
add wave -label "ImmSel" -radix unsigned /Single_Cycle_Top_Tb/dut/ImmSel
add wave -label "WBSel" -radix unsigned /Single_Cycle_Top_Tb/dut/WBSel

# Register File
add wave -divider "Register File"
add wave -label "rs1_data" -radix hex /Single_Cycle_Top_Tb/dut/rs1_data
add wave -label "rs2_data" -radix hex /Single_Cycle_Top_Tb/dut/rs2_data
add wave -label "reg_write_data" -radix hex /Single_Cycle_Top_Tb/dut/reg_write_data

# Important Registers (x1-x10)
add wave -divider "Key Registers"
add wave -label "x1" -radix decimal /Single_Cycle_Top_Tb/dut/Reg_inst/registers[1]
add wave -label "x2" -radix decimal /Single_Cycle_Top_Tb/dut/Reg_inst/registers[2]
add wave -label "x3" -radix decimal /Single_Cycle_Top_Tb/dut/Reg_inst/registers[3]
add wave -label "x4" -radix decimal /Single_Cycle_Top_Tb/dut/Reg_inst/registers[4]
add wave -label "x5" -radix decimal /Single_Cycle_Top_Tb/dut/Reg_inst/registers[5]
add wave -label "x10" -radix decimal /Single_Cycle_Top_Tb/dut/Reg_inst/registers[10]

# Immediate Generation
add wave -divider "Immediate Generation"
add wave -label "imm_out" -radix hex /Single_Cycle_Top_Tb/dut/imm_out

# ALU
add wave -divider "ALU"
add wave -label "alu_a" -radix hex /Single_Cycle_Top_Tb/dut/alu_a
add wave -label "alu_b" -radix hex /Single_Cycle_Top_Tb/dut/alu_b
add wave -label "alu_result" -radix hex /Single_Cycle_Top_Tb/dut/alu_result
add wave -label "alu_zero" /Single_Cycle_Top_Tb/dut/alu_zero
add wave -label "alu_sign" /Single_Cycle_Top_Tb/dut/alu_sign

# Branch Control
add wave -divider "Branch Control"
add wave -label "branch_taken" /Single_Cycle_Top_Tb/dut/branch_taken
add wave -label "pcsel_branch_or_jump" /Single_Cycle_Top_Tb/dut/pcsel_branch_or_jump
add wave -label "BrUn" /Single_Cycle_Top_Tb/dut/BrUn

# Data Memory
add wave -divider "Data Memory"
add wave -label "dmem_addr" -radix hex /Single_Cycle_Top_Tb/dut/DMEM_inst/addr
add wave -label "dmem_write_data" -radix hex /Single_Cycle_Top_Tb/dut/DMEM_inst/write_data
add wave -label "dmem_read_data" -radix hex /Single_Cycle_Top_Tb/dut/dmem_read_data

# Memory locations (first few)
add wave -divider "Memory Contents"
add wave -label "mem[0]" -radix decimal /Single_Cycle_Top_Tb/dut/DMEM_inst/memory[0]
add wave -label "mem[1]" -radix decimal /Single_Cycle_Top_Tb/dut/DMEM_inst/memory[1]
add wave -label "mem[2]" -radix decimal /Single_Cycle_Top_Tb/dut/DMEM_inst/memory[2]
add wave -label "mem[10]" -radix decimal /Single_Cycle_Top_Tb/dut/DMEM_inst/memory[10]

# Run simulation
run 6000ns

# Zoom to fit and show all signals
wave zoom full
