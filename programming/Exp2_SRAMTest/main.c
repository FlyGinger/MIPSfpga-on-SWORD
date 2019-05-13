// Author: Jiang Zengkai
// Date: 2019.4.17

#include "mfp_io.h"
#include <mips/cpu.h>
#include <mips/m32c0.h>

// void __attribute__((interrupt, keep_interrupts_masked))
// _mips_general_exception() {
//     MFP_LEDS = 0x0001;
//     while (1)
//         ;
// }

// void __attribute__((interrupt, keep_interrupts_masked))
// _mips_cache_error() {
//     MFP_LEDS = 0x0002;
//     while (1)
//         ;
// }

// void __attribute__((interrupt, keep_interrupts_masked))
// _mips_xtlb_refill() {
//     MFP_LEDS = 0x0003;
//     while (1)
//         ;
// }

// void __attribute__((interrupt, keep_interrupts_masked))
// _mips_tlb_refill() {
//     MFP_LEDS = 0x0003;
//     while (1)
//         ;
// }

// void delay() {
//     volatile int i = 10000;
//     while (i-- > 0)
//         ;
// }

int main() {
    unsigned int *MFP_SRAM = (unsigned int *)0xbf000000;
    int i = 0;
    int c = 0x5a5a5a5a;
    MFP_7SEGLEDEX = 0;

    while (1) {
        for (i = 0; i < 0x80000; i++) {
            MFP_SRAM[i] = c;
            MFP_7SEGLED = i;
        }
        for (i = 0; i < 0x80000; i++) {
            if (MFP_SRAM[i] != c) {
                MFP_7SEGLED = i;
                while (1)
                    ;
            }
        }
        MFP_LEDS = 0xf;
    }

    return 0;
}
