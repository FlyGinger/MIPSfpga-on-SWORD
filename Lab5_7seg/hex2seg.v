// Author: Jiang Zengkai
// Date: 2019.3.27
// Version: 2.1.0

module hex2seg(
    input wire [3:0] hex,
    output reg [7:0] seg); // high active

    always @ * begin
        case (hex)
            'h0: seg <= 8'b11111100;
            'h1: seg <= 8'b01100000;
            'h2: seg <= 8'b11011010;
            'h3: seg <= 8'b11110010;
            'h4: seg <= 8'b01100110;
            'h5: seg <= 8'b10110110;
            'h6: seg <= 8'b10111110;
            'h7: seg <= 8'b11100000;
            'h8: seg <= 8'b11111110;
            'h9: seg <= 8'b11110110;
            'ha: seg <= 8'b11101110;
            'hb: seg <= 8'b00111110;
            'hc: seg <= 8'b10011100;
            'hd: seg <= 8'b01111010;
            'he: seg <= 8'b10011110;
            'hf: seg <= 8'b10001110;
            default: seg <= 0; 
        endcase
    end

endmodule
