/*
********************************************************************************
*
*      GSM AMR-NB speech codec   R98   Version 7.6.0   December 12, 2001
*                                R99   Version 3.3.0                
*                                REL-4 Version 4.1.0                
*
********************************************************************************
*
*      File             : inv_sqrt.c
*      Purpose          : Computes 1/sqrt(L_x),  where  L_x is positive.
*                       : If L_x is negative or zero, 
*                       : the result is 1 (3fff ffff).
*      Description      :
*            The function 1/sqrt(L_x) is approximated by a table and linear
*            interpolation. The inverse square root is computed using the
*            following steps:
*                1- Normalization of L_x.
*                2- If (30-exponent) is even then shift right once.
*                3- exponent = (30-exponent)/2  +1
*                4- i = bit25-b31 of L_x;  16<=i<=63  because of normalization.
*                5- a = bit10-b24
*                6- i -=16
*                7- L_y = table[i]<<16 - (table[i] - table[i+1]) * a * 2
*                8- L_y >>= exponent
*
********************************************************************************
*/
/*
********************************************************************************
*                         MODULE INCLUDE FILE AND VERSION ID
********************************************************************************
*/
#include "inv_sqrt.h"
#if !VOI_OPT_INV_SQRT
const char inv_sqrt_id[] = "@(#)$Id $" inv_sqrt_h;

/*
********************************************************************************
*                         INCLUDE FILES
********************************************************************************
*/
#include "typedef.h"
#include "basic_op.h"
/*
********************************************************************************
*                         LOCAL VARIABLES AND TABLES
********************************************************************************
*/
#include "inv_sqrt.tab" /* Table for inv_sqrt() */

/*
********************************************************************************
*                         PUBLIC PROGRAM CODE
********************************************************************************
*/
Word32 Inv_sqrt (       /* (o) : output value   */
				 Word32 L_x          /* (i) : input value    */
				 )
{
	nativeInt exp, i, a, tmp;
	Word32 L_y;

	if (L_x <= (Word32) 0)
		return ((Word32) 0x3fffffffL);

	exp = norm_l (L_x);
	L_x <<= exp;     /* L_x is normalize */

	exp = (30- exp);
	if ((exp & 1) == 0)         /* If exponent even -> shift right */
	{
		L_x = (L_x>> 1);
	}
	exp = (exp>> 1);
	exp = (exp+ 1);

	L_x =  (L_x>> 9);
	i = extract_h (L_x);        /* Extract b25-b31 */
	L_x = (L_x>> 1);
	a = extract_l (L_x);        /* Extract b10-b24 */
	a = a & (Word16) 0x7fff;    //logic16 (); 
	i =  (i - 16);
	L_y = L_deposit_h (voAMRNBDecInv_sqrt_table[i]);       /* table[i] << 16          */
	tmp = (voAMRNBDecInv_sqrt_table[i] - voAMRNBDecInv_sqrt_table[i + 1]); /* table[i] - table[i+1])  */
	L_y -=  tmp*a<<1  ;//L_y = L_msu (L_y, tmp, a);  /* L_y -=  tmp*a*2         */
	L_y = (L_y>> exp);     /* denormalization */
	return (L_y);
}
Word16 div_agc_s (Word16 var1, Word16 var2)
{
	Word32 quot;
	if ((var1 > var2) || (var1 < 0) || (var2 < 0))
	{
		return 0;
	}
	quot = 0x8000 * var1;
	quot /= var2;
	if (quot > MAX_16)
		return MAX_16;
	else
		return (Word16)quot;
}
#endif//!VOI_OPT_INV_SQRT
