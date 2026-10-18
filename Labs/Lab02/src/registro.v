module registro (
    input  wire       clk,
    input  wire       load,
    input  wire [3:0] D,
    output reg  [3:0] Q = 4'b0000
);

    always @(posedge clk) begin
        if (load)
            Q <= D;
    end

endmodule