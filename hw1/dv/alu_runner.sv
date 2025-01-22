module alu_runner;

  logic clk_i;
  logic rst_ni;
  logic rxd_i;
  logic txd_o;

  logic [7:0] data_to_send_i;
  logic [7:0] data_received_o;
  logic tx_ready_o, tx_valid_i, rx_ready_i, rx_valid_o;

  localparam realtime ClockPeriod = 32.786ns;

  initial begin
    clk_i = 0;
    forever begin
      #(ClockPeriod / 2);
      clk_i = !clk_i;
    end
  end

  alu alu (.*);

  uart_tx #(
      .DATA_WIDTH(8)
  ) uart_tx_inst (
      .clk(clk_i),
      .rst(!rst_ni),
      .s_axis_tdata(data_to_send_i),
      .s_axis_tready(tx_ready_o),
      .s_axis_tvalid(tx_valid_i),
      .prescale(33),
      .txd(rxd_i),
      .busy()
  );

  uart_rx #(
      .DATA_WIDTH(8)
  ) uart_rx_inst (
      .clk(clk_i),
      .rst(!rst_ni),
      .m_axis_tdata(data_received_o),
      .m_axis_tready(rx_ready_i),
      .m_axis_tvalid(rx_valid_o),
      .prescale(33),
      .rxd(txd_o),
      .busy(),
      .frame_error(),
      .overrun_error()
  );

  task automatic reset;
    rst_ni <= 0;
    @(posedge clk_i);
    rst_ni <= 1;
  endtask

  task automatic send(input logic [7:0] data);
    @(posedge clk_i);
    while (!tx_ready_o) @(posedge clk_i);
    data_to_send_i <= data;
    tx_valid_i <= 1;
    @(posedge clk_i);
    tx_valid_i <= 0;
  endtask


  task automatic receive(output logic [7:0] data);

    while (!rx_valid_o) @(posedge clk_i);
    rx_ready_i <= 1;
    data = data_received_o;
    @(posedge clk_i);
    rx_ready_i <= 0;
    @(posedge clk_i);

  endtask



endmodule
