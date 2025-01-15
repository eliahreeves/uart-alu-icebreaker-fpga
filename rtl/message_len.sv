// module message_len
//   import config_pkg::*;
// #(
//     parameter DATA_WIDTH = 8
// ) (
//     input logic clk_i,
//     input logic rst_ni,
//     input logic [DATA_WIDTH-1:0] data_i,
//     input logic valid_i,
//     output logic valid_o,
//     output logic [DATA_WIDTH * 2 - 1:0] len_o
// );
//
//   message_len_state_t state_d, state_q;
//   logic [DATA_WIDTH * 2 - 1:0] len_d, len_q;
//   always_ff @(posedge clk_i) begin
//     if (!rst_ni) begin
//       len_q <= 0;
//       state_q <= LSB;
//     end else begin
//       len_d <=
//       state_q <= state_d;
//     end
//   end
//   always_comb begin
//     unique case (state_q)
//       LSB: begin
//         if(valid_i) begin
//           len_o[DATA_WIDTH-1: 0] =
//       end
//       MSB: begin
//       end
//     endcase
//   end
// endmodule
