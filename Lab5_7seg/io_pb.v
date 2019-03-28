// Author: Jiang Zengkai
// Date: 2019.3.28

module io_pb(
    input wire clk,
    input wire [4:0] btny,
    output reg [4:0] btnx,
    output reg [24:0] btn);

    // remove jitter
    reg [4:0] btny0;
    reg [4:0] btny1;
    reg [4:0] btny2;
    reg [4:0] btny3;
    always @ (posedge clk) begin
        btny0 <= btny;
        btny1 <= btny0;
        btny2 <= btny1;
        btny3 <= btny2;
    end
    wire [4:0] btny_stable = btny | btny0 | btny1 | btny2 | btny3;

    // state machine
    localparam IDLE = 3'b000;
    localparam SCAN_X0 = 3'b001;
    localparam SCAN_X1 = 3'b010;
    localparam SCAN_X2 = 3'b011;
    localparam SCAN_X3 = 3'b100;
    localparam SCAN_X4 = 3'b101;
    
    reg [2:0] state;
    reg [2:0] state_next;
    always @ (posedge clk) begin
        state <= state_next;
    end
    always @ * begin
        case (state)
            IDLE:       begin
                            state_next <= (btny_stable == 5'b11111) ? IDLE     : SCAN_X0;
                            btnx       <= (btny_stable == 5'b11111) ? 5'b00000 : 5'b11110;
                            btn        <= 25'b0;
                        end
            SCAN_X0:    begin
                            state_next <= (btny_stable == 5'b11111) ? SCAN_X1  : IDLE;
                            btnx       <= (btny_stable == 5'b11111) ? 5'b11101 : 5'b00000;
                            btn        <= (btny_stable == 5'b11111) ? 25'b0    : {20'b0, ~btny};
                        end
            SCAN_X1:    begin
                            state_next <= (btny_stable == 5'b11111) ? SCAN_X2  : IDLE;
                            btnx       <= (btny_stable == 5'b11111) ? 5'b11011 : 5'b00000;
                            btn        <= (btny_stable == 5'b11111) ? 25'b0    : {15'b0, ~btny, 5'b0};
                        end
            SCAN_X2:    begin
                            state_next <= (btny_stable == 5'b11111) ? SCAN_X3  : IDLE;
                            btnx       <= (btny_stable == 5'b11111) ? 5'b10111 : 5'b00000;
                            btn        <= (btny_stable == 5'b11111) ? 25'b0    : {10'b0, ~btny, 10'b0};
                        end
            SCAN_X3:    begin
                            state_next <= (btny_stable == 5'b11111) ? SCAN_X4  : IDLE;
                            btnx       <= (btny_stable == 5'b11111) ? 5'b01111 : 5'b00000;
                            btn        <= (btny_stable == 5'b11111) ? 25'b0    : {5'b0, ~btny, 15'b0};
                        end
            SCAN_X4:    begin
                            state_next <= IDLE;
                            btnx       <= 5'b00000;
                            btn        <= (btny_stable == 5'b11111) ? 25'b0    : {~btny, 20'b0};
                        end
            default:    begin
                            state_next <= IDLE;
                            btnx       <= 5'b00000;
                            btn        <= 25'b0;
                        end
        endcase
    end

endmodule
