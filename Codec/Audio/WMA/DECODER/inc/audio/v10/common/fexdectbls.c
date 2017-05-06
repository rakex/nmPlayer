//*@@@+++@@@@******************************************************************
//
// Microsoft Windows Media
// Copyright (C) Microsoft Corporation. All rights reserved.
//
//*@@@---@@@@******************************************************************

#include "fexdectbls.h"

#if defined(BUILD_WMAPROLBRV1)

AVRT_DATA const U16 g_fexHuffScaleDec[308] = {
    0x0004, 0x00af, 0x00f6, 0x010d, 0x0004, 0x004f, 0x0062, 0x008d,
    0x0004, 0x0007, 0x000a, 0x0045, 0x9c26, 0x9c26, 0x9c51, 0x9c51,
    0x9c52, 0x9c52, 0x9c49, 0x9c49, 0x9c50, 0x9c50, 0xa065, 0x0001,
    0xa411, 0xa411, 0x0002, 0x0031, 0x0004, 0xb080, 0xac0c, 0xac0c,
    0x0004, 0xb883, 0xb405, 0xb405, 0xbc84, 0xbc84, 0x0002, 0x0003,
    0xc489, 0xc48b, 0xc487, 0x0001, 0x0002, 0x0011, 0x0002, 0x0009,
    0x0002, 0x0005, 0x0002, 0xd488, 0xd89a, 0xd89b, 0xd48c, 0xd48d,
    0x0002, 0x0003, 0xd48e, 0xd48f, 0xd490, 0xd491, 0x0002, 0x0007,
    0x0002, 0x0003, 0xd492, 0xd493, 0xd494, 0xd495, 0x0002, 0x0003,
    0xd496, 0xd497, 0xd498, 0xd499, 0xac78, 0xac78, 0xac7a, 0xac7a,
    0x9c4e, 0x9c4e, 0x9c53, 0x9c53, 0x0004, 0x0007, 0x000a, 0x000d,
    0x9c4f, 0x9c4f, 0x9c23, 0x9c23, 0x9c55, 0x9c55, 0x9c56, 0x9c56,
    0x9c54, 0x9c54, 0x9c57, 0x9c57, 0x9c24, 0x9c24, 0x9c22, 0x9c22,
    0x0004, 0x001f, 0x0022, 0x0025, 0xa016, 0x0003, 0x9c5a, 0x9c5a,
    0x0004, 0x0013, 0xa46e, 0xa46e, 0xac79, 0xac79, 0x0002, 0x0009,
    0xb406, 0xb406, 0x0002, 0xb882, 0xbc8a, 0xbc8a, 0xbc86, 0xbc86,
    0xb404, 0xb404, 0xb402, 0xb402, 0xac7b, 0xac7b, 0xac7d, 0xac7d,
    0x9c59, 0x9c59, 0x9c58, 0x9c58, 0x9c20, 0x9c20, 0x9c21, 0x9c21,
    0x9c5c, 0x9c5c, 0x9c5b, 0x9c5b, 0x0004, 0x0007, 0x0012, 0x0015,
    0xa015, 0xa067, 0x9c1f, 0x9c1f, 0xa066, 0xa013, 0xa014, 0x0001,
    0xa874, 0x0003, 0xa410, 0xa410, 0xac7c, 0xac7c, 0xb008, 0xb009,
    0x9c18, 0x9c18, 0x9c5d, 0x9c5d, 0x9c1e, 0x9c1e, 0x9c1d, 0x9c1d,
    0x0004, 0x002b, 0x0032, 0x0041, 0x0004, 0x0007, 0x0012, 0x0021,
    0x9c5e, 0x9c5e, 0xa069, 0xa012, 0x0004, 0xa068, 0x9c1c, 0x9c1c,
    0xa80e, 0x0003, 0xa46f, 0xa46f, 0xac0b, 0xac0b, 0xac7e, 0xac7e,
    0x9c5f, 0x9c5f, 0x0002, 0xa06a, 0xa470, 0xa470, 0xa875, 0x0001,
    0x0004, 0xb003, 0xac7f, 0xac7f, 0xb800, 0xb885, 0xb401, 0xb401,
    0x9c60, 0x9c60, 0x9c1b, 0x9c1b, 0x0004, 0x982c, 0x982d, 0x9830,
    0x9c61, 0x9c61, 0x9c19, 0x9c19, 0x0004, 0x982f, 0x983a, 0x9836,
    0x9c1a, 0x9c1a, 0x0002, 0x0005, 0xa40f, 0xa40f, 0xa80d, 0xa877,
    0xa472, 0xa472, 0xa471, 0xa471, 0x982e, 0x9837, 0x982b, 0x9833,
    0x0004, 0x0007, 0x000a, 0x000d, 0x983d, 0x9838, 0x9832, 0x9831,
    0x983f, 0x9839, 0x983c, 0x9829, 0x9845, 0x9840, 0x9828, 0x9846,
    0x0004, 0x9841, 0x983b, 0x9844, 0x9c17, 0x9c17, 0xa06c, 0xa06b,
    0x0004, 0x0007, 0x000a, 0x0011, 0x982a, 0x9842, 0x9827, 0x9848,
    0x9835, 0x9834, 0x9843, 0x984a, 0x9847, 0x983e, 0x984c, 0x0001,
    0x9c62, 0x9c62, 0x9c63, 0x9c63, 0x984d, 0x984b, 0x9825, 0x0001,
    0x0004, 0xa06d, 0x9c64, 0x9c64, 0x0004, 0xa876, 0xa473, 0xa473,
    0xb007, 0xb081, 0xac0a, 0xac0a
};

