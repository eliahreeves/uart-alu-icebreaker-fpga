// module transmit_buffer #(
//     parameter DATA_WIDTH = 8
// ) (
//     input logic clk_i,
//     input logic rst_ni,
//     input wire [4*DATA_WIDTH-1:0] data_i,
//     output logic [DATA_WIDTH-1:0] data_o,
//     output logic valid_o,
//     input logic valid_i,
//     input logic ready_i,
//     output logic active_o


// );
//   logic state_d, state_q;
//   logic [1:0] count_d, count_q;
//   logic [4*DATA_WIDTH-1:0] data_d, data_q;
//   assign data_o   = data_q[DATA_WIDTH-1:0];
//   // assign active_o = state_q;
//   always_ff @(posedge clk_i) begin
//     if (!rst_ni) begin
//       state_q <= 0;
//       count_q <= 0;
//       data_q  <= 0;
//     end else begin
//       state_q <= state_d;
//       count_q <= count_d;
//       data_q  <= data_d;
//     end
//   end

//   always_comb begin
//     count_d = count_q;
//     state_d = state_q;
//     valid_o = 0;
//     data_d  = data_q;
//     active_o = 0;

//     unique case (state_q)
//       0: begin
//         if (valid_i) begin
//           data_d  = data_i;
//           count_d = 0;
//           state_d = 1;
//           active_o = 1;
//         end

//       end
//       1: begin
//         active_o = 1;


//         if (ready_i) begin
//           if (count_q == 'd3) begin
//             state_d = 0;
//           end
//           count_d = count_q + 1;
//           data_d  = data_q << DATA_WIDTH;
//           valid_o = 1;
//         end
        
//       end
//     endcase
//   end

// endmodule

