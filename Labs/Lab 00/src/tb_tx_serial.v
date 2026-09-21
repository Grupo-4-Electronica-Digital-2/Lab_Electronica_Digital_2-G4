`timescale 1ns/1ps

module tb_tx_serial();
    reg clk;
    reg rst;
    reg start;
    reg [7:0] data_in;
    
    wire tx;
    wire busy;
    wire done;

    tx_serial #(
        .CLKS_PER_BIT(8)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("serial_tx_tb.vcd");
        $dumpvars(0, tb_tx_serial);

        clk = 0; rst = 1; start = 0; data_in = 8'h00;
        #20 rst = 0; #20;

        // Transmisión 1: 0xA5
        @(posedge clk);
        data_in = 8'hA5;
        start = 1;
        @(posedge clk);
        start = 0;
        wait(done == 1'b1);
        @(posedge clk);
        
        #50;

        // Transmisión 2: 0x3C
        @(posedge clk);
        data_in = 8'h3C;
        start = 1;
        @(posedge clk);
        start = 0;
        wait(done == 1'b1);
        @(posedge clk);

        #50;
        $display("Simulación completada.");
        $finish;
    end
endmodule
