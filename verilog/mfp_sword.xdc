# Author: Jiang Zengkai
# Date: 2019.5.13

# Clock and reset
set_property -dict {PACKAGE_PIN AC18 IOSTANDARD LVDS} [get_ports CLK_200M_P]
set_property -dict {IOSTANDARD LVDS} [get_ports CLK_200M_N]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS18} [get_ports CPU_RESETN]

# Button
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {BTNY[4]}]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {BTNY[3]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {BTNY[2]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {BTNY[1]}]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {BTNY[0]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {BTNX[4]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {BTNX[3]}]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {BTNX[2]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {BTNX[1]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {BTNX[0]}]

# Switches
set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS15} [get_ports {SW[0]}]
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS15} [get_ports {SW[1]}]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS15} [get_ports {SW[2]}]
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS15} [get_ports {SW[3]}]
set_property -dict {PACKAGE_PIN Y13  IOSTANDARD LVCMOS15} [get_ports {SW[4]}]
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS15} [get_ports {SW[5]}]
set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVCMOS15} [get_ports {SW[6]}]
set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS15} [get_ports {SW[7]}]
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS15} [get_ports {SW[8]}]
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVCMOS15} [get_ports {SW[9]}]
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS15} [get_ports {SW[10]}]
set_property -dict {PACKAGE_PIN AE8  IOSTANDARD LVCMOS15} [get_ports {SW[11]}]
set_property -dict {PACKAGE_PIN AF8  IOSTANDARD LVCMOS15} [get_ports {SW[12]}]
set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVCMOS15} [get_ports {SW[13]}]
set_property -dict {PACKAGE_PIN AF13 IOSTANDARD LVCMOS15} [get_ports {SW[14]}]
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS15} [get_ports {SW[15]}]

# LEDs
set_property -dict {PACKAGE_PIN N26 IOSTANDARD LVCMOS33} [get_ports LED_CLK]
set_property -dict {PACKAGE_PIN M26 IOSTANDARD LVCMOS33} [get_ports LED_DAT]
set_property -dict {PACKAGE_PIN N24 IOSTANDARD LVCMOS33} [get_ports LED_CLR]
set_property -dict {PACKAGE_PIN R25 IOSTANDARD LVCMOS33} [get_ports LED_EN]

# 7-segment LEDs
set_property -dict {PACKAGE_PIN M24 IOSTANDARD LVCMOS33} [get_ports SEG_CLK]
set_property -dict {PACKAGE_PIN L24 IOSTANDARD LVCMOS33} [get_ports SEG_DAT]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports SEG_EN]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports SEG_CLR]

# LEDs on Arduino board
set_property -dict {PACKAGE_PIN AF24 IOSTANDARD LVCMOS33} [get_ports {ALED[0]}]
set_property -dict {PACKAGE_PIN AE21 IOSTANDARD LVCMOS33} [get_ports {ALED[1]}]
set_property -dict {PACKAGE_PIN Y22  IOSTANDARD LVCMOS33} [get_ports {ALED[2]}]
set_property -dict {PACKAGE_PIN Y23  IOSTANDARD LVCMOS33} [get_ports {ALED[3]}]
set_property -dict {PACKAGE_PIN AA23 IOSTANDARD LVCMOS33} [get_ports {ALED[4]}]
set_property -dict {PACKAGE_PIN Y25  IOSTANDARD LVCMOS33} [get_ports {ALED[5]}]
set_property -dict {PACKAGE_PIN AB26 IOSTANDARD LVCMOS33} [get_ports {ALED[6]}]
set_property -dict {PACKAGE_PIN W23  IOSTANDARD LVCMOS33} [get_ports {ALED[7]}]

# 7-segment LEDs on Arduino board
set_property -dict {PACKAGE_PIN AA22 IOSTANDARD LVCMOS33} [get_ports {SEG[7]}]
set_property -dict {PACKAGE_PIN AC23 IOSTANDARD LVCMOS33} [get_ports {SEG[6]}]
set_property -dict {PACKAGE_PIN AC24 IOSTANDARD LVCMOS33} [get_ports {SEG[5]}]
set_property -dict {PACKAGE_PIN W20  IOSTANDARD LVCMOS33} [get_ports {SEG[4]}]
set_property -dict {PACKAGE_PIN Y21  IOSTANDARD LVCMOS33} [get_ports {SEG[3]}]
set_property -dict {PACKAGE_PIN AD23 IOSTANDARD LVCMOS33} [get_ports {SEG[2]}]
set_property -dict {PACKAGE_PIN AD24 IOSTANDARD LVCMOS33} [get_ports {SEG[1]}]
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {SEG[0]}]
set_property -dict {PACKAGE_PIN AD21 IOSTANDARD LVCMOS33} [get_ports {AN[3]}]
set_property -dict {PACKAGE_PIN AC21 IOSTANDARD LVCMOS33} [get_ports {AN[2]}]
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports {AN[1]}]
set_property -dict {PACKAGE_PIN AC22 IOSTANDARD LVCMOS33} [get_ports {AN[0]}]

# Buzzer on Arduino board
set_property -dict {PACKAGE_PIN AF25 IOSTANDARD LVCMOS33} [get_ports {ABUZ}]

