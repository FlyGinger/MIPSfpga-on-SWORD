// Author: Jiang Zengkai
// Date: 2019.4.14

#include "mfp_io.h"
#include <mips/cpu.h>
#include <mips/m32c0.h>

int main() {
    MFP_7SEGLEDEX = 0;

    unsigned int config = mips32_getconfig();
    config = (config >> 7) & 0x7; // get MT field

    if (config == 1) {
        // MMU type: TLB
        unsigned int config1 = mips32_getconfig1();
        config1 = (config1 >> 25) & 0x3f;
        MFP_7SEGLED = config1;
    } else {
        // MMU type: FMT
        MFP_7SEGLED = 0xffffffff;
    }

    while (1)
        ;

    return 0;
}

// result: 0xF
// which means we have 16 TLB entry
// and hold 32 pages
