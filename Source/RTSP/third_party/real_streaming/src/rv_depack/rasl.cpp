/* ***** BEGIN LICENSE BLOCK *****
 * Source last modified: $Id: rasl.c,v 1.1.1.1.2.1 2005/05/04 18:21:33 hubbe Exp $
 * 
 * REALNETWORKS CONFIDENTIAL--NOT FOR DISTRIBUTION IN SOURCE CODE FORM
 * Portions Copyright (c) 1995-2005 RealNetworks, Inc.
 * All Rights Reserved.
 * 
 * The contents of this file, and the files included with this file,
 * are subject to the current version of the Real Format Source Code
 * Porting and Optimization License, available at
 * https://helixcommunity.org/2005/license/realformatsource (unless
 * RealNetworks otherwise expressly agrees in writing that you are
 * subject to a different license).  You may also obtain the license
 * terms directly from RealNetworks.  You may not use this file except
 * in compliance with the Real Format Source Code Porting and
 * Optimization License. There are no redistribution rights for the
 * source code of this file. Please see the Real Format Source Code
 * Porting and Optimization License for the rights, obligations and
 * limitations governing use of the contents of the file.
 * 
 * RealNetworks is the developer of the Original Code and owns the
 * copyrights in the portions it created.
 * 
 * This file, and the files included with this file, is distributed and
 * made available on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, AND REALNETWORKS HEREBY DISCLAIMS ALL
 * SUCH WARRANTIES, INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT
 * OR NON-INFRINGEMENT.
 * 
 * Technology Compatibility Kit Test Suite(s) Location:
 * https://rarvcode-tck.helixcommunity.org
 * 
 * Contributor(s):
 * 
 * ***** END LICENSE BLOCK ***** */

#include <memory.h>
#include <string.h>

#include "helix_types.h"
#include "rasl.h"

