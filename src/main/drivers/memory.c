#include "numbers.h"
#include "memory.h"

void memory_copy(u8int *source, u8int *dest, u32int nbytes) {
    int i;
    for (i = 0; i < nbytes; i++) {
        *(dest + i) = *(source + i);
    }
}