AVRT_DATA const U16 g_fexHuffScaleDecPred[216] = {
    0x0004, 0x008f, 0x009e, 0x8835, 0x9033, 0x0003, 0x8c36, 0x8c36,
    0x982e, 0x0003, 0x9430, 0x9430, 0xa03d, 0x0003, 0x9c2c, 0x9c2c,
    0x0004, 0xa843, 0x000a, 0xa826, 0xac46, 0xac46, 0x0002, 0xb049,
    0xb41f, 0xb41f, 0xb44c, 0xb44c, 0xac24, 0xac24, 0x0002, 0xb022,
    0xb81b, 0x0003, 0x0066, 0x0069, 0xc051, 0x0003, 0xbc19, 0xbc19,
    0x0002, 0x003f, 0x0002, 0x001f, 0x0002, 0x000f, 0x0002, 0x0007,
    0x0002, 0x0003, 0xd810, 0xd811, 0xd812, 0xd813, 0x0002, 0x0003,
    0xd814, 0xd815, 0xd80b, 0xd816, 0x0002, 0x0007, 0x0002, 0x0003,
    0xd852, 0xd853, 0xd854, 0xd855, 0x0002, 0x0003, 0xd856, 0xd857,
    0xd858, 0xd859, 0x0002, 0x000f, 0x0002, 0x0007, 0x0002, 0x0003,
    0xd85a, 0xd85b, 0xd85c, 0xd85d, 0x0002, 0x0003, 0xd85e, 0xd85f,
    0xd860, 0xd861, 0x0002, 0x0007, 0x0002, 0x0003, 0xd862, 0xd863,
    0xd864, 0xd865, 0x0002, 0x0003, 0xd866, 0xd867, 0xd868, 0xd869,
    0x0002, 0x0011, 0x0002, 0x0009, 0x0002, 0x0005, 0x0002, 0xd404,
    0xd86a, 0xd86b, 0xd403, 0xd402, 0x0002, 0x0003, 0xd401, 0xd405,
    0xd406, 0xd407, 0x0002, 0x0007, 0x0002, 0x0003, 0xd408, 0xd400,
    0xd409, 0xd40a, 0x0002, 0x0003, 0xd40c, 0xd40d, 0xd40e, 0xd40f,
    0xbc18, 0xbc18, 0xbc4f, 0xbc4f, 0xbc50, 0xbc50, 0xbc17, 0xbc17,
    0x9032, 0x0003, 0x8c34, 0x8c34, 0x9438, 0x9438, 0x0002, 0x983a,
    0xa02a, 0x0003, 0x9c3c, 0x9c3c, 0xa440, 0xa440, 0xa428, 0xa428,
    0x9037, 0x0003, 0x9031, 0x0021, 0x982d, 0x0003, 0x942f, 0x942f,
    0xa03e, 0x0003, 0x9c2b, 0x9c2b, 0xa844, 0x0003, 0xa825, 0x000d,
    0xac47, 0xac47, 0x0002, 0x0005, 0xb81a, 0xb84e, 0xb41d, 0xb41d,
    0xb41e, 0xb41e, 0xb44d, 0xb44d, 0xb04a, 0x0003, 0xac23, 0xac23,
    0xb44b, 0xb44b, 0xb41c, 0xb41c, 0x9439, 0x9439, 0x0002, 0x983b,
    0x0004, 0xa029, 0x0006, 0xa03f, 0xa441, 0xa441, 0xa427, 0xa427,
    0xa845, 0x0003, 0xa442, 0xa442, 0xb021, 0xb020, 0xac48, 0xac48
};

AVRT_DATA const I32 g_fexHuffScaleMinSym = 16;
AVRT_DATA const I32 g_fexHuffScaleMaxSym = 169;
AVRT_DATA const I32 g_fexHuffScaleMinBits = 4;
AVRT_DATA const I32 g_fexHuffScaleMaxBits = 6;

AVRT_DATA const I32 g_fexHuffScalePredMinSym = 64;
AVRT_DATA const I32 g_fexHuffScalePredMaxSym = 169;
AVRT_DATA const I32 g_fexHuffScalePredMinBits = 6;
AVRT_DATA const I32 g_fexHuffScalePredMaxBits = 6;
AVRT_DATA const I32 g_fexHuffScalePredOffset = 116;

