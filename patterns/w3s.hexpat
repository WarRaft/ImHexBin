#pragma description Warcraft 3 Sound
#pragma endian little

import std.io;
import std.mem;
import std.string;
import std.core;

u32 format @ 0x00;
u32 count @ 0x04;

struct Skin {
    char variable[];
    char unknown2[];
    char sound[];
    u32 unknown4[5];
    u16 unknown5[1];
};

bitfield Flag {
    repeat: 1 [[comment("0x01 Повтор")]];
    position: 1 [[comment("0x02 Позиционный звук")]];
    ending: 1 [[comment("0x04 Останавливаться при выходе за пределы")]];
    music: 1 [[comment("0x08 Музыка")]];
    imported: 1 [[comment("0x10 Звук импортированный")]];
    padding: 27;
};

enum Eax: str {
    DefaultEAXON = "DefaultEAXON"
};

enum Channel : u32 {
    Default = 0xFFFFFF, // По умолчанию
    General = 0, // Общий
    Select = 1, // Выбор
    Confirm = 2, // Подтверждение
    Move = 3, // Перемещение
    Ready = 4, // Готовность
    Battle = 5, // Бой
    Error = 6, // Ошибка
    Music = 7, // Музыка
    UI = 8, // Интерфейс пользователя
    MoveRepeat = 9, // Повтор звука перемещения
    EnvRepeat = 10, // Повтор фонового звука
    Animation = 11, // Анимация
    Build = 12, // Постройка
    Birth = 13, // Рождение
    Fire = 14, // Огонь
};


struct Sound {
    char variable[];
    char sound[];
    /*
    DefaultEAXON - или отсутствие строки: по умолчанию
    CombatSoundsEAX - Бой
    KotoDrumsEAX - Барабаны
    SpellsEAX - Заклинания
    MissilesEAX - Выстрелы
    HeroAcksEAX - Речь героя
    DoodadsEAX - Декорации
    */
    char effect[];
    Flag flag;
    u32 amplification [[comment("Усиление")]];
    u32 decay [[comment("Затухание")]];
    u32 volume [[comment("Громкость")]];
    float step [[comment("Шаг")]];
    float unknown1;
    u32 unknown2;
    Channel channel [[comment("Канал")]];
    float minDist [[comment("Мин. дистанция")]];
    float maxDist [[comment("Макс. дистанция")]];
    float decayDist [[comment("Дист. затухания")]];
    float unknown3;
    float unknown4;
    u32 unknown5;
    float unknown6;
    float unknown7;
    float unknown8;

    if (format > 1) Skin skin;
};


Sound sounds[count] @ 0x08 ;
