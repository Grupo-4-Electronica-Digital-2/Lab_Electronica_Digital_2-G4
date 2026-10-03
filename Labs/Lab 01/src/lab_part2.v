module alu_personalizada (
    input  wire [7:0] sw,
    input  wire [3:0] btn,

    output reg [3:0] led,
    output reg       rgb_r,
    output reg       rgb_g,
    output reg       rgb_b
);

    // =========================================================
    // OPERANDOS
    // =========================================================

    // Switches de la Zybo
    wire [3:0] A;

    // Switches externos conectados al conector JE
    wire [3:0] B;

    assign A = sw[3:0];

    // Los switches externos tienen PULLUP.
    // Switch abierto  -> 1 físico -> 0 lógico
    // Switch cerrado  -> 0 físico -> 1 lógico
    assign B = ~sw[7:4];


    // =========================================================
    // LÓGICA COMBINACIONAL
    //
    // BTN0 -> AND
    // BTN1 -> OR
    // BTN2 -> XOR
    // BTN3 -> SUMA
    // =========================================================

    always @(*) begin
 
        // Valores por defecto
        led   = 4'b0000;
        rgb_r = 1'b0;
        rgb_g = 1'b0;
        rgb_b = 1'b0;

        // -----------------------------------------------------
        // AND
        // -----------------------------------------------------
        if (btn[0]) begin

            led = A & B;

            // RGB rojo
            rgb_r = 1'b1;

        end

        // -----------------------------------------------------
        // OR
        // -----------------------------------------------------
        else if (btn[1]) begin

            led = A | B;

            // RGB verde
            rgb_g = 1'b1;

        end

        // -----------------------------------------------------
        // XOR
        // -----------------------------------------------------
        else if (btn[2]) begin

            led = A ^ B;

            // RGB azul
            rgb_b = 1'b1;

        end

        // -----------------------------------------------------
        // SUMA
        // -----------------------------------------------------
        else if (btn[3]) begin

            led = A + B;

            // RGB rojo + verde
            rgb_r = 1'b1;
            rgb_g = 1'b1;

        end

    end

endmodule
