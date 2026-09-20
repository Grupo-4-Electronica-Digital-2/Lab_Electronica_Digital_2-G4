
`timescale 1ns/1ps
`include "semaforo.v"
module tb_semaforo;
   reg clk;
    reg rst;
    wire green;
    wire yellow;
    wire red;

    // Instancia del modulo
    semaforo uut (
        .clk(clk),
        .rst(rst),
        .green(green),
        .yellow(yellow),
        .red(red)
    );

    // reloj de 100 MHz 
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_semaforo.vcd");
        $dumpvars(0, tb_semaforo);

        clk = 0;
        rst = 1;

        #20;

        rst = 0;

        // Simulación por 300 ns para observar la secuencia completa de estados
        #300;

        // Prueba de reset asíncrono a mitad de operación
        rst = 1;
        #15;
        rst = 0;

        #150;
        $finish;
    end

endmodule
