// Author: Jiang Zengkai

`include "mfp_ahb_const.vh"

module mfp_sword(
    input  wire        CLK_200M_P,  // clock
    input  wire        CLK_200M_N,
    input  wire        RESETN,      // reset
    inout  wire [8 :1] JB,          // Pmod
    input  wire        UART_TXD_IN, // UART
    input  wire [15:0] SW,          // switches
    output wire [4 :0] BTNX,        // buttons
    input  wire [4 :0] BTNY,
    output wire        LED_CLK,     // LEDs
    output wire        LED_DAT,
    output wire        LED_EN,
    output wire        LED_CLRN,
    output wire        SEG_CLK,     // 7-segment LEDs
    output wire        SEG_DAT,
    output wire        SEG_EN,
    output wire        SEG_CLRN,
    output wire [5 :0] LED3,        // 3 color LED
    output wire [7 :0] ARDUINO_LED, // LEDs on arduino board
    output wire [3 :0] ARDUINO_AN,  // 7-segment LEDs on arduino board
    output wire [7 :0] ARDUINO_SEG,
    output wire        ARDUINO_BUZ, // Buzzer on Arduino board
    output wire        VGA_HS,      // VGA
    output wire        VGA_VS,
    output wire [3 :0] VGA_R,
    output wire [3 :0] VGA_G,
    output wire [3 :0] VGA_B,
    output wire [19:0] SRAM_ADDR,   // SRAM
    inout  wire [47:0] SRAM_DATA,
    output wire [2 :0] SRAM_CE_N,
    output wire [2 :0] SRAM_OE_N,
    output wire [2 :0] SRAM_WE_N,
    output wire [2 :0] SRAM_UB_N,
    output wire [2 :0] SRAM_LB_N,
    inout  wire [3 :0] SD_DAT,      // SD card
    inout  wire        SD_CMD,
    output wire        SD_CLK,
    output wire        SD_RST,
    input  wire        SD_CD,
    input  wire        PS2_CLK,     // PS2 keyboard
    input  wire        PS2_DAT
    );

    // EJTAG
    wire tck_in, tck;
    IBUF IBUF1(.O(tck_in),.I(JB[4]));
    BUFG BUFG1(.O(tck), .I(tck_in));
    
    // clock and reset
    wire clk_cpu;
    wire clk_dev;
    clk_wiz_0 clk_wiz_0(
        .clk_in1_p  (CLK_200M_P),
        .clk_in1_n  (CLK_200M_N),
        .clk_out1   (clk_cpu),      // 50 Mhz
        .clk_out2   (clk_dev));     // 100 Mhz

    // MIPSfpga system
    mfp_sys mfp_sys(
        .SI_Reset_N         (RESETN),
        .SI_ClkIn           (clk_cpu),
        .HADDR              (),
        .HRDATA             (),
        .HWDATA             (),
        .HWRITE             (),
        .HSIZE              (),
        .EJ_TRST_N_probe    (JB[7]),
        .EJ_TDI             (JB[2]),
        .EJ_TDO             (JB[3]),
        .EJ_TMS             (JB[1]),
        .EJ_TCK             (tck),
        .SI_ColdReset_N     (JB[8]),
        .EJ_DINT            (1'b0),
        .UART_RX            (UART_TXD_IN),
        .IO_CLK             (clk_dev),
        .IO_SW              (SW),
        .IO_BTNX            (BTNX),
        .IO_BTNY            (BTNY),
        .IO_LED_CLK         (LED_CLK),
        .IO_LED_DAT         (LED_DAT),
        .IO_LED_EN          (LED_EN),
        .IO_LED_CLRN        (LED_CLRN),
        .IO_SEG_CLK         (SEG_CLK),
        .IO_SEG_DAT         (SEG_DAT),
        .IO_SEG_EN          (SEG_EN),
        .IO_SEG_CLRN        (SEG_CLRN),
        .IO_LED3            (LED3),
        .IO_ARDUINO_LED     (ARDUINO_LED),
        .IO_ARDUINO_AN      (ARDUINO_AN),
        .IO_ARDUINO_SEG     (ARDUINO_SEG),
        .IO_ARDUINO_BUZ     (ARDUINO_BUZ),
        .IO_VGA_HS          (VGA_HS),
        .IO_VGA_VS          (VGA_VS),
        .IO_VGA_R           (VGA_R),
        .IO_VGA_G           (VGA_G),
        .IO_VGA_B           (VGA_B),
        .IO_SRAM_ADDR       (SRAM_ADDR),
        .IO_SRAM_DATA       (SRAM_DATA),
        .IO_SRAM_CE_N       (SRAM_CE_N),
        .IO_SRAM_OE_N       (SRAM_OE_N),
        .IO_SRAM_WE_N       (SRAM_WE_N),
        .IO_SRAM_UB_N       (SRAM_UB_N),
        .IO_SRAM_LB_N       (SRAM_LB_N),
        .IO_SD_DAT          (SD_DAT),
        .IO_SD_CMD          (SD_CMD),
        .IO_SD_CLK          (SD_CLK),
        .IO_SD_RST          (SD_RST),
        .IO_SD_CD           (SD_CD),
        .IO_PS2_CLK         (PS2_CLK),
        .IO_PS2_DAT         (PS2_DAT));

endmodule
