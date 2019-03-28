// Author: Jiang Zengkai
// Date: 2019.3.28

module io_pb(
    input wire clk,
    input wire [4:0] btny,
    output reg [4:0] btnx,
    output reg [24:0] btn);

    // state machine
    localparam IDLE = 3'b000;
    localparam SCAN_X0 = 3'b001;
    localparam SCAN_X1 = 3'b010;
    localparam SCAN_X2 = 3'b011;
    localparam SCAN_X3 = 3'b100;
    localparam SCAN_X4 = 3'b101;
    localparam DONE = 3'b110;
    
    reg [2:0] state;
    reg [2:0] state_next;
    always @ (posedge clk) begin
        state <= state_next;
    end
    always @ * begin
        case (state)
            IDLE: state_next <= (btny == 5'b11111) ? IDLE : SCAN_X0;
            SCAN_X0: state_next <= (btny == 5'b11111) ? SCAN_X1 : DONE;
            SCAN_X1: state_next <= (btny == 5'b11111) ? SCAN_X2 : DONE;
            SCAN_X2: state_next <= (btny == 5'b11111) ? SCAN_X3 : DONE;
            SCAN_X3: state_next <= (btny == 5'b11111) ? SCAN_X4 : DONE;
            SCAN_X4: state_next <= (btny == 5'b11111) ? IDLE : DONE;
            DONE: state_next <= (btny == 5'b11111) ? IDLE : DONE;
            default: state_next <= IDLE;
        endcase
    end

    reg [4:0] row;
    reg [4:0] col;
    always @ (posedge clk) begin
        case (state_next)
            IDLE:       begin btnx <= 5'b00000; row <= 5'b0; col <= 5'b0; end
            SCAN_X0:    begin btnx <= 5'b11110; row <= 5'b0; col <= 5'b0; end
            SCAN_X1:    begin btnx <= 5'b11101; row <= 5'b0; col <= 5'b0; end
            SCAN_X2:    begin btnx <= 5'b11011; row <= 5'b0; col <= 5'b0; end
            SCAN_X3:    begin btnx <= 5'b10111; row <= 5'b0; col <= 5'b0; end
            SCAN_X4:    begin btnx <= 5'b01111; row <= 5'b0; col <= 5'b0; end
            DONE:       begin btnx <= btnx; row <= btnx; col <= btny; end 
            default:    begin btnx <= 5'b00000; row <= 5'b0; col <= 5'b0; end
        endcase
    end

    always @ * begin
        case (row)
            5'b11110: btn <= {20'b0, ~col};
            5'b11101: btn <= {15'b0, ~col, 5'b0};
            5'b11011: btn <= {10'b0, ~col, 10'b0};
            5'b10111: btn <= {5'b0, ~col, 15'b0};
            5'b01111: btn <= {~col, 20'b0};
            default: btn <= 25'b0;
        endcase
    end

endmodule
