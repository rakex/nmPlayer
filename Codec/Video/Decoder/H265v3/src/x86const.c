/******************************************************************************************
*                                                                                         *
*  VisualOn, Inc. Confidential and Proprietary, 2012                                      *
*                                                                                         *
*******************************************************************************************/
/** \file     h265dec_sao.c
    \brief    Sample Adaptive Offset(SAO) processing module
    \author   Lina Lv
		\change
							
*/



#include <stdlib.h>
#include <string.h>

#include "h265dec_utils.h"
#include "h265dec_mem.h"

DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_0[8]) = {0,0,0,0,0,0,0,0};
DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_1[8]) = {1,1,1,1,1,1,1,1};
DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_2[8]) = {2,2,2,2,2,2,2,2};

DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_0[16]) = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_1[16]) = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_2[16]) = {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2};
DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_3[16]) = {3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3};
DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_4[16]) = {4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4};


DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F1_01[16]) = {-1,4,-1,4,-1,4,-1,4,-1,4,-1,4,-1,4,-1,4};
DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F1_23[16]) = {-10,58,-10,58,-10,58,-10,58,-10,58,-10,58,-10,58,-10,58};
DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F1_45[16]) = {17,-5,17,-5,17,-5,17,-5,17,-5,17,-5,17,-5,17,-5};
DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F1_67[16]) = {1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0};

DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F2_01[16]) = {  -1,  4, -1, 4, -1, 4, -1, 4, -1, 4, -1, 4, -1, 4, -1, 4};
DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F2_23[16]) = { -11, 40,-11,40,-11, 40, -11, 40,  -11, 40,  -11, 40,  -11, 40,  -11, 40};
DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F2_45[16]) = { 40, -11, 40, -11, 40, -11, 40, -11, 40, -11, 40, -11,40, -11,40, -11};
DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F2_67[16]) = { 4, -1, 4, -1, 4, -1, 4,-1,4,-1,4,-1,4,-1,4,-1};

DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F3_01[16]) = {0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1};
DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F3_23[16]) = {-5,17,-5,17,-5,17,-5,17,-5,17,-5,17,-5,17,-5,17};
DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F3_45[16]) = {58,-10,58,-10,58,-10,58,-10,58,-10,58,-10,58,-10,58,-10};
DECLARE_ALIGNED(16,  const VO_U8, CONST_S8_F3_67[16]) = {4,-1,4,-1,4,-1,4,-1,4,-1,4,-1,4,-1,4,-1};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_POS1[8]) =  {1,1,1,1,1,1,1,1};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_POS4[8]) =  {4,4,4,4,4,4,4,4};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_NEG10[8]) = {-10,-10,-10,-10,-10,-10,-10,-10};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_POS58[8]) = {58,58,58,58,58,58,58,58};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_POS17[8]) = {17,17,17,17,17,17,17,17};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_NEG5[8]) =  {-5,-5,-5,-5,-5,-5,-5,-5};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_POS11[8]) =  {11,11,11,11,11,11,11,11};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_NEG11[8]) =  {-11,-11,-11,-11,-11,-11,-11,-11};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_POS40[8]) = {40,40,40,40,40,40,40,40};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_NEG1[8]) =  {-1,-1,-1,-1,-1,-1,-1,-1};

DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_POS8[8]) =  {8,8,8,8,8,8,8,8};DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_POS32[8]) = {32,32,32,32,32,32,32,32};
DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_POS64[8]) = {64,64,64,64,64,64,64,64};
DECLARE_ALIGNED(16,  const VO_U32, CONST_U32_POS64[4]) = {64,64,64,64};

DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_POS_0X0800[8]) = {0x800,0x800,0x800,0x800,0x800,0x800,0x800,0x800};
DECLARE_ALIGNED(16,  const VO_U32, CONST_U32_POS_0X0800[4]) = {0x800,0x800,0x800,0x800};

DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_POS83[8]) = {83,83,83,83,83,83,83,83};
DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_POS36[8]) = {36,36,36,36,36,36,36,36};

DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_POS_0X7FF[8]) = {0x7FF,0x7FF,0x7FF,0x7FF,0x7FF,0x7FF,0x7FF,0x7FF};
DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_POS_0X8FF[8]) = {0x8FF,0x8FF,0x8FF,0x8FF,0x8FF,0x8FF,0x8FF,0x8FF};

