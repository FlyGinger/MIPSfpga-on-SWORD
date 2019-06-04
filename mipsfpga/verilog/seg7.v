// Author: Jiang Zengkai

module seg7(
    input  wire        clk,
    input  wire [1 :0] scan,
    input  wire [31:0] data,
    output reg  [3 :0] an,
    output reg  [7 :0] seg
    );
    
    always @ (posedge clk)
        case (scan)
            2'b00: begin an <= 4'b1110; seg <= data[31:24]; end
            2'b01: begin an <= 4'b1101; seg <= data[23:16]; end
            2'b10: begin an <= 4'b1011; seg <= data[15:8]; end
            2'b11: begin an <= 4'b0111; seg <= data[7:0]; end
        endcase

endmodule
