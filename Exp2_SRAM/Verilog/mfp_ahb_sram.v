// Author: Jiang Zengkai
// Date: 2019.4.13

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
    inout [47:0] SRAM_DATA,
    output wire [19:0] SRAM_ADDR,
    output reg [2:0] SRAM_CE_N,
    output reg [2:0] SRAM_WE_N,
    output reg [2:0] SRAM_OE_N,
    output reg [2:0] SRAM_UB_N,
    output reg [2:0] SRAM_LB_N
);

    reg [31:0] HADDR_d; // HADDR delay
    reg HWRITE_d; // HWRITE delay
    reg HSEL_d; // HSEL delay
    reg [1:0] HTRANS_d; // HTRANS delay
    wire we; // write enable
    wire re; // read enable
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
    assign re = (HTRANS_d != `HTRANS_IDLE) & HSEL_d & (~HWRITE_d);

    // determine byte/half-word/word write enables
    always @ * begin
        if (~we) begin
            we_mask = 4'b0000; // not writing
        end
        else if (HBURST == `HBURST_SINGLE && HSIZE == `HSIZE_1) begin
            we_mask = 4'b0001 << HADDR [1:0]; // byte write
        end
        else if (HBURST == `HBURST_SINGLE && HSIZE == `HSIZE_2) begin
            we_mask = HADDR[1] ? 4'b1100 : 4'b0011; // half-word write
        end
        else begin
            we_mask = 4'b1111; // word write
        end
    end

    // data
    assign SRAM_DATA[47:0] = we ? {16'b0, HWDATA} : {48{1'bz}};
    assign HRDATA = we ? 32'b0 : SRAM_DATA[31:0];

    // address
    assign SRAM_ADDR = HADDR_d[21:2];

    // control signals
    always @ (posedge HCLK) begin
        case ({we, re})
            2'b01:      begin
                            SRAM_CE_N <= 3'b100;
                            SRAM_OE_N <= #2 3'b100;
                            SRAM_WE_N <= 3'b111;
                            SRAM_UB_N <= 3'b100;
                            SRAM_LB_N <= 3'b100;
                        end
            2'b10:      begin
                            SRAM_CE_N <= {1'b1, ~(we_mask[3] | we_mask[2]), ~(we_mask[1] | we_mask[0])};
                            SRAM_OE_N <= 3'b111;
                            SRAM_WE_N <= #2 3'b100;
                            SRAM_UB_N <= {1'b1, ~we_mask[3], ~we_mask[1]};
                            SRAM_LB_N <= {1'b1, ~we_mask[2], ~we_mask[0]};
                        end
            default:    begin
                            SRAM_CE_N <= 3'b111;
                            SRAM_OE_N <= 3'b111;
                            SRAM_WE_N <= 3'b111;
                            SRAM_UB_N <= 3'b111;
                            SRAM_LB_N <= 3'b111;
                        end
        endcase
    end

endmodule
