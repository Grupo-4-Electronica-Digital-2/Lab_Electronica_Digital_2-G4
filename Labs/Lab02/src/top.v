         module top (
    input  wire       clk,
    input  wire [3:0] sw,
    input  wire       btn0,
    input  wire       btn1,
    input  wire       btn2,
    input  wire       btn3,
    output wire [3:0] led,
    output wire       led_r,
    output wire       led_g,
    output wire       led_b
);

    wire [3:0] A, B;
    wire [1:0] op;
    wire [3:0] result;

    // Registro A
    registro REG_A (
        .clk  (clk),
        .load (btn0),
        .D    (sw),
        .Q    (A)
    );

    // Registro B
    registro REG_B (
        .clk  (clk),
        .load (btn1),
        .D    (sw),
        .Q    (B)
    );

    // Selector de operación
    op_selector OP_SEL (
        .clk  (clk),
        .btn2 (btn2),
        .btn3 (btn3),
        .op   (op)
    );

    // Unidad aritmético-lógica
    alu ALU (
        .A      (A),
        .B      (B),
        .op     (op),
        .result (result)
    );

    // Control del LED RGB
    rgb_ctrl RGB (
        .op    (op),
        .led_r (led_r),
        .led_g (led_g),
        .led_b (led_b)
    );

    // Mostrar el resultado en los cuatro LEDs
    assign led = result;

endmodule
