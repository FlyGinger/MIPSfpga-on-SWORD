/**
 * Intergrates the SD card controller and a buffer to eliminate Wishbone master interface
 * and form a port attachable to SoC bus.
 * 
 * @author Yunye Pu
 * 
 *
 * @Modified at 05-18-2019
 */
 
`include "mfp_ahb_const.vh"
 
module SDWrapper(
	input clkCPU, input clkSD, input globlRst,
	
	//CPU bus interface
	input [1:0] HTRANS, input [2:0] HBURST, input [2:0] HSIZE, input HWRITE,
	input [31:0] dataInBus, input [31:0] HADDR, input [1:0] HSEL,
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
    reg [1:0] HSEL_d; // HSEL delay
    reg [1:0] HTRANS_d; // HTRANS delay
    always @ (posedge clkCPU) begin
        HADDR_d  <= HADDR;
        HWRITE_d <= HWRITE;
        HSEL_d   <= HSEL;
        HTRANS_d <= HTRANS;
    end
    wire we = (HTRANS_d != `HTRANS_IDLE) & (|HSEL_d) & HWRITE_d; // write enable
    
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
    wire en_ctrl = HSEL[1] | HSEL_d[1];
    wire en_data = HSEL[0] | HSEL_d[0];
    
    reg [31:0] dataOut_ctrl;
    wire [31:0] dataOut_data;
    always @ * begin
        case (HSEL)
            2'b01: dataOut <= dataOut_data;
            2'b10: dataOut <= dataOut_ctrl;
            default: dataOut <= 0;
        endcase
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

/**
 * The top module of SD card controller.
 * 
 * @author Yunye Pu
 */
module SDController(
	//Clock and reset
	input wb_clk, input wb_rst,
	input sd_clk, input sd_rst,
	//Wishbone slave interface
	input [7:0] wb_addr, input [31:0] wb_din, output [31:0] wb_dout,
	input [3:0] wb_dm, input wb_cyc, input wb_stb, input wb_we,
	output wb_ack,
	//Wishbone master interface
	output [31:0] wbm_addr, output [31:0] wbm_dout, input [31:0] wbm_din,
	output [3:0] wbm_dm, output wbm_cyc, output wbm_stb, output wbm_we,
	input wbm_ack,
	//Interrupts
	output int_cmd, output int_data,
	//SD card pins
	inout [3:0] sd_dat_pad,
	inout sd_cmd_pad,
	output sd_clk_pad
);

localparam
	BLKSIZE_W = 12,
	BLKCNT_W = 16,
	CMD_TIMEOUT_W = 24,
	DATA_TIMEOUT_W = 24,
	DIV_BITS = 8;

	//Internal clock and reset
	wire sd_sysclk, sd_sysrst;

	//Signals to/from SDC register set
	wire [31:0] argument_wb, argument_sd;
	wire [13:0] cmd_wb, cmd_sd;
	wire [DATA_TIMEOUT_W-1:0] dataTimeout_wb, dataTimeout_sd;
	wire wideBus_wb, wideBus_sd;
	wire [CMD_TIMEOUT_W-1:0] cmdTimeout_wb, cmdTimeout_sd;
	wire [DIV_BITS-1:0] clkdiv_wb;
	wire [BLKSIZE_W-1:0] blockSize_wb, blockSize_sd;
	wire [BLKCNT_W-1:0] blockCount_wb, blockCount_sd;
	wire [31:0] dmaAddress_wb, dmaAddress_sd;
	wire softRst_wb, softRstStatus_wb;
	wire cmdStart_wb, cmdStart_sd;
	
	wire [6:0] dataIntEvents_wb, dataIntEvents_sd;
	wire [4:0] cmdIntEvents_wb, cmdIntEvents_sd;
	wire [119:0] response_wb, response_sd;
	
	localparam CDC_WB_SD_W = 32 + 14 + 1 + 32 //argument, command, widebus, dmaAddress
		+ DATA_TIMEOUT_W + CMD_TIMEOUT_W + BLKSIZE_W + BLKCNT_W;
	localparam CDC_SD_WB_W = 120 + 5 + 7;//Response + command int + data int
	
	//SD control signals
	wire sdBusy;
	wire startDataRx, startDataTx;
	
	SDC_Clocking #(DIV_BITS, CDC_WB_SD_W, CDC_SD_WB_W) infrastructure(
		.wb_clk(wb_clk), .sd_clk_in(sd_clk), .sd_rst_in(sd_rst),
		.sd_clk_out(sd_sysclk), .sd_rst_out(sd_sysrst),
		.sd_clk_pad(sd_clk_pad),
		.clkdivValue(clkdiv_wb),
		.cmdStart_in(cmdStart_wb), .cmdStart_out(cmdStart_sd),
		.softRst_in(softRst_wb), .softRst_status(softRstStatus_wb),
		.wb_sd_cdcIn ({argument_wb, cmd_wb, dataTimeout_wb, wideBus_wb, cmdTimeout_wb, blockSize_wb, blockCount_wb, dmaAddress_wb}),
		.wb_sd_cdcOut({argument_sd, cmd_sd, dataTimeout_sd, wideBus_sd, cmdTimeout_sd, blockSize_sd, blockCount_sd, dmaAddress_sd}),
		.sd_wb_cdcIn ({response_sd, cmdIntEvents_sd, dataIntEvents_sd}),
		.sd_wb_cdcOut({response_wb, cmdIntEvents_wb, dataIntEvents_wb})
	);
	
	SDC_Registers #(BLKSIZE_W, BLKCNT_W, CMD_TIMEOUT_W, DATA_TIMEOUT_W, DIV_BITS) registers (
		.clk(wb_clk), .rst(wb_rst),
		.wb_addr(wb_addr), .wb_din(wb_din), .wb_dout(wb_dout),
		.wb_dm(wb_dm), .wb_cyc(wb_cyc), .wb_stb(wb_stb),
		.wb_we(wb_we), .wb_ack(wb_ack),
		.cmdInt(int_cmd), .dataInt(int_data),
		.sdc_argument(argument_wb),
		.sdc_cmd(cmd_wb),
		.sdc_dataTimeout(dataTimeout_wb),
		.sdc_wideBus(wideBus_wb),
		.sdc_cmdTimeout(cmdTimeout_wb),
		.sdc_clkdiv(clkdiv_wb),
		.sdc_blockSize(blockSize_wb),
		.sdc_blockCount(blockCount_wb),
		.sdc_dmaAddress(dmaAddress_wb),
		.sdc_softReset(softRst_wb),
		.sdc_cmdStart(cmdStart_wb),
		.dataIntEvents(dataIntEvents_wb),
		.cmdIntEvents(cmdIntEvents_wb),
		.resetStatus(softRstStatus_wb),
		.responseIn(response_wb)
	);
	
	wire sd_cmd_o, sd_cmd_t;
	SDC_Cmdpath #(CMD_TIMEOUT_W) commandPath (
		.clk(sd_sysclk), .rst(sd_sysrst),
		.cmdIndex(cmd_sd[13:8]), .cmdArgument(argument_sd),
		.cmdStart(cmdStart_sd), .startRx(startDataRx), .startTx(startDataTx),
		.cmdConfig(cmd_sd[6:0]), .response(response_sd), .timeoutValue(cmdTimeout_sd),
		.interruptEvents(cmdIntEvents_sd),
		.sdCmd_o(sd_cmd_o), .sdCmd_t(sd_cmd_t), .sdCmd_i(sd_cmd_pad),
		.sdBusy(sdBusy)
	);
	assign sd_cmd_pad = sd_cmd_t? sd_cmd_o: 1'bz;
	
	SDC_Datapath #(BLKSIZE_W, BLKCNT_W, DATA_TIMEOUT_W) dataPath(
		.wb_clk(wb_clk), .wb_rst(wb_rst),
		.sd_clk(sd_sysclk), .sd_rst(sd_sysrst),
		.wb_addr(wbm_addr), .wb_dout(wbm_dout), .wb_din(wbm_din),
		.wb_dm(wbm_dm), .wb_cyc(wbm_cyc), .wb_stb(wbm_stb),
		.wb_we(wbm_we), .wb_ack(wbm_ack),
		.sdDat(sd_dat_pad),
		.blockSize(blockSize_sd), .blockCount(blockCount_sd),
		.timeoutValue(dataTimeout_sd), .dmaAddress(dmaAddress_sd),
		.wideBus(wideBus_sd),
		.rxStart(startDataRx), .txStart(startDataTx), .sdBusy(sdBusy),
		.interruptEvents(dataIntEvents_sd)
	);
	
	
