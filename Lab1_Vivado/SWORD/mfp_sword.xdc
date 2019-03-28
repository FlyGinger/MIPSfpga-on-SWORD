# Author: Jiang Zengkai
# Date: 2019.3.28

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
set_property -dict {PACKAGE_PIN N24 IOSTANDARD LVCMOS33} [get_ports LED_EN]
set_property -dict {PACKAGE_PIN R25 IOSTANDARD LVCMOS33} [get_ports LED_CLR]

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
