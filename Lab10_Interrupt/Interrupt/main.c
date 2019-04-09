//
// This program exercises MIPSfpga's interrupts
//

#include "mfp_io.h"
#include <mips/cpu.h>

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
}

int main() {
    MFP_7SEGLEDEX = 0;
    MFP_7SEGLED = 0;

    // set up interrupts
    // Clear boot interrupt vector bit in Coprocessor 0 Status register
    mips32_bicsr(SR_BEV);

    // Set master interrupt enable bit, as well as individual interrupt
    // enable bits in Coprocessor 0 Status register
    mips32_bissr(SR_IE | SR_HINT0);

    while (1) // loop forever
        ;

    return 0;
}
