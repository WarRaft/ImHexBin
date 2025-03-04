#pragma description Warcraft.w3abdhqtu
#pragma endian little
#pragma array_limit 99999

import std.io;
import std.mem;
import std.string;
import std.core;

bool leveldata in; // .w3a, .w3d, .w3q

u32 format @ 0x00;

struct Mod {
    char modification[4];
    u32 type;

    if (leveldata) {
        u32 level;
        u32 data;
    }

     match (type) {
        (0): u32 value;
        (1 | 2): float value;
        (3): char value[];
    }

    u32 end;
};

struct Set {
    if (format >= 3) u32 flag;
    u32 count;
    Mod mod[count];
};

struct Item {
    char original[4];
    char modified[4];

    if (format >= 3) {
        u32 count;
        Set set[count];
    } else {
        Set set;
    }
};

struct Data {
    u32 countDefault;
    Item default[countDefault];

    u32 countModified;
    Item modified[countModified];
};

Data data @ 0x04;
