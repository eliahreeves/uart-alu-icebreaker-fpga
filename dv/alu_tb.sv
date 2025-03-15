module alu_tb
  import config_pkg::*;
  import dv_pkg::*;
;
  localparam int TRIALS = 1000;
  alu_runner alu_runner ();

  task automatic send_4_bytes(input logic [31:0] data);
    for (int i = 0; i < 4; i++) begin
      alu_runner.send(data[8*i+:8]);
    end
  endtask
  task automatic receive_4_bytes(output logic [31:0] data);
    for (int i = 0; i < 4; i++) begin
      alu_runner.receive(data[8*i+:8]);
    end
  endtask
  task automatic test_division();
    logic [31:0] n = $urandom;
    logic [31:0] d = $urandom;
    test_pair(8'hf6, n, d);
  endtask

  task automatic test_list(input logic [15:0] max_values, input logic [7:0] op_code);
    logic [15:0] num_values = $urandom_range(2, {16'b0, max_values});
    logic [15:0] length = 4 + (num_values * 4);
    logic [31:0] actual_result;
    logic [31:0] expected_sum = $signed(32'd0);
    logic [31:0] expected_product = $signed(32'd1);
    alu_runner.send(op_code);  //op code
    alu_runner.send(8'h00);  //null
    alu_runner.send(length[7:0]);
    alu_runner.send(length[15:8]);
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

  task automatic test_echo(input logic [15:0] max_length);
    logic [15:0] length = $urandom_range(1, {16'b0, max_length});
    logic [15:0] total_length = length + 4;
    alu_runner.send(8'hec);
    alu_runner.send(8'h00);
    alu_runner.send(total_length[7:0]);
    alu_runner.send(total_length[15:8]);
    for (int i = 0; i < length; i++) begin
      logic [7:0] val = $urandom;
      logic [7:0] res;
      alu_runner.send(val);
      alu_runner.receive(res);
      assert (val == res)
      else $error("Echo Error: Sent %h, Received: %h", val, res);
    end
  endtask

  task automatic test_pair(input logic [7:0] op_code, input logic [31:0] a, input logic [31:0] b);
    logic [31:0] res;
    alu_runner.send(op_code);
    alu_runner.send(8'h00);
    alu_runner.send(8'h0c);
    alu_runner.send(8'h00);
    send_4_bytes(a);
    send_4_bytes(b);
    receive_4_bytes(res);
    if (op_code == 8'had) begin
      assert ($signed(res) == $signed(a) + $signed(b))
      else
        $error(
            "Addition Error: Sent: a=%h b=%h, Received %h, Expected %h",
            a,
            b,
            res,
            $signed(
                a
            ) + $signed(
                b
            )
        );
    end else if (op_code == 8'haf) begin
      assert ($signed(res) == $signed(a) * $signed(b))
      else
        $error(
            "Multiplication Error: Sent: a=%h b=%h, Received %h, Expected %h",
            a,
            b,
            res,
            $signed(
                a
            ) * $signed(
                b
            )
        );
    end else if (op_code == 8'hf6) begin
      assert ($signed(res) == $signed(a) / $signed(b))
      else
        $error(
            "Division Error: Sent: a=%h b=%h, Received %h, Expected %h",
            a,
            b,
            res,
            $signed(
                a
            ) / $signed(
                b
            )
        );
    end
  endtask
  always begin
    $dumpfile("dump.fst");
    $dumpvars;
    $display("Begin simulation.");
    $urandom(100);
    $timeformat(-3, 3, "ms", 0);
    alu_runner.reset();

    // Echo
    for (int i = 0; i < TRIALS; i++) begin
      test_echo(16'd16);
    end
    $info("Echo tests completed.");

    // Add
    for (int i = 0; i < TRIALS; i++) begin
      test_list(16'd16, 8'had);
    end
    $info("Addition tests completed.");

    // Multiply
    for (int i = 0; i < TRIALS; i++) begin
      test_list(16'd16, 8'haf);
    end
    $info("Multiplication tests completed.");

    //Divide
    for (int i = 0; i < TRIALS; i++) begin
      test_division();
    end
    $info("Division tests completed.");

    $display("End simulation.");
    $finish;
  end

endmodule
