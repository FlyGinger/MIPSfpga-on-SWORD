#include "mfp_io.h"

//------------------
// main()
//------------------

void delay() {
    volatile int i = 100000;
    while (i-- > 0)
        ;
}
int main() {
    MFP_7SEGLEDEX = 0;
    int i = 0x5a5a5a5a;
    while (1) {
        MFP_7SEGLED = i++;
        delay();
    }
    return 0;
}
