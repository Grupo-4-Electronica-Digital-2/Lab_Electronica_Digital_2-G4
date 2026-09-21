`timescale 1ns/1ps

module tx_serial #(
    parameter CLKS_PER_BIT = 8
)(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,
    output wire tx,
    output wire busy,
    output wire done
);

  
    localparam IDLE     = 3'd0;
    localparam LOAD     = 3'd1;
    localparam SEND     = 3'd2;
    localparam BIT_HOLD = 3'd3;
    localparam SHIFT    = 3'd4;
    localparam DONE_ST  = 3'd5;
    reg [2:0] state, next_state;
    //  VARIABLES DE CONTROL (FSM -> Datapath)
    reg espera;
    reg ctrl_rst;   
    reg send;       
    reg duracion;   
    reg shft;       
    reg ctrl_done;  

  
    reg [7:0] shift_reg;
    reg [3:0] bit_count; // 4 bits para poder contar hasta 8
    reg [$clog2(CLKS_PER_BIT):0] tick_cnt;

    //  BANDERAS (Datapath -> FSM)
      wire tick_done;
    wire bit_done;

    assign tick_done = (tick_cnt == CLKS_PER_BIT);
    assign bit_done  = (bit_count == 4'd8); // Ajustado a 8 para transmitir el byte completo

   
    always @(*) begin
        // Valores por defecto 
        next_state = state;
        espera = 0; ctrl_rst = 0; send = 0; duracion = 0; shft = 0; ctrl_done = 0;

        case (state)
            IDLE: begin
                espera = 1;
                if (start == 1'b1) next_state = LOAD;
            end
            LOAD: begin
                ctrl_rst = 1;
                next_state = SEND;
            end
            SEND: begin
                send = 1;
                next_state = BIT_HOLD;
            end
            BIT_HOLD: begin
                duracion = 1;
                if (tick_done == 1'b1) next_state = SHIFT;
            end
            SHIFT: begin
                shft = 1;
                if (bit_done == 1'b1) next_state = DONE_ST;
                else                  next_state = SEND;
            end
            DONE_ST: begin
                ctrl_done = 1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Transición de estado síncrona
    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    
    //  DATAPATH
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'hFF;
            bit_count <= 4'd0;
            tick_cnt  <= 0;
        end else begin
            if (ctrl_rst) begin
                shift_reg <= data_in;
                bit_count <= 4'd0;
                tick_cnt  <= 1; // Iniciado en 1 como indica tu diagrama
            end
            else if (duracion) begin
                tick_cnt <= tick_cnt + 1'b1;
            end
            else if (shft) begin
                tick_cnt  <= 0; // Se reinicia el conteo para el siguiente bit
                bit_count <= bit_count + 1'b1;
                shift_reg <= shift_reg >> 1;
            end
        end
    end

   
    //  SALIDAS EXTERNAS
   
    // Las salidas externas obedecen a las señales de control de la FSM
    assign tx   = (espera | ctrl_done) ? 1'b1 : shift_reg[0];
    assign busy = (espera | ctrl_done) ? 1'b0 : 1'b1;
    assign done = ctrl_done;

endmodule
