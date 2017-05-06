/*
********************************************************************************
*
*      GSM AMR-NB speech codec   R98   Version 7.6.0   December 12, 2001
*                                R99   Version 3.3.0                
*                                REL-4 Version 4.1.0                
*
********************************************************************************
*      File             : copy.h
*      Purpose          : Copy vector x[] to y[]
*
********************************************************************************
*/
#ifndef copy_h
#define copy_h "$Id $"
#ifdef VOI_OPT
#define VOI_OPT_COPY 1
#endif
 
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
 
/*
**************************************************************************
*
*  Function    : Copy
*  Purpose     : Copy vector x[] to y[], vector length L
*  Returns     : void
*
**************************************************************************
*/
#if !VOI_OPT_COPY
void voAMRNBDecCopy (
    const Word16 x[],  /* i : input vector (L)    */
    Word16 y[],        /* o : output vector (L)   */
    Word16 L           /* i : vector length       */
);
#else//VOI_OPT_COPY
#include "basic_op.h"
#include "count.h"

/*
********************************************************************************
*                         PUBLIC PROGRAM CODE
********************************************************************************
*/
/*************************************************************************
 *
 *   FUNCTION:   Copy
 *
 *   PURPOSE:   Copy vector x[] to y[]
 *
 *
 *************************************************************************/
/*
**************************************************************************
*
*  Function    : Copy
*  Purpose     : Copy vector x[] to y[]
*
**************************************************************************
*/
__inline void voAMRNBDecCopy (
    const Word16 x[],   /* i : input vector (L)  */
    Word16 y[],         /* o : output vector (L) */
    Word16 L            /* i : vector length     */
)
{
    //Word16 i;

    //for (i = 0; i < L; i++)
    //{
    //    y[i] = x[i];            //move16 (); 
    //}

    //return;
	memcpy(y,x,L<<1);
}
#endif//VOI_OPT_COPY
#endif
