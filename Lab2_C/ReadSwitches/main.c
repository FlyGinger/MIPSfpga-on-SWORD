// Author: Jiang Zengkai
// Date: 2019.3.29

#include "mfp_io.h"

void delay();

int main() {
    volatile unsigned int switches;
    while (1) {
        switches = MFP_SWITCHES;
        MFP_LEDS = switches;
        delay();
        MFP_LEDS = 0; // turn off LEDs
        delay();
    }
    return 0;
}

void delay() {
    volatile unsigned int j;
    for (j = 0; j < (1000000); j++)
        ; // delay
}
