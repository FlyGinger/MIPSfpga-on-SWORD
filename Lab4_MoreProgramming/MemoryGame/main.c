/*
 * main.c for the MIPSfpga core running on Nexys4 DDR board.
 *
 * This program:
 *   (1) reads the switches on the Nexys4 DDR board and 
 *   (2) flashes the value of the switches on the LEDs
 */
#include "mfp_io.h"
#include <stdlib.h>
#define ANTI_JITTER 100000

void delay();
int read_button();
void generate_random_sequence(unsigned char *sequence);
void show_sequence(unsigned char *sequence);
int quiz(unsigned char *sequence);

//------------------
// main()
//------------------
int main() {
    unsigned char sequence[8];
    srand(0x12345678);

    while (1) {
        read_button(); // push any key to start
        generate_random_sequence(sequence);
        show_sequence(sequence);
        MFP_LEDS = 0xffff;
        MFP_LEDS = quiz(sequence);
    }

    return 0;
}

void delay() {
    volatile int i = 0; // !!! CAUTION !!! will be optimized without `volatile`
    for (i = 0; i < 10000000; i++)
        ;
}

int read_button() {
    int i;
    int button;
    while (1) {
        if ((button = MFP_BUTTONS) == 0) { // no button pushed
            continue;
        } else {                                // some button was pushed
            for (i = 0; i < ANTI_JITTER; i++) { // wait for a while
                if (button != MFP_BUTTONS) {    // it is stall pushed
                    break;
                }
            }
            if (i == ANTI_JITTER) { // ok, we think it is pushed
                while (1) {         // wait for unpushing
                    if (MFP_BUTTONS != 0) {
                        continue;
                    } else { // unpushing
                        for (i = 0; i < ANTI_JITTER; i++) {
                            if (MFP_BUTTONS != 0) {
                                break;
                            }
                        }
                        if (i == ANTI_JITTER) {
                            return button;
                        }
                    }
                }
            }
        }
    }
}

void generate_random_sequence(unsigned char *sequence) {
    for (int i = 0; i < 8; i++) {
        sequence[i] = rand() % 3;
    }
}

void show_sequence(unsigned char *sequence) {
    for (int i = 0; i < 8; i++) {
        switch (sequence[i]) {
        case 0:
            MFP_LEDS = 0x4;
            break;
        case 1:
            MFP_LEDS = 0x2;
            break;
        case 2:
            MFP_LEDS = 0x1;
            break;
        default:
            MFP_LEDS = 0xffff;
            break;
        }
        delay();
        MFP_LEDS = 0;
        delay();
    }
}

int quiz(unsigned char *sequence) {
    int score = 0;
    int number = 1;
    for (int i = 0; i < 8; i++) {
        int button = read_button();
        switch (sequence[i]) {
        case 0:
            if (button & 0x4)
                score++;
            break;
        case 1:
            if (button & 0x2)
                score++;
            break;
        case 2:
            if (button & 0x1)
                score++;
            break;
        default:
            break;
        }
        MFP_LEDS = number;
        number <<= 1;
    }
    return score;
}
