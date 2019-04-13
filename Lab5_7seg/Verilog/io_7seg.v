// Author: Jiang Zengkai
// Date: 2019.3.28

module io_7seg(
    input wire clk,
    input wire flash,
    input wire sync,
    input wire [63:0] data,
    output wire seg_clk,
    output wire seg_dat,
    output wire seg_en,
    output wire seg_clr);

    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;
    wire [7:0] seg4;
    wire [7:0] seg5;
    wire [7:0] seg6;
    wire [7:0] seg7;

    hex2seg hex0(.flash(flash), .hex(data[3:0]), .extend(data[35:32]), .seg(seg0));
    hex2seg hex1(.flash(flash), .hex(data[7:4]), .extend(data[39:36]), .seg(seg1));
    hex2seg hex2(.flash(flash), .hex(data[11:8]), .extend(data[43:40]), .seg(seg2));
    hex2seg hex3(.flash(flash), .hex(data[15:12]), .extend(data[47:44]), .seg(seg3));
    hex2seg hex4(.flash(flash), .hex(data[19:16]), .extend(data[51:48]), .seg(seg4));
    hex2seg hex5(.flash(flash), .hex(data[23:20]), .extend(data[55:52]), .seg(seg5));
    hex2seg hex6(.flash(flash), .hex(data[27:24]), .extend(data[59:56]), .seg(seg6));
    hex2seg hex7(.flash(flash), .hex(data[31:28]), .extend(data[63:60]), .seg(seg7));

    p2s#(.WIDTH(64)) io_7seg_board(
        .clk(clk),
        .sync(sync),
        .data({seg7, seg6, seg5, seg4, seg3, seg2, seg1, seg0}),
        .sclk(seg_clk),
        .sclr(seg_clr),
        .sout(seg_dat),
        .sen(seg_en));

endmodule
