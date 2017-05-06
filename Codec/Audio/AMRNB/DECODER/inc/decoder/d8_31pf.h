/*
********************************************************************************
*
*      GSM AMR-NB speech codec   R98   Version 7.6.0   December 12, 2001
*                                R99   Version 3.3.0                
*                                REL-4 Version 4.1.0                
*
********************************************************************************
*
*      File             : d8_31pf.h
*      Purpose          : Builds the innovative codevector
*
********************************************************************************
*/
#ifndef d8_31pf_h
#define d8_31pf_h "$Id $"
 
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
void dec_8i40_31bits (
    Word16 index[],    /* i : index of 8 pulses (sign+position)         */
    Word16 cod[]       /* o : algebraic (fixed) codebook excitation     */
);
 
#endif
