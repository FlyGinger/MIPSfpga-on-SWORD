// Author: Jiang Zengkai
// Date: 2019.3.28

module hex2seg(
    input wire flash,
    input wire [3:0] hex,
    input wire [3:0] extend,
    output wire [7:0] seg); // high active

    reg [7:0] seg_out;
    always @ * begin
        case (extend[2:0])
            3'b000:// normal number
                case (hex)
                    'h0: seg_out <= 8'b00111111;
                    'h1: seg_out <= 8'b00000110;
                    'h2: seg_out <= 8'b01011011;
                    'h3: seg_out <= 8'b01001111;
                    'h4: seg_out <= 8'b01100110;
                    'h5: seg_out <= 8'b01101101;
                    'h6: seg_out <= 8'b01111101;
                    'h7: seg_out <= 8'b00000111;
                    'h8: seg_out <= 8'b01111111;
                    'h9: seg_out <= 8'b01101111;
                    'ha: seg_out <= 8'b01110111;
                    'hb: seg_out <= 8'b01111100;
                    'hc: seg_out <= 8'b00111001;
                    'hd: seg_out <= 8'b01011110;
                    'he: seg_out <= 8'b01111001;
                    'hf: seg_out <= 8'b01110001;
                    default: seg_out <= 0; 
                endcase
            3'b001:// pixel mode
                seg_out <= {extend, hex};
            3'b111:// disabled
                seg_out <= 8'b0;
            default:
                seg_out <= 8'b0;
        endcase
    end
    assign seg = extend[3] ? flash & seg_out : seg_out;

endmodule
