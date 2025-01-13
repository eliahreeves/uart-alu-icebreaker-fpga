module alu_tb
    import config_pkg::*;
    import dv_pkg::*;
    ;

alu_runner alu_runner ();

always begin
    $dumpfile( "dump.fst" );
    $dumpvars;
    $display( "Begin simulation." );
    $urandom(100);
    $timeformat( -3, 3, "ms", 0);

    alu_runner.reset();

    alu_runner.send_and_verify(8'd231);
      //  alu_runner.reset();
    alu_runner.send_and_verify(8'd0);
        // alu_runner.reset();
    alu_runner.send_and_verify(8'd83);
        // alu_runner.reset();
    alu_runner.send_and_verify(8'd33);
    
    $display( "End simulation." );
    $finish;
end

endmodule
