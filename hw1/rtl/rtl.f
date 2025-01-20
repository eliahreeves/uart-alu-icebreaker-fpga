-I${UART_STL_DIR}/rtl
-I${BASEJUMP_STL_DIR}/bsg_misc

// uart
${UART_STL_DIR}/rtl/uart.v
${UART_STL_DIR}/rtl/uart_rx.v
${UART_STL_DIR}/rtl/uart_tx.v

// multiply
${BASEJUMP_STL_DIR}/bsg_misc/bsg_imul_iterative.sv

// divide
${BASEJUMP_STL_DIR}/bsg_misc/bsg_idiv_iterative.sv
${BASEJUMP_STL_DIR}/bsg_misc/bsg_idiv_iterative_controller.sv
${BASEJUMP_STL_DIR}/bsg_misc/bsg_dff_en.sv
${BASEJUMP_STL_DIR}/bsg_misc/bsg_mux_one_hot.sv
${BASEJUMP_STL_DIR}/bsg_misc/bsg_adder_cin.sv
${BASEJUMP_STL_DIR}/bsg_misc/bsg_counter_clear_up.sv
rtl/config_pkg.sv

rtl/alu.sv