endmodule

/**
 * Clocking infrastructure for SD card controller.
 * Provides a divided clock output, controller reset signal in divided clock domain,
 * and clock domain crossing for various control/status signals in SD card controller.
 * The divided clock is sourced by a BUFHCE primitive, a horizontal clock buffer,
 * so all the logic driven by the divided clock should be in the same clock region,
 * which means all SD card pins should be in the same I/O bank.
 * 
 * @author Yunye Pu
 */
module SDC_Clocking #(
	parameter DIV_BITS = 8,
	parameter CDC_WB_SD_W = 32,
	parameter CDC_SD_WB_W = 32
)(
	//Clock source
	input wb_clk,
	input sd_clk_in, input sd_rst_in,
	//Output clock
	output sd_clk_out, output reg sd_rst_out = 1,//Output reset is ORed with software reset
	output sd_clk_pad,//Output clock to SD_CLK pin
	//Division value, synchronous to wb_clk
	input [DIV_BITS-1:0] clkdivValue,
	//CDC wb_clk to sd_sysclk
	input [CDC_WB_SD_W-1:0] wb_sd_cdcIn, output reg [CDC_WB_SD_W-1:0] wb_sd_cdcOut,
	//CDC sd_sysclk to wb_clk
	input [CDC_SD_WB_W-1:0] sd_wb_cdcIn, output reg [CDC_SD_WB_W-1:0] sd_wb_cdcOut,
	//Trigger signals
	input cmdStart_in, output reg cmdStart_out = 0,
	input softRst_in, output reg softRst_status = 1
);
	
	//SD clock generation
	reg [DIV_BITS-1:0] divValue_sync = 255;
	reg [DIV_BITS-1:0] divValue_reg = 255;
	reg [DIV_BITS-1:0] divCounter = 0;
	wire [DIV_BITS:0] divCounter2 = {divCounter, 1'b0};
	reg sd_ce;
	
	always @ (posedge sd_clk_in)
	if(sd_rst_in)
		divValue_sync <= 255;
	else
		divValue_sync <= clkdivValue;
	always @ (posedge sd_clk_in)
	begin
		sd_ce <= (divCounter == divValue_reg);
		if(divCounter == divValue_reg)
		begin
			divCounter <= 0;
			divValue_reg <= divValue_sync;
		end
		else
			divCounter <= divCounter + 1;
	end

	BUFHCE #(.CE_TYPE("SYNC"), .INIT_OUT(0)) sdclk_buf(.I(sd_clk_in), .CE(sd_ce), .O(sd_clk_out));
	ODDR #(.DDR_CLK_EDGE("SAME_EDGE"), .INIT(1'b1), .SRTYPE("ASYNC")) sd_clk_fwd (
		.Q(sd_clk_pad), .C(sd_clk_in), .CE(1'b1), .R(1'b0), .S(sd_rst_in),
		.D1(divCounter2 <= divValue_reg),
		.D2(divCounter2 <  divValue_reg)
	);
	
	//Command trigger signal synchronization
	reg cmdStart_trigger = 0;
	reg [2:0] cmdStart_sync = 5'b0;
	always @ (posedge wb_clk)
	if(cmdStart_in) cmdStart_trigger <= !cmdStart_trigger;
	always @ (posedge sd_clk_out)
	begin
		cmdStart_sync <= {cmdStart_sync[1:0], cmdStart_trigger};
		cmdStart_out <= cmdStart_sync[2] ^ cmdStart_sync[1];
	end
	
	//Reset trigger signal synchronization
	reg softRst_trigger = 0;
	reg [2:0] softRst_sync = 2'b0;
	always @ (posedge wb_clk)
	if(softRst_in) softRst_trigger <= !softRst_trigger;
	always @ (posedge sd_clk_out)
		softRst_sync <= {softRst_sync[1:0], softRst_trigger};
	
	//SD reset signal generation
	reg [3:0] sdResetCounter = 0;
	reg sd_rst_in_sync = 1;
	always @ (posedge sd_clk_out)
	begin
		sd_rst_in_sync <= sd_rst_in;
		if(sd_rst_in_sync || (softRst_sync[2] ^ softRst_sync[1]))
			sdResetCounter <= 0;
		else if(~&sdResetCounter)
			sdResetCounter <= sdResetCounter + 1;
		sd_rst_out <= ~&sdResetCounter;
	end
	always @ (posedge wb_clk)
		softRst_status <= sd_rst_out;
	
	//Clock domain crossing
	always @ (posedge wb_clk)
		sd_wb_cdcOut <= sd_wb_cdcIn;
	
	always @ (posedge sd_clk_out)
		wb_sd_cdcOut <= wb_sd_cdcIn;
	