DECLARE_ALIGNED(16,  const VO_U16, CONST_S16_89[8]) = {89,89,89,89,89,89,89,89};
DECLARE_ALIGNED(16,  const VO_U16, CONST_S16_75[8]) = {75,75,75,75,75,75,75,75};
DECLARE_ALIGNED(16,  const VO_U16, CONST_S16_50[8]) = {50,50,50,50,50,50,50,50};
DECLARE_ALIGNED(16,  const VO_U16, CONST_S16_18[8]) = {18,18,18,18,18,18,18,18};

DECLARE_ALIGNED(16,  const VO_U16, CONST_S16_N18[8]) = {-18,-18,-18,-18,-18,-18,-18,-18};
DECLARE_ALIGNED(16,  const VO_U16, CONST_S16_N89[8]) = {-89,-89,-89,-89,-89,-89,-89,-89};
DECLARE_ALIGNED(16,  const VO_U16, CONST_S16_N50[8]) = {-50,-50,-50,-50,-50,-50,-50,-50};
DECLARE_ALIGNED(16,  const VO_U16, CONST_S16_N83[8]) = {-83,-83,-83,-83,-83,-83,-83,-83};
DECLARE_ALIGNED(16,  const VO_U16, CONST_S16_N64[8]) = {-64,-64,-64,-64,-64,-64,-64,-64};


DECLARE_ALIGNED(16,  const VO_S32, CONST_S32_POS4[4]) =  {4,4,4,4};
DECLARE_ALIGNED(16,  const VO_S32, CONST_S32_NEG10[4]) = {-10,-10,-10,-10};
DECLARE_ALIGNED(16,  const VO_S32, CONST_S32_POS58[4]) = {58,58,58,58};
DECLARE_ALIGNED(16,  const VO_S32, CONST_S32_POS17[4]) = {17,17,17,17};
DECLARE_ALIGNED(16,  const VO_S32, CONST_S32_NEG5[4]) =  {-5,-5,-5,-5};
DECLARE_ALIGNED(16,  const VO_S32, CONST_S32_POS11[4]) =  {11,11,11,11};
DECLARE_ALIGNED(16,  const VO_S32, CONST_S32_NEG11[4]) =  {-11,-11,-11,-11};
DECLARE_ALIGNED(16,  const VO_S32, CONST_S32_POS40[4]) = {40,40,40,40};

DECLARE_ALIGNED(16,  const VO_U32, CONST_U32_POS32[4]) = {32,32,32,32};
DECLARE_ALIGNED(16,  const VO_U32, CONST_U32_POS2048[4]) = {2048,2048,2048,2048};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_1_N1[8]) =  {1,-1,1,-1,1,-1,1,-1};
DECLARE_ALIGNED(16,  const VO_S16, CONST_S16_POS74[8]) =  {74,74,74,74,74,74,74,74};

DECLARE_ALIGNED(16,  const VO_U16, g_chromaFilter_x86[256]) =   //[8][32]
  {   0, 0, 0, 0, 0, 0, 0, 0,
     64, 64, 64, 64, 64, 64, 64, 64,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 
      2, 2, 2, 2, 2, 2, 2, 2,
      58, 58, 58, 58, 58, 58, 58, 58,
      10, 10, 10, 10, 10, 10, 10, 10,
      2, 2, 2, 2, 2, 2, 2, 2, 
      4, 4, 4, 4, 4, 4, 4, 4,
      54, 54, 54, 54, 54, 54, 54, 54,
      16, 16, 16, 16, 16, 16, 16, 16,
      2, 2, 2, 2, 2, 2, 2, 2, 
      6, 6, 6, 6, 6, 6, 6, 6,
      46, 46, 46, 46, 46, 46, 46, 46,
      28, 28, 28, 28, 28, 28, 28, 28,
      4, 4, 4, 4, 4, 4, 4, 4,  
      4, 4, 4, 4, 4, 4, 4, 4,
      36, 36, 36, 36, 36, 36, 36, 36,
      36, 36, 36, 36, 36, 36, 36, 36,
      4, 4, 4, 4, 4, 4, 4, 4,  
      4, 4, 4, 4, 4, 4, 4, 4,
      28, 28, 28, 28, 28, 28, 28, 28,
      46, 46, 46, 46, 46, 46, 46, 46,
      6, 6, 6, 6, 6, 6, 6, 6,  
      2, 2, 2, 2, 2, 2, 2, 2,
      16, 16, 16, 16, 16, 16, 16, 16,
      54, 54, 54, 54, 54, 54, 54, 54,
      4, 4, 4, 4, 4, 4, 4, 4,  
      2, 2, 2, 2, 2, 2, 2, 2,
      10, 10, 10, 10, 10, 10, 10, 10,
      58, 58, 58, 58, 58, 58, 58, 58,
      2, 2, 2, 2, 2, 2, 2, 2
  };

