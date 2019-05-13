// Author: Jiang Zengkai
// Date: 2019.5.13

#include "mfp_io.h"
#include <mips/cpu.h>
#include <mips/m32c0.h>

int main() {
    set_seg7led_arduino(0x1234);
    set_seg7led_pixel(0xc6f6f6f0, 0xc6f6f6f0);
    MFP_LEDS = 0x5a5a;

    return 0;
}
