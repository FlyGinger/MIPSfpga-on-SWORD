// Author: Jiang Zengkai
// Date: 2019.4.9

//
// This program exercises MIPSfpga's interrupts
//

#include "mfp_io.h"
#include <mips/cpu.h>
#include <mips/m32c0.h>

#define INTERNAL 25000000

void __attribute__((interrupt, keep_interrupts_masked))
_mips_general_exception() {
    unsigned cause = mips32_getcr(); // Coprocessor 0 Cause register
    // check cause of interrupt
    if ((cause & 0x7c) != 0) {
        MFP_LEDS = 0x8001; // Display 0x8001 on LEDs to indicate exception state
        MFP_7SEGLED = 0x12345678;
        while (1)
            ; // Loop forever non-interrupt exception detected
    }
    if (cause & CR_HINT0) // Checking whether interrupt 0 is pending
        MFP_7SEGLED++;
    else if (cause & CR_HINT1) {
        mips_setcompare(INTERNAL);
        MFP_7SEGLED++;
        mips_setcount(0);
    }
}

int main() {
    MFP_7SEGLEDEX = 0;
    MFP_7SEGLED = 0;

    mips_setcount(0);
    mips_setcompare(INTERNAL);

    // set up interrupts
    // Clear boot interrupt vector bit in Coprocessor 0 Status register
    mips32_bicsr(SR_BEV);

    // Set master interrupt enable bit, as well as individual interrupt
    // enable bits in Coprocessor 0 Status register
    mips32_bissr(SR_IE | SR_HINT0 | SR_HINT1);

    unsigned int *MFP_VGA = (unsigned int *)MFP_VGA_ADDR;
    int i = 0;
    int j = 0;

    while (1) {
        for (i = 0; i < 480; i++) {
            for (j = 0; j < 640; j++) {
                if (i < 240) {
                    if (j < 320) {
                        MFP_VGA[i * 640 + j] = 0xf00;
                    } else {
                        MFP_VGA[i * 640 + j] = 0xf0f;
                    }
                } else {
                    if (j < 320) {
                        MFP_VGA[i * 640 + j] = 0xf0f;
                    } else {
                        MFP_VGA[i * 640 + j] = 0x00f;
                    }
                }
            }
        }
    }

    return 0;
}
