module result_latch (
    input  wire       clk,
    input  wire       rst,
    input  wire       execute,       // Pulso de BTN3
    input  wire [3:0] alu_result,
    output reg  [3:0] latched_result
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            latched_result <= 4'h0;
        end else if (execute) begin
            latched_result <= alu_result;
        end
    end
endmodule