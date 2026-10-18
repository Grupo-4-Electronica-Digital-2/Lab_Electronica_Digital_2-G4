module rgb_ctrl (
    input  wire [1:0] op,
    output reg        led_r,
    output reg        led_g,
    output reg        led_b
);

    always @(*) begin
        case (op)
            2'b00: begin
                led_r = 1'b0; //verde
                led_g = 1'b1;
                led_b = 1'b0;
            end

            2'b01: begin
                led_r = 1'b1;
                led_g = 1'b0; // Rojo
                led_b = 1'b0;
            end

            2'b10: begin
                led_r = 1'b0;
                led_g = 1'b0;
                led_b = 1'b1; // Azul
            end

            2'b11: begin
                led_r = 1'b1; // Rojo + verde + azul
                led_g = 1'b1;
                led_b = 1'b1;
            end

            default: begin
                led_r = 1'b1;
                led_g = 1'b1;
                led_b = 1'b1;
            end
        endcase
    end

endmodule