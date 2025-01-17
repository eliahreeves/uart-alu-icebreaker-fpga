
rtl/config_pkg.sv

-DNO_ICE40_DEFAULT_ASSIGNMENTS
${YOSYS_DATDIR}/ice40/cells_sim.v

synth/icestorm_icebreaker/build/synth.v
synth/icestorm_icebreaker/alu_runner.sv


-I${UART_STL_DIR}/rtl
${UART_STL_DIR}/rtl/uart_rx.v
${UART_STL_DIR}/rtl/uart_tx.v