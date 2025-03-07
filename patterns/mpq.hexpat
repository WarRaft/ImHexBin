#pragma description Warcraft.mpq
#pragma endian little

import std.io;
import std.mem;
import std.string;
import std.core;

// http://www.zezula.net/en/mpq/mpqformat.html
// https://web.archive.org/web/20120222093346/https://wiki.devklog.net/index.php?title=The_MoPaQ_Archive_Format#Conversion_of_FILETIME_And_time_t

// MPQ user data
struct TMPQUserData
{
    // The ID_MPQ_USERDATA ('MPQ\x1B') signature


    // Maximum size of the user data
    u32 cbUserDataSize;

    // Offset of the MPQ header, relative to the begin of this header
    u32 dwHeaderOffs;

    // Appears to be size of user data header (Starcraft II maps)
    u32 cbUserDataHeader;
};

struct BET {
 // Common header, for both HET and BET tables
    u32 dwSignature;                      // 'BET\x1A'
    u32 dwVersion;                        // Version. Seems to be always 1
    u32 dwDataSize;                       // Size of the contained table

    u32 dwTableSize;                      // Size of the entire hash table, including the header (in bytes)
    u32 dwFileCount;                      // Number of files in the BET table
    u32 dwUnknown08;                      // Unknown, set to 0x10
    u32 dwTableEntrySize;                 // Size of one table entry (in bits)
    u32 dwBitIndex_FilePos;               // Bit index of the file position (within the entry record)
    u32 dwBitIndex_FileSize;              // Bit index of the file size (within the entry record)
    u32 dwBitIndex_CmpSize;               // Bit index of the compressed size (within the entry record)
    u32 dwBitIndex_FlagIndex;             // Bit index of the flag index (within the entry record)
    u32 dwBitIndex_Unknown;               // Bit index of the ??? (within the entry record)
    u32 dwBitCount_FilePos;               // Bit size of file position (in the entry record)
    u32 dwBitCount_FileSize;              // Bit size of file size (in the entry record)
    u32 dwBitCount_CmpSize;               // Bit size of compressed file size (in the entry record)
    u32 dwBitCount_FlagIndex;             // Bit size of flags index (in the entry record)
    u32 dwBitCount_Unknown;               // Bit size of ??? (in the entry record)
    u32 dwTotalBetHashSize;               // Total size of the BET hash
    u32 dwBetHashSizeExtra;               // Extra bits in the BET hash
    u32 dwBetHashSize;                    // Effective size of BET hash (in bits)
    u32 dwBetHashArraySize;               // Size of BET hashes array, in bytes
    u32 dwFlagCount;                      // Number of flags in the following array

    // Followed by array of file flags. Each entry is 32-bit size and its meaning is the same like
    u32 dwFlagsArray[dwFlagCount];

    // File table. Size of each entry is taken from dwTableEntrySize.
    // Size of the table is (dwTableEntrySize * dwMaxFileCount), round up to 8.

    // Array of BET hashes. Table size is taken from dwMaxFileCount from HET table
};


// MPQ file header
struct TMPQHeader
{
    // The ID_MPQ ('MPQ\x1A') signature

    // Size of the archive header
    u32 dwHeaderSize;

    // Size of MPQ archive
    // This field is deprecated in the Burning Crusade MoPaQ format, and the size of the archive
    // is calculated as the size from the beginning of the archive to the end of the hash table,
    // block table, or extended block table (whichever is largest).
    u32 dwArchiveSize;

    // 0 = Format 1 (up to The Burning Crusade)
    // 1 = Format 2 (The Burning Crusade and newer)
    // 2 = Format 3 (WoW - Cataclysm beta or newer)
    // 3 = Format 4 (WoW - Cataclysm beta or newer)
    u16 wFormatVersion;

    // Power of two exponent specifying the number of 512-byte disk sectors in each logical sector
    // in the archive. The size of each logical sector in the archive is 512 * 2^wBlockSize.
    u16 wBlockSize;

    // Offset to the beginning of the hash table, relative to the beginning of the archive.
    u32 dwHashTablePos;

    // Offset to the beginning of the block table, relative to the beginning of the archive.
    u32 dwBlockTablePos;

    // Number of entries in the hash table. Must be a power of two, and must be less than 2^16 for
    // the original MoPaQ format, or less than 2^20 for the Burning Crusade format.
    u32 dwHashTableSize;

    // Number of entries in the block table
    u32 dwBlockTableSize;


    if (wFormatVersion >= 1) {
        //-- MPQ HEADER v 2 -------------------------------------------

        // Offset to the beginning of array of 16-bit high parts of file offsets.
        u64 HiBlockTablePos64;

        // High 16 bits of the hash table offset for large archives.
        u16 wHashTablePosHi;

        // High 16 bits of the block table offset for large archives.
        u16 wBlockTablePosHi;
    }


    if (wFormatVersion >= 2) {
        //-- MPQ HEADER v 3 -------------------------------------------

        // 64-bit version of the archive size
        u64 ArchiveSize64;

        // 64-bit position of the BET table
        u64 BetTablePos64;

        // 64-bit position of the HET table
        u64 HetTablePos64;
    }

    if (wFormatVersion >= 3) {
        //-- MPQ HEADER v 4 -------------------------------------------

        // Compressed size of the hash table
        u64 HashTableSize64;

        // Compressed size of the block table
        u64 BlockTableSize64;

        // Compressed size of the hi-block table
        u64 HiBlockTableSize64;

        // Compressed size of the HET block
        u64 HetTableSize64;

        // Compressed size of the BET block
        u64 BetTableSize64;

        // Size of raw data chunk to calculate MD5.
        // MD5 of each data chunk follows the raw file data.
        u32 dwRawChunkSize;

        // Array of MD5's
        u32 MD5_DIGEST_SIZE = 16;

        u8 MD5_BlockTable[MD5_DIGEST_SIZE];      // MD5 of the block table before decryption
        u8 MD5_HashTable[MD5_DIGEST_SIZE];       // MD5 of the hash table before decryption
        u8 MD5_HiBlockTable[MD5_DIGEST_SIZE];    // MD5 of the hi-block table
        u8 MD5_BetTable[MD5_DIGEST_SIZE];        // MD5 of the BET table before decryption
        u8 MD5_HetTable[MD5_DIGEST_SIZE];        // MD5 of the HET table before decryption
        u8 MD5_MpqHeader[MD5_DIGEST_SIZE];       // MD5 of the MPQ header from signature to (including) MD5_HetTable
    }
};

struct Header {
    char magick[4];
    match (magick){
        ("MPQ\x1B") : TMPQUserData data;
        ("MPQ\x1A") : {
            TMPQHeader data;
            //BET bet @ data.HetTablePos64;
        }
    }
};


struct Data {
    char magick[4]; //HM3W

    if (magick == "HM3W"){
        u32;
        char mapname[];
        u32;
        u32;

        Header header @ 0x200;
    }

};

Data data @ 0x00;
