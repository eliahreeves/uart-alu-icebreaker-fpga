
module alu_tb;
    // import config_pkg::*;
    // import dv_pkg::*;

logic clk_i;
logic rst_ni = 0;
logic [7:0]  data_i = 0;
logic [7:0]  data_o;
logic ready_i = 0;
logic ready_o;
logic valid_i = 0;
logic valid_o;

localparam realtime ClockPeriod = 5ms;

initial begin
    clk_i = 0;
    forever begin
        #(ClockPeriod/2);
        clk_i = !clk_i;
    end
end

alu alu (.*);
logic in_handshake = 0;
logic alu_handshake = 0;
logic [7:0] result;
task automatic safe_run(logic [7:0] sent_data);
    $display("Sending %0d", sent_data);

    valid_i <= 1;
    in_handshake <= ready_o;
    ready_i <= 0;
    alu_handshake <= 0;

    data_i <= sent_data;

    @(posedge clk_i);
    while (!in_handshake) begin
        @(posedge clk_i); 
        in_handshake <= (ready_o&&valid_i);
    end

    valid_i <= 0;
    in_handshake <= 0;
    ready_i <= 1;
    alu_handshake <= valid_o;

    result <= data_o;
    data_i <= 0;
    @(posedge clk_i);
    while (!alu_handshake) begin
        alu_handshake <= (ready_i&&valid_o);
        result <= data_o;
        @(posedge clk_i);
    end

    valid_i <= 0;
    in_handshake <= 0;
    ready_i <= 0;
    alu_handshake <= 0;

    assert(sent_data == result) else $error("Expected %0d, Received %0d", sent_data, result);
    $display("Produced %0d", result);
endtask

always begin
    $dumpfile( "dump.fst" );
    $dumpvars;
    $display( "Begin simulation." );
    $urandom(100);

    rst_ni <= 0;
    @(posedge clk_i);
    rst_ni <= 1;

    safe_run(8'h00);
    safe_run(8'h01);
    safe_run(8'h02);
    safe_run(8'h03);
    safe_run(8'd231);

    $display( "End simulation." );
    $finish;
end

endmodule
