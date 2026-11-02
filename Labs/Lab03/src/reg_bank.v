module reg_bank (
    input  wire       clk,
    input  wire       rst,
    input  wire       we,          // Write Enable (procedente de BTN1 debounced)
    input  wire [1:0] write_addr,  // Registro a escribir (00:R0, 01:R1, 10:R2, 11:R3)
    input  wire [3:0] write_data,  // SW[3:0]
    input  wire [1:0] read_addr_a, // Dirección operando A
    input  wire [1:0] read_addr_b, // Dirección operando B
    output wire [3:0] read_data_a,
    output wire [3:0] read_data_b
);
    reg [3:0] regs [3:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            regs[0] <= 4'h0;
            regs[1] <= 4'h0;
            regs[2] <= 4'h0;
            regs[3] <= 4'h0;
        end else if (we) begin
            regs[write_addr] <= write_data;
        end
    end

    assign read_data_a = regs[read_addr_a];
    assign read_data_b = regs[read_addr_b];
endmodule