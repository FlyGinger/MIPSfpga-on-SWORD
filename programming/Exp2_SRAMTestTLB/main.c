// Author: Jiang Zengkai
// Date: 2019.5.13

#include "mfp_io.h"
#include <mips/cpu.h>
#include <mips/m32c0.h>

void delay() {
    volatile int i = 100000;
    while (i-- > 0)
        ;
}

void test1() {
    unsigned int *SRAM = (unsigned int *)0;
    int i = 0;

    while (1) {
        for (i = 0; i < 0x80000; i++) {
            SRAM[i] = 0x5a5a5a5a;
            set_seg7led(i);
        }
        for (i = 0; i < 0x80000; i++) {
            if (SRAM[i] != 0x5a5a5a5a) {
                while (1)
                    ;
            }
        }
        MFP_LEDS = 1;
    }
}

void test2() {
    unsigned int *SRAM = (unsigned int *)0;
    unsigned int *VGA = (unsigned int *)MFP_VGA_ADDR;
    int i = 0;
    int j = 0;
    MFP_LEDS = 0;

    while (1) {
        for (i = 0; i < 480; i++) {
            for (j = 0; j < 640; j++) {
                SRAM[i * 640 + j] = VGA[i * 640 + j];
            }
        }
        for (i = 0; i < 480; i++) {
            for (j = 0; j < 640; j++) {
                VGA[i * 640 + j] = SRAM[i * 640 + j];
            }
        }
        MFP_LEDS++;
    }
}

int main() {
    test1();
    return 0;
}
