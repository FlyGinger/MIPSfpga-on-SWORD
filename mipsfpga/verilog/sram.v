// Author: Jiang Zengkai

`include "mfp_ahb_const.vh"

module sram(
    input  wire        HCLK,
    input  wire        HRESETn,
    input  wire [31:0] HADDR,
    input  wire [2 :0] HBURST,
    input  wire        HMASTLOCK,
    input  wire [3 :0] HPROT,
    input  wire [2 :0] HSIZE,
    input  wire [1 :0] HTRANS,
    input  wire [31:0] HWDATA,
    input  wire        HWRITE,
    output wire [31:0] HRDATA,
	input  wire        HSEL,
    inout  wire [47:0] SRAM_DATA,
    output wire [19:0] SRAM_ADDR,
    output wire [2 :0] SRAM_CE_N,
    output reg  [2 :0] SRAM_WE_N,
    output reg  [2 :0] SRAM_OE_N,
    output wire [2 :0] SRAM_UB_N,
    output wire [2 :0] SRAM_LB_N
    );

    reg [31:0] HADDR_d; // HADDR delay
    reg HWRITE_d;       // HWRITE delay
    reg HSEL_d;         // HSEL delay
    reg [1:0] HTRANS_d; // HTRANS delay
    wire we;            // write enable
    reg [5:0] we_mask;  // sub-word write mask

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
        if (~we) we_mask = 6'b000000;
        else if (HBURST == `HBURST_SINGLE && HSIZE == `HSIZE_1) we_mask = 6'b000001 << HADDR [1:0];
        else if (HBURST == `HBURST_SINGLE && HSIZE == `HSIZE_2) we_mask = HADDR[1] ? 6'b001100 : 6'b000011;
        else we_mask = 6'b001111;
    end

    assign SRAM_ADDR = we ? HADDR_d[21:2] : HADDR[21:2];
    assign SRAM_CE_N = 3'b000;
    assign SRAM_UB_N = {(~we_mask[5])&(we_mask[4]), (~we_mask[3])&(we_mask[2]), (~we_mask[1])&(we_mask[0])};
    assign SRAM_LB_N = {(we_mask[5])&(~we_mask[4]), (we_mask[3])&(~we_mask[2]), (we_mask[1])&(~we_mask[0])};

    always @ * begin
        if (|we) begin
            SRAM_OE_N <=    3'b111;
            SRAM_WE_N <= #2 3'b000;
        end
        else begin
            SRAM_OE_N <= #2 3'b000;
            SRAM_WE_N <=    3'b111;
        end
    end

    wire [47:0] rdata;
    wire [47:0] wdata;
    assign HRDATA = rdata[31:0];
    assign wdata = {16'b0, HWDATA};

    `define SRAM_INOUT IOBUF#(.DRIVE(4), .IBUF_LOW_PWR("FALSE"), .IOSTANDARD("LVCMOS33"), .SLEW("FAST"))
    `SRAM_INOUT IOBUF0  (.O(rdata[0] ), .IO(SRAM_DATA[0] ), .I(wdata[0] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF1  (.O(rdata[1] ), .IO(SRAM_DATA[1] ), .I(wdata[1] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF2  (.O(rdata[2] ), .IO(SRAM_DATA[2] ), .I(wdata[2] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF3  (.O(rdata[3] ), .IO(SRAM_DATA[3] ), .I(wdata[3] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF4  (.O(rdata[4] ), .IO(SRAM_DATA[4] ), .I(wdata[4] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF5  (.O(rdata[5] ), .IO(SRAM_DATA[5] ), .I(wdata[5] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF6  (.O(rdata[6] ), .IO(SRAM_DATA[6] ), .I(wdata[6] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));
    `SRAM_INOUT IOBUF7  (.O(rdata[7] ), .IO(SRAM_DATA[7] ), .I(wdata[7] ), .T(SRAM_WE_N[0] | SRAM_LB_N[0]));

    `SRAM_INOUT IOBUF8  (.O(rdata[8] ), .IO(SRAM_DATA[8] ), .I(wdata[8] ), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF9  (.O(rdata[9] ), .IO(SRAM_DATA[9] ), .I(wdata[9] ), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF10 (.O(rdata[10]), .IO(SRAM_DATA[10]), .I(wdata[10]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF11 (.O(rdata[11]), .IO(SRAM_DATA[11]), .I(wdata[11]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF12 (.O(rdata[12]), .IO(SRAM_DATA[12]), .I(wdata[12]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF13 (.O(rdata[13]), .IO(SRAM_DATA[13]), .I(wdata[13]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF14 (.O(rdata[14]), .IO(SRAM_DATA[14]), .I(wdata[14]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));
    `SRAM_INOUT IOBUF15 (.O(rdata[15]), .IO(SRAM_DATA[15]), .I(wdata[15]), .T(SRAM_WE_N[0] | SRAM_UB_N[0]));

    `SRAM_INOUT IOBUF16 (.O(rdata[16]), .IO(SRAM_DATA[16]), .I(wdata[16]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF17 (.O(rdata[17]), .IO(SRAM_DATA[17]), .I(wdata[17]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF18 (.O(rdata[18]), .IO(SRAM_DATA[18]), .I(wdata[18]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF19 (.O(rdata[19]), .IO(SRAM_DATA[19]), .I(wdata[19]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF20 (.O(rdata[20]), .IO(SRAM_DATA[20]), .I(wdata[20]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF21 (.O(rdata[21]), .IO(SRAM_DATA[21]), .I(wdata[21]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF22 (.O(rdata[22]), .IO(SRAM_DATA[22]), .I(wdata[22]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));
    `SRAM_INOUT IOBUF23 (.O(rdata[23]), .IO(SRAM_DATA[23]), .I(wdata[23]), .T(SRAM_WE_N[1] | SRAM_LB_N[1]));

    `SRAM_INOUT IOBUF24 (.O(rdata[24]), .IO(SRAM_DATA[24]), .I(wdata[24]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF25 (.O(rdata[25]), .IO(SRAM_DATA[25]), .I(wdata[25]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF26 (.O(rdata[26]), .IO(SRAM_DATA[26]), .I(wdata[26]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF27 (.O(rdata[27]), .IO(SRAM_DATA[27]), .I(wdata[27]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF28 (.O(rdata[28]), .IO(SRAM_DATA[28]), .I(wdata[28]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF29 (.O(rdata[29]), .IO(SRAM_DATA[29]), .I(wdata[29]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF30 (.O(rdata[30]), .IO(SRAM_DATA[30]), .I(wdata[30]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    `SRAM_INOUT IOBUF31 (.O(rdata[31]), .IO(SRAM_DATA[31]), .I(wdata[31]), .T(SRAM_WE_N[1] | SRAM_UB_N[1]));
    
    `SRAM_INOUT IOBUF32 (.O(rdata[32]), .IO(SRAM_DATA[32]), .I(wdata[32]), .T(SRAM_WE_N[2] | SRAM_LB_N[2]));
    `SRAM_INOUT IOBUF33 (.O(rdata[33]), .IO(SRAM_DATA[33]), .I(wdata[33]), .T(SRAM_WE_N[2] | SRAM_LB_N[2]));
    `SRAM_INOUT IOBUF34 (.O(rdata[34]), .IO(SRAM_DATA[34]), .I(wdata[34]), .T(SRAM_WE_N[2] | SRAM_LB_N[2]));
    `SRAM_INOUT IOBUF35 (.O(rdata[35]), .IO(SRAM_DATA[35]), .I(wdata[35]), .T(SRAM_WE_N[2] | SRAM_LB_N[2]));
    `SRAM_INOUT IOBUF36 (.O(rdata[36]), .IO(SRAM_DATA[36]), .I(wdata[36]), .T(SRAM_WE_N[2] | SRAM_LB_N[2]));
    `SRAM_INOUT IOBUF37 (.O(rdata[37]), .IO(SRAM_DATA[37]), .I(wdata[37]), .T(SRAM_WE_N[2] | SRAM_LB_N[2]));
    `SRAM_INOUT IOBUF38 (.O(rdata[38]), .IO(SRAM_DATA[38]), .I(wdata[38]), .T(SRAM_WE_N[2] | SRAM_LB_N[2]));
    `SRAM_INOUT IOBUF39 (.O(rdata[39]), .IO(SRAM_DATA[39]), .I(wdata[39]), .T(SRAM_WE_N[2] | SRAM_LB_N[2]));

    `SRAM_INOUT IOBUF40 (.O(rdata[40]), .IO(SRAM_DATA[40]), .I(wdata[40]), .T(SRAM_WE_N[2] | SRAM_UB_N[2]));
    `SRAM_INOUT IOBUF41 (.O(rdata[41]), .IO(SRAM_DATA[41]), .I(wdata[41]), .T(SRAM_WE_N[2] | SRAM_UB_N[2]));
    `SRAM_INOUT IOBUF42 (.O(rdata[42]), .IO(SRAM_DATA[42]), .I(wdata[42]), .T(SRAM_WE_N[2] | SRAM_UB_N[2]));
    `SRAM_INOUT IOBUF43 (.O(rdata[43]), .IO(SRAM_DATA[43]), .I(wdata[43]), .T(SRAM_WE_N[2] | SRAM_UB_N[2]));
    `SRAM_INOUT IOBUF44 (.O(rdata[44]), .IO(SRAM_DATA[44]), .I(wdata[44]), .T(SRAM_WE_N[2] | SRAM_UB_N[2]));
    `SRAM_INOUT IOBUF45 (.O(rdata[45]), .IO(SRAM_DATA[45]), .I(wdata[45]), .T(SRAM_WE_N[2] | SRAM_UB_N[2]));
    `SRAM_INOUT IOBUF46 (.O(rdata[46]), .IO(SRAM_DATA[46]), .I(wdata[46]), .T(SRAM_WE_N[2] | SRAM_UB_N[2]));
    `SRAM_INOUT IOBUF47 (.O(rdata[47]), .IO(SRAM_DATA[47]), .I(wdata[47]), .T(SRAM_WE_N[2] | SRAM_UB_N[2]));

endmodule
