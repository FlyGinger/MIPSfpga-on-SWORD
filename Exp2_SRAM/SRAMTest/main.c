// Author: Jiang Zengkai
// Date: 2019.4.14

#include "mfp_io.h"
#include <mips/cpu.h>
#include <mips/m32c0.h>

void __attribute__((interrupt, keep_interrupts_masked))
_mips_general_exception() {
    MFP_LEDS = 0x0001;
    while (1)
        ;
}

void __attribute__((interrupt, keep_interrupts_masked))
_mips_cache_error() {
    MFP_LEDS = 0x0002;
    while (1)
        ;
}

void __attribute__((interrupt, keep_interrupts_masked))
_mips_xtlb_refill() {
    MFP_LEDS = 0x0003;
    while (1)
        ;
}

void __attribute__((interrupt, keep_interrupts_masked))
_mips_tlb_refill() {
    MFP_LEDS = 0x0003;
    while (1)
        ;
}

void delay() {
    volatile int i = 10000;
    while (i-- > 0)
        ;
}

int main() {
    unsigned int *MFP_VGA = (unsigned int *)MFP_VGA_ADDR;
    unsigned int *MFP_SRAM = (unsigned int *)0;
    int i = 0;
    int j = 0;
    MFP_7SEGLEDEX = 0;

    while (1) {
        for (i = 0; i < 480; i++) {
            for (j = 0; j < 320; j++) {
                MFP_SRAM[i * 640 + j] = MFP_VGA[i * 640 + j];
                MFP_7SEGLED = 0x10000000 | (i * 640 + j);
                delay();
            }
            for (j = 0; j < 320; j++) {
                MFP_VGA[i * 640 + j] = MFP_SRAM[i * 640 + j];
                MFP_7SEGLED = 0x20000000 | (i * 640 + j);
                delay();
            }
        }
    }

    return 0;
}
