// mfp_ahb_gpio.v
//
// General-purpose I/O module for Altera's DE2-115 and 
// Digilent's (Xilinx) Nexys4-DDR board

// Modified by Zengkai Jiang
// Date: 2019.3.28

`include "mfp_ahb_const.vh"

module mfp_ahb_gpio(
    input                        HCLK,
    input                        HRESETn,
    input      [  3          :0] HADDR,
    input      [  1          :0] HTRANS,
    input      [ 31          :0] HWDATA,
    input                        HWRITE,
    input                        HSEL,
    output reg [ 31          :0] HRDATA,

// memory-mapped I/O
    input      [`MFP_N_SW-1    :0] IO_Switch,
    input      [`MFP_N_PB-1    :0] IO_PB,
    output reg [`MFP_N_LED-1   :0] IO_LED,
    output reg [`MFP_N_7SEG-1  :0] IO_7SEG,
    output reg [`MFP_N_7SEGE-1 :0] IO_7SEGE,
    output reg [`MFP_N_ALED-1  :0] IO_ALED,
    output reg [`MFP_N_A7SEG-1 :0] IO_A7SEG,
    output reg [`MFP_N_A7SEGE-1:0] IO_A7SEGE,
    output reg [`MFP_N_ABUZ-1  :0] IO_ABUZ,
    output reg [`MFP_N_3LED-1  :0] IO_3LED,
    input      [`MFP_N_MILLIS-1:0] IO_MILLIS
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

    // write
    always @(posedge HCLK or negedge HRESETn)
       if (~HRESETn) begin
         IO_LED <= `MFP_N_LED'b0;
         IO_7SEG <= `MFP_N_7SEG'b0;
         IO_7SEGE <= `MFP_N_7SEGE'b0;
         IO_ALED <= `MFP_N_ALED'b0;
         IO_A7SEG <= `MFP_N_A7SEG'b0;
         IO_A7SEGE <= `MFP_N_A7SEGE'b0;
         IO_ABUZ <= `MFP_N_ABUZ'b0;
         IO_3LED <= `MFP_N_3LED'b0;
       end else if (we)
         case (HADDR_d)
           `H_LED_IONUM: IO_LED <= HWDATA[`MFP_N_LED-1:0];
           `H_7SEG_IONUM: IO_7SEG <= HWDATA[`MFP_N_7SEG-1:0];
           `H_7SEGE_IONUM: IO_7SEGE <= HWDATA[`MFP_N_7SEGE-1:0];
           `H_ALED_IONUM: IO_ALED <= HWDATA[`MFP_N_ALED-1:0];
           `H_A7SEG_IONUM: IO_A7SEG <= HWDATA[`MFP_N_A7SEG-1:0];
           `H_A7SEGE_IONUM: IO_A7SEGE <= HWDATA[`MFP_N_A7SEGE-1:0];
           `H_ABUZ_IONUM: IO_ABUZ <= HWDATA[`MFP_N_ABUZ-1:0];
           `H_3LED_IONUM: IO_3LED <= HWDATA[`MFP_N_3LED-1:0];
         endcase
    
    // read
	always @(posedge HCLK or negedge HRESETn)
       if (~HRESETn)
         HRDATA <= 32'h0;
       else
	     case (HADDR)
           `H_SW_IONUM: HRDATA <= { {32 - `MFP_N_SW {1'b0}}, IO_Switch };
           `H_PB_IONUM: HRDATA <= { {32 - `MFP_N_PB {1'b0}}, IO_PB };
           `H_LED_IONUM: HRDATA <= { {32 - `MFP_N_LED {1'b0}}, IO_LED };
           `H_7SEG_IONUM: HRDATA <= { {32 - `MFP_N_7SEG {1'b0}}, IO_7SEG };
           `H_7SEGE_IONUM: HRDATA <= { {32 - `MFP_N_7SEGE {1'b0}}, IO_7SEGE };
           `H_ALED_IONUM: HRDATA <= { {32 - `MFP_N_ALED {1'b0}}, IO_ALED };
           `H_A7SEG_IONUM: HRDATA <= { {32 - `MFP_N_A7SEG {1'b0}}, IO_A7SEG };
           `H_A7SEGE_IONUM: HRDATA <= { {32 - `MFP_N_A7SEGE {1'b0}}, IO_A7SEGE };
           `H_ABUZ_IONUM: HRDATA <= { {32 - `MFP_N_ABUZ {1'b0}}, IO_ABUZ };
           `H_3LED_IONUM: HRDATA <= { {32 - `MFP_N_3LED {1'b0}}, IO_3LED };
           `H_MILLIS_IONUM: HRDATA <= { {32 - `MFP_N_MILLIS {1'b0}}, IO_MILLIS };
         endcase
		 
endmodule

