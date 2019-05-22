
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

	// for serial loading of memory using uart
    input         UART_RX,

	// reset system due to serial load
    output        MFP_Reset_serialload,

    // IO
    input                           IO_CLK,
    input  [`MFP_N_SW-1         :0] IO_SW,
    output [`MFP_N_BTNX-1       :0] IO_BTNX,
    input  [`MFP_N_BTNY-1       :0] IO_BTNY,
    output                          IO_LED_CLK,
    output                          IO_LED_DAT,
    output                          IO_LED_EN,
    output                          IO_LED_CLRN,
    output                          IO_SEG_CLK,
    output                          IO_SEG_DAT,
    output                          IO_SEG_EN,
    output                          IO_SEG_CLRN,
    output [`MFP_N_LED3-1       :0] IO_LED3,
    output [`MFP_N_ARDUINO_LED-1:0] IO_ARDUINO_LED,
    output [`MFP_N_ARDUINO_AN-1 :0] IO_ARDUINO_AN,
    output [`MFP_N_ARDUINO_SEG-1:0] IO_ARDUINO_SEG,
    output                          IO_ARDUINO_BUZ,
    output                          IO_VGA_HS,
    output                          IO_VGA_VS,
    output [`MFP_N_VGA_R-1      :0] IO_VGA_R,
    output [`MFP_N_VGA_G-1      :0] IO_VGA_G,
    output [`MFP_N_VGA_B-1      :0] IO_VGA_B,
    output [`MFP_N_SRAM_ADDR-1  :0] IO_SRAM_ADDR,
    inout  [`MFP_N_SRAM_DATA-1  :0] IO_SRAM_DATA,
    output [`MFP_N_SRAM_CE-1    :0] IO_SRAM_CE_N,
    output [`MFP_N_SRAM_OE-1    :0] IO_SRAM_OE_N,
    output [`MFP_N_SRAM_WE-1    :0] IO_SRAM_WE_N,
    output [`MFP_N_SRAM_UB-1    :0] IO_SRAM_UB_N,
    output [`MFP_N_SRAM_LB-1    :0] IO_SRAM_LB_N,
    inout  [`MFP_N_SD_DAT-1     :0] IO_SD_DAT,
    inout                           IO_SD_CMD,
    output                          IO_SD_CLK,
    output                          IO_SD_RST,
    input                           IO_SD_CD,
    input                           IO_PS2_CLK,
    input                           IO_PS2_DAT,

    output [`MFP_AHB_N_INT-1    :0] IO_INT
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
                                             
        .IO_CLK           ( IO_CLK          ),
        .IO_SW            ( IO_SW           ),
        .IO_BTNX          ( IO_BTNX         ),
        .IO_BTNY          ( IO_BTNY         ),
        .IO_LED_CLK       ( IO_LED_CLK      ),
        .IO_LED_DAT       ( IO_LED_DAT      ),
        .IO_LED_EN        ( IO_LED_EN       ),
        .IO_LED_CLRN      ( IO_LED_CLRN     ),
        .IO_SEG_CLK       ( IO_SEG_CLK      ),
        .IO_SEG_DAT       ( IO_SEG_DAT      ),
        .IO_SEG_EN        ( IO_SEG_EN       ),
        .IO_SEG_CLRN      ( IO_SEG_CLRN     ),
        .IO_LED3          ( IO_LED3         ),
        .IO_ARDUINO_LED   ( IO_ARDUINO_LED  ),
        .IO_ARDUINO_AN    ( IO_ARDUINO_AN   ),
        .IO_ARDUINO_SEG   ( IO_ARDUINO_SEG  ),
        .IO_ARDUINO_BUZ   ( IO_ARDUINO_BUZ  ),
        .IO_VGA_HS        ( IO_VGA_HS       ),
        .IO_VGA_VS        ( IO_VGA_VS       ),
        .IO_VGA_R         ( IO_VGA_R        ),
        .IO_VGA_G         ( IO_VGA_G        ),
        .IO_VGA_B         ( IO_VGA_B        ),
        .IO_SRAM_ADDR     ( IO_SRAM_ADDR    ),
        .IO_SRAM_DATA     ( IO_SRAM_DATA    ),
        .IO_SRAM_CE_N     ( IO_SRAM_CE_N    ),
        .IO_SRAM_OE_N     ( IO_SRAM_OE_N    ),
        .IO_SRAM_WE_N     ( IO_SRAM_WE_N    ),
        .IO_SRAM_UB_N     ( IO_SRAM_UB_N    ),
        .IO_SRAM_LB_N     ( IO_SRAM_LB_N    ),
        .IO_SD_DAT        ( IO_SD_DAT       ),
        .IO_SD_CMD        ( IO_SD_CMD       ),
        .IO_SD_CLK        ( IO_SD_CLK       ),
        .IO_SD_RST        ( IO_SD_RST       ),
        .IO_SD_CD         ( IO_SD_CD        ),
        .IO_PS2_CLK       ( IO_PS2_CLK      ),
        .IO_PS2_DAT       ( IO_PS2_DAT      ),

        .IO_INT           ( IO_INT          )
    );

endmodule
