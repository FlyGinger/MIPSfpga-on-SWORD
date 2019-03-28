// Author: Jiang Zengkai
// Date: 2019.3.27

module io_7seg(
    input wire clk,
    input wire sync,
    input wire [1:0] scan,
    input wire [31:0] data,
    output wire seg_clk,
    output wire seg_dat,
    output wire seg_en,
    output wire seg_clr,
    output reg [3:0] an,
    output reg [7:0] seg);

    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;
    wire [7:0] seg4;
    wire [7:0] seg5;
    wire [7:0] seg6;
    wire [7:0] seg7;

    hex2seg hex0(.hex(data[3:0]), .seg(seg0));
    hex2seg hex1(.hex(data[7:4]), .seg(seg1));
    hex2seg hex2(.hex(data[11:8]), .seg(seg2));
    hex2seg hex3(.hex(data[15:12]), .seg(seg3));
    hex2seg hex4(.hex(data[19:16]), .seg(seg4));
    hex2seg hex5(.hex(data[23:20]), .seg(seg5));
    hex2seg hex6(.hex(data[27:24]), .seg(seg6));
    hex2seg hex7(.hex(data[31:28]), .seg(seg7));

    p2s#(.WIDTH(64)) io_7seg_board(
        .clk(clk),
        .sync(sync),
        .data({seg7, seg6, seg5, seg4, seg3, seg2, seg1, seg0}),
        .sclk(seg_clk),
        .sclr(seg_clr),
        .sout(seg_dat),
        .sen(seg_en));
    
    always @ (posedge clk) begin
        case (scan)
            2'b00: begin an <= 4'b1110; seg <= ~seg0; end
            2'b01: begin an <= 4'b1101; seg <= ~seg1; end
            2'b10: begin an <= 4'b1011; seg <= ~seg2; end
            2'b11: begin an <= 4'b0111; seg <= ~seg3; end
        endcase
    end

endmodule