#ifdef BUILD_WMAPROLBRV2
AVRT_DATA const U16 g_fexScFacLevelDecTableIntra_1dB[220] =
{
    0x0004, 0x0033, 0x006a, 0x006d, 0x901e, 0x9021, 0x0002, 0x0005, 
    0x9423, 0x9423, 0x941b, 0x941b, 0x0004, 0x000b, 0x9818, 0x0015, 
    0xa013, 0xa061, 0x0002, 0xa02b, 0xa85a, 0xa85b, 0xa42e, 0xa42e, 
    0x9c28, 0x9c28, 0x0002, 0x0005, 0xa410, 0xa410, 0xa80d, 0xa85c, 
    0xa42f, 0xa42f, 0xa430, 0xa430, 0x0004, 0x0007, 0x9c15, 0x9c15, 
    0xa431, 0xa431, 0xa432, 0xa432, 0xa433, 0xa433, 0x0002, 0xa80c, 
    0xac60, 0xac60, 0xac09, 0xac09, 0x901d, 0x0003, 0x9022, 0x0015, 
    0x9826, 0x0003, 0x9424, 0x9424, 0x0004, 0x0007, 0xa012, 0x0009, 
    0xa434, 0xa434, 0xa435, 0xa435, 0xa436, 0xa436, 0xa437, 0xa437, 
    0xa438, 0xa438, 0xa439, 0xa439, 0x941a, 0x941a, 0x0002, 0x000d, 
    0x0004, 0x0007, 0x9c29, 0x9c29, 0xa43a, 0xa43a, 0xa40f, 0xa40f, 
    0xa85d, 0xa80b, 0xa43b, 0xa43b, 0x0004, 0x0007, 0x000a, 0xa02c, 
    0xa43c, 0xa43c, 0xa43d, 0xa43d, 0xa43e, 0xa43e, 0xa43f, 0xa43f, 
    0xa440, 0xa440, 0xa441, 0xa441, 0x8c1f, 0x8c1f, 0x8c20, 0x8c20, 
    0x901c, 0x0003, 0x002a, 0x0049, 0x9817, 0x0003, 0x001a, 0x9827, 
    0x0004, 0x0007, 0x000a, 0x000d, 0xa442, 0xa442, 0xa443, 0xa443, 
    0xa444, 0xa444, 0xa445, 0xa445, 0xa446, 0xa446, 0xa447, 0xa447, 
    0xa85e, 0x0003, 0xa448, 0xa448, 0xb004, 0xb003, 0xac08, 0xac08, 
    0x9c14, 0x9c14, 0x0002, 0x0005, 0xa449, 0xa449, 0xa44a, 0xa44a, 
    0xa44b, 0xa44b, 0xa44c, 0xa44c, 0x0004, 0x000f, 0x9425, 0x9425, 
    0xa02d, 0x0003, 0x0006, 0xa011, 0xa44d, 0xa44d, 0xa44e, 0xa44e, 
    0xa44f, 0xa44f, 0xa450, 0xa450, 0x9c2a, 0x9c2a, 0x0002, 0x0009, 
    0xa451, 0xa451, 0x0002, 0xa85f, 0xac07, 0xac07, 0xac06, 0xac06, 
    0xa452, 0xa452, 0xa40e, 0xa40e, 0x9419, 0x9419, 0x9816, 0x0001, 
    0x0004, 0x0007, 0x000a, 0x0015, 0xa453, 0xa453, 0xa454, 0xa454, 
    0xa455, 0xa455, 0xa456, 0xa456, 0xa457, 0xa457, 0xa80a, 0x0001, 
    0xac05, 0xac05, 0x0002, 0xb002, 0xb401, 0xb401, 0xb400, 0xb400, 
    0xa458, 0xa458, 0xa459, 0xa459
};

AVRT_DATA const U16 g_fexScFacLevelDecTableInter_1dB[68] =
{
    0x0004, 0x0013, 0x0022, 0x0031, 0x9012, 0x0003, 0x8c10, 0x8c10, 
    0x9414, 0x9414, 0x9816, 0x0001, 0xa006, 0x0003, 0x9c18, 0x9c18, 
    0xa404, 0xa404, 0xa41d, 0xa41d, 0x900d, 0x0003, 0x8c0f, 0x8c0f, 
    0x940b, 0x940b, 0x9809, 0x0001, 0xa01b, 0x0003, 0x9c07, 0x9c07, 
    0xa403, 0xa403, 0xa41e, 0xa41e, 0x8c11, 0x8c11, 0x9013, 0x0001, 
    0x9415, 0x9415, 0x9817, 0x0001, 0x9c19, 0x9c19, 0xa005, 0x0001, 
    0xa801, 0xa800, 0xa41f, 0xa41f, 0x8c0e, 0x8c0e, 0x900c, 0x0001, 
    0x940a, 0x940a, 0x0002, 0x9808, 0xa01c, 0x0003, 0x9c1a, 0x9c1a, 
    0xa402, 0xa402, 0xa420, 0xa420
};

AVRT_DATA const U16 g_fexScFacLevelDecTableCh_1dB[68] =
{
    0x0004, 0x0007, 0x003e, 0x8810, 0x8c11, 0x8c11, 0x8c0f, 0x8c0f, 
    0x0004, 0x0033, 0x9013, 0x900d, 0x0004, 0x002b, 0x9815, 0x980b, 
    0x0004, 0x0023, 0xa017, 0xa009, 0x0004, 0x0007, 0xa819, 0x0011, 
    0xac07, 0xac07, 0xac1a, 0xac1a, 0x0004, 0xb005, 0xac06, 0xac06, 
    0x0004, 0xb81e, 0xb41d, 0xb41d, 0xc001, 0xc000, 0xbc03, 0xbc03, 
    0xac1b, 0xac1b, 0xb01c, 0x0001, 0x0004, 0xb81f, 0xb404, 0xb404, 
    0xbc20, 0xbc20, 0xbc02, 0xbc02, 0xa418, 0xa418, 0xa408, 0xa408, 
    0x9c0a, 0x9c0a, 0x9c16, 0x9c16, 0x940c, 0x940c, 0x9414, 0x9414, 
    0x8c12, 0x8c12, 0x8c0e, 0x8c0e
};