endmodule

/**
 * SD card CMD pin driver. Manages command transmitting,
 * response receiving, CRC generating and checking etc.
 * 
 * @author Yunye Pu
 */
module SDC_Cmdpath #(
	parameter CMD_TIMEOUT_W = 16
)(
	input clk, input rst,
	//Command input
	input [5:0] cmdIndex, input [31:0] cmdArgument,
	//Command trigger
	input cmdStart, output reg startRx = 0, output reg startTx = 0,
	//Configurations
	input [6:0] cmdConfig,
	output [119:0] response,
	input [CMD_TIMEOUT_W-1:0] timeoutValue,
	//Status
	output [4:0] interruptEvents,
	//Command pin signals
	output reg sdCmd_o = 1, input sdCmd_i, output reg sdCmd_t = 0,
	//Busy signal from DAT0 pin
	input sdBusy
);
`define CHECK_INDEX    cmdConfig[4]
`define CHECK_CRC      cmdConfig[3]
`define CHECK_BUSY     cmdConfig[2]
`define CHECK_RESP    (cmdConfig[1] ^ cmdConfig[0]) // == 2'b01 or 2'b10
`define START_DATA_RX (cmdConfig[6:5] == 2'b01)
`define START_DATA_TX (cmdConfig[6:5] == 2'b10)
`define RESP_LENGTH   (cmdConfig[0]? 8'd38: 8'd126)
	
	reg sdCmd_i_reg = 1;

	localparam
	IDLE      = 4'h0,
	TX_DATA   = 4'h1,
	TX_CRC    = 4'h2,
	TX_STOP   = 4'h3,
	TX_CLEAR  = 4'h4,
	WAIT_RESP = 4'h5,
	RX_DATA   = 4'h6,
	RX_CRC    = 4'h7,
	RX_STOP   = 4'h8,
	WAIT_BUSY = 4'h9,
	CMD_FIN   = 4'ha;
	reg [3:0] state = IDLE;
	
	reg [39:0] cmdTxShift;
	reg [119:0] respRxShift;
	reg [7:0] bitCounter = 0;
	
	reg respIndexErr = 0;
	reg respCrcErr = 0;
	reg cmdTimeout = 0;
	
	//State transition
	always @ (posedge clk)
	if(rst)
		state <= IDLE;
	else
	case(state)
	IDLE: if(cmdStart) state <= TX_DATA;
	TX_DATA: if(bitCounter == 39) state <= TX_CRC;
	TX_CRC: if(bitCounter == 46) state <= TX_STOP;
	TX_STOP: state <= TX_CLEAR;
	TX_CLEAR: if(bitCounter == 50) begin // Wait for bus turnaround
		if(`CHECK_RESP)
			state <= WAIT_RESP;
		else if(`CHECK_BUSY)
			state <= WAIT_BUSY;
		else
			state <= CMD_FIN;
	end
	WAIT_RESP: begin
		if(cmdTimeout)
			state <= IDLE;
		else if(sdCmd_i_reg == 0)
			state <= RX_DATA;
	end
	RX_DATA: if(bitCounter == `RESP_LENGTH) state <= RX_CRC;
	RX_CRC: if(bitCounter == `RESP_LENGTH + 7) state <= RX_STOP;
	RX_STOP: begin
		if(respIndexErr || respCrcErr)
			state <= IDLE;
		else if(`CHECK_BUSY)
			state <= WAIT_BUSY;
		else
			state <= CMD_FIN;
	end
	WAIT_BUSY: begin
		if(cmdTimeout)
			state <= IDLE;
		else if(!sdBusy)
			state <= CMD_FIN;
	end
	CMD_FIN: state <= IDLE;
	endcase
	
	wire crcOut;
	wire crcEn = (state == TX_DATA) || (state == RX_DATA);
	wire crcClr = rst || !crcEn;
	wire crcDin = (state == TX_DATA)? cmdTxShift[39]: sdCmd_i_reg;
	SDC_CRC7 crc(.clk(clk), .ce(crcEn), .clr(crcClr), .din(crcDin), .crc_out(crcOut));
	
	reg [CMD_TIMEOUT_W-1:0] timeoutCounter = 0;
	
	always @ (posedge clk)
	begin
		sdCmd_i_reg <= sdCmd_i;
	
		case(state)
		TX_DATA, TX_CRC, TX_STOP, TX_CLEAR,
		RX_DATA, RX_CRC, RX_STOP: bitCounter <= bitCounter + 1;
		default: bitCounter <= 0;
		endcase

		if(state == TX_DATA)
			cmdTxShift <= {cmdTxShift[38:0], 1'b1};
		else
			cmdTxShift <= {2'b01, cmdIndex, cmdArgument};

		case(state)
		TX_DATA: sdCmd_o <= cmdTxShift[39];
		TX_CRC:  sdCmd_o <= crcOut;
		default: sdCmd_o <= 1'b1;
		endcase
		
		case(state)
		TX_DATA, TX_CRC, TX_STOP: sdCmd_t <= 1'b1;
		default: sdCmd_t <= 1'b0;
		endcase
		
		if(state == RX_DATA)
			respRxShift <= {respRxShift[118:0], sdCmd_i_reg};
		
		startRx <= (state == CMD_FIN) && `START_DATA_RX;
		startTx <= (state == CMD_FIN) && `START_DATA_TX;
		
		if(rst || cmdStart)
			respCrcErr <= 0;
		else if((state == RX_CRC) && (crcOut != sdCmd_i_reg) && `CHECK_CRC)
			respCrcErr <= 1;
		
		if(rst || cmdStart)
			respIndexErr <= 0;
		else if((state == RX_DATA) && (bitCounter == 7) && (respRxShift[5:0] != cmdIndex) && `CHECK_INDEX)
			respIndexErr <= 1;
		
		if(rst || (state == IDLE))
			timeoutCounter <= 0;
		else if(timeoutCounter != timeoutValue)
			timeoutCounter <= timeoutCounter + 1;
		
		if(rst || cmdStart)
			cmdTimeout <= 0;
		else if(timeoutValue != 0 && timeoutCounter == timeoutValue)
			cmdTimeout <= 1;
	end
	
	wire errorEvent = respIndexErr || respCrcErr || cmdTimeout;
	
	assign interruptEvents = (state == IDLE)? {respIndexErr, respCrcErr, cmdTimeout, errorEvent, !errorEvent}: 5'h0;
	assign response = respRxShift;
	
endmodule

/**
 * CRC modules used in CMD and DAT lines. CRC results are output serially.
 * 
 * @author Yunye Pu
 */
module SDC_CRC16(
	input clk, input ce, input din,
	input clr, output crc_out
);
	reg [15:0] crc;
	wire crc_in = clr? 1'b0: crc_out ^ din;
	assign crc_out = crc[3] ^ crc[10] ^ crc[15];
	always @ (posedge clk)
	if(ce || clr) crc <= {crc[14:0], crc_in};
	
endmodule

module SDC_CRC7(
	input clk, input ce, input din,
	input clr, output crc_out
);
	reg [6:0] crc;
	wire crc_in = clr? 1'b0: crc_out ^ din;
	assign crc_out = crc[3] ^ crc[6];
	always @ (posedge clk)
	if(ce || clr) crc <= {crc[5:0], crc_in};
	
endmodule

/**
 * Main module on SD controller data path. Drives DAT pins
 * and provides a Wishbone master interface for data movement.
 * 
 * @author Yunye Pu
 */
module SDC_Datapath #(
	parameter BLKSIZE_W = 12,
	parameter BLKCNT_W = 16,
	parameter DATA_TIMEOUT_W = 24
)(
	input wb_clk, input wb_rst,
	input sd_clk, input sd_rst,
	//DMA interface: wishbone master
	output [31:0] wb_addr,
	output [31:0] wb_dout, input [31:0] wb_din,
	output [3:0] wb_dm, output wb_cyc, output wb_stb,
	output wb_we, input wb_ack,
	//SD data interface
	inout [3:0] sdDat,
	//Configuration signals
	input [BLKSIZE_W-1:0] blockSize,
	input [BLKCNT_W-1:0] blockCount,
	input [DATA_TIMEOUT_W-1:0] timeoutValue,
	input [31:0] dmaAddress,
	input wideBus,
	//Control and status
	input rxStart, input txStart, output sdBusy, output [6:0] interruptEvents
);

	reg txRunning = 0;//Sets on tx start, resets on downscaler finish
	reg rxRunning = 0;//Sets on rx start, resets on RX idle after upscaler finish
	//When an error event occur, RX and TX will stop after transaction of current block completes.
	
	wire txFinish, rxFinish, rxIdle, txWaiting;
	wire rxCrcError, rxFrameError;
	
	//TX 32-bit stream
	wire [31:0] txWord_data;
	wire txWord_valid, txWord_ready;
	//TX 8-bit stream
	wire [7:0] txByte_data;
	wire txByte_valid, txByte_ready, txByte_last;
	//RX 8-bit stream
	wire [7:0] rxByte_data;
	wire rxByte_valid, rxByte_last;
	//RX 32-bit stream
	wire [31:0] rxWord_data;
	wire [3:0] rxWord_keep;
	wire rxWord_valid, rxWord_ready;
	
	//SD bus
	wire [3:0] sdDat_o;
	wire [3:0] sdDat_t;
	wire [3:0] sdDat_i;
	
	SDC_DMA dma(
		.wb_clk(wb_clk), .wb_rst(wb_rst),
		.sd_clk(sd_clk), .sd_rst(sd_rst),
		.wb_addr(wb_addr), .wb_dout(wb_dout), .wb_din(wb_din),
		.wb_dm(wb_dm), .wb_cyc(wb_cyc), .wb_stb(wb_stb),
		.wb_we(wb_we), .wb_ack(wb_ack),
		
		.sd_tx_data(txWord_data), .sd_tx_valid(txWord_valid),
		.sd_tx_ready(txWord_ready),
		.sd_rx_data(rxWord_data), .sd_rx_keep(rxWord_keep),
		.sd_rx_valid(rxWord_valid), .sd_rx_ready(rxWord_ready),
		.tx_en(txRunning), .rx_en(rxRunning), .base_addr(dmaAddress)
	);
	
	SDC_TxDownscaler #(BLKSIZE_W, BLKCNT_W) tx1 (
		.clk(sd_clk), .rst(sd_rst || ~txRunning), .tx_finish(txFinish),
		.tx_data_in(txWord_data), .tx_valid_in(txWord_valid), .tx_ready_in(txWord_ready),
		.tx_data_out(txByte_data), .tx_valid_out(txByte_valid),
		.tx_last_out(txByte_last), .tx_ready_out(txByte_ready),
		.block_size(blockSize), .block_cnt(blockCount)
	);
	
	
	SDC_DataTransmitter tx0(
		.clk(sd_clk), .rst(sd_rst),
		.in_data(txByte_data), .in_valid(txByte_valid),
		.in_last(txByte_last), .in_ready(txByte_ready),
		.wideBus(wideBus), .txWaiting(txWaiting),
		.sdDat(sdDat_o), .oe(sdDat_t), .sdBusy(sdBusy)
	);
	
	SDC_DataReceiver #(BLKSIZE_W) rx0(
		.clk(sd_clk), .rst(sd_rst),
		.out_data(rxByte_data), .out_valid(rxByte_valid), .out_last(rxByte_last),
		.crcError(rxCrcError), .frameError(rxFrameError), .idle(rxIdle),
		.wideBus(wideBus), .rxSize(blockSize),
		.sdDat(sdDat_i), .sdBusy(sdBusy)
	);
	
	SDC_RxUpscaler #(BLKCNT_W) rx1(
		.clk(sd_clk), .rst(sd_rst || !rxRunning), .rx_finish(rxFinish),
		.rx_data_in(rxByte_data), .rx_valid_in(rxByte_valid),
		.rx_last_in(rxByte_last),
		.block_cnt(blockCount),
		.rx_data_out(rxWord_data), .rx_valid_out(rxWord_valid),
		.rx_keep_out(rxWord_keep)
	);
	
	//SD data lines driver
	assign sdDat_i = sdDat;
	assign sdDat[0] = sdDat_t[0]? sdDat_o[0]: 1'bz;
	assign sdDat[1] = sdDat_t[1]? sdDat_o[1]: 1'bz;
	assign sdDat[2] = sdDat_t[2]? sdDat_o[2]: 1'bz;
	assign sdDat[3] = sdDat_t[3]? sdDat_o[3]: 1'bz;
	
	//Timeout detection logic
	wire int_timeout;
	reg [DATA_TIMEOUT_W-1:0] timeoutCounter = 0;
	always @ (posedge sd_clk)
	if(sd_rst || !(txRunning || rxRunning))
		timeoutCounter <= 0;
	else if(timeoutCounter != timeoutValue)
		timeoutCounter <= timeoutCounter + 1;
	assign int_timeout = (timeoutCounter == timeoutValue) && (timeoutValue != 0);
	
