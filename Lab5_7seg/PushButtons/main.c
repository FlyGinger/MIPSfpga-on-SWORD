#include "mfp_io.h"
#define ANTI_JITTER 1000000

void delay();

//------------------
// main()
//------------------
int main() {

    MFP_7SEGLEDEX = 0;
    while (1) {
        if (MFP_BUTTONS != 0) {
            MFP_7SEGLED = MFP_BUTTONS;
            delay();
        }
    }

    return 0;
}

void delay() {
    volatile int i = 0; // !!! CAUTION !!! will be optimized without `volatile`
    for (i = 0; i < ANTI_JITTER; i++)
        ;
}
