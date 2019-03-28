// Author: Jiang Zengkai
// Date: 2019.3.28

module io_a7seg(
    input wire clk,
    input wire flash,
    input wire [1:0] scan,
    input wire [31:0] data,
    output reg [3:0] an,
    output reg [7:0] seg);

    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;

    hex2seg hex0(.flash(flash), .hex(data[3:0]), .extend(data[19:16]), .seg(seg0));
    hex2seg hex1(.flash(flash), .hex(data[7:4]), .extend(data[23:20]), .seg(seg1));
    hex2seg hex2(.flash(flash), .hex(data[11:8]), .extend(data[27:24]), .seg(seg2));
    hex2seg hex3(.flash(flash), .hex(data[15:12]), .extend(data[31:28]), .seg(seg3));
    
    always @ (posedge clk) begin
        case (scan)
            2'b00: begin an <= 4'b1110; seg <= seg3; end
            2'b01: begin an <= 4'b1101; seg <= seg2; end
            2'b10: begin an <= 4'b1011; seg <= seg1; end
            2'b11: begin an <= 4'b0111; seg <= seg0; end
        endcase
    end

endmodule