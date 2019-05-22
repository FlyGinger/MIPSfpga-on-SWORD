// Author: Jiang Zengkai

module clk_div(
    input  wire        clk,
    output reg  [31:0] clk_div
    );
    
    always @ (posedge clk)
        clk_div <= clk_div + 1;

endmodule

// 100 Mhz
// 50 MHz
// 25 MHz
// 12.5 MHz
// 6.25 MHz
// 3.125 MHz
// 1.5625 MHz
// 781.25 KHz
// 390.625 KHz
// 195.53125 KHz
// 97.65625 KHz
// 48.828125 KHz
// 24.4140625 KHz
// 12.2070313 KHz
// 6.10351565 KHz
// 3.05175783 KHz
// 1.52587892 KHz
// 762.93946 Hz
// 381.46973 Hz
// 190.734865 Hz
// 95.3674325 Hz
// 47.6837163 Hz
// 23.8418582 Hz
// 11.9209291 Hz
// 5.96046455 Hz
// 2.98023228 Hz
// 1.49011614 Hz
// 1/(1.34s)
// 1/(2.68s)
// 1/(5.37s)
// 1/(10.74s)
// 1/(21.47s)
// 1/(42.95s)
// 1/(85.90s)
