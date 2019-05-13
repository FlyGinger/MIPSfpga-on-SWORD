// Author: Jiang Zengkai
// Date: 2019.4.17

`include "mfp_ahb_const.vh"

module mfp_ahb_v_ram(
    input wire HCLK,
    input wire HRESETn,
    input wire [18:0] HADDR,
    input wire [1:0] HTRANS,
    input wire [11:0] HWDATA,
    input wire HWRITE,
    input wire HSEL,
    output wire [11:0] HRDATA,
    input wire [18:0] IO_VGA_ADDR,
    output wire [11:0] IO_VGA_DATA
);

    reg [18:0] HADDR_d;
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
    assign we = (HTRANS_d != `HTRANS_IDLE) & HSEL_d & HWRITE_d;

    // VRAM
    blk_mem_gen_0 vram(
        .addra(we ? HADDR_d : HADDR),
        .clka(HCLK),
        .dina(HWDATA),
        .douta(HRDATA),
        .wea(we),
        .addrb(IO_VGA_ADDR),
        .clkb(HCLK),
        .dinb(0),
        .doutb(IO_VGA_DATA),
        .web(0));

endmodule

