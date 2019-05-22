// Author: Jiang Zengkai

module buzzer(
    input  wire        clk,     // Must be 50 MHz
    input  wire        rst,
    input  wire [31:0] halflen, // 2.5e7 / f
    output reg         buzzer
    );

    reg [31:0] counter;
    reg [31:0] halflen_buffer;

    always @ (posedge clk) begin
        if (rst || halflen == 0) begin
            buzzer <= 0;
            counter <= 0;
            halflen_buffer <= 0;
        end
        else begin
            if (halflen != halflen_buffer) begin
                halflen_buffer <= halflen;
                buzzer <= 0;
                counter <= 0;
            end
            else begin
                if (counter == halflen_buffer) begin
                    buzzer <= ~buzzer;
                    counter <= 0;
                end
                else begin
                    counter <= counter + 1;
                end
            end
        end
    end

endmodule