DECLARE_ALIGNED(16,  const VO_S8, g_chromaFilter_x86_8[256]) =   //[8][32]
  {  
      0, 64, 0, 64, 0, 64, 0, 64, 0, 64, 0, 64, 0, 64, 0, 64,
	  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	  -2, 58,-2, 58,-2, 58,-2, 58,-2, 58,-2, 58,-2, 58,-2, 58,
	  10, -2,10, -2,10, -2,10, -2,10, -2,10, -2,10, -2,10, -2,
	  -4, 54,-4, 54,-4, 54,-4, 54,-4, 54,-4, 54,-4, 54,-4, 54,
	  16, -2,16, -2,16, -2,16, -2,16, -2,16, -2,16, -2,16, -2,
	  -6, 46,-6, 46,-6, 46,-6, 46,-6, 46,-6, 46,-6, 46,-6, 46,
	  28, -4,28, -4,28, -4,28, -4,28, -4,28, -4,28, -4,28, -4,
	  -4, 36,-4, 36,-4, 36,-4, 36,-4, 36,-4, 36,-4, 36,-4, 36,
	  36, -4,36, -4,36, -4,36, -4,36, -4,36, -4,36, -4,36, -4,
	  -4, 28,-4, 28,-4, 28,-4, 28,-4, 28,-4, 28,-4, 28,-4, 28,
	  46, -6,46, -6,46, -6,46, -6,46, -6,46, -6,46, -6,46, -6,
	  -2, 16,-2, 16,-2, 16,-2, 16,-2, 16,-2, 16,-2, 16,-2, 16,
	  54, -4,54, -4,54, -4,54, -4,54, -4,54, -4,54, -4,54, -4,
	  -2, 10,-2, 10,-2, 10,-2, 10,-2, 10,-2, 10,-2, 10,-2, 10,
	  58, -2,58, -2,58, -2,58, -2,58, -2,58, -2,58, -2,58, -2,
  };



DECLARE_ALIGNED(16, const VO_S16, CONST_TR_16x16_1[4][8][8] ) =
{
  {/*1-3*/ /*2-6*/
	  { 90,  87,  90,  87,  90,  87,  90,  87 },
	  { 87,  57,  87,  57,  87,  57,  87,  57 },
	  { 80,   9,  80,   9,  80,   9,  80,   9 },
	  { 70, -43,  70, -43,  70, -43,  70, -43 },
	  { 57, -80,  57, -80,  57, -80,  57, -80 },
	  { 43, -90,  43, -90,  43, -90,  43, -90 },
	  { 25, -70,  25, -70,  25, -70,  25, -70 },
	  { 9,  -25,   9, -25,   9, -25,   9, -25 },
  },
  { /*5-7*/ /*10-14*/
	  {  80,  70,  80,  70,  80,  70,  80,  70 },
	  {   9, -43,   9, -43,   9, -43,   9, -43 },
	  { -70, -87, -70, -87, -70, -87, -70, -87 },
	  { -87,   9, -87,   9, -87,   9, -87,   9 },
	  { -25,  90, -25,  90, -25,  90, -25,  90 },
	  {  57,  25,  57,  25,  57,  25,  57,  25 },
	  {  90, -80,  90, -80,  90, -80,  90, -80 },
	  {  43, -57,  43, -57,  43, -57,  43, -57 },
  },
  { /*9-11*/ /*18-22*/
	  {  57,  43,  57,  43,  57,  43,  57,  43 },
	  { -80, -90, -80, -90, -80, -90, -80, -90 },
	  { -25,  57, -25,  57, -25,  57, -25,  57 },
	  {  90,  25,  90,  25,  90,  25,  90,  25 },
	  {  -9,  -87, -9,  -87, -9,  -87, -9, -87 },
	  { -87,  70, -87,  70, -87,  70, -87,  70 },
	  {  43,   9,  43,   9,  43,   9,  43,   9 },
	  {  70, -80,  70, -80,  70, -80,  70, -80 },
	  },
  {/*13-15*/ /*  26-30   */
	  {  25,   9,  25,   9,  25,   9,  25,   9 },
	  { -70, -25, -70, -25, -70, -25, -70, -25 },
	  {  90,  43,  90,  43,  90,  43,  90,  43 },
	  { -80, -57, -80, -57, -80, -57, -80, -57 },
	  {  43,  70,  43,  70,  43,  70,  43,  70 },
	  {  9,  -80,   9, -80,   9, -80,   9, -80 },
	  { -57,  87, -57,  87, -57,  87, -57,  87 },
	  {  87, -90,  87, -90,  87, -90,  87, -90 },
  }
};

