#include "mfp_io.h"

unsigned int time = 0;

void __attribute__((interrupt, keep_interrupts_masked))
_mips_general_exception() {
    unsigned cause = mips32_getcr(); // Coprocessor 0 Cause register

    // check cause of interrupt
    if ((cause & 0x7c) != 0) {
        MFP_LEDS = 0x8001; // Display 0x8001 on LEDs to indicate exception state
        while (1)
            ; // Loop forever non-interrupt exception detected
    }
    if (cause & CR_HINT0) {
        set_3leds(time++);
        mips32_setcompare(0x800000);
        mips32_setcount(0);
    } else if (cause & CR_HINT1) {
        set_seg7led(get_buttons());
        clear_buttons_int();
    } else if (cause & CR_HINT2) {
        put_char(keyboard());
    }
}

int init() {
    mips32_bicsr(SR_BEV);
    mips32_bissr(SR_IE | SR_HINT0 | SR_HINT1 | SR_HINT2);

    clear_buttons_int();
    set_seg7led(0);
    set_3leds(0);
    set_arduino_leds(0);
    set_arduino_seg7led(0);
    set_arduino_buz(0);
    clear_ps2_int();
    vga_clear();

    mips32_setcompare(0x800000);
    mips32_setcount(0);

    main();

    return 0;
}
