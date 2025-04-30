#include <stdint.h>
#define VIDEO_MEMORY 0xB8000
#define WHITE_ON_BLACK 0x0F

void write_string(char *str) {
    uint16_t *video = (uint16_t*) VIDEO_MEMORY;
    while (*str) {
        *video = (WHITE_ON_BLACK << 8) | *str;
        ++video;
        ++str;
    }
}

void kernel_main(void) {
    write_string("Hello from Jeans OS Kernel!\n");
    // Your kernel logic here...
    while (1);
}