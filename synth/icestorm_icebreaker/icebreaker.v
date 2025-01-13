
module icebreaker (
    input  wire CLK,
    input wire BTN_N,
    input wire RX,
    output wire TX
);

wire clk_12 = CLK;
wire clk_60;

// icepll -i 12 -o 50
SB_PLL40_PAD #(
    .FEEDBACK_PATH("SIMPLE"),
    .DIVR(4'd0),
    .DIVF(7'd79),
    .DIVQ(3'd4),
    .FILTER_RANGE(3'd1)
) pll (
    .LOCK(),
    .RESETB(1'b1),
    .BYPASS(1'b0),
    .PACKAGEPIN(clk_12),
    .PLLOUTCORE(clk_60)
);

alu alu (
    .clk_i(clk_60),
    .rst_ni(BTN_N),
    .rxd_i(RX),
    .txd_o(TX)
);

endmodule
