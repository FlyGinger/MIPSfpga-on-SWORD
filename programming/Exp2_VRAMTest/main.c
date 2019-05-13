// Author: Jiang Zengkai
// Date: 2019.4.14

#include "mfp_io.h"

int main() {
    unsigned int *MFP_VGA = (unsigned int *)MFP_VGA_ADDR;
    int i = 0;
    int j = 0;
    unsigned int k;
    MFP_7SEGLEDEX = 0;

    while (1) {
        for (i = 0; i < 480; i++) {
            for (j = 0; j < 640; j++) {
                k = MFP_VGA[i * 640 + j];
                MFP_7SEGLED = k;
                MFP_VGA[i * 640 + j] = k;
            }
        }
    }

    return 0;
}
