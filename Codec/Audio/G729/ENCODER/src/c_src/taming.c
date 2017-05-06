/* ITU-T G.729 Software Package Release 2 (November 2006) */
/*
   ITU-T G.729A Speech Coder    ANSI-C Source Code
   Version 1.1    Last modified: September 1996

   Copyright (c) 1996,
   AT&T, France Telecom, NTT, Universite de Sherbrooke
   All rights reserved.
*/

/**************************************************************************
 * Taming functions.                                                      *
 **************************************************************************/

#include "typedef.h"
#include "basic_op.h"
#include "oper_32b.h"
#include "ld8a.h"
#include "tab_ld8a.h"

static Word32 L_exc_err[4];

void Init_exc_err(void)
{
  L_exc_err[0] = 0x00004000L;
  L_exc_err[1] = 0x00004000L;
  L_exc_err[2] = 0x00004000L;
  L_exc_err[3] = 0x00004000L;
}

/**************************************************************************
 * routine test_err - computes the accumulated potential error in the     *
 * adaptive codebook contribution                                         *
 **************************************************************************/

Word16 test_err(  /* (o) flag set to 1 if taming is necessary  */
 Word16 T0,       /* (i) integer part of pitch delay           */
 Word16 T0_frac   /* (i) fractional part of pitch delay        */
)
 {
    Word16 t1, zone1, zone2, flag;
    Word32 i, L_maxloc;

    if(T0_frac > 0) {
        t1 = T0 + 1;
    }
    else {
        t1 = T0;
    }

    i = t1 - 50;
    if(i < 0) {
        i = 0;
    }
    zone1 = tab_zone[i];

    i = t1 + 8;
    zone2 = tab_zone[i];

    L_maxloc = -1L;
    flag = 0 ;
    for(i=zone2; i>=zone1; i--) {
        if(L_exc_err[i] > L_maxloc) {
                L_maxloc = L_exc_err[i];
        }
    }
    if(L_maxloc > L_THRESH_ERR) {
        flag = 1;
    }
    return(flag);
}

/**************************************************************************
 *routine update_exc_err - maintains the memory used to compute the error *
 * function due to an adaptive codebook mismatch between encoder and      *
 * decoder                                                                *
 **************************************************************************/

void update_exc_err(
 Word16 gain_pit,      /* (i) pitch gain */
 Word16 T0             /* (i) integer part of pitch delay */
)
 {
    Word16 zone1, zone2, n;
    Word32 i, L_worst, L_temp;
    Word16 hi, lo;

    L_worst = -1L;
    n = T0 - L_SUBFR;
	//Kh = t0 >>16;
	//Kl = (t0 - (Kh<<16))>>1;
	// L_Extract(t0, &Kh, &Kl);              /* K in DPF         */
    if(n < 0) {
		hi = (Word16)(L_exc_err[0]>>16);
        lo = (Word16)((L_exc_err[0]- (hi<<16))>>1);
        //L_Extract(L_exc_err[0], &hi, &lo);
        L_temp = Mpy_32_16(hi, lo, gain_pit);
        L_temp = L_shl2(L_temp, 1);
        L_temp = L_add(0x00004000L, L_temp);
        if(L_temp > L_worst) {
                L_worst = L_temp;
        }
		hi = (Word16)(L_temp>>16);
        lo = (Word16)((L_temp- (hi<<16))>>1);
        //L_Extract(L_temp, &hi, &lo);
        L_temp = (hi * gain_pit)<<1;
	    L_temp +=(((lo * gain_pit)>>15)<<1);
        //L_temp = Mpy_32_16(hi, lo, gain_pit);
        L_temp = L_shl2(L_temp, 1);
        L_temp = L_add(0x00004000L, L_temp);
        if(L_temp > L_worst) {
                L_worst = L_temp;
        }
    }
    else {
        zone1 = tab_zone[n];
        i = T0 - 1;
        zone2 = tab_zone[i];

        for(i = zone1; i <= zone2; i++) {
		        hi = (Word16)(L_exc_err[i]>>16);
                lo = (Word16)((L_exc_err[i]- (hi<<16))>>1);
                //L_Extract(L_exc_err[i], &hi, &lo);
                L_temp = (hi * gain_pit)<<1;
				L_temp +=(((lo * gain_pit)>>15)<<1);
               // L_temp = Mpy_32_16(hi, lo, gain_pit);
                L_temp = L_shl2(L_temp, 1);
                L_temp = L_add(0x00004000L, L_temp);
                if(L_temp > L_worst) L_worst = L_temp;
        }
    }
    for(i=3; i>=1; i--) {
        L_exc_err[i] = L_exc_err[i-1];
    }
    L_exc_err[0] = L_worst;

    return;
}

