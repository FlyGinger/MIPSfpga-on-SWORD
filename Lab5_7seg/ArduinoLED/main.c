// Author: Jiang Zengkai
// Date: 2019.3.29

#include "mfp_io.h"
#define ANTI_JITTER 1000000

void delay();

int main() {
    volatile unsigned int count = 0x0;
    while (1) {
        MFP_ALEDS = count;
        count++;
        delay();
    }
    return 0;
}
