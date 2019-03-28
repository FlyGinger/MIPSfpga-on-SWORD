// Author: Jiang Zengkai
// Date: 2019.3.21

`include "mfp_ahb_const.vh"

module mfp_sword(
    // Clock and reset
    input CLK_200M_P,
    input CLK_200M_N,
    input CPU_RESETN,
    // Button
    input [4:0] BTNY,
    output [4:0] BTNX,
    // Switches
    input [`MFP_N_SW-1:0] SW,
    // LEDs
    output LED_CLK,
    output LED_DAT,
    output LED_EN,
    output LED_CLR,
    output [7:0] LED_ARDUINO,
    // 7-segment LEDs
    output SEG_CLK,
    output SEG_DAT,
    output SEG_EN,
    output SEG_CLR,
    output [3:0] AN,
    output [7:0] SEG,
    // Pmod
    inout [8:1] JB,
    // UART
    input UART_TXD_IN);
    
    
    // Clock and reset
    wire clk_out;
    wire [31:0] clk;
    wire tck_in, tck;
    IBUF IBUF1(.O(tck_in),.I(JB[4]));
    BUFG BUFG1(.O(tck), .I(tck_in));
    clk_wiz_0 clk_wiz_0(
        .clk_in1_p(CLK_200M_P),
        .clk_in1_n(CLK_200M_N),
        .clk_out1(clk_out));
    clk_div clk_div(
        .clk(clk_out),
        .clk_div(clk));

    
    // Button
    wire [4:0] BTN = ~BTNY;
    assign BTNX = 5'b0;
    
    
    // LEDs
    wire [`MFP_N_LED-1:0] LED;
    assign LED_ARDUINO = LED[7:0];
    p2s io_led(
        .clk(clk_out),
        .sync(clk[10]),
        .data(LED),
        .sclk(LED_CLK),
        .sclr(LED_CLR),
        .sout(LED_DAT),
        .sen(LED_EN));
    
    
    // 7-segment LEDs
    wire [`MFP_N_7SEG-1:0] SEG7;
    io_7seg io_7seg(
        .clk(clk_out),
        .sync(clk[10]),
        .scan(clk[19:18]),
        .data(SEG7),
        .seg_clk(SEG_CLK),
        .seg_clr(SEG_CLR),
        .seg_dat(SEG_DAT),
        .seg_en(SEG_EN),
        .an(AN),
        .seg(SEG));
    
    
    // main system
    mfp_sys mfp_sys(
        .SI_Reset_N(CPU_RESETN),
        .SI_ClkIn(clk_out),
        .HADDR(),
        .HRDATA(),
        .HWDATA(),
        .HWRITE(),
        .HSIZE(),
        .EJ_TRST_N_probe(JB[7]),
        .EJ_TDI(JB[2]),
        .EJ_TDO(JB[3]),
        .EJ_TMS(JB[1]),
        .EJ_TCK(tck),
        .SI_ColdReset_N(JB[8]),
        .EJ_DINT(1'b0),
        .IO_Switch(SW),
        .IO_PB(BTN),
        .IO_LED(LED),
        .IO_7SEG(SEG7),
        .UART_RX(UART_TXD_IN));


endmodule

