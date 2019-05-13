// Author: Jiang Zengkai
// Date: 2019.5.13

#include "mfp_io.h"
#include <mips/cpu.h>
#include <mips/m32c0.h>

int main() {

    set_seg7led_arduino_pixel(0xc6f6f6f0);

    while (1) {
        if (MFP_SWITCHES == 0) {
            set_seg7led(0x01234567);
        } else {
            set_seg7led(0x89abcdef);
        }
    }

    return 0;
}

