
module alu_sim (
    input  logic clk_i,
    input  logic rst_ni,
    output logic led_o
);

alu #(
    .ResetValue(100)
) alu (.*);

endmodule