//TX fifo underflow: DMA output valid goes from high to low when tx running
//RX fifo overflow: DMA input ready goes low when rx running
	wire outValidFall;
	EdgeDetector #(1'b0) dmaTxValidFallDetect (.clk(sd_clk), .rst(sd_rst), .i(txWord_valid), .rise(), .fall(outValidFall));

	reg [4:0] errEvents = 0;
	always @ (posedge sd_clk)
	if(sd_rst || rxStart || txStart)
		errEvents <= 5'h0;
	else
	begin
		//Timeout
		if(int_timeout) errEvents[4] <= 1;
		//Frame error
		if(rxFrameError && rxRunning) errEvents[3] <= 1;
		//TX fifo underflow
		if(outValidFall && txRunning) errEvents[2] <= 1;
		//RX fifo overflow
		if(!rxWord_ready && rxRunning) errEvents[1] <= 1;
		//CRC error
		if(rxCrcError && rxRunning) errEvents[0] <= 1;
	end
	
	reg rxFinished = 0;//Sets on RX upscaler finish, resets on rx start
	
	always @ (posedge sd_clk)
	if(sd_rst || ((|errEvents) && rxIdle) || (rxIdle && rxFinished))
		rxRunning <= 0;
	else if(rxStart)
		rxRunning <= 1;
	
	always @ (posedge sd_clk)
	if(sd_rst || ((|errEvents) && txWaiting) || txFinish)
		txRunning <= 0;
	else if(txStart)
		txRunning <= 1;
	
	always @ (posedge sd_clk)
	if(sd_rst || !rxRunning)
		rxFinished <= 0;
	else if(rxFinish)
		rxFinished <= 1;
	
	assign interruptEvents = (rxRunning || txRunning)? 7'h0: {errEvents, |errEvents, ~|errEvents};
	
