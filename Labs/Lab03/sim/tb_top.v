`timescale 1ns / 1ps

module tb_top;
    reg        clk;
    reg        rst;
    reg  [3:0] sw;
    reg  [1:0] btn_write_sel;
    reg        btn_write;
    reg        btn_next_comb;
    reg        btn_execute;

    wire [3:0] leds;
    wire       tm_clk;
    wire       tm_dio;

    pullup(tm_dio); // Resistencia pull-up en la simulación

    top uut (
        .clk(clk), .rst(rst), .sw(sw),
        .btn_write_sel(btn_write_sel), .btn_write(btn_write),
        .btn_next_comb(btn_next_comb), .btn_execute(btn_execute),
        .leds(leds), .tm_clk(tm_clk), .tm_dio(tm_dio)
    );

    always #10 clk = ~clk; // Reloj de 50 MHz

    initial begin
        $dumpfile("sim_output.vcd");
        $dumpvars(0, tb_top);

        // Inicialización
        clk = 0; rst = 1; sw = 0;
        btn_write_sel = 0; btn_write = 0;
        btn_next_comb = 0; btn_execute = 0;
        #100; rst = 0; #40;

        // 1. Escribir valor 4'h5 en R0
        sw = 4'h5; btn_write_sel = 2'd0; #20;
        btn_write = 1; #20; btn_write = 0; #40;

        // 2. Escribir valor 4'h3 en R1
        sw = 4'h3; btn_write_sel = 2'd1; #20;
        btn_write = 1; #20; btn_write = 0; #40;

        // 3. Seleccionar operación SUMA (sw = 3'b000)
        sw = 4'b0000; #40;

        // Verificación de requerimiento: El resultado NO debe reflejarse aún en la salida
        #200;

        // 4. Presionar BTN3 (Ejecutar operación) -> Debe capturar 5 + 3 = 8
        btn_execute = 1; #20; btn_execute = 0; #500;

        // 5. Cambiar SW a RESTA (sw = 3'b001) SIN presionar BTN3
        sw = 4'b0101; #500; 
        // El display debe MANTENER el valor 8 de la operación anterior.

        // 6. Presionar BTN3 -> Ahora sí debe actualizarse a 5 - 3 = 2
        btn_execute = 1; #20; btn_execute = 0; #1000;

        $finish;
    end
endmodule