#include "mfp_io.h"

int main() {
    vga_set_background(0xf70);
    vga_set_foreground(0x00f);
    vga_clear();

    char buf[512];
    sd_read_block(buf, 0, 1);
    int i = 0;
    for (i = 0; i < 512; i++) {
        put_char(hex2char(buf[i] & 0xf));
        put_char(hex2char(buf[i] >> 4));
    }

    unsigned int *sram = (unsigned int *)0;
    for (i = 0; i < 1048576; i++) {
        sram[i] = 0x5a5a5a5a;
    }
    for (i = 0; i < 1048576; i++) {
        if (sram[i] != 0x5a5a5a5a) {
            set_arduino_seg7led(i);
            while (1)
                ;
        }
    }
    set_arduino_leds(0x1);

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