DECLARE_ALIGNED(16, const VO_S16, CONST_TR_16x16_2[2][4][8] )=
{
  { /*2-6*/ /*4-12*/ /* 1-3 for 8X8*/
	  { 89,  75,  89,  75, 89,  75, 89,  75 },
	  { 75, -18,  75, -18, 75, -18, 75, -18 },
	  { 50, -89,  50, -89, 50, -89, 50, -89 },
	  { 18, -50,  18, -50, 18, -50, 18, -50 },
  },
  { /*10-14*/  /*20-28*/ /* 5-7 for 8X8*/
	  {  50,  18,  50,  18,  50,  18,  50,  18 },
	  { -89, -50, -89, -50, -89, -50, -89, -50 },
	  {  18,  75,  18,  75,  18,  75,  18,  75 },
	  {  75, -89,  75, -89,  75, -89,  75, -89 },
  }
};

DECLARE_ALIGNED(16,const VO_S16, CONST_TR_16x16_3[2][2][8] )=
{
  {/*4-12*/ /*8-24*/ /* 2-6 for 8X8*/  /* 1-3 for 4X4*/
	  {  83,  36,  83,  36,  83,  36,  83,  36 },
	  {  36, -83,  36, -83,  36, -83,  36, -83 },
  },
  {/*0-8*/  /*0-16*/ /* 0-4 for 8X8*/  /* 0-2 for 4X4*/
	  { 64,  64, 64,  64, 64,  64, 64,  64 },
	  { 64, -64, 64, -64, 64, -64, 64, -64 },
  }
};

