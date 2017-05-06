/*
********************************************************************************
*
*      GSM AMR-NB speech codec   R98   Version 7.6.0   December 12, 2001
*                                R99   Version 3.3.0                
*                                REL-4 Version 4.1.0                
*
********************************************************************************
*
*      File             : bits2prm.c
*
********************************************************************************
*/
/*
********************************************************************************
*                         MODULE INCLUDE FILE AND VERSION ID
********************************************************************************
*/
#include "bits2prm.h"
const char bits2prm_id[] = "@(#)$Id $" bits2prm_h;
/*
********************************************************************************
*                         INCLUDE FILES
********************************************************************************
*/
#include "typedef.h"
#include "basic_op.h"
#include "mode.h"
#include <stdlib.h>
#include <stdio.h>

/*
********************************************************************************
*                         LOCAL VARIABLES AND TABLES
********************************************************************************
*/
#include "bitno.tab"

/*
********************************************************************************
*                         LOCAL PROGRAM CODE
********************************************************************************
*/

/*
**************************************************************************
*
*  Function    : Bin2int
*  Purpose     : Read "no_of_bits" bits from the array bitstream[] 
*                and convert to integer.
*
**************************************************************************
*/
__voinline Word16 Bin2int ( /* Reconstructed parameter                      */
								Word16 no_of_bits,  /* input : number of bits associated with value */
								Word16 *bitstream   /* output: address where bits are written       */
								)
{
	Word16 value = 0,  bit;
	int i;                               
	for (i = 0; i < no_of_bits; i++)
	{
		value <<= 1;                            
		bit = *bitstream++;                     
		bit--;
		if (bit== 0)
			value += 1;                         
	}
	return (value);
}
/*
********************************************************************************
*                         PUBLIC PROGRAM CODE
********************************************************************************
*/
/*
**************************************************************************
*
*  Function    : Bits2prm
*  Purpose     : Retrieves the vector of encoder parameters from 
*                the received serial bits in a frame.
*
**************************************************************************
*/
void Bits2prm (
			   enum Mode mode,     /* i : AMR mode                                    */
			   Word16 bits[],      /* i : serial bits       (size <= MAX_SERIAL_SIZE) */
			   Word16 prm[]        /* o : analysis parameters  (size <= MAX_PRM_SIZE) */
)
{
	int   i,high;
	high = voAMRNBDecprmno[mode];                      /* account for pointer init (voAMRNBDecbitno[mode])  */

	for (i = 0; i <high ; i++)
	{
		prm[i] = Bin2int (voAMRNBDecbitno[mode][i], bits);      
		bits += voAMRNBDecbitno[mode][i];
	}
	return;
}
