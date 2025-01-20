module alu_tb
  import config_pkg::*;
  import dv_pkg::*;
;
  localparam int TRIALS = 2;
  alu_runner alu_runner ();
  // logic[7:0] res;
  always begin
    $dumpfile("dump.fst");
    $dumpvars;
    $display("Begin simulation.");
    $urandom(100);
    $timeformat(-3, 3, "ms", 0);

    alu_runner.reset();
    for (int i = 0; i < TRIALS; i++) begin
      alu_runner.test_list(16'd3, 8'had);
    end
    $info("Addition tests completed.");
    for (int i = 0; i < TRIALS; i++) begin
      alu_runner.test_division();
    end
    $info("Division tests completed.");


    $display("End simulation.");
    $finish;
  end

endmodule
