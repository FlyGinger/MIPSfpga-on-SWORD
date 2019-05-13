// Author: Jiang Zengkai
// Date: 2019.3.28

module hex2seg(
    input wire flash,
    input wire [3:0] hex,
    input wire [3:0] extend,
    output wire [7:0] seg); // low active

    reg [7:0] seg_out;
    always @ * begin
        case (extend[2:0])
            3'b000:// normal hex number
                case (hex)
                    'h0: seg_out <= 8'b11000000;
                    'h1: seg_out <= 8'b11111001;
                    'h2: seg_out <= 8'b10100100;
                    'h3: seg_out <= 8'b10110000;
                    'h4: seg_out <= 8'b10011001;
                    'h5: seg_out <= 8'b10010010;
                    'h6: seg_out <= 8'b10000010;
                    'h7: seg_out <= 8'b11111000;
                    'h8: seg_out <= 8'b10000000;
                    'h9: seg_out <= 8'b10010000;
                    'ha: seg_out <= 8'b10001000;
                    'hb: seg_out <= 8'b10000011;
                    'hc: seg_out <= 8'b11000110;
                    'hd: seg_out <= 8'b10100001;
                    'he: seg_out <= 8'b10000110;
                    'hf: seg_out <= 8'b10001110;
                    default: seg_out <= 0; 
                endcase
            3'b111:// disabled
                seg_out <= 8'hff;
            default:
                seg_out <= 8'hff;
        endcase
    end
    assign seg = extend[3] ? {8{flash}} | seg_out : seg_out;

endmodule
