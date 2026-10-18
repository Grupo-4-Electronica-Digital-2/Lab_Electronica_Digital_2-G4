module op_selector (
    input  wire       clk,
    input  wire       btn2,
    input  wire       btn3,
    output reg  [1:0] op = 2'b00
);

    // Sincronizadores de los botones
    reg btn2_meta = 1'b0;
    reg btn2_sync = 1'b0;
    reg btn2_prev = 1'b0;

    reg btn3_meta = 1'b0;
    reg btn3_sync = 1'b0;
    reg btn3_prev = 1'b0;

    always @(posedge clk) begin
        // Sincronizar btn2
        btn2_meta <= btn2;
        btn2_sync <= btn2_meta;
        btn2_prev <= btn2_sync;

        // Sincronizar btn3
        btn3_meta <= btn3;
        btn3_sync <= btn3_meta;
        btn3_prev <= btn3_sync;

        // Cambiar el bit menos significativo
        if (btn2_sync && !btn2_prev)
            op[0] <= ~op[0];

        // Cambiar el bit más significativo
        if (btn3_sync && !btn3_prev)
            op[1] <= ~op[1];
    end

endmodule