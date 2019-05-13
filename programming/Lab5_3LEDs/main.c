// Author: Jiang Zengkai
// Date: 2019.3.29

#include "mfp_io.h"
#define ANTI_JITTER 10000000

void delay();

int main() {
    volatile unsigned int count = 0;
    while (1) {
        MFP_3LED = count;
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
