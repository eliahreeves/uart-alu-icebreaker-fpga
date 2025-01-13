module top(
    input  logic clk_12mhz_i,   // Board oscillator
    input  logic rst_n_i       // Board reset button
);

  logic clk_60mhz;

    pll pll(
        .clock_in(clk_12mhz_i),
        .clock_out(clk_60mhz),
        .locked()
    );

endmodule
