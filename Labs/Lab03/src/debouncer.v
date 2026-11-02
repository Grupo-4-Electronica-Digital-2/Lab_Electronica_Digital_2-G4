module debouncer (
    input  wire clk,
    input  wire rst,
    input  wire btn_in,
    output wire btn_pulse
);
    reg [20:0] count;
    reg        btn_state;
    reg        btn_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count     <= 21'd0;
            btn_state <= 1'b0;
        end else if (btn_in != btn_state) begin
            count <= count + 1'b1;
            if (count == 21'd1250000) begin
                btn_state <= btn_in;
                count     <= 21'd0;
            end
        end else begin
            count <= 21'd0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_prev <= 1'b0;
        end else begin
            btn_prev <= btn_state;
        end
    end

    assign btn_pulse = btn_state & ~btn_prev;
endmodule