#include "mfp_io.h"

int main() {
    while (1) {
        unsigned int sw = get_switches();
        set_leds(sw);

        if (sw & 0x1) {
            set_arduino_buz(95420); // C
        } else if (sw & 0x2) {
            set_arduino_buz(89928); // C#
        } else if (sw & 0x4) {
            set_arduino_buz(85034); // D
        } else if (sw & 0x8) {
            set_arduino_buz(80386); // D#
        } else if (sw & 0x10) {
            set_arduino_buz(75758); // E
        } else if (sw & 0x20) {
            set_arduino_buz(71633); // F
        } else if (sw & 0x40) {
            set_arduino_buz(67568); // F#
        } else if (sw & 0x80) {
            set_arduino_buz(63776); // G
        } else if (sw & 0x100) {
            set_arduino_buz(60241); // G#
        } else if (sw & 0x200) {
            set_arduino_buz(56818); // A
        } else if (sw & 0x400) {
            set_arduino_buz(53648); // A#
        } else if (sw & 0x800) {
            set_arduino_buz(50607); // B
        } else {
            set_arduino_buz(0); // silent
        }
    }
    return 0;
}
