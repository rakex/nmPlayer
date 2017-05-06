/****************************************************************************
*
*   Module Title :     idctpart.c
*
*   Description  :     IDCT with multiple versions based on # of non 0 coeffs
*
*   Copyright (c) 1999 - 2005  On2 Technologies Inc. All Rights Reserved.
*
****************************************************************************/

/****************************************************************************
*  Header Files
****************************************************************************/
#include "pbdll.h"
#include "on2_mem.h"

/****************************************************************************
*  Macros
****************************************************************************/
#define IdctAdjustBeforeShift 8
#define xC1S7 (64277>>1)
#define xC2S6 (60547>>1)
#define xC3S5 (54491>>1)
#define xC4S4 (46341>>1)
#define xC5S3 (36410>>1)
#define xC6S2 (25080>>1)  //
#define xC7S1 (12785>>1)



#define M(a,b) (((a) * (b)))
#if 1
#define SAT(x) 	(unsigned char) ( (x) < 0 ? 0 : ( (x) <= 255 ? (x) : 255 ) )
#else
    static FORCEINLINE
    UINT8 SAT(INT16 _x)
    {
        if( _x & 0xff00 )
        {
            _x = 255 + ( (_x >> 15) & 0x1 );
        }
        return (UINT8)_x;
    }
#endif
/****************************************************************************
 * 
 *  ROUTINE       : IDctSlow
 *
 *  INPUTS        : INT16 *InputData   : Pointer to 8x8 quantized DCT coefficients.
 *                  INT16 *QuantMatrix : Pointer to 8x8 quantization matrix.
 *
 *  OUTPUTS       : INT16 *OutputData  : Pointer to 8x8 block to hold output.
 *
 *  RETURNS       : void
 *
 *  FUNCTION      : Inverse quantizes and inverse DCT's input 8x8 block
 *                  to reproduce prediction error.
 *
 *  SPECIAL NOTES : None. 
 *
 ****************************************************************************/