# 3 color LEDs
set_property -dict {PACKAGE_PIN V23 IOSTANDARD LVCMOS33} [get_ports {LED3[5]}]
set_property -dict {PACKAGE_PIN U25 IOSTANDARD LVCMOS33} [get_ports {LED3[4]}]
set_property -dict {PACKAGE_PIN U24 IOSTANDARD LVCMOS33} [get_ports {LED3[3]}]
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports {LED3[2]}]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS33} [get_ports {LED3[1]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports {LED3[0]}]

# UART
set_property -dict {PACKAGE_PIN L25 IOSTANDARD LVCMOS33 PULLUP true} [get_ports UART_TXD_IN]

# Pmod
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tck_in] 
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports {JB[1]}]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports {JB[2]}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {JB[3]}]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {JB[4]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {JB[7]}]
set_property PULLUP true [get_ports {JB[7]}]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports {JB[8]}]
set_property PULLUP true [get_ports {JB[8]}]
#set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS33} [get_ports {JB[9]}]
#set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {JB[10]}]

# VGA
set_property -dict {PACKAGE_PIN N21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_R[0]}]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_R[1]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_R[2]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_R[3]}]
set_property -dict {PACKAGE_PIN R22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_G[0]}]
set_property -dict {PACKAGE_PIN R23 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_G[1]}]
set_property -dict {PACKAGE_PIN T24 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_G[2]}]
set_property -dict {PACKAGE_PIN T25 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_G[3]}]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_B[0]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_B[1]}]
set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_B[2]}]
set_property -dict {PACKAGE_PIN T23 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_B[3]}]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports VGA_VS]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports VGA_HS]

# SRAM
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[0]}]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[1]}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[2]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[3]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[4]}]
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[5]}]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[6]}]
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[7]}]
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[8]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[9]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[10]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[11]}]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[12]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[13]}]
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[14]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[15]}]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[16]}]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[17]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[18]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_ADDR[19]}]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_CE_N[0]}]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_CE_N[1]}]
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_CE_N[2]}]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[0]}]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[1]}]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[2]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[3]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[4]}]
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[5]}]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[6]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[7]}]
set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[8]}]
set_property -dict {PACKAGE_PIN H23 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[9]}]
set_property -dict {PACKAGE_PIN H21 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[10]}]
set_property -dict {PACKAGE_PIN J26 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[11]}]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[12]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[13]}]
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[14]}]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[15]}]
set_property -dict {PACKAGE_PIN B26 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[16]}]
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[17]}]
set_property -dict {PACKAGE_PIN A24 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[18]}]
set_property -dict {PACKAGE_PIN A23 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[19]}]
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[20]}]
set_property -dict {PACKAGE_PIN E23 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[21]}]
set_property -dict {PACKAGE_PIN C24 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[22]}]
set_property -dict {PACKAGE_PIN D23 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[23]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[24]}]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[25]}]
set_property -dict {PACKAGE_PIN C21 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[26]}]
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[27]}]
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[28]}]
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[29]}]
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[30]}]
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[31]}]
set_property -dict {PACKAGE_PIN H24 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[32]}]
set_property -dict {PACKAGE_PIN E26 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[33]}]
set_property -dict {PACKAGE_PIN G25 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[34]}]
set_property -dict {PACKAGE_PIN F24 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[35]}]
set_property -dict {PACKAGE_PIN F25 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[36]}]
set_property -dict {PACKAGE_PIN G24 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[37]}]
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[38]}]
set_property -dict {PACKAGE_PIN G26 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[39]}]
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[40]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[41]}]
set_property -dict {PACKAGE_PIN C26 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[42]}]
set_property -dict {PACKAGE_PIN D24 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[43]}]
set_property -dict {PACKAGE_PIN E25 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[44]}]
set_property -dict {PACKAGE_PIN F23 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[45]}]
set_property -dict {PACKAGE_PIN D25 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[46]}]
set_property -dict {PACKAGE_PIN D26 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_DATA[47]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_OE_N[0]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_OE_N[1]}]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_OE_N[2]}]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_WE_N[0]}]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_WE_N[1]}]
set_property -dict {PACKAGE_PIN P23 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_WE_N[2]}]
set_property -dict {PACKAGE_PIN R26 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_UB_N[0]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_UB_N[1]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_UB_N[2]}]
set_property -dict {PACKAGE_PIN K26 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_LB_N[0]}]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_LB_N[1]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 4} [get_ports {SRAM_LB_N[2]}]

# SD card
set_property -dict {PACKAGE_PIN AF23 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports SD_CLK]
set_property -dict {PACKAGE_PIN AD25 IOSTANDARD LVCMOS33 SLEW FAST PULLUP true} [get_ports SD_CMD]
set_property -dict {PACKAGE_PIN AE25 IOSTANDARD LVCMOS33 SLEW FAST PULLUP true} [get_ports {SD_DAT[0]}]
set_property -dict {PACKAGE_PIN AE22 IOSTANDARD LVCMOS33 SLEW FAST PULLUP true} [get_ports {SD_DAT[1]}]
set_property -dict {PACKAGE_PIN AF22 IOSTANDARD LVCMOS33 SLEW FAST PULLUP true} [get_ports {SD_DAT[2]}]
set_property -dict {PACKAGE_PIN Y20  IOSTANDARD LVCMOS33 SLEW FAST PULLUP true} [get_ports {SD_DAT[3]}]
set_property -dict {PACKAGE_PIN AE26 IOSTANDARD LVCMOS33} [get_ports SD_CD]
set_property -dict {PACKAGE_PIN AE23 IOSTANDARD LVCMOS33} [get_ports SD_RST]
