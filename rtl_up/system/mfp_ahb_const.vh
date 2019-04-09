// 
// mfp_ahb_const.vh
//
// Verilog include file with AHB definitions
// 

// Modified by Zengkai Jiang
// Date: 2019.4.9

//---------------------------------------------------
// Physical bit-width of memory-mapped I/O interfaces
//---------------------------------------------------
`define MFP_N_LED             16
`define MFP_N_SW              16
`define MFP_N_PB              25
`define MFP_N_7SEG            32
`define MFP_N_7SEGE           32
`define MFP_N_ALED            8
`define MFP_N_A7SEG           16
`define MFP_N_A7SEGE          16
`define MFP_N_ABUZ            32
`define MFP_N_3LED            6

`define MFP_N_MILLIS          32

//---------------------------------------------------
// Memory-mapped I/O addresses
//---------------------------------------------------
`define H_LED_ADDR    			(32'h1f800000)
`define H_SW_ADDR   			(32'h1f800004)
`define H_PB_ADDR   			(32'h1f800008)
`define H_7SEG_ADDR             (32'h1f80000c)
`define H_7SEGE_ADDR            (32'h1f800010)
`define H_ALED_ADDR             (32'h1f800014)
`define H_A7SEG_ADDR            (32'h1f800018)
`define H_A7SEGE_ADDR           (32'h1f80001c)
`define H_ABUZ_ADDR             (32'h1f800020)
`define H_3LED_ADDR             (32'h1f800024)

`define H_MILLIS_ADDR           (32'h1f800034)

`define H_LED_IONUM   			(4'h0)
`define H_SW_IONUM  			(4'h1)
`define H_PB_IONUM  			(4'h2)
`define H_7SEG_IONUM            (4'h3)
`define H_7SEGE_IONUM           (4'h4)
`define H_ALED_IONUM            (4'h5)
`define H_A7SEG_IONUM           (4'h6)
`define H_A7SEGE_IONUM          (4'h7)
`define H_ABUZ_IONUM            (4'h8)
`define H_3LED_IONUM            (4'h9)

`define H_MILLIS_IONUM          (4'hd)

//---------------------------------------------------
// RAM addresses
//---------------------------------------------------
`define H_RAM_RESET_ADDR 		(32'h1fc?????)
`define H_RAM_ADDR	 		    (32'h0???????)
`define H_RAM_V_ADDR            (32'h1f4?????)
`define H_RAM_RESET_ADDR_WIDTH  (8) 
`define H_RAM_ADDR_WIDTH		(16) 
`define H_RAM_V_ADDR_WIDTH      (19)

`define H_RAM_RESET_ADDR_Match  (7'h7f)
`define H_RAM_ADDR_Match 		(1'b0)
`define H_LED_ADDR_Match		(7'h7e)
`define H_RAM_V_ADDR_Match      (7'h7d)

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
