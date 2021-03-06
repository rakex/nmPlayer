/*-----------------------------------------------------------------------*
 *                         ISFEXTRP.C									 *
 *-----------------------------------------------------------------------*
 *	Conversion of 16th-order 12.8kHz ISF vector 						 *
 *	into 20th-order 16kHz ISF vector									 *
 *-----------------------------------------------------------------------*/

#include "typedef.h"
#include "basic_op.h"
#include "oper_32b.h"
#include "cnst_wb_fx.h"
#include "acelp_fx.h"
#include "count.h"

#define INV_LENGTH 2731                    /* 1/12 */

void voAMRWBPDecIsf_Extrapolation(Word16 HfIsf[])
{
    
#if (FUNC_ISF_EXTRAPOLATION_OPT)

    Word16 IsfDiff[M - 2];
    Word32 IsfCorr[3];
    Word32 L_tmp;
    Word16 coeff, mean, tmp, tmp2, tmp3;
    Word16 exp, exp2, hi, lo;
    Word16 i, MaxCorr;

    HfIsf[M16k - 1] = HfIsf[M - 1];

    /* Difference vector */
    for (i = 1; i < (M - 1); i++)
    {
        IsfDiff[i - 1] = HfIsf[i] - HfIsf[i - 1];
    }
    
    L_tmp = 0;
    /* Mean of difference vector */
    for (i = 3; i < (M - 1); i++)
    {
        L_tmp += IsfDiff[i - 1] * INV_LENGTH;
    }
    mean = (L_tmp + 0x4000) >> 15;

    IsfCorr[0] = 0;
    IsfCorr[1] = 0;
    IsfCorr[2] = 0;

    tmp = 0;
    for (i = 0; i < (M - 2); i++)
    {
        if (IsfDiff[i] > tmp)
        {
            tmp = IsfDiff[i];
        }
    }
    exp = norm_s(tmp);
    for (i = 0; i < (M - 2); i++)
    {
        IsfDiff[i] <<= exp;
    }
    mean <<= exp;
    for (i = 7; i < (M - 2); i++)
    {
        tmp2 = IsfDiff[i] - mean;
        tmp3 = IsfDiff[i - 2] -  mean;
        L_tmp = (tmp2 * tmp3) << 1;
        hi = (Word16)(L_tmp >> 16);
        lo = (Word16)((L_tmp & 0xffff ) >> 1);
        voAMRWBPDecL_Extract(L_tmp, &hi, &lo);
        L_tmp = Mpy_32(hi, lo, hi, lo);
        IsfCorr[0] += L_tmp;
    }
    for (i = 7; i < (M - 2); i++)
    {
        tmp2 = IsfDiff[i] - mean;
        tmp3 = IsfDiff[i - 3] - mean;
        L_tmp = (tmp2 * tmp3) << 1;
        hi = (Word16)(L_tmp >> 16);
        lo = (Word16)((L_tmp & 0xffff ) >> 1);
        L_tmp = Mpy_32(hi, lo, hi, lo);
        IsfCorr[1] += L_tmp;
    }
    for (i = 7; i < (M - 2); i++)
    {
        tmp2 = IsfDiff[i] - mean;
        tmp3 = IsfDiff[i - 4] - mean;
        L_tmp = (tmp2 * tmp3) << 1;
        hi = (Word16)(L_tmp >> 16);
        lo = (Word16)((L_tmp & 0xffff ) >> 1);        
        L_tmp = Mpy_32(hi, lo, hi, lo);
        IsfCorr[2] += L_tmp;
    }
    if (IsfCorr[0] > IsfCorr[1])
    {
        MaxCorr = 0;
    } else
    {
        MaxCorr = 1;
    }

    if (IsfCorr[2] > IsfCorr[MaxCorr])
        MaxCorr = 2;

    MaxCorr++;             /* Maximum correlation of difference vector */

    for (i = M - 1; i < (M16k - 1); i++)
    {
        tmp = HfIsf[i - 1 - MaxCorr] - HfIsf[i - 2 - MaxCorr];
        HfIsf[i] = HfIsf[i - 1] + tmp;
    }

    /* tmp=7965+(HfIsf[2]-HfIsf[3]-HfIsf[4])/6; */
    tmp = (((HfIsf[2] - HfIsf[4] - HfIsf[3]) * 5461) >> 15) + 20390;
    
    if (tmp > 19456)
    {                                      /* Maximum value of ISF should be at most 7600 Hz */
        tmp = 19456;
    }
    tmp -= HfIsf[M - 2];
    tmp2 = HfIsf[M16k - 2] - HfIsf[M - 2];

    exp2 = norm_s(tmp2);
    exp = norm_s(tmp);
    exp--;
    tmp <<= exp;
    tmp2 <<= exp2;
    coeff = div_s(tmp, tmp2);              /* Coefficient for stretching the ISF vector */
    exp = exp2 - exp;

    for (i = M - 1; i < (M16k - 1); i++)
    {
        tmp = ((HfIsf[i] - HfIsf[i - 1]) * coeff) >> 15;
        IsfDiff[i - (M - 1)] = shl(tmp, exp);
    }

    for (i = M; i < (M16k - 1); i++)
    {
        /* The difference between ISF(n) and ISF(n-2) should be at least 500 Hz */
        tmp = IsfDiff[i - (M - 1)] + IsfDiff[i - M] - 1280;
        if (tmp < 0)
        {
            if (IsfDiff[i - (M - 1)] > IsfDiff[i - M])
            {
                IsfDiff[i - M] = 1280 - IsfDiff[i - (M - 1)];
            } else
            {
                IsfDiff[i - (M - 1)] = 1280 - IsfDiff[i - M];
            }
        }
    }

    for (i = M - 1; i < (M16k - 1); i++)
    {
        HfIsf[i] = HfIsf[i - 1] + IsfDiff[i - (M - 1)];
    }

    for (i = 0; i < (M16k - 1); i++)
    {
        HfIsf[i] = (HfIsf[i] * 26214) >> 15;  /* Scale the ISF vector correctly for 16000 kHz */
    }

    voAMRWBPDecIsf_isp(HfIsf, HfIsf, M16k);

    return;

#else

    Word16 IsfDiff[M - 2];
    Word32 IsfCorr[3];
    Word32 L_tmp;
    Word16 coeff, mean, tmp, tmp2, tmp3;
    Word16 exp, exp2, hi, lo;
    Word16 i, MaxCorr;

    HfIsf[M16k - 1] = HfIsf[M - 1];        

    /* Difference vector */
    for (i = 1; i < (M - 1); i++)
    {
        IsfDiff[i - 1] = sub(HfIsf[i], HfIsf[i - 1]);   
    }
    L_tmp = 0;                             move32();

    /* Mean of difference vector */
    for (i = 3; i < (M - 1); i++)
        L_tmp = L_mac(L_tmp, IsfDiff[i - 1], INV_LENGTH);
    mean = round16(L_tmp);

    IsfCorr[0] = 0;                        move32();
    IsfCorr[1] = 0;                        move32();
    IsfCorr[2] = 0;                        move32();

    tmp = 0;                               
    for (i = 0; i < (M - 2); i++)
    {
        
        if (sub(IsfDiff[i], tmp) > 0)
        {
            tmp = IsfDiff[i];              
        }
    }
    exp = norm_s(tmp);
    for (i = 0; i < (M - 2); i++)
    {
        IsfDiff[i] = shl(IsfDiff[i], exp); 
    }
    mean = shl(mean, exp);
    for (i = 7; i < (M - 2); i++)
    {
        tmp2 = sub(IsfDiff[i], mean);
        tmp3 = sub(IsfDiff[i - 2], mean);
        L_tmp = L_mult(tmp2, tmp3);
        voAMRWBPDecL_Extract(L_tmp, &hi, &lo);
        L_tmp = Mpy_32(hi, lo, hi, lo);
        IsfCorr[0] = L_add(IsfCorr[0], L_tmp);  move32();
    }
    for (i = 7; i < (M - 2); i++)
    {
        tmp2 = sub(IsfDiff[i], mean);
        tmp3 = sub(IsfDiff[i - 3], mean);
        L_tmp = L_mult(tmp2, tmp3);
        voAMRWBPDecL_Extract(L_tmp, &hi, &lo);
        L_tmp = Mpy_32(hi, lo, hi, lo);
        IsfCorr[1] = L_add(IsfCorr[1], L_tmp);  move32();
    }
    for (i = 7; i < (M - 2); i++)
    {
        tmp2 = sub(IsfDiff[i], mean);
        tmp3 = sub(IsfDiff[i - 4], mean);
        L_tmp = L_mult(tmp2, tmp3);
        voAMRWBPDecL_Extract(L_tmp, &hi, &lo);
        L_tmp = Mpy_32(hi, lo, hi, lo);
        IsfCorr[2] = L_add(IsfCorr[2], L_tmp);  move32();
    }
    
    if (L_sub(IsfCorr[0], IsfCorr[1]) > 0)
    {
        MaxCorr = 0;                       
    } else
    {
        MaxCorr = 1;                       
    }

    
    if (L_sub(IsfCorr[2], IsfCorr[MaxCorr]) > 0)
        MaxCorr = 2;                       

    MaxCorr = add(MaxCorr, 1);             /* Maximum correlation of difference vector */

    for (i = M - 1; i < (M16k - 1); i++)
    {
        tmp = sub(HfIsf[i - 1 - MaxCorr], HfIsf[i - 2 - MaxCorr]);
        HfIsf[i] = add(HfIsf[i - 1], tmp); 
    }

    /* tmp=7965+(HfIsf[2]-HfIsf[3]-HfIsf[4])/6; */
    tmp = add(HfIsf[4], HfIsf[3]);
    tmp = sub(HfIsf[2], tmp);
    tmp = mult(tmp, 5461);
    tmp = add(tmp, 20390);

    
    if (sub(tmp, 19456) > 0)
    {                                      /* Maximum value of ISF should be at most 7600 Hz */
        tmp = 19456;                       
    }
    tmp = sub(tmp, HfIsf[M - 2]);
    tmp2 = sub(HfIsf[M16k - 2], HfIsf[M - 2]);

    exp2 = norm_s(tmp2);
    exp = norm_s(tmp);
    exp = sub(exp, 1);
    tmp = shl(tmp, exp);
    tmp2 = shl(tmp2, exp2);
    coeff = div_s(tmp, tmp2);              /* Coefficient for stretching the ISF vector */
    exp = sub(exp2, exp);

    for (i = M - 1; i < (M16k - 1); i++)
    {
        tmp = mult(sub(HfIsf[i], HfIsf[i - 1]), coeff);
        IsfDiff[i - (M - 1)] = shl(tmp, exp);   
    }

    for (i = M; i < (M16k - 1); i++)
    {
        /* The difference between ISF(n) and ISF(n-2) should be at least 500 Hz */
        tmp = sub(add(IsfDiff[i - (M - 1)], IsfDiff[i - M]), 1280);
        
        if (tmp < 0)
        {
            
            if (sub(IsfDiff[i - (M - 1)], IsfDiff[i - M]) > 0)
            {
                IsfDiff[i - M] = sub(1280, IsfDiff[i - (M - 1)]);       
            } else
            {
                IsfDiff[i - (M - 1)] = sub(1280, IsfDiff[i - M]);       
            }
        }
    }

    for (i = M - 1; i < (M16k - 1); i++)
    {
        HfIsf[i] = add(HfIsf[i - 1], IsfDiff[i - (M - 1)]);     
    }

    for (i = 0; i < (M16k - 1); i++)
    {
        
        HfIsf[i] = mult(HfIsf[i], 26214);  /* Scale the ISF vector correctly for 16000 kHz */
    }

    voAMRWBPDecIsf_isp(HfIsf, HfIsf, M16k);

    return;

#endif
}
