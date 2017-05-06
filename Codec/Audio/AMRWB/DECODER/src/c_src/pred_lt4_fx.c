/*-------------------------------------------------------------------*
 *                         PRED_LT4.C								 *
 *-------------------------------------------------------------------*
 * Compute the result of long term prediction with fractionnal       *
 * interpolation of resolution 1/4.                                  *
 *                                                                   *
 * On return exc[0..L_subfr-1] contains the interpolated signal      *
 *   (adaptive codebook excitation)                                  *
 *-------------------------------------------------------------------*/

#include "typedef.h"
#include "basic_op.h"

#define UP_SAMP      4
#define L_INTERPOL2  16


/*** Coefficients in floating point
static float inter4_2[UP_SAMP*L_INTERPOL2+1] = {
   0.940000,
   0.856390,   0.632268,   0.337560,   0.059072,
  -0.131059,  -0.199393,  -0.158569,  -0.056359,
   0.047606,   0.106749,   0.103705,   0.052062,
  -0.015182,  -0.063705,  -0.073660,  -0.046497,
  -0.000983,   0.038227,   0.053143,   0.040059,
   0.009308,  -0.021674,  -0.037767,  -0.033186,
  -0.013028,   0.010702,   0.025901,   0.026318,
   0.013821,  -0.003645,  -0.016813,  -0.019855,
  -0.012766,  -0.000530,   0.010080,   0.014122,
   0.010657,   0.002594,  -0.005363,  -0.009344,
  -0.008101,  -0.003182,   0.002330,   0.005635,
   0.005562,   0.002844,  -0.000627,  -0.002993,
  -0.003362,  -0.002044,  -0.000116,   0.001315,
   0.001692,   0.001151,   0.000259,  -0.000417,
  -0.000618,  -0.000434,  -0.000133,   0.000063,
   0.000098,   0.000048,   0.000007,   0.000000};
***/
/* 1/4 resolution interpolation filter (-3 dB at 0.856*fs/2) in Q14 */

//static 
Word16 inter4_2[UP_SAMP * 2 * L_INTERPOL2] =
{
    0, 1, 2, 1,
    -2, -7, -10, -7,
    4, 19, 28, 22,
    -2, -33, -55, -49,
    -10, 47, 91, 92,
    38, -52, -133, -153,
    -88, 43, 175, 231,
    165, -9, -209, -325,
    -275, -60, 226, 431,
    424, 175, -213, -544,
    -619, -355, 153, 656,
    871, 626, -16, -762,
    -1207, -1044, -249, 853,
    1699, 1749, 780, -923,
    -2598, -3267, -2147, 968,
    5531, 10359, 14031, 15401,
    14031, 10359, 5531, 968,
    -2147, -3267, -2598, -923,
    780, 1749, 1699, 853,
    -249, -1044, -1207, -762,
    -16, 626, 871, 656,
    153, -355, -619, -544,
    -213, 175, 424, 431,
    226, -60, -275, -325,
    -209, -9, 165, 231,
    175, 43, -88, -153,
    -133, -52, 38, 92,
    91, 47, -10, -49,
    -55, -33, -2, 22,
    28, 19, 4, -7,
    -10, -7, -2, 1,
    2, 1, 0, 0
};

void Pred_lt4(
     Word16 exc[],                         /* in/out: excitation buffer */
     Word16 T0,                            /* input : integer pitch lag */
     Word16 frac,                          /* input : fraction of lag   */
     Word16 L_subfr                        /* input : subframe size     */
)
{
#if (!FUNC_PRED_LT4_OPT)
    Word16 i, j, k, *x;
    Word32 L_sum;
    x = &exc[-T0];
    frac = negate(frac);
    if (frac < 0)
    {
        frac = add(frac, UP_SAMP);
        x--;
    }
    x = x - L_INTERPOL2 + 1;
    for (j = 0; j < L_subfr; j++)
    {
        L_sum = 0L; 
        for (i = 0, k = sub(sub(UP_SAMP, 1), frac); i < 2 * L_INTERPOL2; i++, k += UP_SAMP)
        {
            L_sum = L_mac(L_sum, x[i], inter4_2[k]);
        }
        L_sum = L_shl(L_sum, 1);
        exc[j] = vo_round(L_sum);
        x++;
    }
    return;
#else
    Word16 i, j, k, *x;
    Word32 L_sum;
    x = exc - T0;   
    frac = -frac;
    if (frac < 0)
    {
        frac += UP_SAMP;
        x--;
    }   
    x -= L_INTERPOL2 - 1;
    for (j = 0; j < L_subfr; j++)
    {
        k = UP_SAMP - 1 - frac;
		L_sum = 0L;
		for(i=0; i < (L_INTERPOL2 << 1); i += 8)
		{
        L_sum += x[i] * inter4_2[k];
        k += UP_SAMP;
        L_sum += x[i + 1] * inter4_2[k];
        k += UP_SAMP;
        L_sum += x[i + 2] * inter4_2[k];
        k += UP_SAMP;
        L_sum += x[i + 3] * inter4_2[k];
        k += UP_SAMP;
        L_sum += x[i + 4] * inter4_2[k];
        k += UP_SAMP;
        L_sum += x[i + 5] * inter4_2[k];
        k += UP_SAMP;
        L_sum += x[i + 6] * inter4_2[k];
        k += UP_SAMP;
        L_sum += x[i + 7] * inter4_2[k];
		k += UP_SAMP;
        }
        L_sum = (L_sum << 2);                              //saturation may occur here
        exc[j] = (L_sum + 0x8000)>>16;                     //saturation may occur here
        x++;
    }
#if AMR_DUMP
  {
	Dumploop2(AMR_DEBUG_Pred_lt4,"after Pred_lt4",4,L_subfr/4,exc,d16);
  }
#endif//AMR_DUMP
    return;
#endif
}
