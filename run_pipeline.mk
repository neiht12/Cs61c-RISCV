# Makefile for Pipeline RISC-V Simulation

# Compiler
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Files
SOURCES = *.v
TESTBENCH = pipeline_tb
OUTPUT = pipeline_sim
VCD_FILE = pipeline_tb.vcd

# Default target
all: compile run

# Compile all Verilog files
compile:
	$(IVERILOG) -o $(OUTPUT) $(SOURCES)

# Run simulation
run:
	$(VVP) $(OUTPUT)

# View waveform
wave:
	$(GTKWAVE) $(VCD_FILE)

# Clean generated files
clean:
	rm -f $(OUTPUT) $(VCD_FILE)

# Run everything
test: compile run

.PHONY: all compile run wave clean test