AVRT_DATA const U16 g_fexScFacLevelDecTableRecon_1dB[68] =
{
    0x8410, 0x8410, 0x880f, 0x0001, 0x0004, 0x0013, 0x8c0e, 0x8c0e, 
    0x940d, 0x940d, 0x9811, 0x0001, 0xa013, 0x0003, 0x9c12, 0x9c12, 
    0xa816, 0x0003, 0xa408, 0xa408, 0xb019, 0xb003, 0xac18, 0xac18, 
    0x0004, 0x0013, 0x940c, 0x940c, 0x9c0b, 0x9c0b, 0x0002, 0xa014, 
    0xa415, 0xa415, 0x0002, 0xa806, 0xac05, 0xac05, 0xb01a, 0x0001, 
    0xb800, 0xb81d, 0xb402, 0xb402, 0xa009, 0x0003, 0x9c0a, 0x9c0a, 
    0xa817, 0x0003, 0xa407, 0xa407, 0x0004, 0x000b, 0xac04, 0xac04, 
    0xb41b, 0xb41b, 0x0002, 0xb81e, 0xbc1f, 0xbc1f, 0xbc20, 0xbc20, 
    0xb401, 0xb401, 0xb41c, 0xb41c
};

AVRT_DATA const U16 g_fexScFacRunLevelDecTableIntra_3dB[124] =
{
    0x0004, 0x8800, 0x001e, 0x880d, 0x9017, 0x9001, 0x0002, 0x900e, 
    0x9402, 0x9402, 0x0002, 0x9803, 0x0004, 0xa027, 0x9c10, 0x9c10, 
    0xa828, 0x0003, 0xa437, 0xa437, 0x0004, 0xb031, 0x0006, 0xb008, 
    0xb424, 0xb424, 0xb409, 0xb409, 0xb438, 0xb438, 0xb835, 0xb81e, 
    0x0004, 0x004b, 0x004e, 0x901f, 0x0004, 0x001f, 0x0042, 0x982b, 
    0x0004, 0x0013, 0x9c19, 0x9c19, 0xa830, 0xa81b, 0x0002, 0x0005, 
    0xac2d, 0xac2d, 0xac07, 0xac07, 0xb014, 0x0003, 0xac13, 0xac13, 
    0xb41d, 0xb41d, 0xb42a, 0xb42a, 0xa42c, 0xa42c, 0xa822, 0x0001, 
    0xac1c, 0xac1c, 0xac34, 0xac34, 0xa033, 0x0003, 0x9c2f, 0x9c2f, 
    0xa43b, 0xa43b, 0x0002, 0x0011, 0x0004, 0x000b, 0xac29, 0xac29, 
    0xb836, 0xb825, 0xb816, 0x0001, 0xc00a, 0xc00c, 0xbc0b, 0xbc0b, 
    0xb415, 0xb415, 0xb43c, 0xb43c, 0xb02e, 0x0003, 0xac23, 0xac23, 
    0xb432, 0xb432, 0x0002, 0xb83d, 0xbc39, 0xbc39, 0xbc3a, 0xbc3a, 
    0x9c04, 0x9c04, 0xa011, 0xa021, 0x9418, 0x9418, 0x940f, 0x940f, 
    0x9426, 0x9426, 0x0002, 0x9820, 0xa005, 0xa01a, 0x0002, 0xa03e, 
    0xa406, 0xa406, 0xa412, 0xa412, 
};

AVRT_DATA const U16 g_fexScFacRunLevelDecTableInter_3dB[112] =
{
    0x8800, 0x0003, 0x0006, 0x8811, 0x8c01, 0x8c01, 0x9012, 0x9002, 
    0x0004, 0x0007, 0x000e, 0x901e, 0x9403, 0x9403, 0x9413, 0x9413, 
    0x9804, 0x981f, 0x9814, 0x0001, 0x9c05, 0x9c05, 0x9c15, 0x9c15, 
    0x0004, 0x0007, 0x9827, 0x0029, 0xa028, 0xa016, 0x9c20, 0x9c20, 
    0xa006, 0xa021, 0x0002, 0x0005, 0xa422, 0xa422, 0xa407, 0xa407, 
    0x0004, 0x0017, 0xa417, 0xa417, 0x0004, 0xb036, 0x0006, 0xb025, 
    0xb40a, 0xb40a, 0xb41a, 0xb41a, 0xb837, 0x0003, 0xb41b, 0xb41b, 
    0xbc0d, 0xbc0d, 0x0002, 0x0003, 0xc41d, 0xc40e, 0xc40f, 0xc410, 
    0xac2b, 0xac2b, 0xb034, 0xb031, 0x0004, 0x0007, 0xa02e, 0x000d, 
    0xa808, 0xa82a, 0xa429, 0xa429, 0xa823, 0xa818, 0x0002, 0xa833, 
    0xac09, 0xac09, 0xac24, 0xac24, 0x0004, 0x000b, 0xa42f, 0xa42f, 
    0x0004, 0xb02c, 0xac30, 0xac30, 0xb432, 0xb432, 0xb426, 0xb426, 
    0xac19, 0xac19, 0x0002, 0x0009, 0x0004, 0xb80c, 0xb435, 0xb435, 
    0xbc1c, 0xbc1c, 0xbc38, 0xbc38, 0xb42d, 0xb42d, 0xb40b, 0xb40b, 
};

