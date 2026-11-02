module clk_divider (
    input  wire clk_in,
    input  wire rst,
    output reg  clk_out
);
    reg [11:0] count;
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count   <= 12'd0;
            clk_out <= 1'b0;
        end else if (count == 12'd1249) begin
            count   <= 12'd0;
            clk_out <= ~clk_out;
        end else begin
            count   <= count + 1'b1;
        end
    end
endmodule