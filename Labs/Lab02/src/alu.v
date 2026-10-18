module alu (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire [1:0] op,
    output wire [3:0] result
);

    assign result = (op == 2'b00) ? (A + B) :
                    (op == 2'b01) ? (A - B) :
                    (op == 2'b10) ? (A & B) :
                    (A | B);

endmodule 