// mfp_ahb_gpio.v
//
// General-purpose I/O module for Altera's DE2-115 and 
// Digilent's (Xilinx) Nexys4-DDR board


`include "mfp_ahb_const.vh"

module mfp_ahb_gpio(
    input                        HCLK,
    input                        HRESETn,
    input      [  3          :0] HADDR,
    input      [  2          :0] HBURST,
    input                        HMASTLOCK,
    input      [  3          :0] HPROT,
    input      [  2          :0] HSIZE,
    input      [  1          :0] HTRANS,
    input      [ 31          :0] HWDATA,
    input                        HWRITE,
    output reg [ 31          :0] HRDATA,
    input                        HSEL,

// memory-mapped I/O
    input  [`MFP_AHB_N_CLK-1    :0] IO_CLK,
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
    input                           IO_PS2_CLK,
    input                           IO_PS2_DAT,

    output [`MFP_AHB_N_INT-1    :0] IO_INT
);

  reg  [3:0]  HADDR_d;
  reg         HWRITE_d;
  reg         HSEL_d;
  reg  [1:0]  HTRANS_d;
  wire        we;            // write enable

  // delay HADDR, HWRITE, HSEL, and HTRANS to align with HWDATA for writing
  always @ (posedge HCLK) 
  begin
    HADDR_d  <= HADDR;
	HWRITE_d <= HWRITE;
	HSEL_d   <= HSEL;
	HTRANS_d <= HTRANS;
  end
  
  // overall write enable signal
  assign we = (HTRANS_d != `HTRANS_IDLE) & HSEL_d & HWRITE_d;

  reg [`MFP_AHB_N_BTN-1:0] buf_btn;
  reg [`MFP_AHB_N_LED-1:0] buf_led;
  reg [`MFP_AHB_N_SEG-1:0] buf_seg;
  reg [`MFP_AHB_N_SEGEX-1:0] buf_segex;
  reg [`MFP_AHB_N_LED3-1:0] buf_led3;
  reg [`MFP_AHB_N_ARDUINO_LED-1:0] buf_arduino_led;
  reg [`MFP_AHB_N_ARDUINO_SEG-1:0] buf_arduino_seg;
  reg [`MFP_AHB_N_ARDUINO_BUZ-1:0] buf_arduino_buz;
  reg [`MFP_AHB_N_PS2-1:0] buf_ps2;

  reg int_btn;
  reg int_ps2;
  assign IO_INT = {int_ps2, int_btn};

  // buttons
  wire [`MFP_AHB_N_BTN-1:0] btn;
  button mfp_ahb_gpio_btn(.clk(IO_CLK[16]), .btny(IO_BTNY), .btnx(IO_BTNX), .btn(btn));
  reg [1:0] sample_btn;
  always @ (posedge HCLK)
    sample_btn <= {sample_btn[0], |btn};
  always @ (posedge HCLK) begin
    if (int_btn && we && (HADDR_d == `H_BTN_CTRL_IONUM)) int_btn <= HWDATA[0];
    else if (~int_btn && (sample_btn == 2'b01)) begin
      int_btn <= 1'b1;
      buf_btn <= btn;
    end
  end

  // LED
  p2s mfp_ahb_gpio_led(.clk(IO_CLK[0]), .sync(IO_CLK[21]), .data(buf_led),
                       .sclk(IO_LED_CLK), .sclrn(IO_LED_CLRN),
                       .sout(IO_LED_DAT), .sen(IO_LED_EN));
  
  // 7-segment LED
  p2s#(.WIDTH(64)) mfp_ahb_gpio_seg(.clk(IO_CLK[0]), .sync(IO_CLK[21]), .data({buf_segex, buf_seg}),
                                    .sclk(IO_SEG_CLK), .sclrn(IO_SEG_CLRN), .sout(IO_SEG_DAT), .sen(IO_SEG_EN));

  // 3-color LED
  assign IO_LED3 = buf_led3;
  
  // arduino LED
  assign IO_ARDUINO_LED = buf_arduino_led;

  // 7-segment LED
  seg7 mfp_ahb_gpio_seg_arduino(.clk(IO_CLK[0]), .flash(IO_CLK[26]), .scan(IO_CLK[20:19]),
                                .data(buf_arduino_seg), .an(IO_ARDUINO_AN), .seg(IO_ARDUINO_SEG));
  
  // arduino buzzer
  buzzer mfp_ahb_gpio_buz(.clk(IO_CLK[0]), .rst(~HRESETn),
                          .halflen(buf_arduino_buz), .buzzer(IO_ARDUINO_BUZ));
  
  // ps2 keyboard
  wire [`MFP_AHB_N_PS2-1:0] ps2;
  wire ready;
  always @ (posedge HCLK) begin
    if (int_ps2 && we && (HADDR_d == `H_PS2_CTRL_IONUM)) int_ps2 <= HWDATA[0];
    else if (~int_ps2 && ready) begin
      int_ps2 <= 1'b1;
      buf_ps2 <= ps2;
    end
  end
  reg [1:0] sample_ps2;
  always @ (posedge IO_CLK[0])
    sample_ps2 <= {sample_ps2[0], int_ps2};
  wire read = (sample_ps2 == 2'b01);
  ps2_keyboard mfp_ahb_gpio_ps2(.clk(IO_CLK[0]), .clrn(HRESETn),
                                .ps2_clk(IO_PS2_CLK), .ps2_data(IO_PS2_DAT),
                                .rdn(~read), .data(ps2), .ready(ready), .overflow());

    // read
  	always @(posedge HCLK or negedge HRESETn)
       if (~HRESETn)
         HRDATA <= 32'h0;
       else
	     case (HADDR)
           `H_SW_IONUM: HRDATA <= { {32 - `MFP_N_SW {1'b0}}, IO_SW };
           `H_BTN_DATA_IONUM: HRDATA <= { {32 - `MFP_AHB_N_BTN {1'b0}}, buf_btn };
           `H_LED_IONUM: HRDATA <= { {32 - `MFP_AHB_N_LED {1'b0}}, buf_led };
           `H_SEG_IONUM: HRDATA <= { {32 - `MFP_AHB_N_SEG {1'b0}}, buf_seg };
           `H_SEGEX_IONUM: HRDATA <= { {32 - `MFP_AHB_N_SEGEX {1'b0}}, buf_segex };
           `H_LED3_IONUM: HRDATA <= { {32 - `MFP_AHB_N_LED3 {1'b0}}, buf_led3 };
           `H_ARDUINO_LED_IONUM: HRDATA <= { {32 - `MFP_AHB_N_ARDUINO_LED {1'b0}}, buf_arduino_led };
           `H_ARDUINO_SEG_IONUM: HRDATA <= { {32 - `MFP_AHB_N_ARDUINO_SEG {1'b0}}, buf_arduino_seg };
           `H_ARDUINO_BUZ_IONUM: HRDATA <= { {32 - `MFP_AHB_N_ARDUINO_BUZ {1'b0}}, buf_arduino_buz };
           `H_PS2_DATA_IONUM: HRDATA <= { {32 - `MFP_AHB_N_PS2 {1'b0}}, buf_ps2 };
           default: HRDATA <= 32'h0;
         endcase

    // write
    always @(posedge HCLK or negedge HRESETn)
       if (~HRESETn) begin
         buf_led <= `MFP_AHB_N_LED'b0;
         buf_seg <= `MFP_AHB_N_SEG'b0;
         buf_segex <= `MFP_AHB_N_SEGEX'b0;
         buf_led3 <= `MFP_AHB_N_LED3'b0;
         buf_arduino_led <= `MFP_AHB_N_ARDUINO_LED'b0;
         buf_arduino_seg <= `MFP_AHB_N_ARDUINO_SEG'b0;
         buf_arduino_buz <= `MFP_AHB_N_ARDUINO_BUZ'b0;
       end else if (we)
         case (HADDR_d)
           `H_LED_IONUM: buf_led <= HWDATA[`MFP_AHB_N_LED-1:0];
           `H_SEG_IONUM: buf_seg <= HWDATA[`MFP_AHB_N_SEG-1:0];
           `H_SEGEX_IONUM: buf_segex <= HWDATA[`MFP_AHB_N_SEGEX-1:0];
           `H_LED3_IONUM: buf_led3 <= HWDATA[`MFP_AHB_N_LED3-1:0];
           `H_ARDUINO_LED_IONUM: buf_arduino_led <= HWDATA[`MFP_AHB_N_ARDUINO_LED-1:0];
           `H_ARDUINO_SEG_IONUM: buf_arduino_seg <= HWDATA[`MFP_AHB_N_ARDUINO_SEG-1:0];
           `H_ARDUINO_BUZ_IONUM: buf_arduino_buz <= HWDATA[`MFP_AHB_N_ARDUINO_BUZ-1:0];
         endcase
		 
endmodule
