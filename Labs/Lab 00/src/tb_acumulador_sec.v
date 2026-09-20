`timescale 1ns / 1ps 

module tb_acumulador_sec();

    reg clk;
    reg rst;
    reg start;
    reg [3:0] x;
    wire [5:0] acc;
    wire done;

    // Instanciación del módulo acumulador (Probando variante 0: sumar 3 veces)
    acumulador_sec uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .x(x),
        .acc(acc),
        .done(done)
    );

    // Generación de reloj (Periodo = 10ns)
    always #5 clk = ~clk;

    initial begin
        // Archivos para GTKWave
        $dumpfile("acumulador_sec.vcd");
        $dumpvars(0, tb_acumulador_sec);

        // Inicialización de señales
        clk   = 0;
        rst   = 1;
        start = 0;
        x     = 4'd0;

        // Reset inicial durante 10ns
        #10 rst = 0;
        #10;

        // --- INICIO DEL PROCESO DE ACUMULACIÓN ---
        x = 4'd3;      // Fijamos la entrada x = 4
        start = 1'b1;  // Damos pulso de inicio
        #10;
        start = 1'b0;  // Bajamos start (solo requiere 1 ciclo)

        // Dejamos correr la simulación para observar los estados:
        // IDLE -> LOAD -> ADD (3 ciclos de suma) -> DONE -> IDLE
        #150;

        $display("Simulación finalizada exitosamente.");
        $finish;
    end

endmodule
