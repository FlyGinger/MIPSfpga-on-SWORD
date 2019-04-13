// Author: Jiang Zengkai
// Date: 2019.4.9

#ifndef MFP_MEMORY_MAPPED_REGISTERS_H
#define MFP_MEMORY_MAPPED_REGISTERS_H

#define MFP_LEDS_ADDR           0xBF800000
#define MFP_SWITCHES_ADDR       0xBF800004
#define MFP_BUTTONS_ADDR        0xBF800008
#define MFP_7SEGLED_ADDR        0xBF80000C
#define MFP_7SEGLEDEX_ADDR      0xBF800010
#define MFP_ALEDS_ADDR          0xBF800014
#define MFP_A7SEGLED_ADDR       0xBF800018
#define MFP_A7SEGLEDEX_ADDR     0xBF80001C
#define MFP_ABUZ_ADDR           0xBF800020
#define MFP_3LED_ADDR           0xBF800024
#define MFP_MILLIS_ADDR         0XBF800034

#define MFP_LEDS                (* (volatile unsigned *) MFP_LEDS_ADDR)
#define MFP_SWITCHES            (* (volatile unsigned *) MFP_SWITCHES_ADDR)
#define MFP_BUTTONS             (* (volatile unsigned *) MFP_BUTTONS_ADDR)
#define MFP_7SEGLED             (* (volatile unsigned *) MFP_7SEGLED_ADDR)
#define MFP_7SEGLEDEX           (* (volatile unsigned *) MFP_7SEGLEDEX_ADDR)
#define MFP_ALEDS               (* (volatile unsigned *) MFP_ALEDS_ADDR)
#define MFP_A7SEGLED            (* (volatile unsigned *) MFP_A7SEGLED_ADDR)
#define MFP_A7SEGLEDEX          (* (volatile unsigned *) MFP_A7SEGLEDEX_ADDR)
#define MFP_ABUZ                (* (volatile unsigned *) MFP_ABUZ_ADDR)
#define MFP_3LED                (* (volatile unsigned *) MFP_3LED_ADDR)
#define MFP_MILLIS              (* (volatile unsigned *) MFP_MILLIS_ADDR)

// This define is used in boot.S code

#define BOARD_16_LEDS_ADDR      MFP_LEDS_ADDR

#endif