AVRT_DATA const U16 g_fexScFacRunLevelDecTableIntpl_3dB[188] =
{
    0x0004, 0x8819, 0x002e, 0x0051, 0x8c1a, 0x8c1a, 0x901c, 0x0001, 
    0x981f, 0x0003, 0x941e, 0x941e, 0x9c04, 0x9c04, 0x0002, 0x0011, 
    0x0004, 0xa849, 0xa448, 0xa448, 0xb04e, 0xb00b, 0xb027, 0x0001, 
    0xb82b, 0x0003, 0xb428, 0xb428, 0xc013, 0xc046, 0xbc11, 0xbc11, 
    0xa423, 0xa423, 0xa809, 0x0001, 0x0004, 0xb03d, 0xac0a, 0xac0a, 
    0x0004, 0xb85a, 0xb43f, 0xb43f, 0xbc10, 0xbc10, 0xbc12, 0xbc12, 
    0x0004, 0x0007, 0x8c1b, 0x8c1b, 0x9834, 0x9802, 0x9400, 0x9400, 
    0x0004, 0x0007, 0x9433, 0x9433, 0xa006, 0xa038, 0x9c37, 0x9c37, 
    0x0004, 0xa022, 0x9c21, 0x9c21, 0xa84b, 0xa825, 0xa84a, 0x0001, 
    0xac4d, 0xac4d, 0x0002, 0xb00d, 0xb82c, 0xb80e, 0xb850, 0x0001, 
    0xc045, 0xc044, 0xc043, 0xc053, 0x901d, 0x0003, 0x0006, 0x9032, 
    0x9803, 0x9835, 0x9401, 0x9401, 0x0004, 0x9820, 0x9836, 0x0011, 
    0xa047, 0x0003, 0x9c05, 0x9c05, 0xa43a, 0xa43a, 0x0002, 0xa84c, 
    0xb00c, 0xb058, 0x0002, 0xb04f, 0xb459, 0xb459, 0xb42a, 0xb42a, 
    0xa007, 0x0003, 0x0042, 0xa039, 0xa83b, 0x0003, 0xa424, 0xa424, 
    0x0004, 0x0017, 0x002a, 0x0035, 0x0004, 0x0007, 0x000a, 0x000d, 
    0xc054, 0xc055, 0xc056, 0xc057, 0xc031, 0xc030, 0xc02f, 0xc02e, 
    0xc02d, 0xc018, 0xc017, 0xc016, 0xc060, 0xc061, 0xc062, 0xc063, 
    0x0004, 0x0007, 0x000a, 0x000d, 0xc064, 0xc015, 0xc066, 0xc067, 
    0xc068, 0xc069, 0xc06a, 0xc06b, 0xc06c, 0xc06d, 0xbc52, 0xbc52, 
    0xbc51, 0xbc51, 0xbc5d, 0xbc5d, 0x0004, 0x0007, 0xb85b, 0xb840, 
    0xbc5e, 0xbc5e, 0xbc5f, 0xbc5f, 0xbc65, 0xbc65, 0xbc14, 0xbc14, 
    0xb841, 0xb842, 0xb85c, 0xb80f, 0xa408, 0xa408, 0x0002, 0xa826, 
    0xac3c, 0xac3c, 0xb029, 0xb03e, 
};

AVRT_DATA const U16 g_fexScFacRunLevelDecTableCh_3dB[56] =
{
    0x0004, 0x0007, 0x8400, 0x8400, 0x8c01, 0x8c01, 0x9002, 0x900a, 
    0x0004, 0x000f, 0x9003, 0x001d, 0x9812, 0x0003, 0x940b, 0x940b, 
    0x0004, 0xa00e, 0x9c0d, 0x9c0d, 0xa810, 0xa81b, 0xa40f, 0xa40f, 
    0x980c, 0x0003, 0x941d, 0x941d, 0xa013, 0xa017, 0x0002, 0xa007, 
    0x0004, 0xa816, 0xa408, 0xa408, 0xac09, 0xac09, 0xb01a, 0xb01c, 
    0x9404, 0x9404, 0x9805, 0x0001, 0x9c06, 0x9c06, 0x0002, 0xa014, 
    0xa818, 0x0003, 0xa415, 0xa415, 0xac19, 0xac19, 0xac11, 0xac11
};

