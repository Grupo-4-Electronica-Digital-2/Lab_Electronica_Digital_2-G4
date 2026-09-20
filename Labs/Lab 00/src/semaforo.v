module semaforo (
    input  wire clk,
    input  wire rst,
    output reg  green,
    output reg  yellow,
    output reg  red
);

    localparam S0_GREEN  = 2'b00,
               S1_YELLOW = 2'b01,
               S2_RED    = 2'b10;

    reg [1:0] state;
    reg [3:0] count; 

   
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0_GREEN;
            count <= 4'd0;
        end else begin
            case (state)
                S0_GREEN: begin
                   
                    if (count == 4'd4) state <= S1_YELLOW;
                    count <= count + 1'b1;
                end

                S1_YELLOW: begin
                    if (count == 4'd6) begin
                        
                        state <= S2_RED;
                        count <= count + 1'b1;
                    end else if (count == 4'd12) begin
                        
                        state <= S0_GREEN;
                        count <= 4'd0;
                    end else begin
                        count <= count + 1'b1;
                    end
                end

                S2_RED: begin
                    
                    if (count == 4'd10) state <= S1_YELLOW;
                    count <= count + 1'b1;
                end

                default: begin
                    state <= S0_GREEN;
                    count <= 4'd0;
                end
            endcase
        end
    end

   
    always @(*) begin
        green  = (state == S0_GREEN);
        yellow = (state == S1_YELLOW);
        red    = (state == S2_RED);
    end

endmodule