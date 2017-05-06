/**********************************************************************
Each of the companies; Lucent, Motorola, Nokia, and Qualcomm (hereinafter 
referred to individually as "Source" or collectively as "Sources") do 
hereby state:

To the extent to which the Source(s) may legally and freely do so, the 
Source(s), upon submission of a Contribution, grant(s) a free, 
irrevocable, non-exclusive, license to the Third Generation Partnership 
Project 2 (3GPP2) and its Organizational Partners: ARIB, CCSA, TIA, TTA, 
and TTC, under the Source's copyright or copyright license rights in the 
Contribution, to, in whole or in part, copy, make derivative works, 
perform, display and distribute the Contribution and derivative works 
thereof consistent with 3GPP2's and each Organizational Partner's 
policies and procedures, with the right to (i) sublicense the foregoing 
rights consistent with 3GPP2's and each Organizational Partner's  policies 
and procedures and (ii) copyright and sell, if applicable) in 3GPP2's name 
or each Organizational Partner's name any 3GPP2 or transposed Publication 
even though this Publication may contain the Contribution or a derivative 
work thereof.  The Contribution shall disclose any known limitations on 
the Source's rights to license as herein provided.

When a Contribution is submitted by the Source(s) to assist the 
formulating groups of 3GPP2 or any of its Organizational Partners, it 
is proposed to the Committee as a basis for discussion and is not to 
be construed as a binding proposal on the Source(s).  The Source(s) 
specifically reserve(s) the right to amend or modify the material 
contained in the Contribution. Nothing contained in the Contribution 
shall, except as herein expressly provided, be construed as conferring 
by implication, estoppel or otherwise, any license or right under (i) 
any existing or later issuing patent, whether or not the use of 
information in the document necessarily employs an invention of any 
existing or later issued patent, (ii) any copyright, (iii) any 
trademark, or (iv) any other intellectual property right.

With respect to the Software necessary for the practice of any or 
all Normative portions of the Enhanced Variable Rate Codec (EVRC) as 
it exists on the date of submittal of this form, should the EVRC be 
approved as a Specification or Report by 3GPP2, or as a transposed 
Standard by any of the 3GPP2's Organizational Partners, the Source(s) 
state(s) that a worldwide license to reproduce, use and distribute the 
Software, the license rights to which are held by the Source(s), will 
be made available to applicants under terms and conditions that are 
reasonable and non-discriminatory, which may include monetary compensation, 
and only to the extent necessary for the practice of any or all of the 
Normative portions of the EVRC or the field of use of practice of the 
EVRC Specification, Report, or Standard.  The statement contained above 
is irrevocable and shall be binding upon the Source(s).  In the event 
the rights of the Source(s) in and to copyright or copyright license 
rights subject to such commitment are assigned or transferred, the 
Source(s) shall notify the assignee or transferee of the existence of 
such commitments.
*******************************************************************/
 
/*======================================================================*/
/*     Enhanced Variable Rate Codec - Bit-Exact C Specification         */
/*     Copyright (C) 1997-1998 Telecommunications Industry Association. */
/*     All rights reserved.                                             */
/*----------------------------------------------------------------------*/
/* Note:  Reproduction and use of this software for the design and      */
/*     development of North American Wideband CDMA Digital              */
/*     Cellular Telephony Standards is authorized by the TIA.           */
/*     The TIA does not authorize the use of this software for any      */
/*     other purpose.                                                   */
/*                                                                      */
/*     The availability of this software does not provide any license   */
/*     by implication, estoppel, or otherwise under any patent rights   */
/*     of TIA member companies or others covering any use of the        */
/*     contents herein.                                                 */
/*                                                                      */
/*     Any copies of this software or derivative works must include     */
/*     this and all other proprietary notices.                          */
/*======================================================================*/
/*  Memory Usage:                                                       */
/*      ROM:                6150                                        */
/*      Static/Global RAM:  0                                           */
/*      Stack/Local RAM:    0                                           */
/*----------------------------------------------------------------------*/
/*======================================================================*/
/*         ..Includes.                                                  */
/*----------------------------------------------------------------------*/
#include  "macro.h"

/*======================================================================*/
/*         ..Globals.                                                   */
/*----------------------------------------------------------------------*/

