/*
********************************************************************************
*
*      GSM AMR-NB speech codec   R98   Version 7.6.0   December 12, 2001
*                                R99   Version 3.3.0                
*                                REL-4 Version 4.1.0                
*
********************************************************************************
*
*      File             : weight_a.c
*      Purpose          : Spectral expansion of LP coefficients.  (order==10)
*      Description      : a_exp[i] = a[i] * fac[i-1]    ,i=1,10
*
********************************************************************************
*/
/*
********************************************************************************
*                         MODULE INCLUDE FILE AND VERSION ID
********************************************************************************
*/
#include "weight_a.h"
const char voAMRNBDecweight_a_id[] = "@(#)$Id $" weight_a_h;

/*
********************************************************************************
*                         INCLUDE FILES
********************************************************************************
*/
#include "typedef.h"
#include "basic_op.h"
#include "cnst.h"

/*
********************************************************************************
*                         LOCAL VARIABLES AND TABLES
********************************************************************************
*/
/*
*--------------------------------------*
* Constants (defined in cnst.h         *
*--------------------------------------*
*  M         : LPC order               *
*--------------------------------------*
*/

/*
********************************************************************************
*                         PUBLIC PROGRAM CODE
********************************************************************************
*/
void voAMRNBDecWeight_Ai (
    Word16 a[],         /* (i)     : a[M+1]  LPC coefficients   (M=10)    */
    const Word16 fac[], /* (i)     : Spectral expansion factors.          */
    Word16 a_exp[]      /* (o)     : Spectral expanded LPC coefficients   */
)
#ifdef C_OPT
{
	a_exp[0] = a[0];                                    
	a_exp[1] = ((a[1]* fac[0]<<1)+0x00008000)>>16;
	a_exp[2] = ((a[2]* fac[1]<<1)+0x00008000)>>16;
	a_exp[3] = ((a[3]* fac[2]<<1)+0x00008000)>>16;
	a_exp[4] = ((a[4]* fac[3]<<1)+0x00008000)>>16;
	a_exp[5] = ((a[5]* fac[4]<<1)+0x00008000)>>16;
	a_exp[6] = ((a[6]* fac[5]<<1)+0x00008000)>>16;
	a_exp[7] = ((a[7]* fac[6]<<1)+0x00008000)>>16;
	a_exp[8] = ((a[8]* fac[7]<<1)+0x00008000)>>16;
	a_exp[9] = ((a[9]* fac[8]<<1)+0x00008000)>>16;
	a_exp[10] = ((a[10]* fac[9]<<1)+0x00008000)>>16;;
	return;
}
#else
{
	Word16 i;
	a_exp[0] = a[0];                                 
	for (i = 1; i <= M; i++)
	{
		a_exp[i] = vo_round (L_mult (a[i], fac[i - 1]));  
	}
	return;
}
#endif
