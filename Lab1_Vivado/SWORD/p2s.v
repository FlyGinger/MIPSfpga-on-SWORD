// Author: Jiang Zengkai
// Date: 2019.3.21

module p2s#(
    parameter WIDTH = 16)(
    input wire clk,
    input wire sync,
    input wire [WIDTH-1:0] data,
    output wire sclk,
    output wire sclr,
    output reg sout,
    output wire sen);
    
    reg [1:0] state;
    reg [1:0] state_next;
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam SEND = 2'b10;
    localparam FINISH = 2'b11;

    reg [1:0] sample;
    wire ready = (sample == 2'b01);
    always @ (posedge clk) begin
        sample <= {sample[0], sync};
    end

    reg [WIDTH:0] buffer;
    wire done = &buffer[WIDTH-1:0];
    always @ (posedge clk) begin
        case (state)
            START: buffer <= {data, 1'b0};
            SEND: buffer <= {buffer[WIDTH-1:0], 1'b1};
            default: buffer <= buffer;
        endcase
    end
    
    always @ (posedge clk) begin
        state <= state_next;
    end
    always @ * begin
        case (state)
            IDLE: state_next <= ready ? START : IDLE;
            START: state_next <= SEND;
            SEND: state_next <= done ? FINISH : SEND;
            FINISH: state_next <= IDLE;
            default: state_next <= IDLE;
        endcase
    end
    
    always @ (posedge clk) begin
        sout <= buffer[WIDTH];
    end
    assign sclk = clk & (state == SEND || state == FINISH);
    assign sclr = 1'b1;
    assign sen = 1'b1;

endmodule
