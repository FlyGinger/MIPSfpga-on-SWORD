// Author: Jiang Zengkai
// Date: 2019.5.13

#include "mfp_io.h"

void delay(int x) {
    volatile int i = x;
    while (i-- > 0)
        ;
}

int g;

void __attribute__((interrupt, keep_interrupts_masked))
_mips_general_exception() {
    unsigned cause = mips32_getcr(); // Coprocessor 0 Cause register

    // check cause of interrupt
    if ((cause & 0x7c) != 0) {
        MFP_LEDS = 0x8001; // Display 0x8001 on LEDs to indicate exception state
        set_seg7led(0x12345678);
        while (1)
            ; // Loop forever non-interrupt exception detected
    }
    if (cause & CR_HINT3) {
        g = (g << 8) | MFP_PS2_DATA;
        set_seg7led_arduino(g);
        volatile int i = 10000000;
        while (i-- > 0)
            ;
        MFP_PS2_CTRL = 0;
        // delay(100000);
    } else {
        set_seg7led(0x12340000);
        while (1)
            ;
    }
}

int main() {
    mips32_bicsr(SR_BEV);
    mips32_bissr(SR_IE | SR_HINT0 | SR_HINT3);

    int i = 0;
    g = 0;
    while (1) {
        set_seg7led(i++);
        // set_seg7led_arduino(MFP_PS2_DATA);
        // set_seg7led_arduino(MFP_PS2_CTRL);
        delay(1000000);
    }

    return 0;
}
