#pragma description Rect
#pragma endian little

import std.io;
import std.mem;
import std.string;
import std.core;

u32 format @0x00;
u32 count @0x04;

struct Color {
    u8 b [[color("0000FF")]];
    u8 g [[color("00FF00")]];
    u8 r [[color("FF0000")]];
    u8 a [[color("000000")]];
} [[static, color(std::format("{:02X}{:02X}{:02X}", r, g, b))]];;

struct Rect {
    float l, b, r, t;
    char name[];
    u32 num; // Номер области
    char weather[4]; // Равкод погоды
    char sound[]; // Фоновый звук
    Color color;
};
 
Rect rect[count] @0x08;