void IDCTvp6_Block8x8_c(INT16 *input, UINT8 *dst, INT32 DestStride, const UINT8 *src, INT32 stride)
{
    INT16 *ip = input;

    INT32 A, B, C, D, Ad, Bd, Cd, Dd, E, F, G, H;
    INT32 Ed, Gd, Add, Bdd, Fd, Hd;

    INT32 i;// v;

    /* Inverse DCT on the rows now */
    for (i = 0; i < 8; i++) {
    	if(!(ip[2*8] | ip[3*8] | ip[4*8] | ip[5*8] | ip[6*8] | ip[7*8]))
    	{
    		if(!ip[1*8])
    		{
    			if(ip[0*8])	//ip0
    			{
					E = M(xC4S4, ip[0*8]);
					E = E>>15;
		            ip[0*8] =
		            ip[7*8] =

		            ip[1*8] =
		            ip[2*8] =
		            
		            ip[3*8] =
		            ip[4*8] =

		            ip[5*8] =
		            ip[6*8] = E;    					
    			}
    		}
    		else	////ip0, 1
    		{
				A = M(xC1S7, ip[1*8]);
				B = M(xC7S1, ip[1*8]);
				E = M(xC4S4, ip[0*8]);
				
				Ad = M(xC4S4, A>>15);
				Bd = M(xC4S4, B>>15);

				Gd = E - Ad;
				Add = E + Ad;
				
				/*  Final sequence of operations over-write original inputs. */
				ip[0*8] = (E + A)>>15 ;
				ip[7*8] = (E - A)>>15 ;
				
				ip[1*8] = (Add + Bd)>>15;
				ip[2*8] = (Add - Bd)>>15;
				
				ip[3*8] = (E + B)>>15 ;
				ip[4*8] = (E - B)>>15 ;
				
				ip[5*8] = (Gd + Bd)>>15;
				ip[6*8] = (Gd - Bd)>>15;   				
    		}
    				
    			
    	}
    	else
    	{
    		{
	            A = M(xC1S7, ip[1*8]) + M(xC7S1, ip[7*8]);
	            B = M(xC7S1, ip[1*8]) - M(xC1S7, ip[7*8]);
	            C = M(xC3S5, ip[3*8]) + M(xC5S3, ip[5*8]);
	            D = M(xC3S5, ip[5*8]) - M(xC5S3, ip[3*8]);
	            E = M(xC4S4, (ip[0*8] + ip[4*8]));
	            F = M(xC4S4, (ip[0*8] - ip[4*8]));
	
	            G = M(xC2S6, ip[2*8]) + M(xC6S2, ip[6*8]);
	            H = M(xC6S2, ip[2*8]) - M(xC2S6, ip[6*8]);
	
	
	            Ad = M(xC4S4, (A - C)>>15);
	            Bd = M(xC4S4, (B - D)>>15);
	
	            Cd = A + C;
	            Dd = B + D;
	
	            Ed = E - G;
	            Fd = E + G;
	            Gd = F - Ad;
	            Hd = Bd + H;
	
	
	            Add = F + Ad;
	            Bdd = Bd - H;
	
	            /*  Final sequence of operations over-write original inputs. */
	            ip[0*8] = (Fd + Cd)>>15 ;
	            ip[7*8] = (Fd - Cd)>>15 ;
	
	            ip[1*8] = (Add + Hd)>>15;
	            ip[2*8] = (Add - Hd)>>15;
	
	            ip[3*8] = (Ed + Dd)>>15 ;
	            ip[4*8] = (Ed - Dd)>>15 ;
	
	            ip[5*8] = (Gd + Bdd)>>15;
	            ip[6*8] = (Gd - Bdd)>>15;
	        }
	}
        
        
        ip += 1;            /* next row */
    }




////////////////////////////////////////////////
////////////////////////////////////////////////
////////////////////////////////////////////////


////////////////////////////////////////////////
////////////////////////////////////////////////
////////////////////////////////////////////////




////////////////////////////////////////////////
////////////////////////////////////////////////
////////////////////////////////////////////////





    ip = input;

    for ( i = 0; i < 8; i++) {
    	if(!(ip[2] | ip[3] | ip[4] | ip[5] | ip[6] | ip[7]))
    	{
    		if(!ip[1])
    		{
    			if(ip[0])	//ip0
    			{
    				E = M(xC4S4, ip[0]);
			    
					if(!src)
					{  //HACK
						E += (16*128 + 8)<<15;
					}
					else
					{  //HACK
						E += 8<<15;
					}
		            
		            /* Final sequence of operations over-write original inputs. */
		            if(!src){
		                dst[0] =
		                dst[7] =
		
		                dst[1] =
		                dst[2] =
		
		                dst[3] =
		                dst[4] =
		
		                dst[5] =
		                dst[6] = SAT(((E ) >> 19));
		            }else{
						E = E>>19;
		                dst[0] = SAT(((src[0] + E)));
		                dst[7] = SAT(((src[7] + E)));
		
		                dst[1] = SAT(((src[1] + E)));
		                dst[2] = SAT(((src[2] + E)));
		
		                dst[3] = SAT(((src[3] + E)));
		                dst[4] = SAT(((src[4] + E)));
		
		                dst[5] = SAT(((src[5] + E)));
		                dst[6] = SAT(((src[6] + E)));
						src += stride;
		            }		               					
    			}
    			else
    			{
					if(src)
					{
						if(dst !=src )
						{
							dst[0] = src[0];
							dst[1] = src[1];
							dst[2] = src[2];
							dst[3] = src[3];
							dst[4] = src[4];
							dst[5] = src[5];
							dst[6] = src[6];
							dst[7] = src[7];
						}
						src += stride;
					}
					else
					{
						dst[0]=
						dst[1]=
						dst[2]=
						dst[3]=
						dst[4]=
						dst[5]=
						dst[6]=
						dst[7]= 128;					
					}
    			}
    		}
    		else	//ip0,1
    		{
				A = M(xC1S7, ip[1]);
				B = M(xC7S1, ip[1]);
				E = M(xC4S4, ip[0]);
				
				if(!src)
				{  //HACK
					E += (16*128 + 8)<<15;
				}
				else
				{  //HACK
					E += 8<<15;
				}
								
				Ad = M(xC4S4, A>>15);
				Bd = M(xC4S4, B>>15);

				Gd = E - Ad;
				Add = E + Ad;
			
		            /* Final sequence of operations over-write original inputs. */
		            if(!src){
		                dst[0] = SAT(((E + A )  >> 19));
		                dst[7] = SAT(((E - A )  >> 19));
		
		                dst[1] = SAT(((Add + Bd ) >> 19));
		                dst[2] = SAT(((Add - Bd ) >> 19));
		
		                dst[3] = SAT(((E + B )  >> 19));
		                dst[4] = SAT(((E - B )  >> 19));
		
		                dst[5] = SAT(((Gd + Bd ) >> 19));
		                dst[6] = SAT(((Gd - Bd ) >> 19));
		            }else{
		                dst[0] = SAT(((src[0] + ((E + A )  >> 19))));
		                dst[7] = SAT(((src[7] + ((E - A )  >> 19))));
		
		                dst[1] = SAT(((src[1] + ((Add + Bd ) >> 19))));
		                dst[2] = SAT(((src[2] + ((Add - Bd ) >> 19))));
		
		                dst[3] = SAT(((src[3] + ((E + B )  >> 19))));
		                dst[4] = SAT(((src[4] + ((E - B )  >> 19))));
		
		                dst[5] = SAT(((src[5] + ((Gd + Bd ) >> 19))));
		                dst[6] = SAT(((src[6] + ((Gd - Bd ) >> 19))));
						src += stride;
		            }			 				
    		}
    	}
    	else
    	{
    		{
	            A = M(xC1S7, ip[1]) + M(xC7S1, ip[7]);
	            B = M(xC7S1, ip[1]) - M(xC1S7, ip[7]);
	            C = M(xC3S5, ip[3]) + M(xC5S3, ip[5]);
	            D = M(xC3S5, ip[5]) - M(xC5S3, ip[3]);
	            E = M(xC4S4, (ip[0] + ip[4]));
	            F = M(xC4S4, (ip[0] - ip[4]));
	
			if(!src)
			{  //HACK
				E += (16*128 + 8)<<15;
				F += (16*128 + 8)<<15;				
			}
			else
			{  //HACK
				E += 8<<15;
				F += 8<<15;				
			}
				
	            G = M(xC2S6, ip[2]) + M(xC6S2, ip[6]);
	            H = M(xC6S2, ip[2]) - M(xC2S6, ip[6]);
	
	
	            Ad = M(xC4S4, (A - C)>>15);
	            Bd = M(xC4S4, (B - D)>>15);
	
	            Cd = A + C;
	            Dd = B + D;
	
	            Ed = E - G;
	            Fd = E + G;
	            Gd = F - Ad;
	            Hd = Bd + H;
	
	
	            Add = F + Ad;
	            Bdd = Bd - H;
	            
	            /* Final sequence of operations over-write original inputs. */
	            if(!src){
	                dst[0] = SAT(((Fd + Cd )  >> 19));
	                dst[7] = SAT(((Fd - Cd )  >> 19));
	
	                dst[1] = SAT(((Add + Hd ) >> 19));
	                dst[2] = SAT(((Add - Hd ) >> 19));
	
	                dst[3] = SAT(((Ed + Dd )  >> 19));
	                dst[4] = SAT(((Ed - Dd )  >> 19));
	
	                dst[5] = SAT(((Gd + Bdd ) >> 19));
	                dst[6] = SAT(((Gd - Bdd ) >> 19));
	            }else{
	                dst[0] = SAT(((src[0] + ((Fd + Cd )  >> 19))));
	                dst[7] = SAT(((src[7] + ((Fd - Cd )  >> 19))));
	
	                dst[1] = SAT(((src[1] + ((Add + Hd ) >> 19))));
	                dst[2] = SAT(((src[2] + ((Add - Hd ) >> 19))));
	
	                dst[3] = SAT(((src[3] + ((Ed + Dd )  >> 19))));
	                dst[4] = SAT(((src[4] + ((Ed - Dd )  >> 19))));
	
	                dst[5] = SAT(((src[5] + ((Gd + Bdd ) >> 19))));
	                dst[6] = SAT(((src[6] + ((Gd - Bdd ) >> 19))));
			src += stride;
	            }	            
	        }
	}

        ip += 8;            /* next row */
        dst += DestStride;        
    }      
	memset(input, 0, 64*sizeof(Q_LIST_ENTRY));
}

