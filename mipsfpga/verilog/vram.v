// Author: Jiang Zengkai

`include "mfp_ahb_const.vh"

module vram(
    input  wire        HCLK,
    input  wire        HRESETn,
    input  wire [31:0] HADDR,
    input  wire [1 :0] HTRANS,
    input  wire [11:0] HWDATA,
    input  wire        HWRITE,
    input  wire        HSEL,
    output reg  [31:0] HRDATA,
    input  wire        IO_VGA_CLK,
    input  wire [18:0] IO_VGA_ADDR,
    output wire [11:0] IO_VGA_DATA
    );

    reg [31:0] HADDR_d;
    reg HWRITE_d;
    reg HSEL_d;
    reg [1:0] HTRANS_d;
    wire we; // write enable

    // delay HADDR, HWRITE, HSEL, and HTRANS to align with HWDATA for writing
    always @ (posedge HCLK) begin
        HADDR_d <= HADDR;
        HWRITE_d <= HWRITE;
        HSEL_d <= HSEL;
        HTRANS_d <= HTRANS;
    end
    
    // overall write enable signal
    assign we = (HTRANS_d != `HTRANS_IDLE) & HSEL_d & HWRITE_d & (HADDR_d[31:20] == 'h1f4);
    
    wire [11:0] data_vram;
    wire [31:0] data_char;
    wire [7:0] data_acsii;
    always @ (*) begin
        if (HADDR[31:20] == 'h1f4) HRDATA <= data_vram;
        else if (HADDR[31:20] == 'h1f5) HRDATA <= data_char;
        else if (HADDR[31:20] == 'h1f6) HRDATA <= data_acsii;
        else HRDATA <= 0;
    end

    // VRAM
    blk_mem_gen_0 vram(.addra(we ? HADDR_d[20:2] : HADDR[20:2]), .clka(HCLK), .dina(HWDATA), .douta(data_vram), .wea(we),
                       .addrb(IO_VGA_ADDR), .clkb(IO_VGA_CLK), .dinb(0), .doutb(IO_VGA_DATA), .web(0));
    
    // char ROM
    blk_mem_gen_1 char_rom(.addra(HADDR[11:2]), .clka(HCLK), .douta(data_char));
    
    // ascii ROM
    blk_mem_gen_2 ascii_rom(.addra(HADDR[9:2]), .clka(HCLK), .douta(data_acsii));
    

endmodule