AVRT_DATA const U16 g_fexScFacRunLevelDecTableRecon_3dB[68] =
{
    0x8800, 0x0003, 0x0026, 0x0035, 0x9012, 0x0003, 0x9002, 0x9003, 
    0x0004, 0x9813, 0x0006, 0x0019, 0x9c06, 0x9c06, 0x9c17, 0x9c17, 
    0x0004, 0x0007, 0x000a, 0x000d, 0xa40e, 0xa40e, 0xa40f, 0xa40f, 
    0xa410, 0xa410, 0xa411, 0xa411, 0xa41f, 0xa41f, 0xa41b, 0xa41b, 
    0xa41c, 0xa41c, 0xa41d, 0xa41d, 0x9c07, 0x9c07, 0x9c08, 0x9c08, 
    0x8c01, 0x8c01, 0x0002, 0x9004, 0x0004, 0x0007, 0x9814, 0x9815, 
    0x9c09, 0x9c09, 0x9c0a, 0x9c0a, 0x9c0b, 0x9c0b, 0x9c1e, 0x9c1e, 
    0x8c20, 0x8c20, 0x9005, 0x0001, 0x9418, 0x9418, 0x9816, 0x0001, 
    0xa019, 0xa00c, 0xa01a, 0xa00d
};

AVRT_DATA const U8 g_fexScFacLevelIntpl_3dB[117] =
{
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
    5, 5, 5, 5, 5, 5, 5, 5, 5,
    6, 6, 6, 6, 6, 6, 6,
};

AVRT_DATA const U8 g_fexScFacRunIntpl_3dB[117] =
{
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,
    0, 1, 2, 3, 4, 5, 6, 7, 8,
    0, 1, 2, 3, 4, 5, 6,
};

AVRT_DATA const U8 g_fexScFacLevelInter_3dB[57] =
{
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    3, 3, 3, 3, 3, 3, 3, 3, 3,
    4, 4, 4, 4, 4, 4, 4,
    5, 5, 5, 5, 5,
    6, 6, 6,
    7, 7, 7,
};

AVRT_DATA const U8 g_fexScFacRunInter_3dB[57] =
{
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,
    0, 1, 2, 3, 4, 5, 6, 7, 8,
    0, 1, 2, 3, 4, 5, 6,
    0, 1, 2, 3, 4,
    0, 1, 2,
    0, 1, 2,
};

AVRT_DATA const U8 g_fexScFacLevelIntra_3dB[62] =
{
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    3, 3, 3, 3, 3, 3, 3, 3,
    4, 4, 4, 4, 4, 4, 4,
    5, 5, 5, 5, 5,
    6, 6, 6, 6,
    7, 7, 7, 7,
    8, 8, 8, 8,
    9, 9, 9, 9,
   10,10,10,
};

AVRT_DATA const U8 g_fexScFacRunIntra_3dB[62] =
{
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    0, 1, 2, 3, 4, 5, 6, 7,
    0, 1, 2, 3, 4, 5, 6,
    0, 1, 2, 3, 4,
    0, 1, 2, 3,
    0, 1, 2, 3,
    0, 1, 2, 3,
    0, 1, 2, 3,
    0, 1, 2,
};

AVRT_DATA const U8 g_fexScFacLevelCh_3dB[29] =
{
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    2, 2, 2, 2, 2, 2, 2, 2,
    3, 3, 3, 3, 3,
    4, 4, 4, 4,
    5, 5,
};

AVRT_DATA const U8 g_fexScFacRunCh_3dB[29] =
{
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    0, 1, 2, 3, 4, 5, 6, 7,
    0, 1, 2, 3, 4,
    0, 1, 2, 3,
    0, 1
};

AVRT_DATA const U8 g_fexScFacLevelRecon_3dB[32] =
{
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    2, 2, 2, 2, 2, 2,
    3, 3, 3, 3, 3, 3,
    4,
    5,
};

AVRT_DATA const U8 g_fexScFacRunRecon_3dB[32] =
{
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,
    0, 1, 2, 3, 4, 5,
    0, 1, 2, 3, 4, 5,
    0,
    0,
};

AVRT_DATA const I16 g_fexScaleIntpl    = 0x7fff;

AVRT_DATA const I16 g_fexScaleMaxLevel_1dB = 127;
AVRT_DATA const I16 g_fexScaleMinLevelIntra_1dB = -32;
AVRT_DATA const I16 g_fexScaleMaxLevelIntra_1dB = 64;
AVRT_DATA const I16 g_fexScaleMinLevelInter_1dB = -16;
AVRT_DATA const I16 g_fexScaleMaxLevelInter_1dB = 16;
AVRT_DATA const I16 g_fexScaleMinLevelCh_1dB = -16;
AVRT_DATA const I16 g_fexScaleMaxLevelCh_1dB = 16;
AVRT_DATA const I16 g_fexScaleMinLevelRecon_1dB = -16;
AVRT_DATA const I16 g_fexScaleMaxLevelRecon_1dB = 16;

