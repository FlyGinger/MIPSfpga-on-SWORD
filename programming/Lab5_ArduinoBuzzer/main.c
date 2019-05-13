// Author: Jiang Zengkai
// Date: 2019.3.29

#include "mfp_io.h"
#define ANTI_JITTER 1000000

void delay();

#define C 95420
#define D 85034
#define E 75758
#define F 71633
#define G 63775
#define A 56818
#define B 50607

int main() {

    volatile unsigned int xiaoluohao[26] = {C, C, E, E, G, G, C, C, E, E, G, G,
                                            C, C, E, C, E, G, E, C, G, C, C, C};
    while (1) {
        delay(), delay(), delay(), delay(), delay(), delay();
        for (int i = 0; i < 26; i++) {
            MFP_ABUZ = xiaoluohao[i];
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
