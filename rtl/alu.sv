
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
  logic rx_ready_i, rx_valid_o, tx_ready_o, tx_valid_i;
  logic [DATA_WIDTH-1:0] data_i, data_o;
  logic [15:0] data_length_d, data_length_q;

  uart_rx #(
      .DATA_WIDTH(DATA_WIDTH)
  ) uart_rx (
      .clk(clk_i),
      .rst(!rst_ni),
      .m_axis_tdata(data_o),
      .m_axis_tready(rx_ready_i),
      .m_axis_tvalid(rx_valid_o),
      .prescale(33),
      .rxd(rxd_i),
      .busy(),
      .frame_error(),
      .overrun_error()
  );
  // https://www.desmos.com/calculator/xcpwylb8bf
  uart_tx #(
      .DATA_WIDTH(DATA_WIDTH)
  ) uart_tx (
      .clk(clk_i),
      .rst(!rst_ni),
      .s_axis_tdata(data_i),
      .s_axis_tready(tx_ready_o),
      .s_axis_tvalid(tx_valid_i),
      .prescale(33),
      .txd(txd_o),
      .busy()
  );
  // wire buffer_active_o, buffer_valid_o;
  // logic buffer_valid_i;

  // logic [DATA_WIDTH - 1:0] buffer_data_o;
  // transmit_buffer #(
  //     .DATA_WIDTH(DATA_WIDTH)
  // ) transmit_buffer (
  //     .clk_i(clk_i),
  //     .rst_ni(rst_ni),
  //     .data_i(accum_q),
  //     .ready_i(tx_ready_o),
  //     .active_o(buffer_active_o),
  //     .valid_i(buffer_valid_i),
  //     .valid_o(buffer_valid_o),
  //     .data_o(buffer_data_o)
  // );

  state_t state_d, state_q, future_state_d, future_state_q;
  logic [1:0] bit_num_d, bit_num_q;
  logic [4*DATA_WIDTH -1:0] accum_d, accum_q, operand_d, operand_q;
  always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
      state_q <= GET_OP_CODE;
      future_state_q <= GET_OP_CODE;
      data_length_q <= 0;
      bit_num_q <= 0;
      accum_q <= 0;
      operand_q <= 0;
    end else begin
      state_q <= state_d;
      future_state_q <= future_state_d;
      data_length_q <= data_length_d;
      bit_num_q <= bit_num_d;
      accum_q <= accum_d;
      operand_q <= operand_d;
    end
  end

  always_comb begin
    state_d = state_q;
    future_state_d = future_state_q;
    data_length_d = data_length_q;
    bit_num_d = bit_num_q;
    accum_d = accum_q;
    operand_d = operand_q;
    //ready to recive data by defualt
    rx_ready_i = 1;
    tx_valid_i = 0;
    data_i = 0;

    unique case (state_q)
      GET_OP_CODE: begin
        if (rx_valid_o) begin
          if (data_o == 'hec) begin
            future_state_d = ECHO;
            state_d = HANDLE_RES;
          end else if (data_o == 'had) begin
            future_state_d = ADD;
            state_d = HANDLE_RES;
          end
        end
      end
      HANDLE_RES: begin
        if (rx_valid_o) begin
          state_d = GET_LENGTH_LSB;
        end
      end
      GET_LENGTH_LSB: begin
        if (rx_valid_o) begin
          data_length_d[DATA_WIDTH-1:0] = data_o;
          state_d = GET_LENGHT_MSB;
        end
      end
      GET_LENGHT_MSB: begin
        if (rx_valid_o) begin
          data_length_d[2*DATA_WIDTH-1:DATA_WIDTH] = data_o;

          bit_num_d = 0;
          accum_d = 0;

          state_d = future_state_q;
        end
      end
      ECHO: begin
        rx_ready_i = 0;
        if (data_length_q == 'd4) begin
          state_d = GET_OP_CODE;
        end
        if (rx_valid_o && tx_ready_o) begin
          rx_ready_i = 1;
          data_i = data_o;
          tx_valid_i = 1;
          data_length_d = data_length_q - 1;
        end
      end
      ADD: begin
        if (data_length_q == 'd4) begin
          bit_num_d = 0;
          state_d = TRANSMIT;
        end
        if (rx_valid_o) begin
          data_length_d = data_length_q - 1;
          bit_num_d = bit_num_q + 1;
          unique case (bit_num_q)
            0: operand_d[7:0] = data_o;
            1: operand_d[15:8] = data_o;
            2: operand_d[23:16] = data_o;
            3: operand_d[31:24] = data_o;
          endcase
          if (bit_num_q == 'd3) begin
            accum_d = accum_q + operand_q;
          end
        end
      end
      TRANSMIT: begin
        rx_ready_i = 0;
        if(tx_ready_o) begin
          if(bit_num_q == 'd3) begin
            state_d = GET_OP_CODE;
          end
          unique case (bit_num_q)
            0: data_i = accum_q[7:0];
            1: data_i = accum_q[15:8];
            2: data_i = accum_q[23:16];
            3: data_i = accum_q[31:24];
          endcase
          tx_valid_i = 1;
          bit_num_d = bit_num_q + 1;
        end

      end
    endcase
  end
endmodule

