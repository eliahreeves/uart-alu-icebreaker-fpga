
// module alu_runner;

// logic clk_i;
// logic rst_ni;
// logic [DATA_WIDTH-1:0]  data_i;
// logic [DATA_WIDTH-1:0]  data_o;
// logic ready_i;
// logic ready_o;
// logic valid_i;
// logic valid_o;

// localparam realtime ClockPeriod = 5ms;

// initial begin
//     clk_i = 0;
//     forever begin
//         #(ClockPeriod/2);
//         clk_i = !clk_i;
//     end
// end

// alu alu (.*);

// always @(posedge led_o) $info("Led on");
// always @(negedge led_o) $info(data_o);

// task automatic reset;
//     rst_ni <= 0;
//     @(posedge clk_i);
//     rst_ni <= 1;
// endtask

// task automatic wait_for_on;
//     while (!led_o) @(posedge led_o);
// endtask

// task automatic wait_for_off;
//     while (led_o) @(negedge led_o);
// endtask

// endmodule
