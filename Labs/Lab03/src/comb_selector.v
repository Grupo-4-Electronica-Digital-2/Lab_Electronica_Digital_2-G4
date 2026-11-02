module comb_selector (
    input  wire       clk,
    input  wire       rst,
    input  wire       next_comb,   // Pulso de BTN2
    output reg  [1:0] addr_a,
    output reg  [1:0] addr_b,
    output reg  [3:0] leds_active  // Controla LED[3:0]
);
    reg [2:0] index;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            index <= 3'd0;
        end else if (next_comb) begin
            if (index == 3'd5)
                index <= 3'd0;
            else
                index <= index + 1'b1;
        end
    end

    // Parejas de combinación entre R0, R1, R2, R3
    always @(*) begin
        case (index)
            3'd0: begin addr_a = 2'd0; addr_b = 2'd1; leds_active = 4'b0011; end // R0 y R1
            3'd1: begin addr_a = 2'd0; addr_b = 2'd2; leds_active = 4'b0101; end // R0 y R2
            3'd2: begin addr_a = 2'd0; addr_b = 2'd3; leds_active = 4'b1001; end // R0 y R3
            3'd3: begin addr_a = 2'd1; addr_b = 2'd2; leds_active = 4'b0110; end // R1 y R2
            3'd4: begin addr_a = 2'd1; addr_b = 2'd3; leds_active = 4'b1010; end // R1 y R3
            3'd5: begin addr_a = 2'd2; addr_b = 2'd3; leds_active = 4'b1100; end // R2 y R3
            default: begin addr_a = 2'd0; addr_b = 2'd1; leds_active = 4'b0011; end
        endcase
    end
endmodule