/****************************************************************************
 * 
 *  ROUTINE       : IDctSlow10
 *
 *  INPUTS        : INT16 *InputData   : Pointer to 8x8 quantized DCT coefficients.
 *                  INT16 *QuantMatrix : Pointer to 8x8 quantization matrix.
 *
 *  OUTPUTS       : INT16 *OutputData  : Pointer to 8x8 block to hold output.
 *
 *  RETURNS       : void
 *
 *  FUNCTION      : Inverse quantizes and inverse DCT's input 8x8 block
 *                  with non-zero coeffs only in DC & the first 9 AC coeffs.
 *                  i.e. non-zeros ONLY in the following 10 positions:
 *                  
 *                          x  x  x  x  0  0  0  0
 *                          x  x  x  0  0  0  0  0
 *                          x  x  0  0  0  0  0  0
 *                          x  0  0  0  0  0  0  0
 *                          0  0  0  0  0  0  0  0
 *                          0  0  0  0  0  0  0  0
 *                          0  0  0  0  0  0  0  0
 *                          0  0  0  0  0  0  0  0
 *
 *  SPECIAL NOTES : Output data is in raster, not zig-zag, order.
 *
 ****************************************************************************/
void IDCTvp6_Block4x4_c(INT16 *input, UINT8 *dst, INT32 DestStride, const UINT8 *src, INT32 stride)
{
    INT16 *ip = input;

    INT32 A, B, C, D, Ad, Bd, Cd, Dd, E, /*F,*/ G, H;
    INT32 Ed, Gd, Add, Bdd, Fd, Hd;

    INT32 i; // v;

    /* Inverse DCT on the rows now */
    for (i = 0; i < 4; i++) {
    	if(!(ip[2*8] | ip[3*8]))
    	{
    		if(!ip[1*8])
    		{
    			if(ip[0*8])	//ip0
    			{
			    E = M(xC4S4, ip[0*8]);
			    E = E>>15;
		            ip[0*8] =
		            ip[7*8] =

		            ip[1*8] =
		            ip[2*8] =
		            
		            ip[3*8] =
		            ip[4*8] =

		            ip[5*8] =
		            ip[6*8] = E;    					
    			}
    		}
    		else	////ip01
    		{
			A = M(xC1S7, ip[1*8]);
			B = M(xC7S1, ip[1*8]);
			E = M(xC4S4, ip[0*8]);
			
			Ad = M(xC4S4, A>>15);
			Bd = M(xC4S4, B>>15);

			Gd = E - Ad;
			Add = E + Ad;
			
			/*  Final sequence of operations over-write original inputs. */
			ip[0*8] = (E + A)>>15 ;
			ip[7*8] = (E - A)>>15 ;
			
			ip[1*8] = (Add + Bd)>>15;
			ip[2*8] = (Add - Bd)>>15;
			
			ip[3*8] = (E + B)>>15 ;
			ip[4*8] = (E - B)>>15 ;
			
			ip[5*8] = (Gd + Bd)>>15;
			ip[6*8] = (Gd - Bd)>>15;   				
    		}
    				
    			
    	}
    	else
    	{
    		//ip0123
    		{
	            A = M(xC1S7, ip[1*8]);
	            B = M(xC7S1, ip[1*8]);
	            C = M(xC3S5, ip[3*8]);
	            D = -M(xC5S3, ip[3*8]);
	            E = M(xC4S4, ip[0*8]);
	
	            G = M(xC2S6, ip[2*8]);
	            H = M(xC6S2, ip[2*8]);
	
	
	            Ad = M(xC4S4, (A - C)>>15);
	            Bd = M(xC4S4, (B - D)>>15);
	
	            Cd = A + C;
	            Dd = B + D;
	
	            Ed = E - G;
	            Fd = E + G;
	            Gd = E - Ad;
	            Hd = Bd + H;
	
	
	            Add = E + Ad;
	            Bdd = Bd - H;
	
	            /*  Final sequence of operations over-write original inputs. */
	            ip[0*8] = (Fd + Cd)>>15 ;
	            ip[7*8] = (Fd - Cd)>>15 ;
	
	            ip[1*8] = (Add + Hd)>>15;
	            ip[2*8] = (Add - Hd)>>15;
	
	            ip[3*8] = (Ed + Dd)>>15 ;
	            ip[4*8] = (Ed - Dd)>>15 ;
	
	            ip[5*8] = (Gd + Bdd)>>15;
	            ip[6*8] = (Gd - Bdd)>>15;
    		}
	}
        
        
        ip += 1;            /* next column */
    }
    ip = input;

    for ( i = 0; i < 8; i++) {
    	if(!(ip[2] | ip[3]))
    	{
    		if(!ip[1])
    		{
    			if(ip[0])	//ip0
    			{
    				E = M(xC4S4, ip[0]);
			    
					if(!src)
					{  //HACK
						E += (16*128 + 8)<<15;
					}
					else
					{  //HACK
						E += 8<<15;
					}
		            
		            /* Final sequence of operations over-write original inputs. */
		            if(!src){
		                dst[0] =
		                dst[7] =
		
		                dst[1] =
		                dst[2] =
		
		                dst[3] =
		                dst[4] =
		
		                dst[5] =
		                dst[6] = SAT(((E ) >> 19));
		            }else{
						E = E>>19;
		                dst[0] = SAT(((src[0] + E)));
		                dst[7] = SAT(((src[7] + E)));
		
		                dst[1] = SAT(((src[1] + E)));
		                dst[2] = SAT(((src[2] + E)));
		
		                dst[3] = SAT(((src[3] + E)));
		                dst[4] = SAT(((src[4] + E)));
		
		                dst[5] = SAT(((src[5] + E)));
		                dst[6] = SAT(((src[6] + E)));
						src += stride;
		            }		               					
    			}
    			else
    			{
					if(src)
					{
						if(dst !=src )
						{
							dst[0] = src[0];
							dst[1] = src[1];
							dst[2] = src[2];
							dst[3] = src[3];
							dst[4] = src[4];
							dst[5] = src[5];
							dst[6] = src[6];
							dst[7] = src[7];
						}
						src += stride;
					}
					else
					{
						dst[0]=
						dst[1]=
						dst[2]=
						dst[3]=
						dst[4]=
						dst[5]=
						dst[6]=
						dst[7]= 128;					
					}
    			}
    		}
    		else	//ip0,1
    		{
				A = M(xC1S7, ip[1]);
				B = M(xC7S1, ip[1]);
				E = M(xC4S4, ip[0]);
				
				if(!src)
				{  //HACK
					E += (16*128 + 8)<<15;
				}
				else
				{  //HACK
					E += 8<<15;
				}
								
				Ad = M(xC4S4, A>>15);
				Bd = M(xC4S4, B>>15);

				Gd = E - Ad;
				Add = E + Ad;
			
		            /* Final sequence of operations over-write original inputs. */
		            if(!src){
		                dst[0] = SAT(((E + A )  >> 19));
		                dst[7] = SAT(((E - A )  >> 19));
		
		                dst[1] = SAT(((Add + Bd ) >> 19));
		                dst[2] = SAT(((Add - Bd ) >> 19));
		
		                dst[3] = SAT(((E + B )  >> 19));
		                dst[4] = SAT(((E - B )  >> 19));
		
		                dst[5] = SAT(((Gd + Bd ) >> 19));
		                dst[6] = SAT(((Gd - Bd ) >> 19));
		            }else{
		                dst[0] = SAT(((src[0] + ((E + A )  >> 19))));
		                dst[7] = SAT(((src[7] + ((E - A )  >> 19))));
		
		                dst[1] = SAT(((src[1] + ((Add + Bd ) >> 19))));
		                dst[2] = SAT(((src[2] + ((Add - Bd ) >> 19))));
		
		                dst[3] = SAT(((src[3] + ((E + B )  >> 19))));
		                dst[4] = SAT(((src[4] + ((E - B )  >> 19))));
		
		                dst[5] = SAT(((src[5] + ((Gd + Bd ) >> 19))));
		                dst[6] = SAT(((src[6] + ((Gd - Bd ) >> 19))));
						src += stride;
		            }			 				
    		}
    	}
    	else
    	{
    		{
	            A = M(xC1S7, ip[1]);
	            B = M(xC7S1, ip[1]);
	            C = M(xC3S5, ip[3]);
	            D = -M(xC5S3, ip[3]);
	            E = M(xC4S4, ip[0]);
			if(!src)
			{  //HACK
				E += (16*128 + 8)<<15;
			}
			else
			{  //HACK
				E += 8<<15;
			}	            
	
	            G = M(xC2S6, ip[2]);
	            H = M(xC6S2, ip[2]);
	
	
	            Ad = M(xC4S4, (A - C)>>15);
	            Bd = M(xC4S4, (B - D)>>15);
	
	            Cd = A + C;
	            Dd = B + D;
	
	            Ed = E - G;
	            Fd = E + G;
	            Gd = E - Ad;
	            Hd = Bd + H;
	
	
	            Add = E + Ad;
	            Bdd = Bd - H;
	           
	            /* Final sequence of operations over-write original inputs. */
	            if(!src){
	                dst[0] = SAT(((Fd + Cd )  >> 19));
	                dst[7] = SAT(((Fd - Cd )  >> 19));
	
	                dst[1] = SAT(((Add + Hd ) >> 19));
	                dst[2] = SAT(((Add - Hd ) >> 19));
	
	                dst[3] = SAT(((Ed + Dd )  >> 19));
	                dst[4] = SAT(((Ed - Dd )  >> 19));
	
	                dst[5] = SAT(((Gd + Bdd ) >> 19));
	                dst[6] = SAT(((Gd - Bdd ) >> 19));
	            }else{
	                dst[0] = SAT(((src[0] + ((Fd + Cd )  >> 19))));
	                dst[7] = SAT(((src[7] + ((Fd - Cd )  >> 19))));
	
	                dst[1] = SAT(((src[1] + ((Add + Hd ) >> 19))));
	                dst[2] = SAT(((src[2] + ((Add - Hd ) >> 19))));
	
	                dst[3] = SAT(((src[3] + ((Ed + Dd )  >> 19))));
	                dst[4] = SAT(((src[4] + ((Ed - Dd )  >> 19))));
	
	                dst[5] = SAT(((src[5] + ((Gd + Bdd ) >> 19))));
	                dst[6] = SAT(((src[6] + ((Gd - Bdd ) >> 19))));
			src += stride;
	            }	            
    		}
	}

        ip += 8;            /* next row */
        dst += DestStride;        
    }      
	memset(input, 0, 64*sizeof(Q_LIST_ENTRY));
}

