module alu_tb
    import config_pkg::*;
    import dv_pkg::*;
    ;

alu_runner alu_runner ();
logic[7:0] res;
always begin
    $dumpfile( "dump.fst" );
    $dumpvars;
    $display( "Begin simulation." );
    $urandom(100);
    $timeformat( -3, 3, "ms", 0);

    alu_runner.reset();

    // alu_runner.send_and_verify(8'd231);
    //   //  alu_runner.reset();
    // alu_runner.send_and_verify(8'd0);
    //     // alu_runner.reset();
    // alu_runner.send_and_verify(8'd83);
    //     // alu_runner.reset();
    // alu_runner.send_and_verify(8'd33);
    alu_runner.send(8'hec);
    alu_runner.send(8'h00);
    alu_runner.send(8'h05);
    alu_runner.send(8'h00);
    alu_runner.send(8'h12);
    alu_runner.receive(res);
    $display("Received %h", res);
    // alu_runner.add_and_verify(32'h00000000, 32'h00000000);
    
    $display( "End simulation." );
    $finish;
end

endmodule
