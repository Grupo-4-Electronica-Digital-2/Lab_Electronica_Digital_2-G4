module hex_to_7seg (
    input  wire [3:0] hex,
    output reg  [7:0] seg // Formato de segmentos: [DP, G, F, E, D, C, B, A]
);
    always @(*) begin
        case (hex)
            4'h0: seg = 8'b0011_1111;
            4'h1: seg = 8'b0000_0110;
            4'h2: seg = 8'b0101_1011;
            4'h3: seg = 8'b0100_1111;
            4'h4: seg = 8'b0110_0110;
            4'h5: seg = 8'b0110_1101;
            4'h6: seg = 8'b0111_1101;
            4'h7: seg = 8'b0000_0111;
            4'h8: seg = 8'b0111_1111;
            4'h9: seg = 8'b0110_1111;
            4'hA: seg = 8'b0111_0111;
            4'hB: seg = 8'b0111_1100;
            4'hC: seg = 8'b0011_1001;
            4'hD: seg = 8'b0101_1110;
            4'hE: seg = 8'b0111_1001;
            4'hF: seg = 8'b0111_0001;
            default: seg = 8'b0000_0000;
        endcase
    end
endmodule