/* ROM tables */
short evrc_framelen[6]={1, 3 , -1, 11 , 23, 1};
/* Quantization table for pitch gain */
	/* SCALED DOWN BY 2 FROM FLOATING POINT MODEL. */
short ppvq[ACBGainSize] =
{0, 4915, 9011, 11469, 13107, 14746, 16384, 19661};

short ppvq_mid[ACBGainSize - 1] =
{2458, 6963, 10240, 12288, 13926, 15565, 18022};

/* Quantization table for fcb gain */
	/* SCALED UP BY 8 FROM FLOATING POINT MODEL. */
short gnvq_4[maxFCBGainSize] =
{13, 22, 36, 59, 97, 161, 265, 437,
 720, 1187, 1958, 3227, 5321, 8773, 14464, 23848};
short gnvq_8[maxFCBGainSize] =
{10, 13, 17, 22, 28, 36, 46, 59,
 76, 97, 125, 161, 206, 265, 340, 437,
 561, 720, 925, 1187, 1525, 1958, 2514, 3227,
 4144, 5321, 6832, 8773, 11265, 14464, 18573, 23848};

short nsize8[2] =
{16, 16};
short lognsize8[2] =
{4, 4};							/* c.b. size of each sub-matrix   */
short nsub8[2] =
{5, 5};							/* Vector size of each sub-matrix */

short rnd_delay[NoOfSubFrames + 2] =
{55, 80, 39, 71, 33};

/* New AT&T half-rate quantizer */
short nsize22[3] =
{128, 128, 256};
short nsub22[3] =
{3, 3, 4};
short lognsize22[3] =
{7, 7, 8};

/* New AT&T full-rate quantizer */
short nsize28[4] =
{64, 64, 512, 128};
short lognsize28[4] =
{6, 6, 9, 7};
short nsub28[4] =
{2, 2, 3, 3};

/* LSP quantizer tables (AT&T quantizer) */
#include "lsptab.dat"

/*
 * SCALED DOWN BY 4 FROM FLOATING POINT MODEL.
 */
