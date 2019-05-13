// Author: Jiang Zengkai
// Date: 2019.4.17

`include "mfp_ahb_const.vh"

module mfp_ahb_sram
(
    input wire HCLK,
    input wire HRESETn,
    input wire [31:0] HADDR,
    input wire [2:0] HBURST,
    input wire HMASTLOCK,
    input wire [3:0] HPROT,
    input wire [2:0] HSIZE,
    input wire [1:0] HTRANS,
    input wire [31:0] HWDATA,
    input wire HWRITE,
    output wire [31:0] HRDATA,
	input wire HSEL,
    inout wire [47:0] SRAM_DATA,
    output wire [19:0] SRAM_ADDR,
    output wire [2:0] SRAM_CE_N,
    output wire [2:0] SRAM_WE_N,
    output wire [2:0] SRAM_OE_N,
    output wire [2:0] SRAM_UB_N,
    output wire [2:0] SRAM_LB_N
);

    reg [31:0] HADDR_d; // HADDR delay
    reg HWRITE_d; // HWRITE delay
    reg HSEL_d; // HSEL delay
    reg [1:0] HTRANS_d; // HTRANS delay
    wire we; // write enable
    reg [3:0] we_mask; // sub-word write mask

    // delay HADDR, HWRITE, HSEL, and HTRANS
    always @ (posedge HCLK) begin
        HADDR_d  <= HADDR;
        HWRITE_d <= HWRITE;
        HSEL_d   <= HSEL;
        HTRANS_d <= HTRANS;
    end
  
    // overall write enable signal
    assign we = (HTRANS_d != `HTRANS_IDLE) & HSEL_d & HWRITE_d;

    // determine byte/half-word/word write enables
    always @ * begin
        if (~we) begin
            we_mask = 4'b0000; // not writing
        end
        else if (HBURST == `HBURST_SINGLE && HSIZE == `HSIZE_1) begin
            we_mask = 4'b0001 << HADDR [1:0];  // byte write
        end
        else if (HBURST == `HBURST_SINGLE && HSIZE == `HSIZE_2) begin
            we_mask = HADDR[1] ? 4'b1100 : 4'b0011; // half-word write
        end
        else begin
            we_mask = 4'b1111; // word write
        end
    end

    // sram
    io_sram sram(
        .addr(we ? HADDR_d[21:2] : HADDR[21:2]),
        .we(we_mask),
        .rdata(HRDATA),
        .wdata({16'b0, HWDATA}),
        .SRAM_DATA(SRAM_DATA),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_OE_N(SRAM_OE_N),
        .SRAM_UB_N(SRAM_UB_N),
        .SRAM_LB_N(SRAM_LB_N));


endmodule
