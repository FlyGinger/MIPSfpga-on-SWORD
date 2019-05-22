// Author: Jiang Zengkai
// Date: 2019.5.13

#include <mips/cpu.h>
#include <mips/m32c0.h>

#ifndef MFP_MEMORY_MAPPED_REGISTERS_H
#define MFP_MEMORY_MAPPED_REGISTERS_H

#define MFP_LEDS_ADDR 0xBF800000
#define MFP_SWITCHES_ADDR 0xBF800004
#define MFP_BUTTONS_ADDR 0xBF800008
#define MFP_7SEGLED_ADDR 0xBF80000C
#define MFP_7SEGLEDEX_ADDR 0xBF800010
#define MFP_ALEDS_ADDR 0xBF800014
#define MFP_A7SEGLED_ADDR 0xBF800018
#define MFP_ABUZ_ADDR 0xBF80001C
#define MFP_3LED_ADDR 0xBF800020
#define MFP_PS2_CTRL_ADDR 0xBF800024
#define MFP_PS2_DATA_ADDR 0xBF800028
#define MFP_VGA_ADDR 0xBF400000

#define MFP_LEDS (*(volatile unsigned *)MFP_LEDS_ADDR)
#define MFP_SWITCHES (*(volatile unsigned *)MFP_SWITCHES_ADDR)
#define MFP_BUTTONS (*(volatile unsigned *)MFP_BUTTONS_ADDR)
#define MFP_7SEGLED (*(volatile unsigned *)MFP_7SEGLED_ADDR)
#define MFP_7SEGLEDEX (*(volatile unsigned *)MFP_7SEGLEDEX_ADDR)
#define MFP_ALEDS (*(volatile unsigned *)MFP_ALEDS_ADDR)
#define MFP_A7SEGLED (*(volatile unsigned *)MFP_A7SEGLED_ADDR)
#define MFP_ABUZ (*(volatile unsigned *)MFP_ABUZ_ADDR)
#define MFP_3LED (*(volatile unsigned *)MFP_3LED_ADDR)
#define MFP_PS2_CTRL (*(volatile unsigned *)MFP_PS2_CTRL_ADDR)
#define MFP_PS2_DATA (*(volatile unsigned *)MFP_PS2_DATA_ADDR)

// This define is used in boot.S code

#define BOARD_16_LEDS_ADDR MFP_LEDS_ADDR

// 7 segment LED
void set_seg7led(unsigned int data);
void set_seg7led_arduino(unsigned int data);
void set_seg7led_pixel(unsigned int high, unsigned int low);
void set_seg7led_arduino_pixel(unsigned int data);

// SD card
#define SECSIZE 512
static volatile unsigned int *const SD_CTRL = (unsigned int *)0xBF001000;
static volatile unsigned int *const SD_BUF = (unsigned int *)0xBF000000;
unsigned long sd_read_block(unsigned char *buf, unsigned long addr,
                           unsigned long count);
unsigned long sd_write_block(unsigned char *buf, unsigned long addr,
                            unsigned long count);

#endif