short Logqtbl[256 * 3] =
{
	-202,
	-33,
	-907,
	7155,
	8225,
	8135,
	3459,
	3190,
	4112,
	11878,
	10879,
	10469,
	1603,
	1777,
	2241,
	9355,
	10158,
	9478,
	6456,
	5553,
	3428,
	12321,
	12026,
	12567,
	2599,
	2206,
	-780,
	9347,
	9454,
	8552,
	4216,
	4738,
	7211,
	12304,
	11526,
	11543,
	2591,
	2943,
	2318,
	9970,
	9937,
	9961,
	8380,
	9331,
	-780,
	13263,
	13558,
	13451,
	1177,
	1233,
	560,
	8023,
	8364,
	9150,
	3851,
	5264,
	4521,
	11190,
	11444,
	11518,
	2390,
	2476,
	1982,
	10723,
	10166,
	9994,
	6545,
	6270,
	6055,
	13206,
	12304,
	11854,
	2125,
	1596,
	2093,
	8937,
	9421,
	10420,
	2804,
	3400,
	10600,
	14164,
	11280,
	8724,
	3361,
	2693,
	2644,
	9372,
	10494,
	11600,
	8577,
	9150,
	5069,
	15679,
	14557,
	12419,
	-173,
	1769,
	1926,
	8954,
	8913,
	8405,
	4560,
	4171,
	3813,
	12370,
	11870,
	9839,
	1935,
	2807,
	2088,
	10977,
	10035,
	9150,
	9855,
	3129,
	1859,
	11248,
	11502,
	14991,
	2105,
	2186,
	1340,
	9986,
	8995,
	9191,
	5722,
	6927,
	8757,
	12698,
	12296,
	11370,
	2351,
	2507,
	2948,
	9650,
	11018,
	10666,
	10404,
	9953,
	1484,
	14131,
	14557,
	13869,
	1699,
	1724,
	1261,
	9052,
	8471,
	9044,
	5475,
	5444,
	5439,
	11493,
	11977,
	11756,
	2776,
	3075,
	1761,
	10551,
	10854,
	10297,
	7318,
	6761,
	6663,
	12739,
	12935,
	12820,
	2674,
	1994,
	2336,
	10174,
	9667,
	9847,
	1076,
	1391,
	13484,
	14721,
	13083,
	10166,
	3867,
	4379,
	2512,
	10437,
	11477,
	11067,
	11919,
	11354,
	5267,
	14975,
	15294,
	14950,
	-2675,
	-2422,
	-2017,
	8479,
	8356,
	8217,
	3033,
	3528,
	5793,
	11665,
	11018,
	11076,
	1857,
	2195,
	2488,
	10117,
	10232,
	9388,
	8146,
	5313,
	4299,
	12607,
	12222,
	13206,
	3125,
	2753,
	-780,
	9527,
	9372,
	9150,
	5516,
	6272,
	8307,
	12845,
	11780,
	11919,
	2793,
	2717,
	3159,
	9667,
	10519,
	10519,
	10191,
	9945,
	-780,
	14361,
	13091,
	14287,
	1268,
	1137,
	1655,
	8413,
	9282,
	8954,
	3200,
	6148,
	4674,
	11633,
	11117,
	12640,
	2664,
	2569,
	2297,
	11067,
	10723,
	10027,
	7193,
	6631,
	5824,
	13222,
	12943,
	11739,
	2639,
	1883,
	1767,
	9961,
	8823,
	10215,
	11166,
	10486,
	10789,
	14344,
	11936,
	9683,
	3627,
	3344,
	2606,
	9478,
	10052,
	13140,
	10535,
	10387,
	6690,
	16335,
	16531,
	10707,
	219,
	2125,
	2783,
	9535,
	8847,
	7636,
	4914,
	4977,
	4162,
	11813,
	11813,
	11264,
	1958,
	2911,
	2807,
	10543,
	10707,
	9372,
	9830,
	6140,
	3250,
	12788,
	12427,
	15548,
	2947,
	2837,
	983,
	10633,
	9216,
	8700,
	6207,
	8298,
	9781,
	12591,
	12394,
	11993,
	3310,
	3308,
	3192,
	10592,
	9986,
	11289,
	10240,
	11395,
	2008,
	12763,
	14451,
	14156,
	2212,
	1552,
	1576,
	9101,
	9110,
	9609,
	6209,
	6834,
	3917,
	11993,
	12100,
	12034,
	3278,
	2543,
	1816,
	11026,
	11641,
	10748,
	8774,
	7346,
	6153,
	13238,
	12706,
	12894,
	2727,
	2281,
	2572,
	10494,
	9904,
	10150,
	2298,
	2201,
	13484,
	14860,
	12403,
	12370,
	5104,
	3441,
	3032,
	10281,
	11706,
	11911,
	13451,
	12952,
	5826,
	15106,
	16081,
	15524,
	-345,
	-1221,
	-626,
	8569,
	7863,
	7517,
	3668,
	3772,
	4187,
	12460,
	10584,
	10994,
	1819,
	2088,
	2056,
	9716,
	10273,
	9593,
	7372,
	4063,
	4049,
	11657,
	12157,
	13271,
	2290,
	2276,
	-2310,
	9585,
	9675,
	8815,
	3333,
	6997,
	7661,
	12976,
	11600,
	11362,
	2724,
	2994,
	2736,
	10027,
	10297,
	10199,
	8692,
	9322,
	-780,
	13771,
	13959,
	13705,
	1583,
	1220,
	1031,
	8380,
	8913,
	9380,
	4252,
	5630,
	4237,
	11305,
	11510,
	12075,
	2780,
	2540,
	1828,
	11092,
	10232,
	10404,
	6032,
	6970,
	6756,
	13206,
	12591,
	12362,
	2418,
	1682,
	2122,
	9322,
	9986,
	10338,
	11018,
	10559,
	10961,
	11772,
	11141,
	11813,
	3953,
	2702,
	3147,
	9986,
	10740,
	11575,
	9929,
	9716,
	5208,
	15344,
	15884,
	13713,
	10322,
	10699,
	11207,
	9388,
	8823,
	8397,
	4939,
	4128,
	4736,
	12403,
	11633,
	10846,
	2173,
	2615,
	2492,
	11207,
	9814,
	9830,
	10109,
	4022,
	284,
	11035,
	12780,
	15245,
	2266,
	2365,
	1662,
	10297,
	9052,
	9380,
	11067,
	11084,
	11518,
	12337,
	12943,
	11158,
	2289,
	3169,
	3504,
	10109,
	10928,
	10945,
	10486,
	10256,
	1479,
	11362,
	11436,
	11747,
	2377,
	958,
	1391,
	9290,
	8823,
	9150,
	5723,
	5879,
	6034,
	11223,
	12214,
	12247,
	3302,
	4214,
	1434,
	10920,
	11280,
	10297,
	7546,
	7319,
	7288,
	13017,
	13222,
	12476,
	2582,
	1773,
	2646,
	10650,
	9380,
	9929,
	10396,
	10199,
	12263,
	14442,
	14057,
	10740,
	3852,
	4442,
	3527,
	10994,
	11739,
	11657,
	12059,
	11502,
	6858,
	15860,
	15426,
	15057,
	10371,
	10609,
	10666,
	8798,
	8208,
	8380,
	4265,
	3314,
	5365,
	11936,
	11289,
	11166,
	2224,
	2154,
	2327,
	10355,
	10412,
	9626,
	10953,
	10691,
	10699,
	12739,
	12870,
	13574,
	2737,
	3397,
	-2988,
	9732,
	9708,
	9511,
	5077,
	5905,
	9478,
	12960,
	12001,
	12394,
	3145,
	2991,
	3124,
	9945,
	10289,
	10584,
	11149,
	11166,
	10748,
	14688,
	13869,
	13672,
	1547,
	1044,
	2076,
	8733,
	9617,
	9282,
	4095,
	6723,
	4762,
	12108,
	11600,
	12263,
	3124,
	2571,
	2367,
	11436,
	10363,
	10101,
	7748,
	7505,
	4813,
	13697,
	13369,
	12722,
	2871,
	2068,
	1937,
	9921,
	9322,
	10117,
	11395,
	10084,
	11100,
	14606,
	12370,
	9822,
	3463,
	3726,
	3007,
	10494,
	10273,
	13607,
	10961,
	11297,
	7808,
	17596,
	16097,
	12976,
	764,
	2929,
	2885,
	9929,
	8897,
	8552,
	5020,
	5027,
	4964,
	12157,
	12345,
	11436,
	2310,
	3152,
	2585,
	11207,
	10543,
	9241,
	11215,
	11076,
	11125,
	11313,
	14459,
	17310,
	10764,
	11018,
	10928,
	10568,
	9601,
	9167,
	10682,
	11280,
	11690,
	12206,
	12616,
	12583,
	3272,
	3606,
	3419,
	10838,
	10707,
	11403,
	11469,
	11370,
	11215,
	13672,
	14893,
	15024,
	2246,
	1831,
	1627,
	9314,
	9331,
	9839,
	10846,
	11346,
	11051,
	11919,
	12894,
	11911,
	4112,
	2666,
	2093,
	11370,
	11780,
	10650,
	11420,
	11051,
	11559,
	13427,
	12943,
	13771,
	3211,
	2046,
	2886,
	10658,
	10002,
	10527,
	10797,
	10994,
	12239,
	15647,
	13763,
	12042,
	4982,
	4317,
	3419,
	10281,
	12100,
	12313,
	14803,
	14270,
	5368,
	16384,
	16974,
	16802
};

