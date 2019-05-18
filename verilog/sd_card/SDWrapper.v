`timescale 1ns / 1ps
/**
 * Intergrates the SD card controller and a buffer to eliminate Wishbone master interface
 * and form a port attachable to SoC bus.
 * 
 * @author Yunye Pu
 * 
 *
 * @Modified by Zengkai Jiang
 * @Date 05-18-2019
 */
 
 `include "mfp_ahb_const.vh"
 
module SDWrapper(
	input clkCPU, input clkSD, input globlRst,
	
	//CPU bus interface
	input [1:0] HTRANS, input [2:0] HBURST, input [2:0] HSIZE, input HWRITE,
	input [31:0] dataInBus, input [31:0] HADDR, input HSEL,
	output reg [31:0] dataOut,
	output sd_int,
	
	//SD interface
	inout [3:0] sd_dat,
	inout sd_cmd,
	input sd_cd,
	output sd_clk,
	output reg sd_rst = 1
);

    // prepare -------------------------------------------------
    reg [31:0] HADDR_d; // HADDR delay
    reg HWRITE_d; // HWRITE delay
    reg HSEL_d; // HSEL delay
    reg [1:0] HTRANS_d; // HTRANS delay
    always @ (posedge clkCPU) begin
        HADDR_d  <= HADDR;
        HWRITE_d <= HWRITE;
        HSEL_d   <= HSEL;
        HTRANS_d <= HTRANS;
    end
    wire we = (HTRANS_d != `HTRANS_IDLE) & HSEL_d & HWRITE_d; // write enable
    
    reg [3:0] weBus;
    always @ * begin
        if (~we) begin
            weBus = 4'b0000; // not writing
        end
        else if (HBURST == `HBURST_SINGLE && HSIZE == `HSIZE_1) begin
            weBus = 4'b0001 << HADDR [1:0];  // byte write
        end
        else if (HBURST == `HBURST_SINGLE && HSIZE == `HSIZE_2) begin
            weBus = HADDR[1] ? 4'b1100 : 4'b0011; // half-word write
        end
        else begin
            weBus = 4'b1111; // word write
        end
    end
    
    wire [31:0] addrBus = we ? HADDR_d : HADDR;
    wire en_ctrl = (addrBus[31:12] == 'h1fc01);
    wire en_data = (addrBus[31:12] == 'h1fc00);
    
    reg [31:0] dataOut_ctrl;
    wire [31:0] dataOut_data;
    always @ * begin
        if (en_ctrl) dataOut <= dataOut_ctrl;
        else if (en_data) dataOut <= dataOut_data;
        else dataOut <= 'h005500aa;
    end
	// done ----------------------------------------------------

	
	wire intCmd, intDat;
	wire sd_clk_internal;
	assign sd_int = intCmd | intDat;
	
	//SD DMA signals
	wire [31:0] ws_buf_din, ws_buf_dout, ws_buf_addr;
	wire [3:0] ws_buf_dm;
	wire ws_buf_cyc, ws_buf_stb, ws_buf_we;
	wire ws_buf_ack;

	//SD bus signals
	always @ (posedge clkSD)
		if(~globlRst) sd_rst <= 1'b0;
	wire [31:0] ctrlDataOut;
	
	//SD controller
	SDController sd(.wb_clk(clkCPU), .wb_rst(globlRst), .sd_clk(clkSD), .sd_rst(globlRst),
		.wb_addr({addrBus[7:2], 2'b0}), .wb_din(dataInBus), .wb_dout(ctrlDataOut),
		.wb_dm(weBus), .wb_cyc(en_ctrl), .wb_stb(en_ctrl), .wb_we(|weBus), .wb_ack(),
		.wbm_addr(ws_buf_addr), .wbm_dout(ws_buf_din), .wbm_din(ws_buf_dout),
		.wbm_dm(ws_buf_dm), .wbm_cyc(ws_buf_cyc), .wbm_stb(ws_buf_stb),
		.wbm_we(ws_buf_we), .wbm_ack(ws_buf_ack),
		.int_cmd(intCmd), .int_data(intDat),
		.sd_dat_pad(sd_dat), .sd_cmd_pad(sd_cmd), .sd_clk_pad(sd_clk)
	);
	always @ (posedge clkCPU)
		dataOut_ctrl <= ctrlDataOut;
	
	//Buffer for SD DMA
	wire buf_enb;
	wire [3:0] buf_web;
	reg buf_readAck;
	reg [9:0] prevAddr;
	Buffer_SD buffer(.clka(clkCPU), .addra(addrBus[11:2]), .dina(dataInBus),
		.wea(weBus), .ena(en_data), .douta(dataOut_data),
		.clkb(clkCPU), .addrb(ws_buf_addr[11:2]), .dinb(ws_buf_din),
		.web(buf_web), .enb(buf_enb), .doutb(ws_buf_dout));
	assign buf_web = ws_buf_we? ws_buf_dm: 4'h0;
	assign buf_enb = ws_buf_cyc & ws_buf_stb & (ws_buf_addr[31:12] == 0);
	assign ws_buf_ack = buf_enb & (ws_buf_we | (buf_readAck & (prevAddr == ws_buf_addr[11:2])));
	always @ (posedge clkCPU)
	begin
		buf_readAck <= buf_enb;
		prevAddr <= ws_buf_addr[11:2];
	end
	
endmodule

module Buffer_SD(
	input clka, input [9:0] addra, input [31:0] dina, input ena,
	input [3:0] wea, output reg [31:0] douta,
	input clkb, input [9:0] addrb, input [31:0] dinb, input enb,
	input [3:0] web, output reg [31:0] doutb
);
	reg [31:0] data[1023:0];
	
	always @ (posedge clka)
	if(ena)
	begin
		if(wea[0]) data[addra][ 7: 0] = dina[ 7: 0];
		if(wea[1]) data[addra][15: 8] = dina[15: 8];
		if(wea[2]) data[addra][23:16] = dina[23:16];
		if(wea[3]) data[addra][31:24] = dina[31:24];
		douta <= data[addra];
	end
	
	always @ (posedge clkb)
	if(enb)
	begin
		if(web[0]) data[addrb][ 7: 0] = dinb[ 7: 0];
		if(web[1]) data[addrb][15: 8] = dinb[15: 8];
		if(web[2]) data[addrb][23:16] = dinb[23:16];
		if(web[3]) data[addrb][31:24] = dinb[31:24];
		doutb <= data[addrb];
	end
	
endmodule