#ifdef _VONAMESPACE
namespace _VONAMESPACE{
#endif

/*
 * The interleave table was created with the following properties:
 * -equal contributions from each block
 * -symmetric (if table[i] = j, then table[j] = i), allows in-place interleave
 * -random spacing between lost frames, except
 * -no double losses
 * Solution was generated by a random-walk optimization loop.
 * 
 */
/* Loss patterns for a five-block solution:
...X..X....X.X.....X.X.X........X..........X...X.X....X........X..X..X..X.......
.X..X....X........X...X..X.....X.X........X...X....X...X..X......X....X.......X.
..X..X.X.........X..........X.X...X...X..X...X.......X.....X.X.....X......X.X...
..........X.X..X....X......X.X......X...X...X...X.X.....X.....X.X......X.X......
X.......X.....X.X.......X.X........X.X.X............X....X..X.......X......X.X.X
*/
/*
static int RASL_InterleaveTable[RASL_NFRAMES * RASL_NBLOCKS] = {
	66, 21, 43, 3, 23, 47, 6, 32, 72, 19, 49, 11, 54, 13, 69, 63,
	65, 42, 18, 9, 58, 1, 22, 4, 78, 25, 70, 51, 33, 55, 46, 31,
	7, 28, 34, 74, 61, 76, 38, 67, 59, 41, 17, 2, 53, 45, 30, 5,
	48, 10, 50, 27, 71, 44, 12, 29, 56, 73, 20, 40, 64, 36, 62, 15,
	60, 16, 0, 39, 68, 14, 26, 52, 8, 57, 35, 75, 37, 77, 24, 79
};
*/

/* Loss pattern for a six-block solution
....X.X....X..........X........X....X..X....X........X....X....X....X....X.......X....X...X.....
.X.....X..........X....X...X..X...X...........X...X...X..X...........X.X...X............X.....X.
..X.......X..X......X...X............X...X.....X........X..X.....X....X...X..........X.X....X...
X........X.....X.X........X..X..........X....X......X.......X.X.............X..X.........X...X.X
............X.X.X....X......X...X..X.......X....X............X..X.X.....X.....X.X..X............
...X.X..X..........X.....X.......X....X...X......X.X...X...........X.........X....X.X......X....
*/
static const int RASL_InterleaveTable[RASL_NFRAMES * RASL_NBLOCKS] = {
	63, 22, 44, 90, 4, 81, 6, 31, 86, 58, 36, 11, 68, 39, 73, 53,
	69, 57, 18, 88, 34, 71, 1, 23, 46, 94, 54, 27, 75, 50, 30, 7,
	70, 92, 20, 74, 10, 37, 85, 13, 56, 41, 87, 65, 2, 59, 24, 47,
	79, 93, 29, 89, 52, 15, 26, 95, 40, 17, 9, 45, 60, 76, 62, 0,
	64, 43, 66, 83, 12, 16, 32, 21, 72, 14, 35, 28, 61, 80, 78, 48,
	77, 5, 82, 67, 84, 38, 8, 42, 19, 51, 3, 91, 33, 49, 25, 55
};

/*
 * DeInterleave operates in-place!.
 * 
 * Entry:
 * buf points to NCODEBYTES * NFRAMES * NBLOCKS bytes of interleaved data.
 * If an input block is bad, flag[block] should be set.
 * 
 * Exit:
 * data in buf is deinterleaved.
 * flags[block] stores a bit array for each output block,
 * where (flags[block] & (1 << F)) is set if Fth frame is bad.
 */
void
RASL_DeInterleave(char *buf, unsigned long ulBufSize, int type, ULONG32 * pFlags)
{
        char temp[RASL_MAXCODEBYTES];     /* space for swapping */ /* Flawfinder: ignore */
        INT32 inFlags[RASL_NBLOCKS];           /* save input flags */
        int nCodeBytes,nCodeBits;
        int fi, fo;                           /* frame in/out */
	    int blk;
        int bitOffsetTo, bitOffsetFrom;       /* for bit maniputlations */
        char *toPtr, *fromPtr;                /* for bit maniputlations */
        unsigned long ulToBufSize;
        unsigned long ulFromBufSize;

        if(type == 0)
        {
            nCodeBits=RA65_NCODEBITS;   
        }
        if(type == 1)
        {
            nCodeBits=RA85_NCODEBITS;
        }
        if(type == 2)
        {
            nCodeBits=RA50_NCODEBITS;
        }
        if(type == 3)
        {
            nCodeBits=RA160_NCODEBITS;  
        }


	/* Save input flags, and initialize output flags */
	if(pFlags)
        for (blk = 0; blk < RASL_NBLOCKS; blk++) {
		inFlags[blk] = pFlags[blk];	    /* save input */
		pFlags[blk] = 0;				/* init output to no error */
	}


        if(nCodeBits%8 == 0)
        {
            nCodeBytes=nCodeBits>>3;
            for (fi = 0; fi < RASL_NFRAMES * RASL_NBLOCKS; fi++)
            {
		
                fo = RASL_InterleaveTable[fi];  /* frame to swap with */
		/* 
		 * Note that when (fo == fi), the frame doesn't move, 
		 * and if (fo < fi), we have swapped it already.
		 */
                if (fo > fi)             /* do the swap if needed */
                { 
                    memcpy(temp, buf + fo * nCodeBytes, nCodeBytes); /* Flawfinder: ignore */
                    memcpy(buf + fo * nCodeBytes, buf + fi * nCodeBytes, nCodeBytes); /* Flawfinder: ignore */
                    memcpy(buf + fi * nCodeBytes, temp, nCodeBytes); /* Flawfinder: ignore */
		        }

		/* 
		 * If frame came from bad block, set bit corresponding to new position.
		 * Only check one of the swapped pair, since other will be done when
		 * fi gets there.
		 */
                if (pFlags && inFlags[RASL_BLOCK_NUM(fi)])
                        pFlags[RASL_BLOCK_NUM(fo)] |= (1 << RASL_BLOCK_OFF(fo));
            }
        }
        else
        {
            for (fi = 0; fi < RASL_NFRAMES * RASL_NBLOCKS; fi++)
            {
		
                fo = RASL_InterleaveTable[fi];  /* frame to swap with */
		/* 
		 * Note that when (fo == fi), the frame doesn't move, 
		 * and if (fo < fi), we have swapped it already.
		 */
                if (fo > fi)             /* do the swap if needed */
                { 
                    toPtr=temp;
                    ulToBufSize = RASL_MAXCODEBYTES;
                    fromPtr=buf;
                    ulFromBufSize = ulBufSize;
                    bitOffsetTo=0;
                    bitOffsetFrom=fo*nCodeBits;
                    ra_bitcopy((unsigned char *)toPtr,ulToBufSize,(unsigned char *)fromPtr,ulFromBufSize,bitOffsetTo,bitOffsetFrom,nCodeBits);

                    toPtr=buf;
                    ulToBufSize = ulBufSize;
                    fromPtr=buf;
                    ulFromBufSize = ulBufSize;
                    bitOffsetTo=fo*nCodeBits;
                    bitOffsetFrom=fi*nCodeBits;
                    ra_bitcopy((unsigned char *)toPtr,ulToBufSize,(unsigned char *)fromPtr,ulFromBufSize,bitOffsetTo,bitOffsetFrom,nCodeBits);

                    toPtr=buf;
                    ulToBufSize = ulBufSize;
                    fromPtr=temp;
                    ulFromBufSize = RASL_MAXCODEBYTES;
                    bitOffsetTo=fi*nCodeBits;
                    bitOffsetFrom=0;
                    ra_bitcopy((unsigned char *)toPtr,ulToBufSize,(unsigned char *)fromPtr,ulFromBufSize,bitOffsetTo,bitOffsetFrom,nCodeBits);
		       }

		/* 
		 * If frame came from bad block, set bit corresponding to new position.
		 * Only check one of the swapped pair, since other will be done when
		 * fi gets there.
		 */	    
                if (pFlags && inFlags[RASL_BLOCK_NUM(fi)])
                        pFlags[RASL_BLOCK_NUM(fo)] |= (1 << RASL_BLOCK_OFF(fo));
	    }
    }
}

void ra_bitcopy(unsigned char* toPtr,
                unsigned long  ulToBufSize,
                unsigned char* fromPtr,
                unsigned long  ulFromBufSize,
                int            bitOffsetTo,
                int            bitOffsetFrom,
                int            numBits)
{
    unsigned char* pToLimit   = toPtr   + ulToBufSize;
    int bofMod8, botMod8, nbMod8, eightMinusBotMod8, eightMinusBofMod8, i, iMax;
    unsigned char rightInword, leftInword, *byteOffsetFrom, *byteOffsetTo,
                  alignWord, endWord;
    unsigned char lmask[9] = {0, 0x80, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc, 0xfe, 0xff}; /* Flawfinder: ignore */
    unsigned char rmask[9] = {0, 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff}; /* Flawfinder: ignore */

    int nibbleAlignFrom, nibbleAlignTo, alignCase=30; // special case variables
    unsigned char mask[2] = {0x0f, 0xf0}; /* Flawfinder: ignore */

    bofMod8 = bitOffsetFrom & 0x07;  // same as %8
    botMod8 = bitOffsetTo & 0x07;
    nbMod8 = numBits & 0x07;
    eightMinusBofMod8 = 8 - bofMod8; // don't want these evaluated every loop
    eightMinusBotMod8 = 8 - botMod8; 
    byteOffsetFrom = fromPtr + (bitOffsetFrom >> 3);
    byteOffsetTo = toPtr + (bitOffsetTo >> 3);
    iMax = (numBits>>3) - 1; // last output byte not handled inside a loop

    if (numBits>>3 == 0)
    // quick and easy if we have fewer than 8 bits to align
    
    {
       	leftInword = *(byteOffsetFrom++);
        rightInword = *(byteOffsetFrom);
        alignWord = (leftInword >> bofMod8) + (rightInword << (eightMinusBofMod8));
        alignWord &= rmask[nbMod8];

    	if (nbMod8 >= eightMinusBotMod8)  // have more extra input bits than 
                                          // free space in current output byte
            {
            *(byteOffsetTo) &= rmask[botMod8];
            *(byteOffsetTo++) += (alignWord << botMod8);
            *(byteOffsetTo) = ((*byteOffsetTo) & lmask[8-(nbMod8-eightMinusBotMod8)])
                + (alignWord >> eightMinusBotMod8);
            }

       	else    // have fewer input bits than free space in current output byte
                // be careful not to overwrite extra bits already in output byte 
            {
            endWord = *(byteOffsetTo) & lmask[8-(nbMod8+botMod8)];
            *(byteOffsetTo) &= rmask[botMod8];
            *(byteOffsetTo) += ((alignWord << botMod8) + endWord);
            }
        return; // finished, return to calling function
  	}	

    if (bitOffsetFrom%4 == 0 && bitOffsetTo%4 == 0)
     	// byte-packing done here is optimized for the common case of nibble-alignment
  
    {
        nibbleAlignFrom = (bitOffsetFrom & 0x04)>>2;  // 0 implies whole-byte alignment 
        nibbleAlignTo = (bitOffsetTo & 0x04)>>2;      // 1 implies half-byte alignment
        

        if (nibbleAlignFrom == nibbleAlignTo) // either src and dest both byte-aligned 
        {                                      // or both half byte-aligned
            if (nibbleAlignFrom == 0)
                alignCase = 0;
            else
                alignCase = 3;
        }

        if (nibbleAlignFrom != nibbleAlignTo)
        {
			if (nibbleAlignFrom == 0)
                alignCase = 1;          // src aligned, dest half aligned
            else 
                alignCase = 2;          // src half aligned, dest aligned
        }
		
        switch (alignCase)
        {
        case 0:
            for (i=0; i<iMax; i++)
                *byteOffsetTo++ = *byteOffsetFrom++; // copy byte-by-byte directly
                break;
    
        case 1:
            for (i=0; i<iMax; i++)  // move two nibbles from src to dest each loop
            {                       // shift bits as necessary
                *byteOffsetTo = (*byteOffsetTo & mask[0]) + 
                    ((*byteOffsetFrom & mask[0])<<4);
                *++byteOffsetTo = ((*byteOffsetFrom++ & mask[1])>>4);
            }
                break;
    
        case 2:
            for (i=0; i<iMax; i++)  // same as case 1, but shift other direction   
            {
                *byteOffsetTo = ((*byteOffsetFrom & mask[1])>>4);
                *byteOffsetTo++ += ((*++byteOffsetFrom & mask[0])<<4);
            }
                break;

        case 3:
            {
            *byteOffsetTo &= mask[0];  // align first nibble, thereafter this is
            *byteOffsetTo += (*byteOffsetFrom & mask[1]);  // just like case 0
            for (i=0; i<iMax; i++)
                *++byteOffsetTo = *++byteOffsetFrom; // copy byte-by-byte directly
            }   
                break;
        }
    }

    else
    	// this code can handle all source and destination buffer offsets
    	
    {
    	// take the first 8 desired bits from the input buffer, store them
    	// in alignWord, then break up alignWord into two pieces to 
    	// fit in the free space in two consecutive output buffer bytes

        for (i=0; i<iMax; i++)
        {
            leftInword = *(byteOffsetFrom++);
            rightInword = *(byteOffsetFrom);
            alignWord = (leftInword >> bofMod8) + (rightInword << (eightMinusBofMod8));
            *(byteOffsetTo) = (*(byteOffsetTo) & rmask[botMod8]) +
                (alignWord << (botMod8));
            *(++byteOffsetTo) = alignWord >> (eightMinusBotMod8);
        }
    }
        // special section to set last byte in fromBuf correctly
        
        // even if byte packing was done with the code optimized for nibble-alignment,
       	// the tricky job of setting the last output byte is still done here
    
            leftInword = *(byteOffsetFrom++);
            rightInword = *(byteOffsetFrom);
            alignWord = (leftInword >> bofMod8) + (rightInword << (eightMinusBofMod8));
            *(byteOffsetTo) = (*(byteOffsetTo) & rmask[botMod8]) +
                (alignWord << (botMod8));

            if (nbMod8 >= eightMinusBotMod8)
            {
	            *(++byteOffsetTo) = alignWord >> (eightMinusBotMod8);
	              
	            leftInword = *(byteOffsetFrom++);
	            rightInword = *(byteOffsetFrom);
	            alignWord = (leftInword >> bofMod8) + (rightInword << (eightMinusBofMod8));
	            alignWord &= rmask[nbMod8];
	            *(byteOffsetTo++) += (alignWord << botMod8);
	            if (byteOffsetTo >= toPtr && byteOffsetTo < pToLimit)
	            {
	               *(byteOffsetTo) = ((*byteOffsetTo) & lmask[8-(nbMod8-eightMinusBotMod8)])
	                                 + (alignWord >> eightMinusBotMod8);
	            }
            }
            else
            {
	            endWord = *(++byteOffsetTo) & lmask[8-(nbMod8+botMod8)];
	            *(byteOffsetTo) = alignWord >> (eightMinusBotMod8);
	            leftInword = *(byteOffsetFrom++);
	            rightInword = *(byteOffsetFrom);
	            alignWord = (leftInword >> bofMod8) + (rightInword << (eightMinusBofMod8));
	            alignWord &= rmask[nbMod8];
	            *(byteOffsetTo) += ((alignWord << botMod8) + endWord);
            }
            
    
}

#ifdef _VONAMESPACE
}
#endif