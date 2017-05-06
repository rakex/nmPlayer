/*
********************************************************************************
*
*      GSM AMR-NB speech codec   R98   Version 7.6.0   December 12, 2001
*                                R99   Version 3.3.0                
*                                REL-4 Version 4.1.0                
*
********************************************************************************
*
*      File             : inter_36.h
*      Purpose          : Interpolating the normalized correlation
*                       : with 1/3 or 1/6 resolution.
*
********************************************************************************
*/
#ifndef inter_36_h
#define inter_36_h "$Id $"
 
/*
********************************************************************************
*                         INCLUDE FILES
********************************************************************************
*/
#include "typedef.h"
 
/*
********************************************************************************
*                         DEFINITION OF DATA TYPES
********************************************************************************
*/
 
/*
********************************************************************************
*                         DECLARATION OF PROTOTYPES
********************************************************************************
*/
Word16 voAMRNBEnc_Interpol_3or6 (  /* (o)  : interpolated value                        */
    Word16 *x,          /* (i)  : input vector                              */
    Word16 frac,        /* (i)  : fraction  (-2..2 for 3*, -3..3 for 6*)    */
    Word16 flag3        /* (i)  : if set, upsampling rate = 3 (6 otherwise) */
);
 
#endif
