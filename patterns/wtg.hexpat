#pragma description Warcraft.wct
#pragma endian little
#pragma array_limit 999999

import std.io;
import std.mem;
import std.string;
import std.core;

char magick[4] @ 0x00; // WTG!

u32 format @ 0x04; // ROC=4, TFT=7

struct Cat {
    u32 index; // Индекс
    char name[]; //  Название
    if(format >= 7) u32 comment; // Коментарий или нет (0/1)
};

struct Var {
    char name[]; // Название
    char type[]; //  Тип
    u32 unknown; // Неизвестно (если тут 0, то редактор удалит эту переменную при открытии карты)
    u32 array; // Массив или нет (0/1)
    if (format >= 7) u32 arraySize; //Размер массива
    u32 init; //Есть начальное значение (0/1)
    char initval[]; // Начальное значение
};

enum ActType: u32 {
    Event = 0, //   Событие
    Condition = 1, //   Условие
    Action = 2, //   Действие
};


struct Act {
    ActType type; // Тип
    //if(isChild) u32 num; // Номер группы
    char name[]; //  Название
    u32 enabled; // Включено или нет (0/1)
//    Количество параметров (см. кол-во параметров ДУС)
//i раз, см. данные о параметрах
//IF( Версия формата == 7 )
//int Количество дочерних ДУС    Переменная i
//i раз, см. данные о ДУС (аргумент true)
//ENDIF
};


struct Trig {
    char name[]; //  Название
    char description[]; //  Описание
    if (format >= 7) u32 comment; // Комментарий или нет (0/1)
    u32 enabled; // Включен или нет (0/1)
    u32 texted; // Текстовый или нет (0/1)
    u32 initiated; // Изначально включен !(0/1)
    u32 mapinit; // Инициализация при старте карты (0/1)
    u32 cat; // Индекс категории
    u32 actCount; // Количество ДУС Переменная i
    bool isChild = false;
    Act act[actCount];
};


struct Data {
    u32 catCount; // Количество категорий
    Cat cat[catCount];

    u32 format; // ROC=1, TFT=2;

    u32 varCount;
    Var var[varCount];

    u32 trigCount;
    //Trig trig[trigCount];
    Trig trig[1];
};


Data data @ 0x08;
