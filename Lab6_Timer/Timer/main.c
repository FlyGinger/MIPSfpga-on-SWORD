#include "mfp_io.h"

//------------------
// main()
//------------------
int main() {

    MFP_7SEGLEDEX = 0;
    while (1) {
        MFP_7SEGLED = MFP_MILLIS;
    }

    return 0;
}
