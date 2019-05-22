#include "mfp_io.h"

#define DIGIT_0 (0xC0)
#define DIGIT_1 (0xF9)
#define DIGIT_2 (0xA4)
#define DIGIT_3 (0xB0)
#define DIGIT_4 (0x99)
#define DIGIT_5 (0x92)
#define DIGIT_6 (0x82)
#define DIGIT_7 (0xF8)
#define DIGIT_8 (0x80)
#define DIGIT_9 (0x90)
#define DIGIT_A (0x88)
#define DIGIT_B (0x83)
#define DIGIT_C (0xC6)
#define DIGIT_D (0xA1)
#define DIGIT_E (0x86)
#define DIGIT_F (0x8E)

unsigned int vga_foreground;
unsigned int vga_background;
unsigned int vga_cursor_x;
unsigned int vga_cursor_y;

unsigned char get_digit(unsigned char x) {
    switch (x) {
    case 0:
        return DIGIT_0;
    case 1:
        return DIGIT_1;
    case 2:
        return DIGIT_2;
    case 3:
        return DIGIT_3;
    case 4:
        return DIGIT_4;
    case 5:
        return DIGIT_5;
    case 6:
        return DIGIT_6;
    case 7:
        return DIGIT_7;
    case 8:
        return DIGIT_8;
    case 9:
        return DIGIT_9;
    case 10:
        return DIGIT_A;
    case 11:
        return DIGIT_B;
    case 12:
        return DIGIT_C;
    case 13:
        return DIGIT_D;
    case 14:
        return DIGIT_E;
    case 15:
        return DIGIT_F;
    default:
        return 0xff;
    }
}

void set_seg7led(unsigned int data) {
    MFP_7SEGLED = (get_digit((data & 0xf000) >> 12) << 24) |
                  (get_digit((data & 0x0f00) >> 8) << 16) |
                  (get_digit((data & 0x00f0) >> 4) << 8) |
                  (get_digit(data & 0x000f));
    MFP_7SEGLEDEX = (get_digit((data & 0xf0000000) >> 28) << 24) |
                    (get_digit((data & 0x0f000000) >> 24) << 16) |
                    (get_digit((data & 0x00f00000) >> 20) << 8) |
                    (get_digit((data & 0x000f0000) >> 16));
}

void set_arduino_seg7led(unsigned int data) {
    MFP_ARDUINO_SEG = (get_digit((data & 0xf000) >> 12) << 24) |
                      (get_digit((data & 0x0f00) >> 8) << 16) |
                      (get_digit((data & 0x00f0) >> 4) << 8) |
                      (get_digit(data & 0x000f));
}

void set_seg7led_pixel(unsigned int high, unsigned int low) {
    MFP_7SEGLED = low;
    MFP_7SEGLEDEX = high;
}

void set_arduino_seg7led_pixel(unsigned int data) { MFP_ARDUINO_SEG = data; }

#define SECSIZE 512
static volatile unsigned int *const SD_CTRL = (unsigned int *)MFP_SD_CTRL_ADDR;
static volatile unsigned int *const SD_BUF = (unsigned int *)MFP_SD_BUF_ADDR;

static int sd_send_cmd_blocking(int cmd, int argument) {
    // Send cmd
    SD_CTRL[1] = cmd;
    SD_CTRL[0] = argument;
    // Wait for cmd transmission
    int t = 4096;
    while (t--)
        ;

    // Read CMD_EVENT_STATUS
    int cmd_event_status = 0;
    do {
        cmd_event_status = SD_CTRL[13];
    } while (cmd_event_status == 0);

    // Check if sending success
    if (cmd_event_status & 1) {
        // success
        return 0;
    } else {
        // fail
        return cmd_event_status;
    }
}

