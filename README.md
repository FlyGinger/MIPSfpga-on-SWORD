# MIPSfpga-on-SWORD

该工程目的为把Imagination Technologies公司的开源项目MIPSfpga移植到浙江大学的硬件平台SWORD上.

开发思路为跟随MIPSfpga官方教学实验, 为MIPSfpga裸核一步步添加外设.



# Known Bugs List

### #1 板载LED灯显示不正常

板载LED灯使用一个接收串行数据的单片机驱动.

不知何故, `LED[15]`常亮, 处于半亮半暗状态, 但不闪烁.
