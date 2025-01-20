
module alu_runner;

  reg CLK;
  reg BTN_N = 1;
  logic RX;
  logic TX;

  logic [7:0] data_to_send_i;
  logic [7:0] data_received_o;
  logic tx_ready_o, tx_valid_i, rx_ready_i, rx_valid_o;
  logic rst_ni = 1;
  initial begin
    CLK = 0;
    forever begin
      #41.666ns;  // 12MHz
      CLK = !CLK;
    end
  end

  logic pll_out;
  initial begin
    pll_out = 0;
    forever begin
      #16.393ns;  // 30.5MHz
      pll_out = !pll_out;
    end
  end
  assign icebreaker.pll.PLLOUTCORE = pll_out;

  icebreaker icebreaker (.*);

  uart_tx #(
      .DATA_WIDTH(8)
  ) uart_tx_inst (
      .clk(pll_out),
      .rst(!rst_ni),
      .s_axis_tdata(data_to_send_i),
      .s_axis_tready(tx_ready_o),
      .s_axis_tvalid(tx_valid_i),
      .prescale(33),
      .txd(RX),
      .busy()
  );

  uart_rx #(
      .DATA_WIDTH(8)
  ) uart_rx_inst (
      .clk(pll_out),
      .rst(!rst_ni),
      .m_axis_tdata(data_received_o),
      .m_axis_tready(rx_ready_i),
      .m_axis_tvalid(rx_valid_o),
      .prescale(33),
      .rxd(TX),
      .busy(),
      .frame_error(),
      .overrun_error()
  );

  task automatic reset;
    BTN_N <= 0;
    @(posedge CLK);
    BTN_N <= 1;
  endtask

  task automatic send(input logic [7:0] data);
    @(posedge CLK);
    while (!tx_ready_o) @(posedge CLK);
    data_to_send_i <= data;
    tx_valid_i <= 1;
    @(posedge CLK);
    tx_valid_i <= 0;
  endtask

  task automatic send_4_bytes(input logic [31:0] data);
    for (int i = 0; i < 4; i++) begin
      send(data[8*i+:8]);
    end
  endtask

  task automatic receive(output logic [7:0] data);

    while (!rx_valid_o) @(posedge CLK);
    rx_ready_i <= 1;
    data = data_received_o;
    @(posedge CLK);
    rx_ready_i <= 0;

  endtask

  task automatic receive_4_bytes(output logic [31:0] data);
    for (int i = 0; i < 4; i++) begin
      receive(data[8*i+:8]);
    end
  endtask

  task automatic test_division();
    logic [31:0] n = $urandom;
    logic [31:0] d = $urandom;
    logic [31:0] q;
    send(8'hf6);  //op code
    send(8'h00);  //null
    send(8'h0c);  //12
    send(8'h00);  //0
    send_4_bytes(n);
    send_4_bytes(d);
    receive_4_bytes(q);
    assert ($signed(q) == $signed(n) / $signed(d))
    else $error("Sent n = %h, d = %h, Expected %h, got %h", n, d, $signed(n) / $signed(d), q);
  endtask



  // task automatic test_addition2();
  //   logic [31:0] a = $urandom;
  //   logic [31:0] b = $urandom;
  //   logic [31:0] s;
  //   send(8'had);  //op code
  //   send(8'h00);  //null
  //   send(8'h0c);  //12
  //   send(8'h00);  //0
  //   send_4_bytes(a);
  //   send_4_bytes(b);
  //   receive_4_bytes(s);
  //   assert ($signed(s) == $signed(a) + $signed(b))
  //   else $error("Sent %h + %h, Expected %h, got %h", a, b, $signed(a) + $signed(b), s);
  // endtask

  task automatic test_list(input logic [15:0] max_values, input logic [7:0] op_code);
    logic [31:0] large_num_values = $urandom_range(2, {16'b0, max_values});
    logic [15:0] num_values = large_num_values[15:0];
    logic [15:0] length = 4 + (num_values * 4);
    logic [31:0] actual_result;
    logic [31:0] expected_sum = $signed(32'd0);
    logic [31:0] expected_product = $signed(32'd1);
    send(op_code);  //op code
    send(8'h00);  //null
    send(length[7:0]);
    send(length[15:8]);
    for (int i = 0; i < num_values; i++) begin
      logic [31:0] val = $urandom;
      send_4_bytes(val);
      expected_sum = $signed(expected_sum) + $signed(val);
      expected_product = $signed(expected_product) * $signed(val);
    end
    receive_4_bytes(actual_result);
    if (op_code == 8'had) begin
      assert ($signed(expected_sum) == $signed(actual_result))
      else $error("Addition Error: Expected %h, Received %h", expected_sum, actual_result);
    end else if (op_code == 8'haf) begin
      assert ($signed(expected_product) == $signed(actual_result))
      else
        $error("Multiplication Error: Expected %h, Received %h", expected_product, actual_result);
    end else begin
      $error("Parameter Error: Expected 0xAD or 0xAF, Received %h", op_code);
    end
  endtask


  // task automatic test_multiply2();
  //   logic [31:0] a = $urandom;
  //   logic [31:0] b = $urandom;
  //   logic [31:0] s;
  //   send(8'had);  //op code
  //   send(8'h00);  //null
  //   send(8'h0c);  //12
  //   send(8'h00);  //0
  //   send_4_bytes(a);
  //   send_4_bytes(b);
  //   receive_4_bytes(s);
  //   assert ($signed(s) == $signed(a) + $signed(b))
  //   else $error("Sent %h + %h, Expected %h, got %h", a, b, $signed(a) + $signed(b), s);
  // endtask
endmodule
