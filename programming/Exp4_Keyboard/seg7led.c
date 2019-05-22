#include "mfp_io.h"

#define DIGIT_0 (0xC0)
#define DIGIT_1 (0xF9)
#define DIGIT_2 (0xA4)
#define DIGIT_3 (0xB0)
#define DIGIT_4 (0x99)
#define DIGIT_5 (0x92)
#define DIGIT_6 (0x82)
#define DIGIT_7 (0xF8)
#define DIGIT_8 (0x80)
#define DIGIT_9 (0x90)
#define DIGIT_A (0x88)
#define DIGIT_B (0x83)
#define DIGIT_C (0xC6)
#define DIGIT_D (0xA1)
#define DIGIT_E (0x86)
#define DIGIT_F (0x8E)

unsigned char get_digit(unsigned char x) {
    switch (x) {
    case 0:
        return DIGIT_0;
    case 1:
        return DIGIT_1;
    case 2:
        return DIGIT_2;
    case 3:
        return DIGIT_3;
    case 4:
        return DIGIT_4;
    case 5:
        return DIGIT_5;
    case 6:
        return DIGIT_6;
    case 7:
        return DIGIT_7;
    case 8:
        return DIGIT_8;
    case 9:
        return DIGIT_9;
    case 10:
        return DIGIT_A;
    case 11:
        return DIGIT_B;
    case 12:
        return DIGIT_C;
    case 13:
        return DIGIT_D;
    case 14:
        return DIGIT_E;
    case 15:
        return DIGIT_F;
    default:
        return 0xff;
    }
}

void set_seg7led(unsigned int data) {
    MFP_7SEGLED = (get_digit((data & 0xf000) >> 12) << 24) |
                  (get_digit((data & 0x0f00) >> 8) << 16) |
                  (get_digit((data & 0x00f0) >> 4) << 8) |
                  (get_digit(data & 0x000f));
    MFP_7SEGLEDEX = (get_digit((data & 0xf0000000) >> 28) << 24) |
                    (get_digit((data & 0x0f000000) >> 24) << 16) |
                    (get_digit((data & 0x00f00000) >> 20) << 8) |
                    (get_digit((data & 0x000f0000) >> 16));
}

void set_seg7led_arduino(unsigned int data) {
    MFP_A7SEGLED = (get_digit((data & 0xf000) >> 12) << 24) |
                   (get_digit((data & 0x0f00) >> 8) << 16) |
                   (get_digit((data & 0x00f0) >> 4) << 8) |
                   (get_digit(data & 0x000f));
}

void set_seg7led_pixel(unsigned int high, unsigned int low) {
    MFP_7SEGLED = low;
    MFP_7SEGLEDEX = high;
}

void set_seg7led_arduino_pixel(unsigned int data) { MFP_A7SEGLED = data; }
