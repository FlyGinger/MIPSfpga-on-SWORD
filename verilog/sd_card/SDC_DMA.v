`timescale 1ns / 1ps
/**
 * DMA controller for adapting stream interface to Wishbone master interface.
 * 
 * @author Yunye Pu
 */
module SDC_DMA (
	input wb_clk, input wb_rst,
	input sd_clk, input sd_rst,
	//Wishbone master interface
	output [31:0] wb_addr,
	output [31:0] wb_dout, input [31:0] wb_din,
	output [3:0] wb_dm, output wb_cyc, output wb_stb,
	output wb_we, input wb_ack,
	//SD data stream, synchronous to sd_clk
	output [31:0] sd_tx_data, output sd_tx_valid, input sd_tx_ready,
	input [31:0] sd_rx_data, input [3:0] sd_rx_keep,
	input sd_rx_valid, output sd_rx_ready,
	//Control signals
	input tx_en, input rx_en, input [31:0] base_addr
);
	
	wire wb_tx_ready;
	wire wb_rx_valid;
	wire fifo_rst;
	reg [29:0] wb_addr_reg;
	
	AxisFifo #(32, 5, 1, 1) txFifo(
		.s_load(), .m_load(),
		.s_clk(wb_clk), .s_rst(wb_rst), .s_data(wb_din), .s_ready(wb_tx_ready),
		.s_valid(tx_en & wb_cyc & wb_stb & wb_ack),
		.m_clk(sd_clk), .m_rst(sd_rst), .m_data(sd_tx_data),
		.m_valid(sd_tx_valid), .m_ready(sd_tx_ready));
	
	AxisFifo #(36, 5, 1, 1) rxFifo(
		.s_load(), .m_load(),
		.s_clk(sd_clk), .s_rst(sd_rst), .s_data({sd_rx_keep, sd_rx_data}),
		.s_ready(sd_rx_ready), .s_valid(sd_rx_valid),
		.m_clk(wb_clk), .m_rst(wb_rst), .m_data({wb_dm, wb_dout}),
		.m_valid(wb_rx_valid), .m_ready(rx_en & wb_cyc & wb_stb & wb_ack));
	
	assign wb_cyc = (tx_en & wb_tx_ready) | (rx_en & wb_rx_valid);
	assign wb_stb = wb_cyc;
	assign wb_we = rx_en & wb_rx_valid;
	assign fifo_rst = ~(tx_en | rx_en);
	assign wb_addr = {wb_addr_reg, 2'b00};
	
	always @ (posedge wb_clk)
	if(wb_rst)
		wb_addr_reg <= 0;
	else if(wb_cyc & wb_stb & wb_ack)
		wb_addr_reg <= wb_addr_reg + 1;
	else if(fifo_rst)
		wb_addr_reg <= base_addr[31:2];
	
endmodule

module AxisFifo #(
	parameter WIDTH = 8,
	parameter DEPTH_BITS = 7,
	parameter SYNC_STAGE_I = 0,
	parameter SYNC_STAGE_O = 1
) (
	input s_clk, input s_rst, input s_valid, output s_ready,
	input [WIDTH-1:0] s_data, output [DEPTH_BITS-1:0] s_load,
	input m_clk, input m_rst, output m_valid, input m_ready,
	output reg [WIDTH-1:0] m_data, output [DEPTH_BITS-1:0] m_load
);
	localparam DEPTH = 1 << DEPTH_BITS;
	reg [WIDTH-1:0] data[DEPTH-1:0];
	
	//s_clk(write) domain logic
	reg [DEPTH_BITS-1:0] wrPtr = 0;
	wire [DEPTH_BITS-1:0] rdPtrSync;
	always @ (posedge s_clk)
	if(s_rst)
		wrPtr <= {DEPTH_BITS{1'b0}};
	else if(s_valid & s_ready)
	begin
		wrPtr <= wrPtr + 1'b1;
		data[wrPtr] <= s_data;
	end
	wire [DEPTH_BITS-1:0] wrPtr_add1 = wrPtr + 1;
	assign s_ready = wrPtr_add1 != rdPtrSync;
	assign s_load = wrPtr - rdPtrSync;
	
	//m_clk(read) domain logic
	reg [DEPTH_BITS-1:0] rdPtr = 0;
	wire [DEPTH_BITS-1:0] wrPtrSync;
	always @ (posedge m_clk)
	if(m_rst)
		rdPtr = {DEPTH_BITS{1'b0}};
	else
	begin
		if(m_valid & m_ready)
			rdPtr = rdPtr + 1'b1;
		m_data <= data[rdPtr];
	end
	assign m_valid = (rdPtr != wrPtrSync);
	assign m_load = wrPtrSync - rdPtr;
	
	ClockDomainCross #(.I_REG(SYNC_STAGE_I), .O_REG(SYNC_STAGE_O))
		rdPtrCross[DEPTH_BITS-1:0] (.clki(m_clk), .clko(s_clk), .i(rdPtr), .o(rdPtrSync));

	ClockDomainCross #(.I_REG(SYNC_STAGE_I), .O_REG(SYNC_STAGE_O))
		wrPtrCross[DEPTH_BITS-1:0] (.clki(s_clk), .clko(m_clk), .i(wrPtr), .o(wrPtrSync));
	
endmodule

module ClockDomainCross #(
	parameter I_REG = 1,
	parameter O_REG = 1
)(
	input clki, input clko, input i, output o
);
	wire internal;
	PipeReg #(I_REG) inReg(.clk(clki), .i(i), .o(internal));
	PipeReg #(O_REG) outReg(.clk(clko), .i(internal), .o(o));

endmodule

module PipeReg #(
	parameter DEPTH = 1
)(
	input clk, input i, output o
);
	generate
	if(DEPTH < 1)
		assign o = i;
	else if(DEPTH == 1)
	begin
		(* SHREG_EXTRACT = "NO" *)
		reg o_reg;
		always @ (posedge clk) o_reg <= i;
		assign o = o_reg;
	end
	else
	begin
		(* SHREG_EXTRACT = "NO" *)
		reg [DEPTH-1:0] o_reg;
		always @ (posedge clk) o_reg <= {i, o_reg[DEPTH-1:1]};
		assign o = o_reg[0];
	end
	endgenerate
	
endmodule