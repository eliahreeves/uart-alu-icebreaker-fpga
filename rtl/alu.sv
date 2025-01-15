
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

  uart #(
      .DATA_WIDTH(DATA_WIDTH)
  ) uart (
      .clk(clk_i),
      .rst(!rst_ni),
      .m_axis_tdata(data_o),
      .m_axis_tready(rx_ready_i),
      .m_axis_tvalid(rx_valid_o),
      .prescale(33),
      .rxd(rxd_i),
      .txd(txd_o),
      .s_axis_tdata(data_i),
      .s_axis_tready(tx_ready_o),
      .s_axis_tvalid(tx_valid_i),
      .tx_busy(),
      .rx_busy(),
      .rx_overrun_error(),
      .rx_frame_error()
  );

  state_t state_d, state_q, future_state_d, future_state_q;
  logic [1:0] bit_num_d, bit_num_q;
  logic [4*DATA_WIDTH -1:0] accum_d, accum_q, operand_d, operand_q;

  logic is_echo_d, is_echo_q;
  logic [15:0] data_length_d, data_length_q;
  always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
      state_q <= GET_OP_CODE;
      future_state_q <= GET_OP_CODE;
      data_length_q <= 0;
      bit_num_q <= 0;
      accum_q <= 0;
      operand_q <= 0;
      is_echo_q <= 0;
    end else begin
      state_q <= state_d;
      future_state_q <= future_state_d;
      data_length_q <= data_length_d;
      bit_num_q <= bit_num_d;
      accum_q <= accum_d;
      operand_q <= operand_d;
      is_echo_q <= is_echo_d;
    end
  end

  always_comb begin
    is_echo_d = is_echo_q;
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
            is_echo_d = 1;
            future_state_d = ECHO;
            state_d = HANDLE_RES;
          end else if (data_o == 'had) begin
            is_echo_d = 0;
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
        bit_num_d = 0;
        accum_d = 0;
        operand_d = 0;
        if (rx_valid_o) begin
          data_length_d[2*DATA_WIDTH-1:DATA_WIDTH] = data_o;
          state_d = (is_echo_q) ? ECHO : GET_INITIAL_OPERAND;
        end
      end
      GET_INITIAL_OPERAND: begin
        // Wait for data
        if (rx_valid_o) begin
          // Change counters
          bit_num_d = bit_num_q + 1;
          data_length_d = data_length_q - 1;
          // Get next data after 4 bytes
          if (bit_num_q == 'd3) begin
            bit_num_d = 0;
            state_d   = GET_OPERAND;
          end
          // Bail out if we have all the data
          if (data_length_q == 'd4) begin
            bit_num_d = 0;
            state_d   = TRANSMIT;
          end
          // Load data in
          accum_d[bit_num_q*8+:8] = data_o;
        end
      end
      GET_OPERAND: begin
        if (rx_valid_o) begin
          bit_num_d = bit_num_q + 1;
          data_length_d = data_length_q - 1;
          // Go to operation after 4 bytes
          if (bit_num_q == 'd3) begin
            state_d = future_state_q;
          end else if (data_length_q == 'd4) begin
            // Go to transmit if all data is received
            bit_num_d = 0;
            state_d   = TRANSMIT;
          end
          // Load data in
          operand_d[bit_num_q*8+:8] = data_o;
        end
      end
      ADD: begin
        // Don't get more data
        rx_ready_i = 0;
        // Probably don't need this
        bit_num_d = 0;
        // Add the two operands
        accum_d = accum_q + operand_q;
        // Transition
        if (data_length_q == 'd4) begin
          //if all data is recived then transmit
          state_d = TRANSMIT;
        end else begin
          state_d = GET_OPERAND;
        end
      end
      TRANSMIT: begin
        rx_ready_i = 0;
        if (tx_ready_o) begin
          if (bit_num_q == 'd3) begin
            bit_num_d = 0;
            state_d   = GET_OP_CODE;
          end
          data_i = accum_q[bit_num_q*8+:8];
          tx_valid_i = 1;
          bit_num_d = bit_num_q + 1;
        end
      end
      ECHO: begin
        rx_ready_i = 0;
        if (data_length_q == 'd4) begin
          bit_num_d = 0;
          state_d   = GET_OP_CODE;
        end
        if (rx_valid_o && tx_ready_o) begin
          rx_ready_i = 1;
          data_i = data_o;
          tx_valid_i = 1;
          data_length_d = data_length_q - 1;
        end
      end
    endcase
  end
endmodule