AVRT_DATA const I16 g_fexScaleMaxLevel_3dB = 38;
AVRT_DATA const I16 g_fexScaleRunLevelVLCAtLevelIntpl_3dB[7] = {0, 25, 50, 71, 88, 101, 110};
AVRT_DATA const I16 g_fexScaleRunLevelMaxLevelIntpl_3dB = 6;
AVRT_DATA const I16 g_fexScaleRunLevelVLCAtLevelInter_3dB[9] = {0, 17, 17, 30, 39, 46, 51, 54, 57};
AVRT_DATA const I16 g_fexScaleRunLevelMaxLevelInter_3dB = 8;
AVRT_DATA const I16 g_fexScaleRunLevelVLCAtLevelIntra_3dB[12] = {0, 13, 13, 23, 31, 38, 43, 47, 51, 55, 59, 62};
AVRT_DATA const I16 g_fexScaleRunLevelMaxLevelIntra_3dB = 11;
AVRT_DATA const I16 g_fexScaleRunLevelVLCAtLevelCh_3dB[7] = {0, 0, 10, 18, 23, 27, 29};
AVRT_DATA const I16 g_fexScaleRunLevelMaxLevelCh_3dB = 6;
AVRT_DATA const I16 g_fexScaleRunLevelVLCAtLevelRecon_3dB[7] = {0, 0, 18, 24, 30, 31, 32};
AVRT_DATA const I16 g_fexScaleRunLevelMaxLevelRecon_3dB = 6;

// 0: (0/1/2,Mv,Exp,Sign,Rev,Nf)        5: (0,Mv,Exp,Sign,Rev)or(1,Mv,Sign)     8: (0,Mv,Exp,Sign,Rev)      13: (1,Mv)
// 1: (0/1/2,Mv,Exp,Sign,    Nf)        6: (0,Mv,Exp,Sign    )or(1,Mv,Sign)     9: (0,Mv,Exp,Sign)      
// 2: (0/1/2,Mv,Exp,         Nf)        7: (0,Mv,Exp         )or(1,Mv)         10: (0,Mv,Exp,     Rev)
//                                                                             11: (0,Mv,Exp)
// 3: (0/1,Mv,Exp,Sign,Rev)                                                    12: (0,Mv)
// 4: (0/1,Mv,Exp,     Rev)                                                     
AVRT_DATA const FexMvCodebook g_rgMvCodebook[] = {
    // bPredMv,   bPredExp,   bPredSign,  bPredRev,   bPredNF,    bNoiseMv,   bNoiseExp,  bNoiseSign, bNoiseRev,  #b,ind, #b,ind(w/oNf)
    { WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,   2,  0, -1, -1 },//0
    { WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE,  2,  1, -1, -1 },//1
    { WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE, WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE,  2,  2, -1, -1 },//2

    { WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,   4, 12,  5, 25 },//3
    { WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_TRUE,  WMAB_FALSE, WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_TRUE,   4, 13,  5, 26 },//4

    { WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_TRUE,  WMAB_FALSE, WMAB_TRUE,  WMAB_FALSE, -1, -1,  5, 24 },//5
    { WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE, WMAB_TRUE,  WMAB_FALSE, WMAB_TRUE,  WMAB_FALSE,  4, 14,  2,  0 },//6
    { WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE, WMAB_FALSE,  4, 15,  5, 27 },//7

    { WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, -1, -1,  2,  2 },//8
    { WMAB_TRUE,  WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, -1, -1,  2,  1 },//9
    { WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, -1, -1,  5, 28 },//10
    { WMAB_TRUE,  WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, -1, -1,  5, 29 },//11
    { WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, -1, -1,  5, 30 },//12

    { WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, WMAB_TRUE,  WMAB_FALSE, WMAB_FALSE, WMAB_FALSE, -1, -1,  5, 31 },//13
};
AVRT_DATA const I32   g_cNumMvCodebooks = 14;

AVRT_DATA const I32   g_rgrgcNumScMvBands_8_0[13][2] = {
    {4, 2}, {4, 4}, {5, 3}, {5, 5}, {6, 2}, {6, 3}, {6, 6}, {7, 3}, {7, 5}, {7, 7},
    {8, 4}, {8, 6}, {8, 8}
};
AVRT_DATA const I32   g_rgrgcNumScMvBands_8_1[8][2] = {
    {2, 2}, {3, 2}, {3, 3}, {4, 3}, {5, 2}, {5, 4}, {6, 4}, {6, 5}
};
AVRT_DATA const I32   g_rgrgcNumScMvBands_8_2[8][2] = {
    {1, 1}, {2, 1}, {3, 1}, {4, 1}, {5, 1}, {6, 1}, {7, 1}, {8, 1}
};
AVRT_DATA const I32   g_rgrgcNumScMvBands_8_3[7][2] = {
    {7, 2}, {7, 4}, {7, 6}, {8, 2}, {8, 3}, {8, 5}, {8, 7}
};
AVRT_DATA const I32   g_rgcNumEntriesScMvBands_8[4] = { 13, 8, 8, 7 };
AVRT_DATA const I32   g_rgcBitsScMvBands_8[4] = { 4, 3, 3, 3 };

