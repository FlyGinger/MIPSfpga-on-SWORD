// Modified by Jiang Zengkai
// Date: 2019.4.13

`include "mfp_ahb_const.vh"

module mfp_ahb_withloader (
    input         HCLK,
    input         HRESETn,
    input  [31:0] HADDR,
    input  [ 2:0] HBURST,
    input         HMASTLOCK,
    input  [ 3:0] HPROT,
    input  [ 2:0] HSIZE,
    input  [ 1:0] HTRANS,
    input  [31:0] HWDATA,
    input         HWRITE,
    output [31:0] HRDATA,
    output        HREADY,
    output        HRESP,
    input         SI_Endian,

	// memory-mapped I/O
    input      [`MFP_N_SW-1    :0] IO_Switch,
    input      [`MFP_N_PB-1    :0] IO_PB,
    output     [`MFP_N_LED-1   :0] IO_LED,
    output     [`MFP_N_7SEG-1  :0] IO_7SEG,
    output     [`MFP_N_7SEGE-1 :0] IO_7SEGE,
    output     [`MFP_N_ALED-1  :0] IO_ALED,
    output     [`MFP_N_A7SEG-1 :0] IO_A7SEG,
    output     [`MFP_N_ABUZ-1  :0] IO_ABUZ,
    output     [`MFP_N_3LED-1  :0] IO_3LED,
    input      [18             :0] IO_VGA_ADDR,
    output     [11             :0] IO_VGA_DATA,
    
	// for serial loading of memory using uart
    input         UART_RX,

    // SRAM
    output [19:0] SRAM_ADDR,
    output [2 :0] SRAM_CE_N,
    output [2 :0] SRAM_OE_N,
    output [2 :0] SRAM_WE_N,
    output [2 :0] SRAM_UB_N,
    output [2 :0] SRAM_LB_N,
    inout  [47:0] SRAM_DATA,

	// reset system due to serial load
    output        MFP_Reset_serialload
);

    wire [7:0] char_data;
    wire       char_ready;

    mfp_uart_receiver mfp_uart_receiver
    (
        .clock      ( HCLK       ),
        .reset_n    ( HRESETn    ),
        .rx         ( UART_RX    ),
        .byte_data  ( char_data  ),
        .byte_ready ( char_ready )
    );                     

    wire        in_progress;
    wire        format_error;
    wire        checksum_error;
    wire [ 7:0] error_location;

    wire [31:0] write_address;
    wire [ 7:0] write_byte;
    wire        write_enable;

//    assign IO_RedLEDs = { in_progress, format_error, checksum_error, write_enable, write_address [31:0] };

    mfp_srec_parser mfp_srec_parser
    (
        .clock           ( HCLK           ),
        .reset_n         ( HRESETn        ),

        .char_data       ( char_data      ),
        .char_ready      ( char_ready     ), 

        .in_progress     ( in_progress    ),
        .format_error    ( format_error   ),
        .checksum_error  ( checksum_error ),
        .error_location  ( error_location ),

        .write_address   ( write_address  ),
        .write_byte      ( write_byte     ),
        .write_enable    ( write_enable   )
    );

    assign MFP_Reset_serialload = in_progress;

    wire [31:0] loader_HADDR;
    wire [ 2:0] loader_HBURST;
    wire        loader_HMASTLOCK;
    wire [ 3:0] loader_HPROT;
    wire [ 2:0] loader_HSIZE;
    wire [ 1:0] loader_HTRANS;
    wire [31:0] loader_HWDATA;
    wire        loader_HWRITE;

    mfp_srec_parser_to_ahb_lite_bridge mfp_srec_parser_to_ahb_lite_bridge
    (
        .clock          ( HCLK             ),
        .reset_n        ( HRESETn          ),
        .big_endian     ( SI_Endian        ),
    
        .write_address  ( write_address    ),
        .write_byte     ( write_byte       ),
        .write_enable   ( write_enable     ), 
    
        .HADDR          ( loader_HADDR     ),
        .HBURST         ( loader_HBURST    ),
        .HMASTLOCK      ( loader_HMASTLOCK ),
        .HPROT          ( loader_HPROT     ),
        .HSIZE          ( loader_HSIZE     ),
        .HTRANS         ( loader_HTRANS    ),
        .HWDATA         ( loader_HWDATA    ),
        .HWRITE         ( loader_HWRITE    )
    );

    mfp_ahb mfp_ahb
    (
        .HCLK             ( HCLK            ),
        .HRESETn          ( HRESETn         ),
                         
        .HADDR            ( in_progress ? loader_HADDR     : HADDR     ),
        .HBURST           ( in_progress ? loader_HBURST    : HBURST    ),
        .HMASTLOCK        ( in_progress ? loader_HMASTLOCK : HMASTLOCK ),
        .HPROT            ( in_progress ? loader_HPROT     : HPROT     ),
        .HSIZE            ( in_progress ? loader_HSIZE     : HSIZE     ),
        .HTRANS           ( in_progress ? loader_HTRANS    : HTRANS    ),
        .HWDATA           ( in_progress ? loader_HWDATA    : HWDATA    ),
        .HWRITE           ( in_progress ? loader_HWRITE    : HWRITE    ),
                         
        .HRDATA           ( HRDATA          ),
        .HREADY           ( HREADY          ),
        .HRESP            ( HRESP           ),
        .SI_Endian        ( SI_Endian       ),
                                             
        .IO_Switch        ( IO_Switch       ),
        .IO_PB            ( IO_PB           ),
        .IO_LED           ( IO_LED          ),
        .IO_7SEG          ( IO_7SEG         ),
        .IO_7SEGE         ( IO_7SEGE        ),
        .IO_ALED          ( IO_ALED         ),
        .IO_A7SEG         ( IO_A7SEG        ),
        .IO_ABUZ          ( IO_ABUZ         ),
        .IO_3LED          ( IO_3LED         ),
        .IO_VGA_ADDR      ( IO_VGA_ADDR     ),
        .IO_VGA_DATA      ( IO_VGA_DATA     ),
        .SRAM_ADDR        ( SRAM_ADDR       ),
        .SRAM_CE_N        ( SRAM_CE_N       ),
        .SRAM_OE_N        ( SRAM_OE_N       ),
        .SRAM_WE_N        ( SRAM_WE_N       ),
        .SRAM_UB_N        ( SRAM_UB_N       ),
        .SRAM_LB_N        ( SRAM_LB_N       ),
        .SRAM_DATA        ( SRAM_DATA       )
    );

endmodule
