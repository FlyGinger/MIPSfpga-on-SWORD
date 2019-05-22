// Author: Jiang Zengkai

module p2s#(
    parameter WIDTH = 16)(
    input  wire             clk,
    input  wire             sync,
    input  wire [WIDTH-1:0] data,
    output wire             sclk,
    output wire             sclrn,
    output wire             sout,
    output reg              sen
    );  

    // sampling
    reg [1:0] sample;
    always @ (posedge clk)
        sample <= {sample[0], sync};
    wire start = (sample == 2'b01) ? 1'b1: 1'b0;

    // state
    reg [1:0] state;
    localparam HOLD = 2'b00;
    localparam SHIFT = 2'b01;
    localparam LOAD = 2'b11;

    // buffer
    reg [WIDTH:0] buffer = {1'b1, {WIDTH{1'b1}}};
    wire finish = &buffer[WIDTH-1:0];
    always @ (posedge clk)
        case (state)
            HOLD: buffer <= buffer;
            SHIFT: buffer <= {buffer[WIDTH-1:0], 1'b1};
            LOAD: buffer <= {data, 1'b0};
            default: buffer <= buffer;
        endcase

    // state control
    always @ * begin
        if (start & finish) begin sen <= 0; state <= LOAD; end
        else if (!finish)   begin sen <= 0; state <= SHIFT; end
        else                begin sen <= 1; state <= HOLD; end
    end

    // output
    assign sout = buffer[WIDTH];
    assign sclk = finish | clk;
    assign sclrn = 1;

endmodule