DECLARE_ALIGNED(16, const VO_S16, CONST_TR_32x32[8][16][8] )=
{
	{ /* 1-3 */
		{ 90,  90, 90,  90, 90,  90, 90,  90 },
		{ 90,  82, 90,  82, 90,  82, 90,  82 },
		{ 88,  67, 88,  67, 88,  67, 88,  67 },
		{ 85,  46, 85,  46, 85,  46, 85,  46 },
		{ 82,  22, 82,  22, 82,  22, 82,  22 },
		{ 78,  -4, 78,  -4, 78,  -4, 78,  -4 },
		{ 73, -31, 73, -31, 73, -31, 73, -31 },
		{ 67, -54, 67, -54, 67, -54, 67, -54 },
		{ 61, -73, 61, -73, 61, -73, 61, -73 },
		{ 54, -85, 54, -85, 54, -85, 54, -85 },
		{ 46, -90, 46, -90, 46, -90, 46, -90 },
		{ 38, -88, 38, -88, 38, -88, 38, -88 },
		{ 31, -78, 31, -78, 31, -78, 31, -78 },
		{ 22, -61, 22, -61, 22, -61, 22, -61 },
		{ 13, -38, 13, -38, 13, -38, 13, -38 },
		{ 4,  -13,  4, -13,  4, -13,  4, -13 },
	},
	{/* 5-7 */
		{  88,  85,  88,  85,  88,  85,  88,  85 },
		{  67,  46,  67,  46,  67,  46,  67,  46 },
		{  31, -13,  31, -13,  31, -13,  31, -13 },
		{ -13, -67, -13, -67, -13, -67, -13, -67 },
		{ -54, -90, -54, -90, -54, -90, -54, -90 },
		{ -82, -73, -82, -73, -82, -73, -82, -73 },
		{ -90, -22, -90, -22, -90, -22, -90, -22 },
		{ -78,  38, -78,  38, -78,  38, -78,  38 },
		{ -46,  82, -46,  82, -46,  82, -46,  82 },
		{  -4,  88,  -4,  88,  -4,  88,  -4,  88 },
		{  38,  54,  38,  54,  38,  54,  38,  54 },
		{  73,  -4,  73,  -4,  73,  -4,  73,  -4 },
		{  90, -61,  90, -61,  90, -61,  90, -61 },
		{  85, -90,  85, -90,  85, -90,  85, -90 },
		{  61, -78,  61, -78,  61, -78,  61, -78 },
		{  22, -31,  22, -31,  22, -31,  22, -31 },
	},
	{/* 9-11 */
		{  82,  78,  82,  78,  82,  78,  82,  78 },
		{  22,  -4,  22,  -4,  22,  -4,  22,  -4 },
		{ -54, -82, -54, -82, -54, -82, -54, -82 },
		{ -90, -73, -90, -73, -90, -73, -90, -73 },
		{ -61,  13, -61,  13, -61,  13, -61,  13 },
		{  13,  85,  13,  85,  13,  85,  13,  85 },
		{  78,  67,  78,  67,  78,  67,  78,  67 },
		{  85, -22,  85, -22,  85, -22,  85, -22 },
		{  31, -88,  31, -88,  31, -88,  31, -88 },
		{ -46, -61, -46, -61, -46, -61, -46, -61 },
		{ -90,  31, -90,  31, -90,  31, -90,  31 },
		{ -67,  90, -67,  90, -67,  90, -67,  90 },
		{   4,  54,   4,  54,   4,  54,   4,  54 },
		{  73, -38,  73, -38,  73, -38,  73, -38 },
		{  88, -90,  88, -90,  88, -90,  88, -90 },
		{  38, -46,  38, -46,  38, -46,  38, -46 },
		},
	{/* 13-15 */
		{  73,  67,  73,  67,  73,  67,  73,  67 },
		{ -31, -54, -31, -54, -31, -54, -31, -54 },
		{ -90, -78, -90, -78, -90, -78, -90, -78 },
		{ -22,  38, -22,  38, -22,  38, -22,  38 },
		{  78,  85,  78,  85,  78,  85,  78,  85 },
		{  67, -22,  67, -22,  67, -22,  67, -22 },
		{ -38, -90, -38, -90, -38, -90, -38, -90 },
		{ -90,   4, -90,   4, -90,   4, -90,   4 },
		{ -13,  90, -13,  90, -13,  90, -13,  90 },
		{  82,  13,  82,  13,  82,  13,  82,  13 },
		{  61, -88,  61, -88,  61, -88,  61, -88 },
		{ -46, -31, -46, -31, -46, -31, -46, -31 },
		{ -88,  82, -88,  82, -88,  82, -88,  82 },
		{ -4,   46, -4,   46, -4,   46, -4,   46 },
		{  85, -73,  85, -73,  85, -73,  85, -73 },
		{  54, -61,  54, -61,  54, -61,  54, -61 },
	},
	{/* 17-19 */
		{  61,  54,  61,  54,  61,  54,  61,  54 },
		{ -73, -85, -73, -85, -73, -85, -73, -85 },
		{ -46,  -4, -46,  -4, -46,  -4, -46,  -4 },
		{  82,  88,  82,  88,  82,  88,  82,  88 },
		{  31, -46,  31, -46,  31, -46,  31, -46 },
		{ -88, -61, -88, -61, -88, -61, -88, -61 },
		{ -13,  82, -13,  82, -13,  82, -13,  82 },
		{  90,  13,  90,  13,  90,  13,  90,  13 },
		{ -4, -90,  -4, -90,  -4, -90,  -4, -90 },
		{ -90,  38, -90,  38, -90,  38, -90,  38 },
		{  22,  67,  22,  67,  22,  67,  22,  67 },
		{  85, -78,  85, -78,  85, -78,  85, -78 },
		{ -38, -22, -38, -22, -38, -22, -38, -22 },
		{ -78,  90, -78,  90, -78,  90, -78,  90 },
		{  54, -31,  54, -31,  54, -31,  54, -31 },
		{  67, -73,  67, -73,  67, -73,  67, -73 },
	},
	{ /* 21-23 */
		{  46,  38,  46,  38,  46,  38,  46,  38 },
		{ -90, -88, -90, -88, -90, -88, -90, -88 },
		{  38,  73,  38,  73,  38,  73,  38,  73 },
		{  54,  -4,  54,  -4,  54,  -4,  54,  -4 },
		{ -90, -67, -90, -67, -90, -67, -90, -67 },
		{  31,  90,  31,  90,  31,  90,  31,  90 },
		{  61, -46,  61, -46,  61, -46,  61, -46 },
		{ -88, -31, -88, -31, -88, -31, -88, -31 },
		{  22,  85,  22,  85,  22,  85,  22,  85 },
		{  67, -78,  67, -78,  67, -78,  67, -78 },
		{ -85,  13, -85,  13, -85,  13, -85,  13 },
		{  13,  61,  13,  61,  13,  61,  13,  61 },
		{  73, -90,  73, -90,  73, -90,  73, -90 },
		{ -82,  54, -82,  54, -82,  54, -82,  54 },
		{   4,  22,   4,  22,   4,  22,   4,  22 },
		{  78, -82,  78, -82,  78, -82,  78, -82 },
	},{ /* 25-27 */
		{  31,  22,  31,  22,  31,  22,  31,  22 },
		{ -78, -61, -78, -61, -78, -61, -78, -61 },
		{  90,  85,  90,  85,  90,  85,  90,  85 },
		{ -61, -90, -61, -90, -61, -90, -61, -90 },
		{   4,  73,   4,  73,   4,  73,   4,  73 },
		{  54, -38,  54, -38,  54, -38,  54, -38 },
		{ -88,  -4, -88,  -4, -88,  -4, -88,  -4 },
		{  82,  46,  82,  46,  82,  46,  82,  46 },
		{ -38, -78, -38, -78, -38, -78, -38, -78 },
		{ -22,  90, -22,  90, -22,  90, -22,  90 },
		{  73, -82,  73, -82,  73, -82,  73, -82 },
		{ -90,  54, -90,  54, -90,  54, -90,  54 },
		{  67, -13,  67, -13,  67, -13,  67, -13 },
		{ -13, -31, -13, -31, -13, -31, -13, -31 },
		{ -46,  67, -46,  67, -46,  67, -46,  67 },
		{  85, -88,  85, -88,  85, -88,  85, -88 },
	},
	{/* 29-31 */
		{  13,   4,  13,   4,  13,   4,  13,   4 },
		{ -38, -13, -38, -13, -38, -13, -38, -13 },
		{  61,  22,  61,  22,  61,  22,  61,  22 },
		{ -78, -31, -78, -31, -78, -31, -78, -31 },
		{  88,  38,  88,  38,  88,  38,  88,  38 },
		{ -90, -46, -90, -46, -90, -46, -90, -46 },
		{  85,  54,  85,  54,  85,  54,  85,  54 },
		{ -73, -61, -73, -61, -73, -61, -73, -61 },
		{  54,  67,  54,  67,  54,  67,  54,  67 },
		{ -31, -73, -31, -73, -31, -73, -31, -73 },
		{   4,  78,   4,  78,   4,  78,   4,  78 },
		{  22, -82,  22, -82,  22, -82,  22, -82 },
		{ -46,  85, -46,  85, -46,  85, -46,  85 },
		{  67, -88,  67, -88,  67, -88,  67, -88 },
		{ -82,  90, -82,  90, -82,  90, -82,  90 },
		{  90, -90,  90, -90,  90, -90,  90, -90 },
	}
};

