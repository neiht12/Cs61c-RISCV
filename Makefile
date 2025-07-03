# Tên file đầu ra
OUT = cpu_tb

# Danh sách file nguồn Verilog
SRC = \
  ALU.v \
  ALU_Decoder.v \
  Branch_Comp.v \
  Control_unit_top.v \
  D_mem.v \
  I_mem.v \
  Imm_gen.v \
  Mux.v \
  PC.v \
  Reg_file.v \
  main_decoder.v \
  Single_Cycle_top.v \
  Single_Cycle_top_tb.v

# Trình biên dịch và tuỳ chọn
IVERILOG = iverilog
VVP = vvp
WAVE = wave.vcd

# Mục tiêu mặc định
all: run

# Biên dịch
compile:
	$(IVERILOG) -o $(OUT).vvp $(SRC)

# Chạy mô phỏng
run: compile
	$(VVP) $(OUT).vvp

# Xoá file tạm
clean:
	rm -f $(OUT).vvp $(WAVE)

# Waveform (nếu bạn có $dumpfile trong testbench)
wave: run
	gtkwave $(WAVE)
