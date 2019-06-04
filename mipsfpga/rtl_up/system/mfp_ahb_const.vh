// 
// mfp_ahb_const.vh
//
// Verilog include file with AHB definitions
// 

//---------------------------------------------------
// Physical bit-width of memory-mapped I/O interfaces
//---------------------------------------------------
`define MFP_N_SW                16
`define MFP_N_BTNX              5
`define MFP_N_BTNY              5
`define MFP_N_LED3              6
`define MFP_N_ARDUINO_LED       8
`define MFP_N_ARDUINO_AN        4
`define MFP_N_ARDUINO_SEG       8
`define MFP_N_VGA_R             4
`define MFP_N_VGA_G             `MFP_N_VGA_R
`define MFP_N_VGA_B             `MFP_N_VGA_R
`define MFP_N_SRAM_ADDR         20
`define MFP_N_SRAM_DATA         48
`define MFP_N_SRAM_CE           3
`define MFP_N_SRAM_OE           3
`define MFP_N_SRAM_WE           3
`define MFP_N_SRAM_UB           3
`define MFP_N_SRAM_LB           3
`define MFP_N_SD_DAT            4

`define MFP_AHB_N_CLK           32
`define MFP_AHB_N_BTN           25
`define MFP_AHB_N_LED           16
`define MFP_AHB_N_SEG           32
`define MFP_AHB_N_SEGEX         32
`define MFP_AHB_N_LED3          6
`define MFP_AHB_N_ARDUINO_LED   8
`define MFP_AHB_N_ARDUINO_SEG   32
`define MFP_AHB_N_ARDUINO_BUZ   32
`define MFP_AHB_N_PS2           8

`define MFP_AHB_N_INT           2

//---------------------------------------------------
// Memory-mapped I/O addresses
//---------------------------------------------------
`define H_SW_IONUM   			(4'h0)
`define H_BTN_CTRL_IONUM  		(4'h1)
`define H_BTN_DATA_IONUM        (4'h2)
`define H_LED_IONUM  			(4'h3)
`define H_SEG_IONUM             (4'h4)
`define H_SEGEX_IONUM           (4'h5)
`define H_LED3_IONUM            (4'h6)
`define H_ARDUINO_LED_IONUM     (4'h7)
`define H_ARDUINO_SEG_IONUM     (4'h8)
`define H_ARDUINO_BUZ_IONUM     (4'h9)
`define H_PS2_CTRL_IONUM        (4'ha)
`define H_PS2_DATA_IONUM        (4'hb)

//---------------------------------------------------
// RAM addresses
//---------------------------------------------------
`define H_RAM_RESET_ADDR_WIDTH  (8) 
`define H_RAM_ADDR_WIDTH		(16) 

`define H_RAM_RESET_ADDR_Match  (10'b0001_1111_11)
`define H_RAM_ADDR_Match 		( 4'b0000)
`define H_LED_ADDR_Match		(10'b0001_1111_10)
`define H_VRAM_ADDR_Match       (10'b0001_1111_01)
`define H_SRAM_ADDR_Match       ( 4'b0010)
`define H_SD_CTRL_ADDR_Match    (20'h1f00_1)
`define H_SD_BUF_ADDR_Match     (20'h1f00_0)

//---------------------------------------------------
// AHB-Lite values used by MIPSfpga core
//---------------------------------------------------

`define HTRANS_IDLE    2'b00
`define HTRANS_NONSEQ  2'b10
`define HTRANS_SEQ     2'b11

`define HBURST_SINGLE  3'b000
`define HBURST_WRAP4   3'b010

`define HSIZE_1        3'b000
`define HSIZE_2        3'b001
`define HSIZE_4        3'b010
