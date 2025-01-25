
# UART ALU

In this assignment I created an Arithmetic Logic Unit (ALU) that can perform a variety of operations on integers. The ALU supports the following operations:

  * Echo back input.
  * Addition on a list of 32-bit integers.
  * Multiplication on a list of 32-bit signed integers.
  * Division on a pair of 32-bit signed integers.
## Dependencies

* <https://github.com/YosysHQ/oss-cad-suite-build/releases>
* <https://github.com/zachjs/sv2v/releases>
* <https://www.xilinx.com/support/download.html>

## Running

```bash
git submodule update --init --recursive

# simulate with Verilator
make sim

# generic synthesis with Yosys, then simulate with Verilator
make gls

# Icebreaker synthesis with Yosys/Icestorm, then simulate with Verilator
make icestorm_icebreaker_gls
# program Icebreaker volatile memory
make icestorm_icebreaker_program
# program Icebreaker non-volatile memory
make icestorm_icebreaker_flash
```

## Important Files

* [alu.sv](./rtl/alu.sv): Contains the UART modules and all parts of the ALU.
* [config_pkg.sv](./rtl/config_pkg.sv): Defines states that are used in [alu.sv](./rtl/alu.sv).
* [alu_tb.sv](./dv/alu_tb.sv): Defines tests that can be run on the ALU.
* [testing_library.py](./testing_library.py): Library for sending command to the FPGA.