int sd_read_sector_blocking(int id, void *buffer) {
    // Disable interrupts
    _mips_intdisable();
    int result = 0;

    // Set dma_address
    SD_CTRL[24] = 0;
    // Clear data_event_status
    SD_CTRL[15] = 0;
    // Tell sd ready to read
    result = sd_send_cmd_blocking(0x1139, id);
    if (result != 0) {
        goto ret;
    }

    // Read data_event_status
    int des = 0;
    do {
        des = SD_CTRL[15];
    } while (des == 0);

    if (des & 1) {
        // Start reading
        int *buffer_int = (int *)buffer;
        for (int i = 0; i < 128; i++) {
            buffer_int[i] = SD_BUF[i];
        }
        result = 0;
    } else {
        // Error encountered
        result = des;
    }
ret:
    // Enable interrupts
    _mips_intenable();
    return result;
}

int sd_write_sector_blocking(int id, void *buffer) {
    // Disable interrupts
    _mips_intdisable();
    int result = 0;

    // Set dma_address
    SD_CTRL[24] = 0;
    // Clear data_event_status
    SD_CTRL[15] = 0;
    // Wait bus until clear
    asm volatile("nop\n\t"
                 "nop\n\t");

    // Start writing
    int *buffer_int = (int *)buffer;
    for (int i = 0; i < 128; i++) {
        SD_BUF[i] = buffer_int[i];
    }
    // Tell sd ready to write
    result = sd_send_cmd_blocking(0x1859, id);
    if (result != 0) {
        goto ret;
    }

    // Read data_event_status
    int des = 0;
    do {
        des = SD_CTRL[15];
    } while (des == 0);

    if (des & 1) {
        result = 0;
    } else {
        result = des;
    }
ret:
    // Enable interrupts
    _mips_intenable();
    return result;
}

unsigned long sd_read_block(unsigned char *buf, unsigned long addr,
                            unsigned long count) {
    // Read single/multiple block
    unsigned long result;
    for (int i = 0; i < count; ++i) {
        result = sd_read_sector_blocking(addr + i, buf + i * SECSIZE);
        if (0 != result) {
            goto error;
        }
    }
ok:
    return 0;
error:
    return 1;
}

unsigned long sd_write_block(unsigned char *buf, unsigned long addr,
                             unsigned long count) {
    // Write single/multiple block
    unsigned long result;
    for (int i = 0; i < count; ++i) {
        result = sd_write_sector_blocking(addr + i, buf + i * SECSIZE);
        if (0 != result) {
            goto error;
        }
    }
ok:
    return 0;
error:
    return 1;
}

void vga_clear() {
    int i;
    for (i = 0; i < 307200; i++) {
        set_vga_pixel(i, vga_background);
    }
    vga_cursor_x = 0;
    vga_cursor_y = 0;
}

void page_down() {
    int i, j;
    for (i = 0; i < 464; i++) {
        for (j = 0; j < 640; j++) {
            set_vga_pixel(i * 640 + j, get_vga_pixel((i + 16) * 640 + j));
        }
    }
    for (; i < 480; i++) {
        for (j = 0; j < 640; j++) {
            set_vga_pixel(i * 640 + j, vga_background);
        }
    }
}

void put_char(char c) {
    unsigned int *pixel = (unsigned int *)(MFP_VGA_CHAR_ADDR + c * 4 * 4);
    int i, j, k = 31, l = 0;
    for (i = vga_cursor_x * 16; i < (vga_cursor_x + 1) * 16; i++) {
        for (j = vga_cursor_y * 8; j < (vga_cursor_y + 1) * 8; j++) {
            set_vga_pixel(i * 640 + j,
                          (pixel[l] >> k) ? vga_foreground : vga_background);
            k -= 1;
            if (k == 0) {
                k = 31;
                l += 1;
            }
        }
    }

    vga_cursor_y += 1;
    if (vga_cursor_y == 80) {
        vga_cursor_y = 0;
        vga_cursor_x += 1;
        if (vga_cursor_x == 30) {
            page_down();
            vga_cursor_x = 29;
        }
    }
}

char keyboard() {
    char c = get_ps2();
    clear_ps2_int();
    return c;
}

void vga_set_foreground(unsigned int x) { vga_foreground = x; }
unsigned int vga_get_foreground() { return vga_foreground; }
void vga_set_background(unsigned int x) { vga_background = x; }
unsigned int vga_get_background() { return vga_background; }