AVRT_DATA const I32   g_rgrgcNumScMvBands_16_0[29][2] = {
    { 4,  2}, { 4,  4}, { 5,  3}, { 5,  5}, { 6,  3}, { 6,  6}, { 7,  4}, { 7,  7}, { 8,  4}, { 8,  6},
    { 8,  8}, { 9,  5}, { 9,  7}, { 9,  9}, {10,  5}, {10,  7}, {10, 10}, {11,  6}, {11,  8}, {11, 11},
    {12,  6}, {12,  9}, {12, 12}, {13,  7}, {13, 10}, {13, 13}, {14,  7}, {14, 10}, {14, 14}
};
AVRT_DATA const I32   g_rgrgcNumScMvBands_16_1[16][2] = {
    { 2,  2}, { 3,  3}, { 6,  2}, { 7,  2}, { 8,  2}, { 9,  3}, {10,  3}, {11,  3}, {12,  3}, {13,  4},
    {15,  8}, {15, 11}, {15, 15}, {16,  8}, {16, 12}, {16, 16}
};
AVRT_DATA const I32   g_rgrgcNumScMvBands_16_2[32][2] = {
    { 1,  1}, { 2,  1}, { 3,  1}, { 3,  2}, { 4,  1}, { 4,  3}, { 5,  1}, { 5,  2}, { 5,  4}, { 6,  1},
    { 6,  4}, { 6,  5}, { 7,  1}, { 7,  3}, { 7,  5}, { 7,  6}, { 8,  1}, { 8,  3}, { 8,  5}, { 8,  7},
    { 9,  1}, { 9,  2}, { 9,  4}, { 9,  6}, { 9,  8}, {10,  1}, {11,  1}, {12,  1}, {13,  1}, {14,  1},
    {15,  1}, {16,  1}
};
AVRT_DATA const I32   g_rgrgcNumScMvBands_16_3[59][2] = {
    {10,  2}, {10,  4}, {10,  6}, {10,  8}, {10,  9}, {11,  2}, {11,  4}, {11,  5}, {11,  7}, {11,  9},
    {11, 10}, {12,  2}, {12,  4}, {12,  5}, {12,  7}, {12,  8}, {12, 10}, {12, 11}, {13,  2}, {13,  3},
    {13,  5}, {13,  6}, {13,  8}, {13,  9}, {13, 11}, {13, 12}, {14,  2}, {14,  3}, {14,  4}, {14,  5},
    {14,  6}, {14,  8}, {14,  9}, {14, 11}, {14, 12}, {14, 13}, {15,  2}, {15,  3}, {15,  4}, {15,  5}, 
    {15,  6}, {15,  7}, {15,  9}, {15, 10}, {15, 12}, {15, 13}, {15, 14}, {16,  2}, {16,  3}, {16,  4},
    {16,  5}, {16,  6}, {16,  7}, {16,  9}, {16, 10}, {16, 11}, {16, 13}, {16, 14}, {16, 15},
};
AVRT_DATA const I32   g_rgcNumEntriesScMvBands_16[4] = { 29, 16, 32, 59 };
AVRT_DATA const I32   g_rgcBitsScMvBands_16[4] = { 5, 4, 5, 6 };

#ifdef BUILD_WMAPROLBRV3
AVRT_DATA const I16   g_bpeakShiftRange   = 5;
AVRT_DATA const I16   g_bpeakMaxLevel     = 4;
AVRT_DATA const I16   g_bpeakMinMaskDelta = -3;
AVRT_DATA const I16   g_bpeakMaxMaskDelta = 10;

AVRT_DATA const U16 g_bpeakCoefShiftHuffDec[24] = {
    0x0004, 0x880b, 0x8405, 0x8405, 0x9004, 0x0003, 0x8c06, 0x8c06,
    0x9807, 0x9803, 0x0002, 0x0005, 0x9c08, 0x9c08, 0x9c02, 0x9c02,
    0x0004, 0xa001, 0x9c09, 0x9c09, 0xa40a, 0xa40a, 0xa400, 0xa400
};
AVRT_DATA const U16 g_bpeakCoefLevelHuffDec[8] = {
    0x8400, 0x8400, 0x8801, 0x0001, 0x8c02, 0x8c02, 0x9003, 0x9004
};
AVRT_DATA const U16 g_bpeakMaskDeltaHuffDec[32] = {
    0x0004, 0x000b, 0x001a, 0x8803, 0x9006, 0x9002, 0x0002, 0x9007, 
    0x9409, 0x9409, 0x940c, 0x940c, 0x8c04, 0x8c04, 0x0002, 0x0009, 
    0x980e, 0x0003, 0x940a, 0x940a, 0x9c00, 0x9c00, 0x9c0f, 0x9c0f, 
    0x940b, 0x940b, 0x940d, 0x940d, 0x8c05, 0x8c05, 0x9008, 0x9001, 
};
AVRT_DATA const U16 g_bpeakShapeCB1HuffDec[8] = {
    0x8400, 0x8400, 0x0002, 0x8802, 0x8c03, 0x8c03, 0x8c01, 0x8c01
};
AVRT_DATA const U16 g_bpeakShapeCB2HuffDec[12] = {
    0x0004, 0x8800, 0x0006, 0x8802, 0x8c03, 0x8c03, 0x8c05, 0x8c05,
    0x8c06, 0x8c06, 0x9004, 0x9001,
};
#endif
#endif // BUILD_WMAPROLBRV2

#endif // BUILD_WMAPROLBRV1