module hc595_driver (
    input  wire       clk,        // Reloj de baja frecuencia (~50 kHz - 100 kHz)
    input  wire       rst,        // Reset activo en alto
    input  wire [7:0] seg0,       // Byte del decodificador 7 segmentos [DP, G, F, E, D, C, B, A]
    output reg        ds,         // Dato Serie (Pin SER / DS)
    output reg        sh_cp,      // Reloj de Desplazamiento (Pin SRCLK / SH_CP)
    output reg        st_cp       // Reloj de Latch (Pin RCLK / ST_CP)
);

    localparam [2:0]
        ST_IDLE       = 3'd0,
        ST_SHIFT_LOW  = 3'd1,
        ST_SHIFT_HIGH = 3'd2,
        ST_LATCH_LOW  = 3'd3,
        ST_LATCH_HIGH = 3'd4,
        ST_HOLD       = 3'd5;

    reg [2:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= ST_IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'h00;
            ds        <= 1'b0;
            sh_cp     <= 1'b0;
            st_cp     <= 1'b0;
        end else begin
            case (state)
                ST_IDLE: begin
                    sh_cp     <= 1'b0;
                    st_cp     <= 1'b0;
                    shift_reg <= seg0;   // Captura los 8 bits de segmentos
                    bit_cnt   <= 3'd0;
                    state     <= ST_SHIFT_LOW;
                end

                // 1. Coloca el bit correspondiente en la línea DS (enviando de MSB a LSB)
                ST_SHIFT_LOW: begin
                    ds    <= shift_reg[3'd7 - bit_cnt];
                    sh_cp <= 1'b0;
                    state <= ST_SHIFT_HIGH;
                end

                // 2. Flanco de subida en SH_CP: El 74HC595 ingresa el bit
                ST_SHIFT_HIGH: begin
                    sh_cp <= 1'b1;
                    if (bit_cnt == 3'd7) begin
                        state <= ST_LATCH_LOW;
                    end else begin
                        bit_cnt <= bit_cnt + 1'b1;
                        state   <= ST_SHIFT_LOW;
                    end
                end

                // 3. Prepara el pulso de almacenamiento
                ST_LATCH_LOW: begin
                    sh_cp <= 1'b0;
                    st_cp <= 1'b0;
                    state <= ST_LATCH_HIGH;
                end

                // 4. Flanco de subida en ST_CP: Copia los bits a las salidas del chip
                ST_LATCH_HIGH: begin
                    st_cp <= 1'b1;
                    state <= ST_HOLD;
                end

                // 5. Retención y ciclo continuo de refresco
                ST_HOLD: begin
                    st_cp <= 1'b0;
                    state <= ST_IDLE;
                end

                default: state <= ST_IDLE;
            endcase
        end
    end
endmodule