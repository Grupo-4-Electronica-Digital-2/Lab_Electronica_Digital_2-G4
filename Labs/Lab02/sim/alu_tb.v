`timescale 1ns/1ps
`include "top.v"

module alu_tb;
    reg        clk = 0, rst = 0;   // reset activo en alto
    reg  [3:0] sw = 0;
    reg        btn0 = 0, btn1 = 0, btn2 = 0, btn3 = 0;
    wire [3:0] led;
    wire       led_r, led_g, led_b;

    top DUT(.clk(clk), .rst(rst), .sw(sw),
            .btn0(btn0), .btn1(btn1), .btn2(btn2), .btn3(btn3),
            .led(led), .led_r(led_r), .led_g(led_g), .led_b(led_b));

    // reloj de 10 ns
    always #5 clk = ~clk;

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // reset
        rst = 1; repeat(4) @(posedge clk); rst = 0;
        repeat(2) @(posedge clk);

        // cargar A = 5
        sw = 4'b0101;
        @(negedge clk); btn0 = 1;
        @(negedge clk); @(negedge clk); btn0 = 0;
        @(posedge clk); #1;

        // cargar B = 3
        sw = 4'b0011;
        @(negedge clk); btn1 = 1;
        @(negedge clk); @(negedge clk); btn1 = 0;
        @(posedge clk); #1;

        // mover los switches: A y B deben quedar igual
        sw = 4'b1111; @(posedge clk); #1;

        // op = 01 (resta), btn2 cambia op[0]
        @(negedge clk); btn2 = 1;
        @(negedge clk); @(negedge clk); btn2 = 0;
        @(posedge clk); #2;

        // op = 10 (AND), btn2 devuelve op[0] a 0 y btn3 sube op[1]
        @(negedge clk); btn2 = 1;
        @(negedge clk); @(negedge clk); btn2 = 0;
        @(negedge clk); btn3 = 1;
        @(negedge clk); @(negedge clk); btn3 = 0;
        @(posedge clk); #2;

        // op = 11 (OR)
        @(negedge clk); btn2 = 1;
        @(negedge clk); @(negedge clk); btn2 = 0;
        @(posedge clk); #2;

        // volver a op = 00 (suma), los switches siguen en 1111
        @(negedge clk); btn2 = 1;
        @(negedge clk); @(negedge clk); btn2 = 0;
        @(negedge clk); btn3 = 1;
        @(negedge clk); @(negedge clk); btn3 = 0;
        @(posedge clk); #2;

        // nuevos operandos: A = 15, B = 1
        sw = 4'b1111; @(negedge clk); btn0 = 1;
        @(negedge clk); @(negedge clk); btn0 = 0;
        sw = 4'b0001; @(negedge clk); btn1 = 1;
        @(negedge clk); @(negedge clk); btn1 = 0;

        // resta 15 - 1
        @(negedge clk); btn2 = 1;
        @(negedge clk); @(negedge clk); btn2 = 0;
        @(posedge clk); #2;

        $finish;
    end

    // salida de emergencia por si la simulacion se queda corriendo
    initial #500000 $finish;
endmodule
