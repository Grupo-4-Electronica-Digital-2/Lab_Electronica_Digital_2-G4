module acumulador_sec (
    input clk,
    input rst,
    input start,
    input [3:0] x,
    output reg [5:0] acc,
    output reg done
);

// Estados
parameter IDLE = 2'd0;
parameter LOAD = 2'd1;
parameter ADD  = 2'd2;
parameter DONE = 2'd3;

// Variantes en add
parameter variante = 2'd2;
parameter var_3    = 2'd0;
parameter var_4    = 2'd1;
parameter var_20   = 2'd2;

reg [1:0] estado, estado_siguiente;
reg [2:0] contador, contador_siguiente;
reg [5:0] acc_siguiente;

// Bloque secuencial (registros)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        estado   <= IDLE;
        contador <= 3'd0;
        acc      <= 6'd0;
    end else begin
        estado   <= estado_siguiente;
        contador <= contador_siguiente;
        acc      <= acc_siguiente;
    end
end // <-- FALTABA ESTE END

// Bloque combinacional (Lógica de próximo estado)
always @(*) begin
    estado_siguiente   = estado;
    contador_siguiente = contador;
    acc_siguiente      = acc;

    case (estado)
        IDLE: begin
            contador_siguiente = 3'd0;
            if (start) begin
                estado_siguiente = LOAD;
            end
        end

        LOAD: begin
            acc_siguiente      = 6'd0;
            contador_siguiente = 3'd0;
            estado_siguiente   = ADD;
        end

        ADD: begin
            acc_siguiente   = acc + x;
            contador_siguiente = contador + 1'd1;

            case (variante)
                var_3: begin
                    if (contador == 3'd2) begin
                        estado_siguiente = DONE;
                    end
                end
                var_4: begin
                    if (contador == 3'd3) begin
                        estado_siguiente = DONE;
                    end          
                end
                var_20: begin
                    if ((acc + x) >= 6'd20) begin
                        estado_siguiente = DONE;
                    end
                end
                default: estado_siguiente = IDLE;
            endcase
        end

        DONE: begin
            estado_siguiente = IDLE;
        end

        default: begin
            estado_siguiente   = IDLE;
            contador_siguiente = 3'd0;
            acc_siguiente      = 6'd0;
        end
    endcase 
end

// Lógica de salida combinacional
always @(*) begin
    done = 1'b0;
    if (estado == DONE) begin
        done = 1'b1;
    end
end

endmodule
