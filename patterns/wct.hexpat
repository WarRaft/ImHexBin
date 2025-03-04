#pragma description Warcraft.wct
#pragma endian little
#pragma array_limit 99999

import std.io;
import std.mem;
import std.string;
import std.core;

u32 format @ 0x00;

struct Code {
    u32 size;
    if (size > 0){
        char code[size];
    }
};

struct Data {
    if (format >= 1){
        char comment[]; // Комментарий к нестандартному коду
        Code code;
    }

    u32 countTrigger;
    Code triggers[countTrigger];
};

Data data @ 0x04;
