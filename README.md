# 🚀 RISC-V Processor - CS61C Style

## 📚 Mô tả dự án

Đây là một bộ xử lý RISC-V đơn chu kỳ được xây dựng theo phong cách kiến trúc giảng dạy của khóa học [CS61C](https://inst.eecs.berkeley.edu/~cs61c/) tại UC Berkeley. Mục tiêu của dự án là cung cấp một mô hình trực quan, đơn giản nhưng đầy đủ chức năng của một bộ xử lý thực hiện các lệnh cơ bản trong tập lệnh [RV32I](https://en.wikipedia.org/wiki/RISC-V#Base_instruction_formats).

## 🧠 Kiến trúc hỗ trợ

- Kiến trúc: `RV32I`
- Thiết kế: **Single-cycle (đơn chu kỳ)**
- Các thành phần chính:
  - `Program Counter (PC)`
  - `Instruction Memory`
  - `Register File`
  - `ALU (Arithmetic Logic Unit)`
  - `Immediate Generator`
  - `Control Unit`
  - `MUXes`
  - `Data Memory`

> Thiết kế này tương thích với các lab CS61C (lab 4~7) và tuân thủ sơ đồ datapath tiêu chuẩn trong sách *Computer Organization and Design - Patterson & Hennessy*.

## ✅ Các lệnh hỗ trợ

- **R-type**: `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
- **I-type**: `addi`, `andi`, `ori`, `lw`, `jalr`
- **S-type**: `sw`
- **B-type**: `beq`, `bne`, `blt`, `bge`
- **U-type**: `lui`, `auipc`
- **J-type**: `jal`

## 📁 Cấu trúc thư mục

```plaintext
.
├── src/
│   ├── ALU.v
│   ├── ALUControl.v
│   ├── ControlUnit.v
│   ├── Datapath.v
│   ├── RegisterFile.v
│   ├── Memory.v
│   ├── Top.v
│   └── ...
├── testbench/
│   └── tb_RISCV.v
├── programs/
│   └── test_program.mem
├── README.md
