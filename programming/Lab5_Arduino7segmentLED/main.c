// Author: Jiang Zengkai
// Date: 2019.3.29

#include "mfp_io.h"
#define ANTI_JITTER 10000000

void delay();

int main() {
    volatile unsigned int count = 0x1234;
    MFP_A7SEGLEDEX = 0;
    while (1) {
        switch (MFP_SWITCHES) {
        case 0x1:
            MFP_A7SEGLEDEX = 0x7;
            break;
        case 0x2:
            MFP_A7SEGLEDEX = 0x70;
            break;
        case 0x4:
            MFP_A7SEGLEDEX = 0x700;
            break;
        case 0x8:
            MFP_A7SEGLEDEX = 0x7000;
            break;
        case 0x10:
            MFP_A7SEGLEDEX = 0x8;
            break;
        case 0x20:
            MFP_A7SEGLEDEX = 0x80;
            break;
        case 0x40:
            MFP_A7SEGLEDEX = 0x800;
            break;
        case 0x80:
            MFP_A7SEGLEDEX = 0x8000;
            break;
        default:
            MFP_A7SEGLEDEX = 0;
            break;
        }
        MFP_A7SEGLED = count;
        count++;
        delay();
    }
    return 0;
}

void delay() {
    volatile int i = 0; // !!! CAUTION !!! will be optimized without `volatile`
    for (i = 0; i < ANTI_JITTER; i++)
        ;
}
