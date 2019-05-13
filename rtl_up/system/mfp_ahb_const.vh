// Modified by Jiang Zengkai
// Date: 2019.5.13

// 
// mfp_ahb_const.vh
//
// Verilog include file with AHB definitions
// 

//---------------------------------------------------
// Physical bit-width of memory-mapped I/O interfaces
//---------------------------------------------------
`define MFP_N_LED             16
`define MFP_N_SW              16
`define MFP_N_PB              25
`define MFP_N_7SEG            32
`define MFP_N_7SEGE           32
`define MFP_N_ALED            8
`define MFP_N_A7SEG           32
`define MFP_N_ABUZ            32
`define MFP_N_3LED            6

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
`define H_ABUZ_ADDR             (32'h1f80001C)
`define H_3LED_ADDR             (32'h1f800020)

`define H_LED_IONUM   			(4'h0)
`define H_SW_IONUM  			(4'h1)
`define H_PB_IONUM  			(4'h2)
`define H_7SEG_IONUM            (4'h3)
`define H_7SEGE_IONUM           (4'h4)
`define H_ALED_IONUM            (4'h5)
`define H_A7SEG_IONUM           (4'h6)
`define H_ABUZ_IONUM            (4'h7)
`define H_3LED_IONUM            (4'h8)

//---------------------------------------------------
// RAM addresses
//---------------------------------------------------
`define H_RAM_RESET_ADDR 		(32'h1fc?????)
`define H_RAM_ADDR	 		    (32'h0???????)
`define H_RAM_V_ADDR            (32'h1f4?????)
`define H_SRAM_ADDR             (32'h2???????)

`define H_RAM_RESET_ADDR_WIDTH  (8) 
`define H_RAM_ADDR_WIDTH		(16) 
`define H_RAM_V_ADDR_WIDTH      (19)
`define H_SRAM_ADDR_WIDTH       (22)

`define H_RAM_RESET_ADDR_Match  (10'b0001_1111_11)
`define H_RAM_ADDR_Match 		(4'b0000)
`define H_LED_ADDR_Match		(10'b0001_1111_10)
`define H_RAM_V_ADDR_Match      (10'b0001_1111_01)
`define H_SRAM_ADDR_Match       (4'b0010)

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
