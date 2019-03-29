#include "mfp_io.h"
#define ANTI_JITTER 10000000

void delay();

//------------------
// main()
//------------------
int main() {

    volatile unsigned int count = 0x12345678;
    MFP_7SEGLEDEX = 0;

    while (1) {
        MFP_7SEGLED = count;
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