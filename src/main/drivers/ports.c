#include "numbers.h"
#include "ports.h"

data port_byte_in(port Port) {
    data result;
    asm("inb %1, %0" : "=a" (result) : "d" (Port));
    return result;
}

void port_byte_out(port Port, data Data) {
    asm("out %%al, %%dx" : "=d" (Port) : "a" (Data));
}

void port_word_out(port Port, u16int Data) {
    asm("outw %0, %1" : : "a" (Data), "d" (Port));
}