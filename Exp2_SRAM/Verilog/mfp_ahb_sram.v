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
            we_mask = 4'b1111; // not writing
        end
        else if (HBURST == `HBURST_SINGLE && HSIZE == `HSIZE_1) begin
            we_mask = 4'b1111 ^ (4'b0001 << HADDR [1:0]);  // byte write
        end
        else if (HBURST == `HBURST_SINGLE && HSIZE == `HSIZE_2) begin
            we_mask = HADDR[1] ? 4'b0011 : 4'b1100; // half-word write
        end
        else begin
            we_mask = 4'b0000; // word write
        end
    end

    // address
    assign SRAM_ADDR = HADDR_d[21:2];

    // control signals
    always @ * begin
        if (we) begin
            SRAM_CE_N <= {1'b1, we_mask[3] & we_mask[2], we_mask[1] & we_mask[0]};
            SRAM_OE_N <= 3'b111;
            SRAM_WE_N <= #5 3'b100;
            SRAM_UB_N <= {1'b1, we_mask[3], we_mask[1]};
            SRAM_LB_N <= {1'b1, we_mask[2], we_mask[0]};
        end
        else begin
            SRAM_CE_N <= 3'b100;
            SRAM_OE_N <= #5 3'b100;
            SRAM_WE_N <= 3'b111;
            SRAM_UB_N <= 3'b100;
            SRAM_LB_N <= 3'b100;
        end
    end
    
    `define SRAM_INOUT IOBUF#(.DRIVE(4), .IBUF_LOW_PWR("FALSE"), .IOSTANDARD("LVCMOS33"), .SLEW("FAST"))
    `SRAM_INOUT IOBUF0  (.O(HRDATA[0] ), .IO(SRAM_DATA[0] ), .I(HWDATA[0] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF1  (.O(HRDATA[1] ), .IO(SRAM_DATA[1] ), .I(HWDATA[1] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF2  (.O(HRDATA[2] ), .IO(SRAM_DATA[2] ), .I(HWDATA[2] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF3  (.O(HRDATA[3] ), .IO(SRAM_DATA[3] ), .I(HWDATA[3] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF4  (.O(HRDATA[4] ), .IO(SRAM_DATA[4] ), .I(HWDATA[4] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF5  (.O(HRDATA[5] ), .IO(SRAM_DATA[5] ), .I(HWDATA[5] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF6  (.O(HRDATA[6] ), .IO(SRAM_DATA[6] ), .I(HWDATA[6] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF7  (.O(HRDATA[7] ), .IO(SRAM_DATA[7] ), .I(HWDATA[7] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));

    `SRAM_INOUT IOBUF8  (.O(HRDATA[8] ), .IO(SRAM_DATA[8] ), .I(HWDATA[8] ), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF9  (.O(HRDATA[9] ), .IO(SRAM_DATA[9] ), .I(HWDATA[9] ), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF10 (.O(HRDATA[10]), .IO(SRAM_DATA[10]), .I(HWDATA[10]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF11 (.O(HRDATA[11]), .IO(SRAM_DATA[11]), .I(HWDATA[11]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF12 (.O(HRDATA[12]), .IO(SRAM_DATA[12]), .I(HWDATA[12]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF13 (.O(HRDATA[13]), .IO(SRAM_DATA[13]), .I(HWDATA[13]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF14 (.O(HRDATA[14]), .IO(SRAM_DATA[14]), .I(HWDATA[14]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF15 (.O(HRDATA[15]), .IO(SRAM_DATA[15]), .I(HWDATA[15]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));

    `SRAM_INOUT IOBUF16 (.O(HRDATA[16]), .IO(SRAM_DATA[16]), .I(HWDATA[16]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF17 (.O(HRDATA[17]), .IO(SRAM_DATA[17]), .I(HWDATA[17]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF18 (.O(HRDATA[18]), .IO(SRAM_DATA[18]), .I(HWDATA[18]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF19 (.O(HRDATA[19]), .IO(SRAM_DATA[19]), .I(HWDATA[19]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF20 (.O(HRDATA[20]), .IO(SRAM_DATA[20]), .I(HWDATA[20]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF21 (.O(HRDATA[21]), .IO(SRAM_DATA[21]), .I(HWDATA[21]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF22 (.O(HRDATA[22]), .IO(SRAM_DATA[22]), .I(HWDATA[22]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF23 (.O(HRDATA[23]), .IO(SRAM_DATA[23]), .I(HWDATA[23]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));

    `SRAM_INOUT IOBUF24 (.O(HRDATA[24]), .IO(SRAM_DATA[24]), .I(HWDATA[24]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF25 (.O(HRDATA[25]), .IO(SRAM_DATA[25]), .I(HWDATA[25]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF26 (.O(HRDATA[26]), .IO(SRAM_DATA[26]), .I(HWDATA[26]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF27 (.O(HRDATA[27]), .IO(SRAM_DATA[27]), .I(HWDATA[27]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF28 (.O(HRDATA[28]), .IO(SRAM_DATA[28]), .I(HWDATA[28]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF29 (.O(HRDATA[29]), .IO(SRAM_DATA[29]), .I(HWDATA[29]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF30 (.O(HRDATA[30]), .IO(SRAM_DATA[30]), .I(HWDATA[30]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF31 (.O(HRDATA[31]), .IO(SRAM_DATA[31]), .I(HWDATA[31]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    
    `SRAM_INOUT IOBUF32 (.O(), .IO(SRAM_DATA[32]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF33 (.O(), .IO(SRAM_DATA[33]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF34 (.O(), .IO(SRAM_DATA[34]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF35 (.O(), .IO(SRAM_DATA[35]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF36 (.O(), .IO(SRAM_DATA[36]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF37 (.O(), .IO(SRAM_DATA[37]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF38 (.O(), .IO(SRAM_DATA[38]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF39 (.O(), .IO(SRAM_DATA[39]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF40 (.O(), .IO(SRAM_DATA[40]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF41 (.O(), .IO(SRAM_DATA[41]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF42 (.O(), .IO(SRAM_DATA[42]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF43 (.O(), .IO(SRAM_DATA[43]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF44 (.O(), .IO(SRAM_DATA[44]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF45 (.O(), .IO(SRAM_DATA[45]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF46 (.O(), .IO(SRAM_DATA[46]), .I(1'b0), .T(1));
    `SRAM_INOUT IOBUF47 (.O(), .IO(SRAM_DATA[47]), .I(1'b0), .T(1));

endmodule
