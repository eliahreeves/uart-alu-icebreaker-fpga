/**
 * PLL configuration
 *
 * This Verilog header file was generated partially automatically
 * using the icepll tool from the IceStorm project.
 * It is intended for use with FPGA primitives SB_PLL40_CORE,
 * SB_PLL40_PAD, SB_PLL40_2_PAD, SB_PLL40_2F_CORE or SB_PLL40_2F_PAD.
 * Use at your own risk.
 *
 * Given input frequency:        12.000 MHz
 * Requested output frequency:   60.000 MHz
 * Achieved output frequency:    60.000 MHz
 */
module pll #(
    parameter DIVR    =  0,
    parameter DIVF    = 79,
    parameter DIVQ    =  4,
    parameter FLT_RNG =  1 ) (
	
    input  clock_in,
	output clock_out,
	output locked
	);

SB_PLL40_PAD #(
		.FEEDBACK_PATH("SIMPLE"),
		.DIVR(DIVR),        // DIVR =  0
		.DIVF(DIVF),        // DIVF = 79
		.DIVQ(DIVQ),        // DIVQ =  4
		.FILTER_RANGE(FLT_RNG) // FILTER_RANGE = 1
	) uut (
		.LOCK(locked),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.PACKAGEPIN(clock_in),
		.PLLOUTCORE(clock_out)
	);

endmodule
