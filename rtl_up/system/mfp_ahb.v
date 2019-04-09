// mfp_ahb.v
// 
// January 1, 2017
//
// AHB-lite bus module with 3 slaves: boot RAM, program RAM, and
// GPIO (memory-mapped I/O: switches and LEDs from the FPGA board).
// The module includes an address decoder and multiplexer (for 
// selecting which slave module produces HRDATA).

// Modified by Zengkai Jiang
// Date: 2019.4.9

`include "mfp_ahb_const.vh"


module mfp_ahb
(
    input                       HCLK,
    input                       HRESETn,
    input      [ 31         :0] HADDR,
    input      [  2         :0] HBURST,
    input                       HMASTLOCK,
    input      [  3         :0] HPROT,
    input      [  2         :0] HSIZE,
    input      [  1         :0] HTRANS,
    input      [ 31         :0] HWDATA,
    input                       HWRITE,
    output     [ 31         :0] HRDATA,
    output                      HREADY,
    output                      HRESP,
    input                       SI_Endian,

// memory-mapped I/O
    input      [`MFP_N_SW-1 :0] IO_Switch,
    input      [`MFP_N_PB-1 :0] IO_PB,
    output     [`MFP_N_LED-1:0] IO_LED,
    output     [`MFP_N_7SEG-1:0] IO_7SEG,
    output     [`MFP_N_7SEGE-1 :0] IO_7SEGE,
    output     [`MFP_N_ALED-1  :0] IO_ALED,
    output     [`MFP_N_A7SEG-1 :0] IO_A7SEG,
    output     [`MFP_N_A7SEGE-1:0] IO_A7SEGE,
    output     [`MFP_N_ABUZ-1  :0] IO_ABUZ,
    output     [`MFP_N_3LED-1  :0] IO_3LED,
    input      [18             :0] IO_VGA_ADDR,
    output     [11             :0] IO_VGA_DATA
);

  // millisecond counter
  wire [31:0] millis;
  mfp_ahb_millis_counter mfp_ahb_millis_counter(
    .clk(HCLK), .rstn(HRESETn), .millis(millis));

  wire [31:0] HRDATA2, HRDATA1, HRDATA0;
  wire [11:0] HRDATA3;
  wire [ 3:0] HSEL;
  reg  [ 3:0] HSEL_d;

  assign HREADY = 1;
  assign HRESP = 0;
	
  // Delay select signal to align for reading data
  always @(posedge HCLK)
    HSEL_d <= HSEL;

  // Module 0 - boot ram
  mfp_ahb_b_ram mfp_ahb_b_ram(HCLK, HRESETn, HADDR, HBURST, HMASTLOCK, HPROT, HSIZE,
                              HTRANS, HWDATA, HWRITE, HRDATA0, HSEL[0]);
  // Module 1 - program ram
  mfp_ahb_p_ram mfp_ahb_p_ram(HCLK, HRESETn, HADDR, HBURST, HMASTLOCK, HPROT, HSIZE,
                              HTRANS, HWDATA, HWRITE, HRDATA1, HSEL[1]);
  // Module 2 - GPIO
  mfp_ahb_gpio mfp_ahb_gpio(HCLK, HRESETn, HADDR[5:2], HTRANS, HWDATA, HWRITE, HSEL[2], 
                            HRDATA2, IO_Switch, IO_PB, IO_LED, IO_7SEG, IO_7SEGE,
                            IO_ALED, IO_A7SEG, IO_A7SEGE, IO_ABUZ, IO_3LED, millis);
  
  // Module 3 - VRAM
  mfp_ahb_v_ram mfp_ahb_v_ram(HCLK, HRESETn, HADDR[20:2], HTRANS, HWDATA[11:0], HWRITE, HSEL[3], 
                            HRDATA3, IO_VGA_ADDR, IO_VGA_DATA);
  
  ahb_decoder ahb_decoder(HADDR, HSEL);
  ahb_mux ahb_mux(HCLK, HSEL_d, HRDATA3, HRDATA2, HRDATA1, HRDATA0, HRDATA);

endmodule


module ahb_decoder
(
    input  [31:0] HADDR,
    output [ 3:0] HSEL
);

  // Decode based on most significant bits of the address
  assign HSEL[0] = (HADDR[28:22] == `H_RAM_RESET_ADDR_Match); // 128 KB RAM  at 0xbfc00000 (physical: 0x1fc00000)
  assign HSEL[1] = (HADDR[28]    == `H_RAM_ADDR_Match);       // 256 KB RAM at 0x80000000 (physical: 0x00000000)
  assign HSEL[2] = (HADDR[28:22] == `H_LED_ADDR_Match);       // GPIO at 0xbf800000 (physical: 0x1f800000)
  assign HSEL[3] = (HADDR[28:22] == `H_RAM_V_ADDR_Match);     // VRAM at 0xbf400000 (physical: 0x1f400000)
endmodule


module ahb_mux
(
    input             HCLK,
    input      [ 3:0] HSEL,
    input      [11:0] HRDATA3,
    input      [31:0] HRDATA2, HRDATA1, HRDATA0,
    output reg [31:0] HRDATA
);

    always @(*)
      casez (HSEL)
	      4'b???1: HRDATA = HRDATA0;
	      4'b??10: HRDATA = HRDATA1;
	      4'b?100: HRDATA = HRDATA2;
	      4'b1000: HRDATA = {20'b0, HRDATA3};
	      default: HRDATA = HRDATA1;
      endcase
endmodule

module mfp_ahb_millis_counter(
    input wire clk,
    input wire rstn,
    output reg [31:0] millis);
    
    reg [13:0] counter;
    always @ (posedge clk) begin
        if (~rstn) begin
            counter <= 0;
            millis <= 0;
        end
        else begin
            if (counter == 'd12500) begin
                counter <= 0;
                millis <= millis + 1;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