/****************************************************************************
 * 
 *  ROUTINE       : IDct1
 *
 *  INPUTS        : INT16 *InputData   : Pointer to 8x8 quantized DCT coefficients.
 *                  INT16 *QuantMatrix : Pointer to 8x8 quantization matrix.
 *
 *  OUTPUTS       : INT16 *OutputData  : Pointer to 8x8 block to hold output.
 *
 *  RETURNS       : void
 *
 *  FUNCTION      : Inverse DCT's input 8x8 block with only one non-zero
 *                  coeff in the DC position:
 *                  
 *                          x   0   0  0  0  0  0  0
 *                          0   0   0  0  0  0  0  0
 *                          0   0   0  0  0  0  0  0
 *                          0   0   0  0  0  0  0  0
 *                          0   0   0  0  0  0  0  0
 *                          0   0   0  0  0  0  0  0
 *                          0   0   0  0  0  0  0  0
 *                          0   0   0  0  0  0  0  0
 *
 *  SPECIAL NOTES : Output data is in raster, not zig-zag, order.
 *
 ****************************************************************************/
void IDCTvp6_Block1x1_c(INT16 *input, UINT8 *dst, INT32 DestStride, const UINT8 *src, INT32 stride)
{
    INT32 loop;
	INT16 OutD;	
	INT16 v;	
#ifdef voIDCT1X1
	INT32 tmp;
	tmp = (xC4S4 * input[0])>>15;
	OutD = (xC4S4 * tmp + (IdctAdjustBeforeShift<<15))>>19;

	if(OutD != ((input[0]+15)>>5))
		OutD = OutD;
#else
	OutD = (INT16)((INT32)(input[0]+15)>>5);
#endif
	if(!src)
	{
		v = SAT((128 + OutD));
		for ( loop=0; loop<8; loop++ )
		{	
			dst[0]=
			dst[1]=
			dst[2]=
			dst[3]=
			dst[4]=
			dst[5]=
			dst[6]=
			dst[7]= (UINT8)v;
			dst += DestStride;	
		}
	}
	else
	{
	    for ( loop=0; loop<8; loop++ )
		{	
			dst[0] = SAT((src[0] + OutD));
			dst[1] = SAT((src[1] + OutD));
			dst[2] = SAT((src[2] + OutD));
			dst[3] = SAT((src[3] + OutD));
			dst[4] = SAT((src[4] + OutD));
			dst[5] = SAT((src[5] + OutD));
			dst[6] = SAT((src[6] + OutD));
			dst[7] = SAT((src[7] + OutD));
			src += stride;
			dst += DestStride;	
		}	
	}
		
	input[0] = 0;
}