DECLARE_ALIGNED(16, const VO_S16, CONST_TR_32X32_2ND_ROW[8][16])= 
{
	{90,  90, 90,  90, 87,  87,  87, 87, 80, 80, 80, 80, 70, 70, 70, 70},
	{57,  57, 57,  57, 43,  43,  43, 43, 25, 25, 25, 25, 9,  9,   9, 9 },
	{-9, -9, -9,   -9, -25,-25, -25,-25,-43,-43,-43,-43,-57,-57,-57,-57},
	{-70,-70,-70, -70, -80, -80,-80,-80,-87,-87,-87,-87,-90,-90,-90,-90},
	{-90,-90,-90,-90,  -87,-87,-87,-87, -80,-80,-80,-80,-70,-70,-70,-70},
	{-57,-57,-57,-57,  -43,-43,-43,-43, -25,-25,-25,-25, -9, -9, -9, -9},
	{ 9,  9,  9,  9,    25, 25, 25, 25,  43, 43, 43, 43, 57, 57, 57, 57}, 
	{70, 70, 70, 70,   80, 80, 80, 80, 87, 87, 87, 87, 90, 90, 90, 90}
};

//89, 75, 50, 18, -18, -50, -75, -89, -89, -75, -50, -18, 18, 50, 75, 89,
DECLARE_ALIGNED(16, const VO_S16, CONST_TR_16X16_2ND_ROW[8][16])= 
{
	{ 89,  89, 89, 89, 75, 75, 75, 75, 50, 50, 50, 50, 18, 18, 18, 18},
	{ -18,-18,-18,-18,-50,-50,-50,-50,-75,-75,-75,-75,-89,-89,-89,-89},
	{ -89,-89,-89,-89,-75,-75,-75,-75,-50,-50,-50,-50,-18,-18,-18,-18},
	{ 18,  18, 18, 18, 50, 50, 50, 50, 75, 75, 75, 75, 89, 89, 89, 89}
};

