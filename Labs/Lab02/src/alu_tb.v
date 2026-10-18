`timescale 1ns/1ps
`include "top.v"

module alu_tb;
    reg        clk=0, rst=0; // Reset activo en alto
    reg  [3:0] sw=0;
    reg        btn0=0,btn1=0,btn2=0,btn3=0;
    wire [3:0] led;
    wire       led_r,led_g,led_b;

    top DUT(.clk(clk),.rst(rst),.sw(sw),
        .btn0(btn0),.btn1(btn1),.btn2(btn2),.btn3(btn3),
        .led(led),.led_r(led_r),.led_g(led_g),.led_b(led_b));

    always #5 clk=~clk;
    integer pass=0, fail=0;

    task check_result;
        input [3:0]   exp;
        input [399:0] name; // Vector ampliado a 50 caracteres (400 bits) para evitar truncamiento
        begin
            if (led==exp) begin
                $display("PASS %-24s: led=%04b (%0d)", name, led, led);
                pass=pass+1;
            end else begin
                $display("FAIL %-24s: got=%04b exp=%04b", name, led, exp);
                fail=fail+1;
            end
        end
    endtask

    task check_rgb;
        input [2:0]   exp_rgb; // {R,G,B}
        input [399:0] name; 
        begin
            if ({led_r,led_g,led_b}==exp_rgb) begin
                $display("PASS RGB %-20s: RGB=%03b", name, {led_r,led_g,led_b});
                pass=pass+1;
            end else begin
                $display("FAIL RGB %-20s: got=%03b exp=%03b",
                    name,{led_r,led_g,led_b},exp_rgb);
                fail=fail+1;
            end
        end
    endtask

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);$display("=== Testbench ALU 4 bits con almacenamiento ===");

        // Lógica de reset ACTIVO EN ALTO para los submódulos (1 = reset, 0 = run)
        rst=1; repeat(4) @(posedge clk); rst=0;
        repeat(2) @(posedge clk);

        // Cargar A=5
        sw=4'b0101;
        @(negedge clk); btn0=1;
        @(negedge clk); @(negedge clk); btn0=0;
        @(posedge clk); #1;
        $display("--- A=5 (0101) cargado ---");

        // Cargar B=3
        sw=4'b0011;
        @(negedge clk); btn1=1;
        @(negedge clk); @(negedge clk); btn1=0;
        @(posedge clk); #1;
        $display("--- B=3 (0011) cargado ---");

        // Cambiar sw — A y B deben conservarse intactos
        sw=4'b1111; @(posedge clk); #1;

        // op=00 SUMA
        $display("--- op=00 SUMA ---");
        check_result(4'd8,   "SUMA 5+3=8");
        check_rgb(3'b010,    "Verde (Suma)"); // Zybo: 010 (G=1)

        // op=01 RESTA — toggle op[0] con btn2
        @(negedge clk); btn2=1;
        @(negedge clk); @(negedge clk); btn2=0;
        @(posedge clk); #2;
        $display("--- op=01 RESTA ---");
        check_result(4'd2,   "RESTA 5-3=2");
        check_rgb(3'b100,    "Rojo (Resta)"); // Zybo: 100 (R=1)

        // op=10 AND — toggle op[0] de vuelta, toggle op[1]
        @(negedge clk); btn2=1;
        @(negedge clk); @(negedge clk); btn2=0;
        @(negedge clk); btn3=1;
        @(negedge clk); @(negedge clk); btn3=0;
        @(posedge clk); #2;
        $display("--- op=10 AND ---");
        check_result(4'b0001,"AND 0101&0011=0001");
        check_rgb(3'b001,    "Azul (AND)"); // Zybo: 001 (B=1)

        // op=11 OR — toggle op[0]
        @(negedge clk); btn2=1;
        @(negedge clk); @(negedge clk); btn2=0;
        @(posedge clk); #2;
        $display("--- op=11 OR ---");
        check_result(4'b0111,"OR 0101|0011=0111");
        check_rgb(3'b110,    "Amarillo (OR)"); // Zybo: 110 (R=1, G=1)

        // Verificar que A y B no cambiaron (sw=1111 pero resultado de SUMA sigue siendo 8)
        @(negedge clk); btn2=1;
        @(negedge clk); @(negedge clk); btn2=0;
        @(negedge clk); btn3=1;
        @(negedge clk); @(negedge clk); btn3=0;
        @(posedge clk); #2;
        $display("--- Verificar conservacion operandos ---");
        check_result(4'd8, "A=5 B=3 conservados (sw=1111 ignorado)");

        // Prueba con A=15, B=1 → RESTA = 14
        sw=4'b1111; @(negedge clk); btn0=1;
        @(negedge clk); @(negedge clk); btn0=0;
        sw=4'b0001; @(negedge clk); btn1=1;
        @(negedge clk); @(negedge clk); btn1=0;
        
        // op=01 RESTA
        @(negedge clk); btn2=1;
        @(negedge clk); @(negedge clk); btn2=0;
        @(posedge clk); #2;
        $display("--- A=15 B=1 RESTA ---");
        check_result(4'd14, "RESTA 15-1=14");

        $display("─────────────────────────────────");
        $display("TOTAL: PASS=%0d FAIL=%0d", pass, fail);
        $finish;
    end
    initial #500000 begin $display("TIMEOUT"); $finish; end
endmodule