/*
 * SCALED DOWN BY 256 FROM FLOATING POINT MODEL.
 */
short Powqtbl[256 * 3] =
{
	121,
	127,
	99,
	956,
	1292,
	1260,
	338,
	314,
	407,
	3608,
	2724,
	2428,
	201,
	211,
	240,
	1775,
	2224,
	1837,
	786,
	610,
	336,
	4085,
	3760,
	4377,
	266,
	238,
	103,
	1771,
	1825,
	1416,
	419,
	485,
	971,
	4066,
	3267,
	3283,
	265,
	293,
	246,
	2110,
	2090,
	2105,
	1350,
	1763,
	103,
	5324,
	5784,
	5613,
	178,
	181,
	150,
	1221,
	1343,
	1676,
	378,
	562,
	456,
	2973,
	3193,
	3260,
	251,
	257,
	223,
	2607,
	2230,
	2124,
	806,
	746,
	702,
	5239,
	4066,
	3583,
	233,
	200,
	231,
	1578,
	1808,
	2394,
	282,
	333,
	2519,
	6858,
	3049,
	1487,
	329,
	273,
	269,
	1783,
	2445,
	3336,
	1426,
	1676,
	532,
	10501,
	7660,
	4200,
	122,
	210,
	220,
	1586,
	1568,
	1359,
	461,
	413,
	374,
	4142,
	3599,
	2033,
	221,
	282,
	230,
	2800,
	2149,
	1676,
	2043,
	308,
	216,
	3021,
	3245,
	8654,
	231,
	237,
	187,
	2119,
	1604,
	1695,
	639,
	897,
	1500,
	4542,
	4057,
	3128,
	248,
	259,
	293,
	1928,
	2833,
	2566,
	2383,
	2100,
	194,
	6795,
	7660,
	6313,
	206,
	208,
	182,
	1630,
	1384,
	1626,
	596,
	591,
	590,
	3238,
	3709,
	3485,
	279,
	304,
	210,
	2484,
	2705,
	2313,
	1001,
	856,
	833,
	4594,
	4855,
	4701,
	271,
	224,
	247,
	2235,
	1937,
	2038,
	173,
	189,
	5665,
	8021,
	5061,
	2230,
	380,
	438,
	259,
	2406,
	3223,
	2872,
	3649,
	3113,
	563,
	8614,
	9423,
	8555,
	60,
	65,
	73,
	1387,
	1340,
	1289,
	300,
	345,
	652,
	3398,
	2833,
	2879,
	216,
	237,
	258,
	2199,
	2271,
	1791,
	1264,
	570,
	429,
	4428,
	3974,
	5239,
	308,
	277,
	103,
	1863,
	1783,
	1676,
	603,
	746,
	1322,
	4734,
	3509,
	3649,
	281,
	275,
	311,
	1937,
	2462,
	2462,
	2245,
	2095,
	103,
	7248,
	5072,
	7099,
	183,
	176,
	204,
	1362,
	1739,
	1586,
	315,
	721,
	476,
	3367,
	2912,
	4469,
	271,
	264,
	244,
	2872,
	2607,
	2144,
	967,
	825,
	658,
	5263,
	4866,
	3469,
	269,
	217,
	210,
	2105,
	1528,
	2261,
	2953,
	2439,
	2656,
	7215,
	3666,
	1946,
	355,
	328,
	266,
	1837,
	2159,
	5143,
	2473,
	2373,
	839,
	12624,
	13342,
	2595,
	136,
	233,
	280,
	1867,
	1539,
	1095,
	509,
	519,
	412,
	3542,
	3542,
	3035,
	222,
	290,
	282,
	2479,
	2595,
	1783,
	2029,
	719,
	319,
	4658,
	4209,
	10121,
	293,
	284,
	169,
	2542,
	1707,
	1476,
	733,
	1319,
	2001,
	4408,
	4171,
	3726,
	325,
	324,
	314,
	2513,
	2119,
	3056,
	2276,
	3149,
	225,
	4626,
	7434,
	6842,
	238,
	198,
	199,
	1653,
	1657,
	1906,
	733,
	874,
	385,
	3726,
	3839,
	3769,
	322,
	262,
	213,
	2839,
	3375,
	2625,
	1507,
	1009,
	722,
	5287,
	4552,
	4800,
	275,
	243,
	264,
	2445,
	2071,
	2219,
	244,
	238,
	5665,
	8341,
	4180,
	4142,
	537,
	337,
	300,
	2303,
	3437,
	3641,
	5613,
	4878,
	658,
	8937,
	11755,
	10051,
	116,
	91,
	107,
	1423,
	1167,
	1059,
	359,
	370,
	415,
	4248,
	2507,
	2813,
	213,
	230,
	228,
	1964,
	2297,
	1898,
	1017,
	401,
	399,
	3390,
	3901,
	5336,
	244,
	243,
	67,
	1893,
	1942,
	1525,
	327,
	915,
	1103,
	4911,
	3336,
	3120,
	275,
	297,
	276,
	2144,
	2313,
	2250,
	1473,
	1759,
	103,
	6141,
	6475,
	6029,
	200,
	180,
	171,
	1350,
	1568,
	1787,
	423,
	623,
	421,
	3071,
	3252,
	3813,
	280,
	261,
	214,
	2892,
	2271,
	2383,
	697,
	908,
	855,
	5239,
	4408,
	4132,
	253,
	205,
	232,
	1759,
	2119,
	2340,
	2833,
	2490,
	2787,
	3501,
	2932,
	3542,
	389,
	274,
	310,
	2119,
	2619,
	3313,
	2085,
	1964,
	553,
	9555,
	11123,
	6042,
	2329,
	2589,
	2987,
	1791,
	1528,
	1356,
	513,
	408,
	485,
	4180,
	3367,
	2699,
	236,
	267,
	258,
	2987,
	2019,
	2029,
	2194,
	396,
	139,
	2846,
	4647,
	9294,
	242,
	249,
	204,
	2313,
	1630,
	1787,
	2872,
	2885,
	3260,
	4104,
	4866,
	2946,
	244,
	312,
	343,
	2194,
	2762,
	2775,
	2439,
	2287,
	194,
	3120,
	3186,
	3477,
	250,
	168,
	189,
	1743,
	1528,
	1676,
	639,
	668,
	698,
	3001,
	3965,
	4001,
	324,
	418,
	192,
	2756,
	3049,
	2313,
	1068,
	1001,
	993,
	4968,
	5263,
	4268,
	264,
	211,
	269,
	2554,
	1787,
	2085,
	2378,
	2250,
	4020,
	7417,
	6656,
	2619,
	378,
	446,
	345,
	2813,
	3469,
	3390,
	3795,
	3245,
	880,
	11046,
	9777,
	8815,
	2362,
	2525,
	2566,
	1518,
	1286,
	1350,
	424,
	325,
	578,
	3666,
	3056,
	2953,
	239,
	234,
	246,
	2351,
	2389,
	1915,
	2781,
	2584,
	2589,
	4594,
	4767,
	5810,
	276,
	333,
	55,
	1973,
	1960,
	1854,
	533,
	673,
	1837,
	4889,
	3734,
	4171,
	310,
	297,
	308,
	2095,
	2308,
	2507,
	2939,
	2953,
	2625,
	7947,
	6313,
	5973,
	198,
	172,
	229,
	1490,
	1911,
	1739,
	405,
	847,
	488,
	3848,
	3336,
	4020,
	308,
	264,
	249,
	3186,
	2356,
	2189,
	1130,
	1055,
	495,
	6015,
	5485,
	4573,
	287,
	229,
	221,
	2081,
	1759,
	2199,
	3149,
	2179,
	2899,
	7766,
	4142,
	2024,
	339,
	365,
	298,
	2445,
	2297,
	5864,
	2787,
	3063,
	1149,
	17997,
	11809,
	4911,
	159,
	292,
	288,
	2085,
	1560,
	1416,
	525,
	526,
	517,
	3901,
	4113,
	3186,
	245,
	310,
	265,
	2987,
	2479,
	1719,
	2994,
	2879,
	2919,
	3078,
	7451,
	16604,
	2638,
	2833,
	2762,
	2496,
	1902,
	1683,
	2578,
	3049,
	3421,
	3956,
	4438,
	4398,
	321,
	353,
	335,
	2693,
	2595,
	3157,
	3215,
	3128,
	2994,
	5973,
	8418,
	8734,
	241,
	214,
	202,
	1755,
	1763,
	2033,
	2699,
	3106,
	2859,
	3649,
	4800,
	3641,
	407,
	271,
	231,
	3128,
	3509,
	2554,
	3171,
	2859,
	3298,
	5575,
	4866,
	6141,
	316,
	228,
	288,
	2560,
	2129,
	2467,
	2662,
	2813,
	3992,
	10404,
	6126,
	3778,
	519,
	431,
	335,
	2303,
	3839,
	4076,
	8207,
	7067,
	579,
	12800,
	15108,
	14395
};
