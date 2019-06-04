// mfp_ahb.v
// 
// January 1, 2017
//
// AHB-lite bus module with 3 slaves: boot RAM, program RAM, and
// GPIO (memory-mapped I/O: switches and LEDs from the FPGA board).
// The module includes an address decoder and multiplexer (for 
// selecting which slave module produces HRDATA).

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

// I/O
    input                           IO_CLK,
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
    output                          IO_VGA_HS,
    output                          IO_VGA_VS,
    output [`MFP_N_VGA_R-1      :0] IO_VGA_R,
    output [`MFP_N_VGA_G-1      :0] IO_VGA_G,
    output [`MFP_N_VGA_B-1      :0] IO_VGA_B,
    output [`MFP_N_SRAM_ADDR-1  :0] IO_SRAM_ADDR,
    inout  [`MFP_N_SRAM_DATA-1  :0] IO_SRAM_DATA,
    output [`MFP_N_SRAM_CE-1    :0] IO_SRAM_CE_N,
    output [`MFP_N_SRAM_OE-1    :0] IO_SRAM_OE_N,
    output [`MFP_N_SRAM_WE-1    :0] IO_SRAM_WE_N,
    output [`MFP_N_SRAM_UB-1    :0] IO_SRAM_UB_N,
    output [`MFP_N_SRAM_LB-1    :0] IO_SRAM_LB_N,
    inout  [`MFP_N_SD_DAT-1     :0] IO_SD_DAT,
    inout                           IO_SD_CMD,
    output                          IO_SD_CLK,
    output                          IO_SD_RST,
    input                           IO_SD_CD,
    input                           IO_PS2_CLK,
    input                           IO_PS2_DAT,

    output [`MFP_AHB_N_INT-1    :0] IO_INT
);


  wire [31:0] HRDATA5, HRDATA4, HRDATA3, HRDATA2, HRDATA1, HRDATA0;
  wire [ 6:0] HSEL;
  reg  [ 6:0] HSEL_d;

  assign HREADY = 1;
  assign HRESP = 0;
	
  // Delay select signal to align for reading data
  always @(posedge HCLK)
    HSEL_d <= HSEL;

  wire [`MFP_AHB_N_CLK-1:0] IO_CLK_DIV;
  clk_div mfp_ahb_clk_div(.clk(IO_CLK), .clk_div(IO_CLK_DIV));

  // Module 0 - boot ram
  mfp_ahb_b_ram mfp_ahb_b_ram(HCLK, HRESETn, HADDR, HBURST, HMASTLOCK, HPROT, HSIZE,
                              HTRANS, HWDATA, HWRITE, HRDATA0, HSEL[0]);
  // Module 1 - program ram
  mfp_ahb_p_ram mfp_ahb_p_ram(HCLK, HRESETn, HADDR, HBURST, HMASTLOCK, HPROT, HSIZE,
                              HTRANS, HWDATA, HWRITE, HRDATA1, HSEL[1]);
  // Module 2 - GPIO
  mfp_ahb_gpio mfp_ahb_gpio(HCLK, HRESETn, HADDR[5:2], HBURST, HMASTLOCK, HPROT, HSIZE,
                            HTRANS, HWDATA, HWRITE, HRDATA2, HSEL[2], 
                            IO_CLK_DIV, IO_SW, IO_BTNX, IO_BTNY,
                            IO_LED_CLK, IO_LED_DAT, IO_LED_EN, IO_LED_CLRN,
                            IO_SEG_CLK, IO_SEG_DAT, IO_SEG_EN, IO_SEG_CLRN, IO_LED3,
                            IO_ARDUINO_LED, IO_ARDUINO_AN, IO_ARDUINO_SEG, IO_ARDUINO_BUZ,
                            IO_PS2_CLK, IO_PS2_DAT, IO_INT);
  
  // Module 3 - VRAM
  wire [9:0] h_addr;
  wire [8:0] v_addr;
  wire [18:0] vga_addr = v_addr * 'd640 + h_addr;
  wire [11:0] vga_data;
  vram mfp_ahb_vram(HCLK, HRESETn, HADDR, HTRANS, HWDATA[11:0], HWRITE, HSEL[3], 
                    HRDATA3, IO_CLK_DIV[1], vga_addr, vga_data);
  vga mfp_ahb_vga(.clk(IO_CLK_DIV[1]), .clr(~HRESETn), .rgb(vga_data), .h_addr(h_addr), .v_addr(v_addr),
                  .read(), .VGA_HS(IO_VGA_HS), .VGA_VS(IO_VGA_VS),
                  .VGA_R(IO_VGA_R), .VGA_G(IO_VGA_G), .VGA_B(IO_VGA_B));
  
  // Module 4 - SRAM
  sram mfp_ahb_sram(HCLK, HRESETn, HADDR, HBURST, HMASTLOCK, HPROT, HSIZE,
                    HTRANS, HWDATA, HWRITE, HRDATA4, HSEL[4], IO_SRAM_DATA,
                    IO_SRAM_ADDR, IO_SRAM_CE_N, IO_SRAM_WE_N, IO_SRAM_OE_N,
                    IO_SRAM_UB_N, IO_SRAM_LB_N);
    
  // Module 5 - SD card
  SDWrapper mfp_ahb_sd(.clkCPU(HCLK), .clkSD(IO_CLK), .globlRst(~HRESETn), .HTRANS(HTRANS),
                       .HBURST(HBURST), .HSIZE(HSIZE), .HWRITE(HWRITE),
                       .dataInBus(HWDATA), .HADDR(HADDR), .HSEL(HSEL[6:5]), .dataOut(HRDATA5), .sd_int(),
                       .sd_dat(IO_SD_DAT), .sd_cmd(IO_SD_CMD), .sd_clk(IO_SD_CLK), .sd_rst(IO_SD_RST), .sd_cd(IO_SD_CD));

  ahb_decoder ahb_decoder(HADDR, HSEL);
  ahb_mux ahb_mux(HCLK, HSEL_d, HRDATA5, HRDATA5, HRDATA4, HRDATA3, HRDATA2, HRDATA1, HRDATA0, HRDATA);

endmodule


module ahb_decoder
(
    input  [31:0] HADDR,
    output [ 6:0] HSEL
);

  // Decode based on most significant bits of the address
  assign HSEL[0] = (HADDR[31:22] == `H_RAM_RESET_ADDR_Match); // 1 KB RAM at 0xbfc00000 (physical: 0x1fc00000)
  assign HSEL[1] = (HADDR[31:28] == `H_RAM_ADDR_Match);       // 256 KB RAM at 0x80000000 (physical: 0x00000000)
  assign HSEL[2] = (HADDR[31:22] == `H_LED_ADDR_Match);       // GPIO at 0xbf800000 (physical: 0x1f800000)
  assign HSEL[3] = (HADDR[31:22] == `H_VRAM_ADDR_Match);      // VRAM at 0xbf400000 (physical: 0x1f400000)
  assign HSEL[4] = (HADDR[31:28] == `H_SRAM_ADDR_Match);      // SRAM at physical 0x20000000
  assign HSEL[5] = (HADDR[31:12] == `H_SD_BUF_ADDR_Match);    // SD card buffer at physical 0x1f000000
  assign HSEL[6] = (HADDR[31:12] == `H_SD_CTRL_ADDR_Match);   // SD card control registers at physical 0x1f001000

endmodule


module ahb_mux
(
    input             HCLK,
    input      [ 6:0] HSEL,
    input      [31:0] HRDATA6, HRDATA5, HRDATA4, HRDATA3, HRDATA2, HRDATA1, HRDATA0,
    output reg [31:0] HRDATA
);

    always @(*)
      casez (HSEL)
	      7'b??????1: HRDATA = HRDATA0;
	      7'b?????10: HRDATA = HRDATA1;
	      7'b????100: HRDATA = HRDATA2;
          7'b???1000: HRDATA = HRDATA3;
          7'b??10000: HRDATA = HRDATA4;
          7'b?100000: HRDATA = HRDATA5;
          7'b1000000: HRDATA = HRDATA6;
	      default:    HRDATA = HRDATA1;
      endcase

endmodule
