// Author: Jiang Zengkai
// Date: 2019.4.5

#include "mfp_io.h"

int main() {
    MFP_7SEGLEDEX = 0;
    while (1) {
        MFP_7SEGLED = MFP_BUTTONS;
    }
    return 0;
}