endmodule

module EdgeDetector #(
	parameter INIT = 1'b1
)(
	input clk, input rst,
	input i, output rise, output fall
);
	reg [1:0] in_reg = {2{INIT}};
	always @ (posedge clk)
	if(rst)
		in_reg <= {2{INIT}};
	else
		in_reg <= {in_reg[0], i};
	
	assign rise = (in_reg == 2'b01);
	assign fall = (in_reg == 2'b10);
	
endmodule

/**
 * SD data receiver. Supports both 1-bit and 4-bit SD bus mode.
 * CRC is checked and removed from data frames.
 * Data output is 8-bit wide, to minimize efforts on data alignment.
 * 
 * @author Yunye Pu
 */
module SDC_DataReceiver #(
	parameter BLKSIZE_W = 12
)(
	input clk, input rst,
	//Stream output
	output reg [7:0] out_data, output reg out_valid, output reg out_last,
	output reg crcError = 0, output frameError, output idle,
	//Bus mode and size
	input wideBus, input [BLKSIZE_W-1:0] rxSize,
	//SD data input
	input [3:0] sdDat, output sdBusy
);
	reg [3:0] sdDat_reg;
	
	localparam IDLE = 3'h0;
	localparam RX_DATA = 3'h1;
	localparam RX_CRC = 3'h2;
	localparam RX_STOP = 3'h3;
	reg [2:0] state = IDLE;
	
	reg [BLKSIZE_W-1:0] byteCounter = 0;
	reg [3:0] bitCounter = 0;
	
	reg [6:0] dat0Shift;
	reg dat1Shift, dat2Shift, dat3Shift;
	wire byteLoad = wideBus? bitCounter[0]: &bitCounter[2:0];
	
	wire [3:0] crcOut;
	wire _crcError = wideBus? (crcOut != sdDat_reg): (crcOut[0] != sdDat_reg[0]);
	
	assign idle = (state == IDLE);
	
	always @ (posedge clk)
	if(rst)
	begin
		state <= IDLE;
		byteCounter <= 0;
		bitCounter <= 0;
		crcError <= 0;
	end
	else
	case(state)
	IDLE: begin
		byteCounter <= 0;
		bitCounter <= 0;
		crcError <= 0;
		if(sdDat_reg[0] == 0) state <= RX_DATA;
	end
	RX_DATA: begin
		bitCounter <= bitCounter + 1;
		if(byteLoad) byteCounter <= byteCounter + 1;
		if(byteLoad && (byteCounter == rxSize))
		begin
			state <= RX_CRC;
			bitCounter <= 0;
		end
		crcError <= 0;
	end
	RX_CRC: begin
		if(_crcError) crcError <= 1;
		bitCounter <= bitCounter + 1;
		byteCounter <= 0;
		if(&bitCounter) state <= RX_STOP;
	end
	RX_STOP: begin
		state <= IDLE;
		byteCounter <= 0;
		bitCounter <= 0;
		crcError <= 0;
	end
	endcase
	
	assign frameError = (state == RX_STOP) && (sdDat_reg != 4'hf);
	
	always @ (posedge clk)
	begin
		sdDat_reg <= sdDat;
		dat0Shift <= {dat0Shift[5:0], sdDat_reg[0]};
		dat1Shift <= sdDat_reg[1];
		dat2Shift <= sdDat_reg[2];
		dat3Shift <= sdDat_reg[3];
		out_valid <= byteLoad && (state == RX_DATA);
		out_last <=  byteLoad && (state == RX_DATA) && (byteCounter == rxSize);
		if(wideBus)
			out_data <= {dat3Shift, dat2Shift, dat1Shift, dat0Shift[0], sdDat_reg};
		else
			out_data <= {dat0Shift, sdDat_reg[0]};
	end
	
	assign sdBusy = !sdDat_reg[0];
	
	wire crcEn = (state == RX_DATA);
	wire crcRst = rst || !crcEn;
	
	SDC_CRC16 crc[3:0] (.clk(clk), .ce(crcEn), .din(sdDat_reg), .clr(crcRst), .crc_out(crcOut));

	
endmodule

/**
 * SD data transmitter. Supports both 1-bit and 4-bit SD bus mode.
 * CRC is computed and appended at the end of data frames.
 * Data input is 8-bit wide, to minimize efforts on data alignment.
 * 
 * @author Yunye Pu
 */
module SDC_DataTransmitter(
	input clk, input rst,
	//Stream input
	input [7:0] in_data, input in_valid,
	input in_last, output in_ready,
	//Bus mode
	input wideBus,
	//SD data output
	output reg [3:0] sdDat, output reg [3:0] oe,
	input sdBusy, output txWaiting
);
	
	localparam IDLE = 3'h0;
	localparam TX_START = 3'h1;
	localparam TX_DATA = 3'h2;
	localparam TX_LAST = 3'h3;
	localparam TX_CRC = 3'h4;
	localparam TX_STOP = 3'h5;
	localparam BUS_TURNAROUND = 3'h6;
	localparam CARD_BUSY = 3'h7;
	reg [2:0] state = IDLE;
	
	reg [3:0] bitCounter = 0;
	reg [7:0] byteShift;
	
	wire byteLoad = wideBus? bitCounter[0]: &bitCounter[2:0];
	assign in_ready = ((state == TX_DATA) && byteLoad) || (state == TX_START);
	
	always @ (posedge clk)
	if(rst)
	begin
		state <= IDLE;
		bitCounter <= 0;
		byteShift <= 8'hff;
	end
	else
	case(state)
	IDLE:begin
		bitCounter <= 0;
		if(in_valid) state <= TX_START;
		byteShift <= in_valid? 8'h00: 8'hff;
	end
	TX_START: begin
		bitCounter <= 0;
		byteShift <= in_data;
		state <= TX_DATA;
	end
	TX_DATA: begin
		if(byteLoad)
			byteShift <= in_data;
		else if(wideBus)
			byteShift <= {byteShift[3:0], 4'h0};
		else
			byteShift <= {byteShift[6:0], 1'b0};
		bitCounter <= bitCounter + 1;
		if(byteLoad && in_last) state <= TX_LAST;
	end
	TX_LAST: begin
		if(byteLoad)
			byteShift <= in_data;
		else if(wideBus)
			byteShift <= {byteShift[3:0], 4'h0};
		else
			byteShift <= {byteShift[6:0], 1'b0};
		if(byteLoad) state <= TX_CRC;
		if(byteLoad)
			bitCounter <= 0;
		else
			bitCounter <= bitCounter + 1;
	end
	TX_CRC: begin
		bitCounter <= bitCounter + 1;
		if(&bitCounter) state <= TX_STOP;
		byteShift <= 8'hff;
	end
	TX_STOP: begin
		state <= BUS_TURNAROUND;
		bitCounter <= 0;
		byteShift <= 0;
		byteShift <= 8'hff;
	end
	BUS_TURNAROUND: begin
		bitCounter <= bitCounter + 1;
		if(&bitCounter) state <= CARD_BUSY;
		byteShift <= 8'hff;
	end
	CARD_BUSY: begin
		bitCounter <= 0;
		byteShift <= 8'hff;
		if(!sdBusy) state <= IDLE;
	end
	endcase
	
	wire crcEn = (state == TX_DATA) || (state == TX_LAST);
	wire crcRst = rst || !crcEn;
	wire [3:0] crcOut;
	
	SDC_CRC16 crc[3:0] (.clk(clk), .ce(crcEn), .din(byteShift[7:4]), .clr(crcRst), .crc_out(crcOut));
	wire _oe = (state == TX_START) || (state == TX_DATA) || (state == TX_LAST)
			||(state == TX_CRC) || (state == TX_STOP);
	
	always @ (posedge clk)
	begin
		sdDat[3] <= wideBus? ((state == TX_CRC)? crcOut[3]: byteShift[7]): 1'b1;
		sdDat[2] <= wideBus? ((state == TX_CRC)? crcOut[2]: byteShift[6]): 1'b1;
		sdDat[1] <= wideBus? ((state == TX_CRC)? crcOut[1]: byteShift[5]): 1'b1;
		if(state == TX_CRC)
			sdDat[0] <= wideBus? crcOut[0]: crcOut[3];
		else
			sdDat[0] <= wideBus? byteShift[4]: byteShift[7];
		oe[0] <= _oe;
		oe[3:1] <= wideBus? {3{_oe}}: 3'b000;
	end
	
	assign txWaiting = (state == CARD_BUSY);
	
endmodule

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

/**
 * Control register set of SD card controller. Accessible
 * through a Wishbone slave interface; ack output is always
 * high whenever stb and cyc inputs are high, so the Wishbone
 * master can assume a non-blocking operation.
 * 
 * @author Yunye Pu
 */
module SDC_Registers #(
	parameter BLKSIZE_W = 12,
	parameter BLKCNT_W = 16,
	parameter CMD_TIMEOUT_W = 24,
	parameter DATA_TIMEOUT_W = 24,
	parameter DIV_BITS = 8
)(
	input clk, input rst,
	//Wishbone interface
	input [7:0] wb_addr, input [31:0] wb_din,
	output reg [31:0] wb_dout, input [3:0] wb_dm,
	input wb_cyc, input wb_stb, input wb_we,
	output wb_ack,
	//Interrupt output
	output cmdInt, output dataInt,
	//SDC configuration signals output
	output [31:0] sdc_argument,
	output [13:0] sdc_cmd,
	output [DATA_TIMEOUT_W-1:0] sdc_dataTimeout,
	output sdc_wideBus,
	output [CMD_TIMEOUT_W-1:0] sdc_cmdTimeout,
	output [DIV_BITS-1:0] sdc_clkdiv,
	output [BLKSIZE_W-1:0] sdc_blockSize,
	output [BLKCNT_W-1:0] sdc_blockCount,
	output [31:0] sdc_dmaAddress,
	//SDC trigger signals output
	output reg sdc_softReset,
	output reg sdc_cmdStart,
	//SDC status signals input
	input [6:0] dataIntEvents, input [4:0] cmdIntEvents, input resetStatus,
	input [119:0] responseIn
);
	wire [6:0] dataIntMask;
	wire [4:0] cmdIntMask;
	
	wire [6:0] dataIntTrigger;
	wire [4:0] cmdIntTrigger;
	
	wire dataIntClear, cmdIntClear;
	
	assign cmdInt = |(cmdIntTrigger & cmdIntMask);
	assign dataInt = |(dataIntTrigger & dataIntMask);
	
	SDC_IntTrigger dataIntReg[6:0] (.clk(clk), .trigger(dataIntEvents), .reset(dataIntClear), .out(dataIntTrigger));
	SDC_IntTrigger cmdIntReg [4:0] (.clk(clk), .trigger(cmdIntEvents),  .reset(cmdIntClear),  .out(cmdIntTrigger));
	
	wire regWe = wb_cyc && wb_stb && wb_we;
	assign wb_ack = wb_cyc && wb_stb;
	
	SDC_Reg #(32, 32'h0, 6, 6'h00) argument_reg    (clk, rst, wb_addr[7:2], regWe, wb_din[31:0], wb_dm[3:0], sdc_argument);
	SDC_Reg #(14, 14'h0, 6, 6'h01) command_reg     (clk, rst, wb_addr[7:2], regWe, wb_din[13:0], wb_dm[1:0], sdc_cmd);
	SDC_Reg #( 1,  1'h0, 6, 6'h07) wideBus_reg     (clk, rst, wb_addr[7:2], regWe, wb_din[0],    wb_dm[0],   sdc_wideBus);
	SDC_Reg #( 5,  5'h0, 6, 6'h0e) cmdIntMask_reg  (clk, rst, wb_addr[7:2], regWe, wb_din[ 4:0], wb_dm[0],   cmdIntMask);
	SDC_Reg #( 7,  7'h0, 6, 6'h10) dataIntMask_reg (clk, rst, wb_addr[7:2], regWe, wb_din[ 6:0], wb_dm[0],   dataIntMask);
	SDC_Reg #(32, 32'h0, 6, 6'h18) dmaAddress_reg  (clk, rst, wb_addr[7:2], regWe, wb_din[31:0], wb_dm[3:0], sdc_dmaAddress);

	SDC_Reg #(DATA_TIMEOUT_W, 0, 6, 6'h06) dataTimeout_reg (clk, rst, wb_addr[7:2], regWe, wb_din[DATA_TIMEOUT_W-1:0], wb_dm[(DATA_TIMEOUT_W-1)/8:0], sdc_dataTimeout);
	SDC_Reg #(CMD_TIMEOUT_W,  0, 6, 6'h08) cmdTimeout_reg  (clk, rst, wb_addr[7:2], regWe, wb_din[CMD_TIMEOUT_W -1:0], wb_dm[(CMD_TIMEOUT_W -1)/8:0], sdc_cmdTimeout);
	SDC_Reg #(DIV_BITS,     255, 6, 6'h09) clkdiv_reg      (clk, rst, wb_addr[7:2], regWe, wb_din[DIV_BITS      -1:0], wb_dm[(DIV_BITS      -1)/8:0], sdc_clkdiv);
	SDC_Reg #(BLKSIZE_W,    511, 6, 6'h11) blockSize_reg   (clk, rst, wb_addr[7:2], regWe, wb_din[BLKSIZE_W     -1:0], wb_dm[(BLKSIZE_W     -1)/8:0], sdc_blockSize);
	SDC_Reg #(BLKCNT_W,       0, 6, 6'h12) blockCount_reg  (clk, rst, wb_addr[7:2], regWe, wb_din[BLKCNT_W      -1:0], wb_dm[(BLKCNT_W      -1)/8:0], sdc_blockCount);
	
	always @*
	case(wb_addr[7:2])
	6'h00: wb_dout <= sdc_argument;
	6'h01: wb_dout <= sdc_cmd;
	6'h02: wb_dout <= responseIn[31: 0];
	6'h03: wb_dout <= responseIn[63:32];
	6'h04: wb_dout <= responseIn[95:64];
	6'h05: wb_dout <= responseIn[119:96];
	6'h06: wb_dout <= sdc_dataTimeout;
	6'h07: wb_dout <= sdc_wideBus;
	6'h08: wb_dout <= sdc_cmdTimeout;
	6'h09: wb_dout <= sdc_clkdiv;
	6'h0a: wb_dout <= resetStatus;
	6'h0b: wb_dout <= 32'd3300;//Voltage
	6'h0c: wb_dout <= 32'h0;//Capabilities
	6'h0d: wb_dout <= cmdIntEvents;
	6'h0e: wb_dout <= cmdIntMask;
	6'h0f: wb_dout <= dataIntEvents;
	6'h10: wb_dout <= dataIntMask;
	6'h11: wb_dout <= sdc_blockSize;
	6'h12: wb_dout <= sdc_blockCount;
	6'h18: wb_dout <= sdc_dmaAddress;
	default: wb_dout <= 32'h0;
	endcase
	
	always @ (posedge clk)
	begin
		sdc_softReset <= regWe && wb_dm[0] && wb_din[0] && (wb_addr[7:2] == 6'h0a);
		sdc_cmdStart  <= regWe && (wb_addr[7:2] == 6'h00);
	end
	assign cmdIntClear   = regWe && (wb_addr[7:2] == 6'h0d);
	assign dataIntClear  = regWe && (wb_addr[7:2] == 6'h0f);
	
endmodule

module SDC_Reg #(
	parameter DW = 32,
	parameter INIT = 32'h0,
	parameter AW = 6,
	parameter ADDR = 6'h0
)(
	input clk, input rst, input [AW-1:0] addr,
	input we, input [DW-1:0] din, input [(DW-1)/8:0] dm,
	output reg [DW-1:0] dout = INIT
);
	
	wire write = we && (addr == ADDR);
	
	integer i;
	
	always @ (posedge clk)
	if(rst)
		dout <= INIT;
	else if(we && (addr == ADDR))
	begin
		for(i = 0; i < DW; i = i+1)
			if(dm[i/8]) dout[i] <= din[i];
	end
		
endmodule

module SDC_IntTrigger(
	input clk, input trigger, input reset, output reg out = 0
);
	reg trigger_reg = 0;
	always @ (posedge clk)
	if(reset)
		out <= 0;
	else if(trigger && !trigger_reg)
		out <= 1;
	
	always @ (posedge clk)
		trigger_reg <= trigger;

endmodule

/**
 * 1-byte to 4-byte upscaler on SD data receiving path.
 * Also combines data packets into a single stream.
 * 
 * @author Yunye Pu
 */
module SDC_RxUpscaler #(
	parameter BLKCNT_W = 16
)(
	input clk, input rst,
	output rx_finish,
	//Stream input
	input [7:0] rx_data_in, input rx_valid_in,
	input rx_last_in,
	//Transfer size
	input [BLKCNT_W-1:0] block_cnt,
	//Stream output
	output reg [31:0] rx_data_out,
	output reg rx_valid_out, output reg [3:0] rx_keep_out = 4'b0001
);
	
	reg [BLKCNT_W-1:0] block_counter = 0;
	reg [1:0] offset = 0;
	
	always @ (posedge clk)
	if(rst)
	begin
		offset <= 0;
		block_counter <= 0;
	end
	else if(rx_valid_in)
	begin
		offset <= offset + 1;
		if(rx_last_in)
		begin
			if(block_counter == block_cnt)
				block_counter <= 0;
			else
				block_counter <= block_counter + 1;
		end
	end

	always @ (posedge clk)
	if(rst)
		rx_valid_out <= 0;
	else
		rx_valid_out <= ((offset == 2'b11) | ((block_counter == block_cnt) & rx_last_in)) & rx_valid_in;
	
	always @ (posedge clk)
	if(rx_valid_in)
	case(offset)
	2'b00: begin rx_data_out[ 7: 0] <= rx_data_in; rx_keep_out <= 4'b0001; end
	2'b01: begin rx_data_out[15: 8] <= rx_data_in; rx_keep_out <= 4'b0011; end
	2'b10: begin rx_data_out[23:16] <= rx_data_in; rx_keep_out <= 4'b0111; end
	2'b11: begin rx_data_out[31:24] <= rx_data_in; rx_keep_out <= 4'b1111; end
	endcase
	
	assign rx_finish = (block_counter == block_cnt) & rx_valid_in & rx_last_in;
	
endmodule

/**
 * 4-byte to 1-byte downscaler on SD data transmitting path.
 * Also breaks data stream into packets(tx_last_out signal).
 * 
 * @author Yunye Pu
 */
module SDC_TxDownscaler #(
	parameter BLKSIZE_W = 12,
	parameter BLKCNT_W = 16
)(
	input clk, input rst,
	output tx_finish,
	//Stream input
	input [31:0] tx_data_in, input tx_valid_in,
	output tx_ready_in,
	//Transfer size
	input [BLKSIZE_W-1:0] block_size,
	input [BLKCNT_W-1:0] block_cnt,
	//Stream output
	output reg [7:0] tx_data_out, output tx_last_out,
	output tx_valid_out, input tx_ready_out
);
	reg [BLKSIZE_W-1:0] byte_counter = 0;
	reg [BLKCNT_W-1:0] block_counter = 0;
	
	reg [1:0] offset = 0;
	
	always @*
	case(offset)
	2'b00: tx_data_out <= tx_data_in[ 7: 0];
	2'b01: tx_data_out <= tx_data_in[15: 8];
	2'b10: tx_data_out <= tx_data_in[23:16];
	2'b11: tx_data_out <= tx_data_in[31:24];
	endcase
	
	assign tx_ready_in = tx_ready_out & (offset == 2'b11);
	assign tx_last_out = (byte_counter == block_size);
	assign tx_valid_out = tx_valid_in && !rst;
	
	always @ (posedge clk)
	if(rst)
	begin
		offset <= 0;
		byte_counter <= 0;
		block_counter <= 0;
	end
	else if(tx_ready_out)
	begin
		offset <= offset + 1;
		if(byte_counter == block_size)
		begin
			byte_counter <= 0;
			if(block_counter == block_cnt)
				block_counter <= 0;
			else
				block_counter <= block_counter + 1;
		end
		else
			byte_counter <= byte_counter + 1;
	end
	
	assign tx_finish = (byte_counter == block_size) & (block_counter == block_cnt) & tx_ready_out;
	
	
endmodule
