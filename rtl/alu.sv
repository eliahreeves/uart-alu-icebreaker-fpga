
module alu import config_pkg::*;#(
    parameter DATA_WIDTH = 8
)(
    input  logic clk_i,
    input  logic rst_ni,
    input  logic [DATA_WIDTH-1:0]  data_i,
    output logic [DATA_WIDTH-1:0]  data_o,

    input logic ready_i,
    input logic valid_i,

    output logic ready_o,
    output logic valid_o
);
wire uart;
uart_tx #(
    .DATA_WIDTH(DATA_WIDTH)
) uart_tx (
    .clk(clk_i),
    .rst(!rst_ni),
    .s_axis_tdata(data_i),
    .s_axis_tready(ready_o),
    .s_axis_tvalid(valid_i),
    .prescale(1),
    .txd(uart),

    .busy()
);
uart_rx #(
    .DATA_WIDTH(DATA_WIDTH)
) uart_rx (
    .clk(clk_i),
    .rst(!rst_ni),
    .m_axis_tdata(data_o),
    .m_axis_tready(ready_i),
    .m_axis_tvalid(valid_o),
    .prescale(1),
    .rxd(uart),
    
    .busy(),
    .frame_error(),
    .overrun_error()
);
endmodule
