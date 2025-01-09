module alu import config_pkg::*; #(
    parameter WIDTH = 32
) (
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    input logic [2:0] op,
    output logic [WIDTH-1:0] result,
    output logic zero
);

    always_comb begin
        case (op)
            3'b000: result = a + b; // Dummy operation: addition
            3'b001: result = a - b; // Dummy operation: subtraction
            3'b010: result = a & b; // Dummy operation: AND
            3'b011: result = a | b; // Dummy operation: OR
            3'b100: result = a ^ b; // Dummy operation: XOR
            default: result = {WIDTH{1'b0}}; // Default case
        endcase
        zero = (result == {WIDTH{1'b0}});
    end

endmodule