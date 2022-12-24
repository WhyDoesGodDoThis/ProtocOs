#pragma once

#include "numbers.h"

data port_byte_in(port Port);

void port_byte_out(port Port, data Data);

void port_word_out(port Port, u16int Data);