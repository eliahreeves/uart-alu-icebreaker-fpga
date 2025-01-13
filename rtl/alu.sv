
module alu
  import config_pkg::*;
#(
    parameter DATA_WIDTH = 8
) (
    input  logic clk_i,
    input  logic rst_ni,
    input  logic rxd_i,
    output logic txd_o
);
  wire ready, valid;
  logic [DATA_WIDTH-1:0] data;

  uart_rx #(
      .DATA_WIDTH(DATA_WIDTH)
  ) uart_rx (
      .clk(clk_i),
      .rst(!rst_ni),
      .m_axis_tdata(data),
      .m_axis_tready(ready),
      .m_axis_tvalid(valid),
      .prescale(65),
      .rxd(rxd_i),
      .busy(),
      .frame_error(),
      .overrun_error()
  );

  uart_tx #(
      .DATA_WIDTH(DATA_WIDTH)
  ) uart_tx (
      .clk(clk_i),
      .rst(!rst_ni),
      .s_axis_tdata(data),
      .s_axis_tready(ready),
      .s_axis_tvalid(valid),
      // https://www.desmos.com/calculator/xcpwylb8bf
      .prescale(65),
      .txd(txd_o),
      .busy()
  );
endmodule
