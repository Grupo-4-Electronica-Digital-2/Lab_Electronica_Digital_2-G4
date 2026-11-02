module top (
    input  wire       clk,
    input  wire [3:0] sw,
    input  wire       btn0,
    input  wire       btn1,
    input  wire       btn2,
    input  wire       btn3,
    output wire [3:0] led,
    output reg        led_r,
    output reg        led_g,
    output reg        led_b,
    output wire       ds,
    output wire       sh_cp,
    output wire       st_cp
);

    wire clk_slow;
    wire rst = 1'b0;
    wire btn0_p, btn1_p, btn2_p, btn3_p;

    reg  [1:0] write_addr_cnt;
    wire [1:0] addr_a, addr_b;
    wire [3:0] data_a, data_b;
    wire [3:0] alu_raw_res;
    wire [3:0] latched_res;
    wire [7:0] seg_patterns;

    clk_divider u_clkdiv (
        .clk_in(clk),
        .rst(rst),
        .clk_out(clk_slow)
    );

    debouncer db0 (.clk(clk), .rst(rst), .btn_in(btn0), .btn_pulse(btn0_p));
    debouncer db1 (.clk(clk), .rst(rst), .btn_in(btn1), .btn_pulse(btn1_p));
    debouncer db2 (.clk(clk), .rst(rst), .btn_in(btn2), .btn_pulse(btn2_p));
    debouncer db3 (.clk(clk), .rst(rst), .btn_in(btn3), .btn_pulse(btn3_p));

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_addr_cnt <= 2'b00;
        end else if (btn0_p) begin
            write_addr_cnt <= write_addr_cnt + 1'b1;
        end
    end

    always @(*) begin
        case (write_addr_cnt)
            2'b00: {led_r, led_g, led_b} = 3'b100;
            2'b01: {led_r, led_g, led_b} = 3'b010;
            2'b10: {led_r, led_g, led_b} = 3'b001;
            2'b11: {led_r, led_g, led_b} = 3'b110;
            default: {led_r, led_g, led_b} = 3'b000;
        endcase
    end

    comb_selector u_comb (
        .clk(clk),
        .rst(rst),
        .next_comb(btn2_p),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .leds_active(led)
    );

    reg_bank u_regs (
        .clk(clk),
        .rst(rst),
        .we(btn1_p),
        .write_addr(write_addr_cnt),
        .write_data(sw),
        .read_addr_a(addr_a),
        .read_addr_b(addr_b),
        .read_data_a(data_a),
        .read_data_b(data_b)
    );

    alu u_alu (
        .a(data_a),
        .b(data_b),
        .op(sw[2:0]),
        .result(alu_raw_res)
    );

    result_latch u_latch (
        .clk(clk),
        .rst(rst),
        .execute(btn3_p),
        .alu_result(alu_raw_res),
        .latched_result(latched_res)
    );

    hex_to_7seg u_dec (
        .hex(latched_res),
        .seg(seg_patterns)
    );

    hc595_driver u_display_driver (
        .clk(clk_slow),
        .rst(rst),
        .seg0(seg_patterns),
        .ds(ds),
        .sh_cp(sh_cp),
        .st_cp(st_cp)
    );

endmodule