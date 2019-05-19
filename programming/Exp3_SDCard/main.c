// Author: Jiang Zengkai
// Date: 2019.5.13

#include "mfp_io.h"

void delay(int x) {
    volatile int i = x;
    while (i-- > 0)
        ;
}

void test1() {
    unsigned char buffer[512];
    sd_read_block(buffer, 0, 1);

    int i;
    MFP_LEDS = 0;
    unsigned int *buf = (unsigned int *)buffer;
    for (i = 0; i < 128; i++) {
        set_seg7led(buf[i]);
        MFP_LEDS = i + 1;
        delay(100000);
    }
}

void test2() {
    unsigned int *ptr = (unsigned int *)0xbf000000;
    int i = 0;
    for (i = 0; i < 1024; i++) {
        ptr[i] = 0x5a5a5a5a;
        set_seg7led(i);
        delay(10000);
    }
    for (i = 0; i < 1024; i++) {
        if (ptr[i] != 0x5a5a5a5a) {
            set_seg7led(i);
            while (1)
                ;
        }
    }
    set_seg7led(0xffffffff);
}

void test3() {
    unsigned char buffer[512];
    sd_read_block(buffer, 0, 1);

    buffer[511] = 0xf;
    sd_write_block(buffer, 0, 1);
}

int main() {
    test3();
    test1();
    return 0;
}
