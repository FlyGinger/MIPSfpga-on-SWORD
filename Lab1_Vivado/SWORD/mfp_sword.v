// Author: Jiang Zengkai
// Date: 2019.3.28

`include "mfp_ahb_const.vh"

module mfp_sword(
    // Clock and reset
    input CLK_200M_P,
    input CLK_200M_N,
    input CPU_RESETN,
    // LEDs
    output LED_CLK,
    output LED_DAT,
    output LED_EN,
    output LED_CLR,
    // Switches
    input [15:0] SW,
    // Button
    input [4:0] BTNY,
    output [4:0] BTNX,
    // 7-segment LEDs
    output SEG_CLK,
    output SEG_DAT,
    output SEG_EN,
    output SEG_CLR,
    // LEDs on Arduino board
    output [7:0] ALED,
    // 7-segment LEDs on Arduino board
    output [3:0] AN,
    output [7:0] SEG,
    // Buzzer on Arduino board
    output ABUZ,
    // 3 color LED
    output [5:0] LED3,
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


    // LEDs
    wire [15:0] LED;
    p2s led(
        .clk(clk_out),
        .sync(clk[10]),
        .data(LED),
        .sclk(LED_CLK),
        .sclr(LED_CLR),
        .sout(LED_DAT),
        .sen(LED_EN));
    
    
    // Button
    wire [24:0] BTN;
    io_pb pushbutton(
        .clk(clk[15]),
        .btny(BTNY),
        .btnx(BTNX),
        .btn(BTN));
    
    
    // 7-segment LEDs
    wire [31:0] SEG7;
    wire [31:0] SEG7E;
    io_7seg seg7led(
        .clk(clk_out),
        .flash(clk[25]),
        .sync(clk[10]),
        .data({SEG7E, SEG7}),
        .seg_clk(SEG_CLK),
        .seg_clr(SEG_CLR),
        .seg_dat(SEG_DAT),
        .seg_en(SEG_EN));
    

    // 7-segment LEDs on Arduino board
    wire [15:0] A7SEGE;
    wire [15:0] A7SEG;
    io_a7seg arduino_seg7led(
        .clk(clk_out),
        .flash(clk[25]),
        .scan(clk[19:18]),
        .data({A7SEGE, A7SEG}),
        .an(AN),
        .seg(SEG));


    // 3 color LED
    wire [5:0] LED3_REV;
    assign LED3 = ~LED3_REV;


    // Buzzer
    wire [31:0] BUZZER;
    io_buzzer arduino_buzzer(
        .clk(clk_out),
        .rst(~CPU_RESETN),
        .halflen(BUZZER),
        .buzzer(ABUZ));
    
    
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
        .IO_7SEGE(SEG7E),
        .IO_ALED(ALED),
        .IO_A7SEG(A7SEG),
        .IO_A7SEGE(A7SEGE),
        .IO_ABUZ(BUZZER),
        .IO_3LED(LED3_REV),
        .UART_RX(UART_TXD_IN));


endmodule