DECLARE_ALIGNED(16, const VO_S16, CONST_TR_IDST_4X4[6][8])= 
{
	{29, 55, 29, 55, 29, 55, 29, 55},
	{55,-29, 55,-29, 55,-29, 55,-29},
	{74,-74, 74,-74, 74,-74, 74,-74},
	{55, 29, 55, 29, 55, 29, 55, 29},
	{84, 84, 84, 84, 84, 84, 84, 84},
	{29, 29, 55, 55, 74, 74, 84, 84}
};

DECLARE_ALIGNED(16, const VO_S16, CONST_TR_32X32_8X8[4][8])= 
{
	{89,89,89,89,89,89,89,89},
	{75,75,75,75,75,75,75,75},
	{50,50,50,50,50,50,50,50},
	{18,18,18,18,18,18,18,18}
};

DECLARE_ALIGNED(16, const VO_S16, CONST_TR_16X16_8X8[4][8])= 
{
	{64,64,64,64,64,64,64,64},
	{64,64,64,64,64,64,64,64},
	{83,83,83,83,83,83,83,83},
	{36,36,36,36,36,36,36,36}
};

DECLARE_ALIGNED(16,  const VO_U16, CONST_U16_16[8]) = {16,16,16,16,16,16,16,16};

DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_1_64[4][16]) = 
{	
	{1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12,13,14,15,16},
	{17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32},
	{33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48},
	{49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64}
};

DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_64[16]) = {64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64};
DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_Planar_nTbs4[8]) = {3,1,2,2,1,3,0,4};
DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_Planar_nTbs8[16]) = {7,1,6,2,5,3,4,4,3,5,2,6,1,7,0,8};
DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_Planar_nTbs16[32]) = 
{
	15,1,14,2,13,3,12,4,11,5,10,6,9,7,8,8,
	7,9,6,10,5,11,4,12,3,13,2,14,1,15,0,16
};

DECLARE_ALIGNED(16,  const VO_U8, CONST_U8_Planar_nTbs32[64]) = 
{
	31,1,30,2,29,3,28,4,27,5,26,6,25,7,24,8,
	23,9,22,10,21,11,20,12,19,13,18,14,17,15,16,16,
	15,17,14,18,13,19,12,20,11,21,10,22,9,23,8,24,
	7,25,6,26,5,27,4,28,3,29,2,30,1,31,0,32
};