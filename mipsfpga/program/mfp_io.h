#include <mips/cpu.h>
#include <mips/m32c0.h>

#ifndef MFP_IO_H
#define MFP_IO_H

#define MFP_SWITCHES_ADDR 0xBF800000
#define MFP_BUTTONS_CTRL_ADDR 0xBF800004
#define MFP_BUTTONS_DATA_ADDR 0xBF800008
#define MFP_LEDS_ADDR 0xBF80000C
#define MFP_7SEGLED_ADDR 0xBF800010
#define MFP_7SEGLEDEX_ADDR 0xBF800014
#define MFP_3LEDS_ADDR 0xBF800018
#define MFP_ARDUINO_LEDS_ADDR 0xBF80001C
#define MFP_ARDUINO_SEG_ADDR 0xBF800020
#define MFP_ARDUINO_BUZ_ADDR 0xBF800024
#define MFP_PS2_CTRL_ADDR 0xBF800028
#define MFP_PS2_DATA_ADDR 0xBF80002C
#define MFP_VGA_ADDR 0xBF400000
#define MFP_VGA_CHAR_ADDR 0xBF500000
#define MFP_VGA_ASCII_ADDR 0xBF600000
#define MFP_SRAM_ADDR 0x00000000
#define MFP_SD_CTRL_ADDR 0xBF001000
#define MFP_SD_BUF_ADDR 0xBF000000

#define MFP_SWITCHES (*(volatile unsigned *)MFP_SWITCHES_ADDR)
#define MFP_BUTTONS_CTRL (*(volatile unsigned *)MFP_BUTTONS_CTRL_ADDR)
#define MFP_BUTTONS_DATA (*(volatile unsigned *)MFP_BUTTONS_DATA_ADDR)
#define MFP_LEDS (*(volatile unsigned *)MFP_LEDS_ADDR)
#define MFP_7SEGLED (*(volatile unsigned *)MFP_7SEGLED_ADDR)
#define MFP_7SEGLEDEX (*(volatile unsigned *)MFP_7SEGLEDEX_ADDR)
#define MFP_3LEDS (*(volatile unsigned *)MFP_3LEDS_ADDR)
#define MFP_ARDUINO_LEDS (*(volatile unsigned *)MFP_ARDUINO_LEDS_ADDR)
#define MFP_ARDUINO_SEG (*(volatile unsigned *)MFP_ARDUINO_SEG_ADDR)
#define MFP_ARDUINO_BUZ (*(volatile unsigned *)MFP_ARDUINO_BUZ_ADDR)
#define MFP_PS2_CTRL (*(volatile unsigned *)MFP_PS2_CTRL_ADDR)
#define MFP_PS2_DATA (*(volatile unsigned *)MFP_PS2_DATA_ADDR)

#define get_switches() (MFP_SWITCHES)
#define get_buttons() (MFP_BUTTONS_DATA)
#define clear_buttons_int() (MFP_BUTTONS_CTRL = 0)
#define get_leds() (MFP_LEDS)
#define set_leds(x) (MFP_LEDS = (x))
void set_seg7led(unsigned int data);
void set_seg7led_pixel(unsigned int high, unsigned int low);
#define get_3leds() (MFP_3LEDS)
#define set_3leds(x) (MFP_3LEDS = (x))
#define get_arduino_leds() (MFP_ARDUINO_LEDS)
#define set_arduino_leds(x) (MFP_ARDUINO_LEDS = (x))
void set_arduino_seg7led(unsigned int data);
void set_arduino_seg7led_pixel(unsigned int data);
#define get_arduino_buz() (MFP_ARDUINO_BUZ)
#define set_arduino_buz(x) (MFP_ARDUINO_BUZ = (x))
#define clear_ps2_int() (MFP_PS2_CTRL = 0)
#define get_ps2() (MFP_PS2_DATA)
#define get_vga_pixel(x) (((unsigned int *)MFP_VGA_ADDR)[(x)])
#define set_vga_pixel(x, rgb) (((unsigned int *)MFP_VGA_ADDR)[(x)] = (rgb))
#define get_sram_word(x) (((unsigned int *)MFP_SRAM_ADDR)[(x)])
#define set_sram_word(x, v) (((unsigned int *)MFP_SRAM_ADDR)[(x)] = (v))
unsigned long sd_read_block(unsigned char *buf, unsigned long addr,
                            unsigned long count);
unsigned long sd_write_block(unsigned char *buf, unsigned long addr,
                             unsigned long count);

void vga_clear();
void vga_set_foreground(unsigned int x);
unsigned int vga_get_foreground();
void vga_set_background(unsigned int x);
unsigned int vga_get_background();
void put_char(char c);
char keyboard();

int init();
int main();

#endif
