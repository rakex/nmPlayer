;************************************************************************
; VisualOn Proprietary
; Copyright (c) 2012, VisualOn Incorporated. All rights Reserved
;
; VisualOn, Inc., 4675 Stevens Creek Blvd, Santa Clara, CA 95051, USA
;
; All data and information contained in or disclosed by this document are
; confidential and proprietary information of VisualOn, and all rights
; therein are expressly reserved. By accepting this material, the
; recipient agrees that this material and the information contained
; therein are held in confidence and in trust. The material may only be
; used and/or disclosed as authorized in a license agreement controlling
; such use and disclosure.
;************************************************************************

    AREA |.text|, CODE, READONLY, ALIGN=2
 
PIC_WIDTH        EQU 32
PIC_HEIGHT       EQU 36
AVG_TMP_DST      EQU 32
AVG_TMP_STRIDE   EQU 36	
AVG_PIC_WIDTH    EQU 40
AVG_PIC_HEIGHT   EQU 44
MAX_TMP_BI_SIZE  EQU 128
CHROMA_MX        EQU 40
CHROMA_MY        EQU 44
AVG_CHROMA_MX    EQU 48
AVG_CHROMA_MY    EQU 52

pSrc           RN  2
pTmpSrc        RN  4
nSrcStride     RN  3
pDst           RN  0
pTmpDst        RN  5     
nDstStride     RN  1
nHeight        RN  6
nWidth         RN  7
nTmpHeight     RN  8
nTmp0          RN  9
nTmp1          RN 10
pTmpDst2       RN 12
nDstStride2    RN 14

mx             RN 5
my             RN 6

ChromaCoeff
    DCW      0,  64,  0,    0
    DCW      2,  58,  10,   2
    DCW      4,  54,  16,   2
    DCW      6,  46,  28,   4
    DCW      4,  36,  36,   4
    DCW      4,  28,  46,   6
    DCW      2,  16,  54,   4
    DCW      2,  10,  58,   2
	
SigChromaCoeff
    DCW      0,  64,  0,    0
    DCW     -2,  58,  10,  -2
    DCW     -4,  54,  16,  -2
    DCW     -6,  46,  28,  -4
    DCW     -4,  36,  36,  -4
    DCW     -4,  28,  46,  -6
    DCW     -2,  16,  54,  -4
    DCW     -2,  10,  58,  -2

	
    macro 
		func $name, $export="{{FALSE}}"      
    IF $export
        EXPORT $name
	ENDIF	
$name    
        mend
		
		macro
		endfunc
		mend
		
		macro  
		trans_8x8   $r0, $r1, $r2, $r3, $r4, $r5, $r6, $r7
        vtrn.32         $r0, $r4
        vtrn.32         $r1, $r5
        vtrn.32         $r2, $r6
        vtrn.32         $r3, $r7
        vtrn.16         $r0, $r2
        vtrn.16         $r1, $r3
        vtrn.16         $r4, $r6
        vtrn.16         $r5, $r7
        vtrn.8          $r0, $r1
        vtrn.8          $r2, $r3
        vtrn.8          $r4, $r5
        vtrn.8          $r6, $r7
        mend
		
        macro  
        tap1_const $r0, $r1
        vmov.i8        d12,  #4
		vmov.i8        d13,  #10
		vmov.i8        d14,  #58
		vmov.i8        d15,  #17
		vmov.i8        d30,  #5
        mend
		
		macro  
        tap8_1_const $r0, $r1
        vmov.i8        d16,  #10
		vmov.i8        d17,  #58
		vmov.i8        d18,  #17
		vmov.i8        d19,  #5
        mend
		
		macro  
        tap8_2_const $r0, $r1
        vmov.i16        q8,  #11
		vmov.i16        q9,  #40
        mend
		
		macro  
        tap8_3_const $r0, $r1
        vmov.i8        d16,  #5
		vmov.i8        d17,  #17
		vmov.i8        d18,  #58
		vmov.i8        d19,  #10
        mend
		
		macro  
        tap7_1_const $r0, $r1
        movw            $r0,  #10
        movt            $r0,  #58
        movw            $r1,  #17
	    movt            $r1,  #5
        vmov            d6, $r0, $r1
        mend
		
		macro  
        tap2_const $r0, $r1
        movw            $r0,  #4
        movt            $r0,  #11
		movw            $r1,  #10
        vmov            d6, $r0, $r1
        mend
		
		macro  
        tap3_const $r0, $r1
        vmov.i8        d12,  #5
		vmov.i8        d13,  #17
		vmov.i8        d14,  #58
		vmov.i8        d15,  #10
		vmov.i8        d30,  #4
        mend
		
		macro  
        tap7_3_const $r0, $r1
        movw            $r0,  #5
        movt            $r0,  #17
        movw            $r1,  #58
	    movt            $r1,  #10
        vmov            d6, $r0, $r1
        mend
		
		macro  
		h1_8 $x0, $x1, $x2, $x3, $x4, $x5, $x6, $x7, $d0, $d1, $d2, $d3, $narrow={TRUE}
	    vext.8          d4, $x0, $x1, #6
		vext.8          d6, $x2, $x3, #6
		vsubl.u8        q2, d4,  $x0
		vsubl.u8        q3, d6,  $x2
		
		vext.8          d8, $x0, $x1, #1
		vext.8          d9, $x0, $x1, #2
		vext.8          d10, $x2, $x3, #1
		vext.8          d11, $x2, $x3, #2
		vmlal.u8        q2,  d8, d12
		vmlsl.u8        q2,  d9, d13
		vmlal.u8        q3,  d10, d12
		vmlsl.u8        q3,  d11, d13
		
		vext.8          d8,  $x0, $x1, #3
		vext.8          d9,  $x0, $x1, #4
		vext.8          d10,  $x2, $x3, #3
		vext.8          d11,  $x2, $x3, #4
		vmlal.u8        q2,   d8, d14
		vmlal.u8        q2,   d9, d15
		vmlal.u8        q3,   d10, d14
		vmlal.u8        q3,   d11, d15
		
		vext.8          d8, $x0, $x1, #5
		vext.8          d9, $x2, $x3, #5
  IF $narrow		
		vmlsl.u8       q2,  d8, d30
		vmlsl.u8       q3,  d9, d30
  ELSE
        vmlsl.u8       $d0,  d8, d30
		vmlsl.u8       $d1,  d9, d30
  ENDIF		
		vext.8          d20,  $x4, $x5, #6
		vext.8          d22,  $x6, $x7, #6
		vsubl.u8        q10, d20,  $x4
		vsubl.u8        q11, d22,  $x6
		
		vext.8          d24, $x4, $x5, #1
		vext.8          d25, $x4, $x5, #2
		vext.8          d26, $x6, $x7, #1
		vext.8          d27, $x6, $x7, #2
		vmlal.u8        q10,  d24, d12
		vmlsl.u8        q10,  d25, d13
		vmlal.u8        q11,  d26, d12
		vmlsl.u8        q11,  d27, d13
		
		vext.8          d28,  $x4, $x5, #3
		vext.8          d29,  $x4, $x5, #4
		vext.8          d24,  $x6, $x7, #3
		vext.8          d25,  $x6, $x7, #4
		vmlal.u8        q10,   d28, d14
		vmlal.u8        q10,   d29, d15
		vmlal.u8        q11,   d24, d14
		vmlal.u8        q11,   d25, d15
		
		vext.8          d28, $x4, $x5, #5
		vext.8          d29, $x6, $x7, #5
  IF $narrow		
		vmlsl.u8        q10,  d28, d30
		vmlsl.u8        q11,  d29, d30
        
		vqrshrun.s16    $d0, q2,  #6
		vqrshrun.s16    $d1, q3,  #6
        vqrshrun.s16    $d2, q10,  #6
		vqrshrun.s16    $d3, q11,  #6
  ELSE
        vmlsl.u8        $d2,  d28, d30
		vmlsl.u8        $d3,  d29, d30
  ENDIF		
        mend	

		macro  
		h2_8 $x0, $x1, $x2, $x3, $x4, $x5, $x6, $x7, $d0, $d1, $d2, $d3, $narrow={TRUE}  ; (x0,x1) : q2, q4, q5  (x2, x3) : q6, q7, q10 (x4, x5) : q11, q12, q13 (x6, x7) : q14, q15, q7 
        vext.8          d4,  $x0, $x1, #3                                                ; ((10x(A0+A1)+(A_2+A3))*4 -(11*(A_1+A2) + (A_3+A4)) + 32 ) >> 6
        vext.8          d5,  $x0, $x1, #4      		 	
		vext.8          d12,  $x2, $x3, #3
        vext.8          d13,  $x2, $x3, #4
		
		vext.8          d22, $x4, $x5, #3
        vext.8          d23, $x4, $x5, #4
		vext.8          d28, $x6, $x7, #3
        vext.8          d29, $x6, $x7, #4
				
		vaddl.u8        q2,  d4,  d5
        vaddl.u8        q6,  d12,  d13
		vaddl.u8        q11,  d22, d23
		vaddl.u8        q14,  d28, d29
		
        vext.8          d8,  $x0, $x1, #1
        vext.8          d9,  $x0, $x1, #6        
		vext.8          d14,  $x2, $x3, #1
        vext.8          d15,  $x2, $x3, #6
		
	    vext.8          d24, $x4, $x5, #1
        vext.8          d25, $x4, $x5, #6			
		vext.8          d30, $x6, $x7, #1
        vext.8          d31, $x6, $x7, #6			
		
		vaddl.u8        q4,  d8,  d9
        vaddl.u8        q7,  d14,  d15
		vaddl.u8        q12, d24, d25
		vaddl.u8        q15, d30, d31
		
		vmla.i16        q4,  q2,  d6[2]
		vmla.i16        q7,  q6,  d6[2]
		vmla.i16        q12,  q11,  d6[2]
		vmla.i16        q15,  q14,  d6[2]
		
		
		vext.8          d10,  $x0, $x1, #2
        vext.8          d11,  $x0, $x1, #5        
		vext.8          d20,  $x2, $x3, #2
        vext.8          d21,  $x2, $x3, #5
		
        vext.8          d26, $x4, $x5, #2
        vext.8          d27, $x4, $x5, #5			
		vext.8          d28, $x6, $x7, #2
        vext.8          d29, $x6, $x7, #5
						
		vaddl.u8        q5,  d10,  d11
        vaddl.u8        q10,  d20,  d21
		vaddl.u8        q13, d26, d27	
		vaddl.u8        q14, d28, d29
		
        vext.8          d5, $x0, $x1, #7        
		vext.8          d13, $x2, $x3, #7
		vext.8          d23, $x4, $x5, #7		
		vext.8          $x7, $x6, $x7, #7
		
		vaddl.u8        q2,  $x0, d5
        vaddl.u8        q6,  $x2, d13
		vaddl.u8        q11,  $x4, d23
		vaddl.u8        q9,  $x6, $x7
		
		vshl.i16        q4, q4, #2
		vshl.i16        q7, q7, #2	
		vshl.i16        q12, q12, #2
		vshl.i16        q15, q15, #2
		
		vmla.i16        q2,  q5,  d6[1]
		vmla.i16        q6, q10,  d6[1]
		vmla.i16        q11,  q13,  d6[1]
		vmla.i16        q9,   q14,  d6[1]

  IF $narrow		
		vsub.i16        q4,  q4,  q2
		vsub.i16        q5,  q7,  q6				     
		vsub.i16        q8,  q12,  q11
		vsub.i16        q9,  q15,  q9	
			
		vqrshrun.s16    $d0, q4,  #6
        vqrshrun.s16    $d1, q5,  #6
		vqrshrun.s16    $d2, q8,  #6
        vqrshrun.s16    $d3, q9,  #6
  ELSE
        vsub.i16        $d0,  q4,  q2
		vsub.i16        $d1,  q7,  q6				     
		vsub.i16        $d2,  q12,  q11
		vsub.i16        $d3,  q15,  q9
  ENDIF		
        mend
		
		macro  
		h3_8 $x0, $x1, $x2, $x3, $x4, $x5, $x6, $x7, $d0, $d1, $d2, $d3, $narrow={TRUE}
	    vext.8          d4, $x0, $x1, #6
		vext.8          d6, $x2, $x3, #6
		vsubl.u8        q2, $x0, d4
		vsubl.u8        q3, $x2, d6
		
		vext.8          d8, $x0, $x1, #1
		vext.8          d9, $x0, $x1, #2
		vext.8          d10, $x2, $x3, #1
		vext.8          d11, $x2, $x3, #2
		vmlsl.u8        q2,  d8, d12
		vmlal.u8        q2,  d9, d13
		vmlsl.u8        q3,  d10, d12
		vmlal.u8        q3,  d11, d13
		
		vext.8          d8,  $x0, $x1, #3
		vext.8          d9,  $x0, $x1, #4
		vext.8          d10,  $x2, $x3, #3
		vext.8          d11,  $x2, $x3, #4
		vmlal.u8        q2,   d8, d14
		vmlsl.u8        q2,   d9, d15
		vmlal.u8        q3,   d10, d14
		vmlsl.u8        q3,   d11, d15
		
		vext.8          d8, $x0, $x1, #5
		vext.8          d9, $x2, $x3, #5
  IF $narrow		
		vmlal.u8       q2,  d8, d30
		vmlal.u8       q3,  d9, d30
  ELSE
        vmlal.u8        $d0,  d8, d30
		vmlal.u8        $d1,  d9, d30
  ENDIF		
		
		vext.8          d20,  $x4, $x5, #6
		vext.8          d22,  $x6, $x7, #6
		vsubl.u8        q10, $x4, d20
		vsubl.u8        q11, $x6, d22
		
		vext.8          d24, $x4, $x5, #1
		vext.8          d25, $x4, $x5, #2
		vext.8          d26, $x6, $x7, #1
		vext.8          d27, $x6, $x7, #2
		vmlsl.u8        q10,  d24, d12
		vmlal.u8        q10,  d25, d13
		vmlsl.u8        q11,  d26, d12
		vmlal.u8        q11,  d27, d13
		
		vext.8          d28,  $x4, $x5, #3
		vext.8          d29,  $x4, $x5, #4
		vext.8          d24,  $x6, $x7, #3
		vext.8          d25,  $x6, $x7, #4
		vmlal.u8        q10,   d28, d14
		vmlsl.u8        q10,   d29, d15
		vmlal.u8        q11,   d24, d14
		vmlsl.u8        q11,   d25, d15
		
		vext.8          d28, $x4, $x5, #5
		vext.8          d29, $x6, $x7, #5
  IF $narrow		
		vmlal.u8        q10,  d28, d30
		vmlal.u8        q11,  d29, d30
        
		vqrshrun.s16    $d0, q2,  #6
		vqrshrun.s16    $d1, q3,  #6
        vqrshrun.s16    $d2, q10,  #6
		vqrshrun.s16    $d3, q11,  #6
  ELSE
        vmlal.u8        $d2,  d28, d30
		vmlal.u8        $d3,  d29, d30
  ENDIF		
        mend	
		
		macro  
		v1_8 $x0, $x1, $x2, $x3, $x4, $x5, $x6, $x7, $x8, $x9, $d0, $d1, $d2, $d3, $narrow={TRUE}
        vsubl.u8        q0,  $x6,  $x0
		vshll.u8        q1,  $x1,  #2
		vsubl.u8        q2,  $x7,  $x1
		vshll.u8        q3,  $x2,  #2
		vsubl.u8        q4,  $x8,  $x2
		vshll.u8        q5,  $x3,  #2
		vsubl.u8        q6,  $x9,  $x3
		vshll.u8        q7,  $x4,  #2
        
		vadd.s16        q1,   q1,  q0
		vadd.s16        q3,   q3,  q2
		vadd.s16        q5,   q5,  q4
		vadd.s16        q7,   q7,  q6
		
		vmlsl.u8       q1,   $x2, d16
		vmlsl.u8       q3,   $x3, d16
		vmlsl.u8       q5,   $x4, d16
		vmlsl.u8       q7,   $x5, d16
		
		vmlal.u8       q1,   $x3, d17
		vmlal.u8       q3,   $x4, d17
		vmlal.u8       q5,   $x5, d17
		vmlal.u8       q7,   $x6, d17
		
		vmlal.u8       q1,   $x4, d18
		vmlal.u8       q3,   $x5, d18
		vmlal.u8       q5,   $x6, d18
		vmlal.u8       q7,   $x7, d18

  IF $narrow		
		vmlsl.u8       q1,   $x5, d19
		vmlsl.u8       q3,   $x6, d19
		vmlsl.u8       q5,   $x7, d19
		vmlsl.u8       q7,   $x8, d19		
		
		vqrshrun.s16    $d0, q1,   #6
		vqrshrun.s16    $d1, q3,   #6
		vqrshrun.s16    $d2, q5,   #6
        vqrshrun.s16    $d3, q7,   #6	
  ELSE
        vmlsl.u8       $d0,   $x5, d19
		vmlsl.u8       $d1,   $x6, d19
		vmlsl.u8       $d2,   $x7, d19
		vmlsl.u8       $d3,   $x8, d19
  ENDIF		
        mend
		
		macro  
		v2_8 $x0, $x1, $x2, $x3, $x4, $x5, $x6, $x7, $x8, $x9, $x10, $d0, $d1, $d2, $d3, $narrow={TRUE}
		vaddl.u8        q0,  $x0,  $x7
		vaddl.u8        q1,  $x1,  $x6
		vaddl.u8        q2,  $x1,  $x8
		vaddl.u8        q3,  $x2,  $x7
		vaddl.u8        q4,  $x2,  $x9
		vaddl.u8        q5,  $x3,  $x8
		vaddl.u8        q6,  $x3,  $x10
		vaddl.u8        q7,  $x4,  $x9
		
		vshl.i16        q1,  q1, #2
		vshl.i16        q3,  q3, #2
		vshl.i16        q5,  q5, #2
		vshl.i16        q7,  q7, #2
		
		vsub.s16        q1,  q1, q0
		vsub.s16        q3,  q3, q2
		vsub.s16        q5,  q5, q4
		vsub.s16        q7,  q7, q6
		
		vaddl.u8        q0,  $x2,  $x5
		vaddl.u8        q2,  $x3,  $x6
		vaddl.u8        q4,  $x4,  $x7
		vaddl.u8        q6,  $x5,  $x8
		
		vmls.i16        q1,  q0,  q8
		vmls.i16        q3,  q2,  q8
		vmls.i16        q5,  q4,  q8
		vmls.i16        q7,  q6,  q8
		
		vaddl.u8        q0,  $x3,  $x4
		vaddl.u8        q2,  $x4,  $x5
		vaddl.u8        q4,  $x5,  $x6
		vaddl.u8        q6,  $x6,  $x7

  IF $narrow		
		vmla.i16        q1,  q0,  q9
		vmla.i16        q3,  q2,  q9
		vmla.i16        q5,  q4,  q9
		vmla.i16        q7,  q6,  q9
		
		vqrshrun.s16    $d0, q1,   #6
		vqrshrun.s16    $d1, q3,   #6
		vqrshrun.s16    $d2, q5,   #6
        vqrshrun.s16    $d3, q7,   #6
  ELSE
        vmla.i16        $d0,  q0,  q9
		vmla.i16        $d1,  q2,  q9
		vmla.i16        $d2,  q4,  q9
		vmla.i16        $d3,  q6,  q9
  ENDIF		
		
		mend
		
		macro  
		v3_8 $x0, $x1, $x2, $x3, $x4, $x5, $x6, $x7, $x8, $x9, $d0, $d1, $d2, $d3, $narrow={TRUE}
        vsubl.u8        q0,  $x0,  $x6
		vshll.u8        q1,  $x5,  #2
		vsubl.u8        q2,  $x1,  $x7
		vshll.u8        q3,  $x6,  #2
		vsubl.u8        q4,  $x2,  $x8
		vshll.u8        q5,  $x7,  #2
		vsubl.u8        q6,  $x3,  $x9
		vshll.u8        q7,  $x8,  #2
        
		vadd.s16        q1,   q1,  q0
		vadd.s16        q3,   q3,  q2
		vadd.s16        q5,   q5,  q4
		vadd.s16        q7,   q7,  q6
		
		vmlsl.u8       q1,   $x1, d16
		vmlsl.u8       q3,   $x2, d16
		vmlsl.u8       q5,   $x3, d16
		vmlsl.u8       q7,   $x4, d16
		
		vmlal.u8       q1,   $x2, d17
		vmlal.u8       q3,   $x3, d17
		vmlal.u8       q5,   $x4, d17
		vmlal.u8       q7,   $x5, d17
		
		vmlal.u8       q1,   $x3, d18
		vmlal.u8       q3,   $x4, d18
		vmlal.u8       q5,   $x5, d18
		vmlal.u8       q7,   $x6, d18
	
  IF $narrow	
		vmlsl.u8       q1,   $x4, d19
		vmlsl.u8       q3,   $x5, d19
		vmlsl.u8       q5,   $x6, d19
		vmlsl.u8       q7,   $x7, d19		
		
		vqrshrun.s16    $d0, q1,   #6
		vqrshrun.s16    $d1, q3,   #6
		vqrshrun.s16    $d2, q5,   #6
        vqrshrun.s16    $d3, q7,   #6
  ELSE
        vmlsl.u8       $d0,   $x4, d19
		vmlsl.u8       $d1,   $x5, d19
		vmlsl.u8       $d2,   $x6, d19
		vmlsl.u8       $d3,   $x7, d19
  ENDIF		
        mend
		

		macro  
        tap123_const $r0, $r1
        movw            $r0,  #4
        movt            $r0,  #5
		movw            $r1,  #58
		movt            $r1,  #17
        vmov            d6, $r0, $r1
		mov             $r0,  #10
		mov             $r1,  #11
        vmov            d7, $r0, $r1
        mend
		
		macro  
		h1_8_1 $x0, $x1, $d0
		vext.8          d0, $x0, $x1, #6
		vsubl.u8        q0, d0,  $x0
		
		vext.8          d2, $x0, $x1, #2
		vext.8          d4, $x0, $x1, #3
		vmovl.u8        q1, d2
		vmovl.u8        q2, d4
		vmls.i16        q0,  q1,  d7[0]
		vmla.i16        q0,  q2,  d6[2]
		
		vext.8          d8,  $x0, $x1, #4
		vext.8          d10,  $x0, $x1, #5
		vmovl.u8        q4, d8
		vmovl.u8        q5, d10	
		vmla.i16        q0,  q4,  d6[3]
		vmls.i16        q0,  q5,  d6[1]
		
		vext.8          d12, $x0, $x1, #1
		vshll.u8        $d0, d12, #2
		vadd.i16        $d0, q0
		mend		
		
		 macro  
		h1_8_2 $x0, $x1, $x2, $x3, $d0, $d1
		vext.8          d0, $x0, $x1, #6
		vext.8          d8, $x2, $x3, #6
		vsubl.u8        q0, d0,  $x0
		vsubl.u8        q4, d8,  $x2
		
		vext.8          d2,  $x0, $x1, #2
		vext.8          d10, $x2, $x3, #2
		vext.8          d4,  $x0, $x1, #3
		vext.8          d12, $x2, $x3, #3
		
		vmovl.u8        q1, d2
		vmovl.u8        q5, d10
		vmovl.u8        q2, d4
		vmovl.u8        q6, d12
		
		vmls.i16        q0,  q1,  d7[0]
		vmls.i16        q4,  q5,  d7[0]
		vmla.i16        q0,  q2,  d6[2]
		vmla.i16        q4,  q6,  d6[2]
		
		vext.8          d2,  $x0, $x1, #4
		vext.8          d10,  $x2, $x3, #4
		vext.8          d4,  $x0, $x1, #5
		vext.8          d12,  $x2, $x3, #5
		
		vmovl.u8        q1, d2
		vmovl.u8        q5, d10
		vmovl.u8        q2, d4	
		vmovl.u8        q6, d12
		
		vmla.i16        q0,  q1,  d6[3]
		vmla.i16        q4,  q5,  d6[3]
		vmls.i16        q0,  q2,  d6[1]
		vmls.i16        q4,  q6,  d6[1]
		
		vext.8          d2,  $x0, $x1, #1
		vext.8          d10, $x2, $x3, #1
		vshll.u8        $d0, d2, #2
		vshll.u8        $d1, d10, #2
		vadd.i16        $d0, q0
		vadd.i16        $d1, q4
        mend
		
		macro  
		h1_8_3 $x0, $x1, $x2, $x3, $x4, $x5, $d0, $d1, $d2
		vext.8          d4,   $x0, $x1, #1
		vext.8          d5,   $x2, $x3, #1
		vext.8          d30,  $x4, $x5, #1
		
		vmull.u8        $d0,  d4,  d13
		vmull.u8        $d1,  d5,  d13
		vmull.u8        $d2,  d30, d13
		
		vmlsl.u8        $d0,  $x0,   d12  
		vmlsl.u8        $d1,  $x2,   d12
		vmlsl.u8        $d2,  $x4,   d12
		
		vext.8          d4,   $x0, $x1, #2
		vext.8          d5,   $x2, $x3, #2
		vext.8          d30,  $x4, $x5, #2
		
		vmlal.u8        $d0,  d4,   d14  
		vmlal.u8        $d1,  d5,   d14
		vmlal.u8        $d2,  d30,  d14
		
		vext.8          d4,   $x0, $x1, #3
		vext.8          d5,   $x2, $x3, #3
		vext.8          d30,  $x4, $x5, #3
		
		vmlsl.u8        $d0,  d4,   d15  
		vmlsl.u8        $d1,  d5,   d15
		vmlsl.u8        $d2,  d30,  d15
        mend
		
		
		
		macro  
		h1_8_4 $x0, $x1, $x2, $x3, $x4, $x5, $x6, $x7, $d0, $d1, $d2, $d3, $narrow={FALSE}
		vext.8          d4,   $x0, $x1, #1
		vext.8          d5,   $x2, $x3, #1
		vext.8          d30,  $x4, $x5, #1
		vext.8          d31,  $x6, $x7, #1
		
		vmull.u8        $d0,  d4,  d13
		vmull.u8        $d1,  d5,  d13
		vmull.u8        $d2,  d30, d13
		vmull.u8        $d3,  d31, d13
		
		
		
		vmlsl.u8        $d0,  $x0,   d12  
		vmlsl.u8        $d1,  $x2,   d12
		vmlsl.u8        $d2,  $x4,   d12
		vmlsl.u8        $d3,  $x6,   d12
		
		vext.8          d4,   $x0, $x1, #2
		vext.8          d5,   $x2, $x3, #2
		vext.8          d30,  $x4, $x5, #2
		vext.8          d31,  $x6, $x7, #2
		
		vmlal.u8        $d0,  d4,   d14  
		vmlal.u8        $d1,  d5,   d14
		vmlal.u8        $d2,  d30,  d14
		vmlal.u8        $d3,  d31,  d14
		
		vext.8          d4,   $x0, $x1, #3
		vext.8          d5,   $x2, $x3, #3
		vext.8          d30,  $x4, $x5, #3
		vext.8          d31,  $x6, $x7, #3
		
		vmlsl.u8        $d0,  d4,   d15  
		vmlsl.u8        $d1,  d5,   d15
		vmlsl.u8        $d2,  d30,  d15
		vmlsl.u8        $d3,  d31,  d15
  
  IF $narrow
        vqrshrun.s16    $x0, $d0,  #6	
        vqrshrun.s16    $x1, $d1,  #6	
		vqrshrun.s16    $x2, $d2,  #6	
		vqrshrun.s16    $x3, $d3,  #6	
  ENDIF	
        mend
		
		
		macro  
		h2_8_1 $x0, $x1, $d0                ; use q0, q1, q2, q15, q3, q8, q9, q10
        vext.8          d0,  $x0, $x1, #3
        vext.8          d1,  $x0, $x1, #4
        vaddl.u8        q0,  d0,  d1
        vext.8          d2,  $x0, $x1, #1
        vext.8          d3,  $x0, $x1, #6
        vaddl.u8        q1,  d2,  d3
		vext.8          d4,  $x0, $x1, #2
        vext.8          d5,  $x0, $x1, #5
        vaddl.u8        q2,  d4,  d5
        vext.8          d8, $x0, $x1, #7
        vaddl.u8        $d0,  $x0, d8        ;A_3 + A4
		
		vmla.i16        $d0,  q2,  d7[2]      ;11*(A_1+A2) + (A_3+A4)
		vmla.i16        q1,  q0,  d7[0]       ;10*(A0 + A1) + (A_2+A3)
		vshl.s16        q1,  q1,  #2	      ;(10*(A0 + A1) + (A_2+A3)) * 4
		vsub.i16        $d0,  q1,  $d0         ;(10*(A0 + A1) + (A_2+A3)) * 4 - (11*(A_1+A2) + (A_3+A4))		
        mend
		
		macro  
		h2_8_2 $x0, $x1, $x2, $x3, $d0, $d1    ; use q0, q1, q2, q15, q3, q8, q9, q10
        vext.8          d0,  $x0, $x1, #3
        vext.8          d1,  $x0, $x1, #4
        vaddl.u8        q0,  d0,  d1
        vext.8          d2,  $x0, $x1, #1
        vext.8          d3,  $x0, $x1, #6
        vaddl.u8        q1,  d2,  d3
		vext.8          d4,  $x0, $x1, #2
        vext.8          d5,  $x0, $x1, #5
        vaddl.u8        q2,  d4,  d5
        vext.8          d8, $x0, $x1, #7
        vaddl.u8        $d0,  $x0, d8        ;A_3 + A4
		
		vmla.i16        $d0,  q2,  d7[2]      ;11*(A_1+A2) + (A_3+A4)
		vmla.i16        q1,  q0,  d7[0]       ;10*(A0 + A1) + (A_2+A3)
		vshl.s16        q1,  q1,  #2	      ;(10*(A0 + A1) + (A_2+A3)) * 4
		vsub.i16        $d0,  q1,  $d0         ;(10*(A0 + A1) + (A_2+A3)) * 4 - (11*(A_1+A2) + (A_3+A4))
		
		vext.8          d10,  $x2, $x3, #3
        vext.8          d11,  $x2, $x3, #4
        vaddl.u8        q5,  d10,  d11
        vext.8          d12,  $x2, $x3, #1
        vext.8          d13,  $x2, $x3, #6
        vaddl.u8        q6,  d12,  d13
		vext.8          d14,  $x2, $x3, #2
        vext.8          d15,  $x2, $x3, #5
        vaddl.u8        q7,  d14,  d15
        vext.8          d9, $x2, $x3, #7
        vaddl.u8        $d1,  $x2, d9        ;A_3 + A4
		
		vmla.i16        $d1,  q7,  d7[2]      ;11*(A_1+A2) + (A_3+A4)
		vmla.i16        q6,  q5,  d7[0]       ;10*(A0 + A1) + (A_2+A3)
		vshl.s16        q6,  q6,  #2	      ;(10*(A0 + A1) + (A_2+A3)) * 4
		vsub.i16        $d1,  q6,  $d1         ;(10*(A0 + A1) + (A_2+A3)) * 4 - (11*(A_1+A2) + (A_3+A4))
		
        mend
		
		macro  
		h3_8_1 $x0, $x1,  $d0
		vext.8          d0, $x0, $x1, #6
		vsubl.u8        q0, $x0, d0
		
		vext.8          d2, $x0, $x1, #1
		vext.8          d4, $x0, $x1, #2
		vmovl.u8        q1, d2
		vmovl.u8        q2, d4
		vmls.i16        q0,  q1,  d6[1]
		vmla.i16        q0,  q2,  d6[3]
		
		vext.8          d8,  $x0, $x1, #3
		vext.8          d10,  $x0, $x1, #4
		vmovl.u8        q4, d8
		vmovl.u8        q5, d10	
		vmla.i16        q0,  q4,  d6[2]
		vmls.i16        q0,  q5,  d7[0]
		
		vext.8          d12, $x0, $x1, #5
		vshll.u8       $d0, d12, #2
		vadd.i16        $d0, q0
        mend
		
		macro  
		h3_8_2 $x0, $x1, $x2, $x3, $d0, $d1
		vext.8          d0, $x0, $x1, #6
		vsubl.u8        q0, $x0, d0
		
		vext.8          d2, $x0, $x1, #1
		vext.8          d4, $x0, $x1, #2
		vmovl.u8        q1, d2
		vmovl.u8        q2, d4
		vmls.i16        q0,  q1,  d6[1]
		vmla.i16        q0,  q2,  d6[3]
		
		vext.8          d8,  $x0, $x1, #3
		vext.8          d10,  $x0, $x1, #4
		vmovl.u8        q4, d8
		vmovl.u8        q5, d10	
		vmla.i16        q0,  q4,  d6[2]
		vmls.i16        q0,  q5,  d7[0]
		
		vext.8          d12, $x0, $x1, #5
		vshll.u8       $d0, d12, #2
		vadd.i16        $d0, q0
		
		vext.8          d0, $x2, $x3, #6
		vsubl.u8        q0, $x2, d0
		
		vext.8          d2, $x2, $x3, #1
		vext.8          d4, $x2, $x3, #2
		vmovl.u8        q1, d2
		vmovl.u8        q2, d4
		vmls.i16        q0,  q1,  d6[1]
		vmla.i16        q0,  q2,  d6[3]
		
		vext.8          d8,  $x2, $x3, #3
		vext.8          d10,  $x2, $x3, #4
		vmovl.u8        q4, d8
		vmovl.u8        q5, d10	
		vmla.i16        q0,  q4,  d6[2]
		vmls.i16        q0,  q5,  d7[0]
		
		vext.8          d12, $x2, $x3, #5
		vshll.u8       $d1, d12, #2
		vadd.i16        $d1, q0      
        mend
		
		macro  
		v1_8_2 $x0, $d0, $d1, $d2, $d3, $narrow={TRUE}

	    vsubl.s16       q4,  d28, d16    
        vsubl.s16       q5,  d29, d17	;q14 - q8
		
		vsubl.s16       q6,  d30, d18    
        vsubl.s16       q7,  d31, d19	;q15 - q9
		
		vmlal.s16       q4,  d18,  d6[0]
        vmlal.s16       q5,  d19,  d6[0] ; + 4 * q9
		
		vmlal.s16       q6,  d20,  d6[0]
        vmlal.s16       q7,  d21,  d6[0] ; + 4 * q10
		
		vmlsl.s16       q4,  d20,  d7[0]
        vmlsl.s16       q5,  d21,  d7[0] ; - 10 * q10
		
		vmlsl.s16       q6,  d22,  d7[0]
        vmlsl.s16       q7,  d23,  d7[0] ; - 10 * q11
		
		vmlal.s16       q4,  d22,  d6[2]
        vmlal.s16       q5,  d23,  d6[2]
		
		vmlal.s16       q6,  d24,  d6[2]
        vmlal.s16       q7,  d25,  d6[2]
		
        vmlal.s16       q4,  d24,  d6[3]
        vmlal.s16       q5,  d25,  d6[3]
		
		vmlal.s16       q6,  d26,  d6[3]
        vmlal.s16       q7,  d27,  d6[3]
		
		vmlsl.s16       q4,  d26,  d6[1]	
        vmlsl.s16       q5,  d27,  d6[1]

        vmlsl.s16       q6,  d28,  d6[1]	
        vmlsl.s16       q7,  d29,  d6[1]

        vmov            q8,  q10
		vmov            q9,  q11		
		vmov            q10, q12
		vmov            q11, q13
        vmov            q12, q14
		vmov            q13, q15		
  IF $narrow
        vqrshrun.s32    d8, q4,  #12	
        vqrshrun.s32    d9, q5,  #12
        vqmovn.u16       $d0, q4		
		
		vqrshrun.s32    d12, q6,  #12	
        vqrshrun.s32    d13, q7,  #12
        vqmovn.u16       $d1, q6	
  ELSE	
        vshrn.s32    $d0, q4,  #6	
        vshrn.s32    $d1, q5,  #6	
		
		vshrn.s32    $d2, q6,  #6	
        vshrn.s32    $d3, q7,  #6	
  ENDIF	
		mend
		
		
		macro  
		v1_8_4 $x0, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $narrow={TRUE}

	    vmull.s16       q0,   d18,  d6[1]
		vmull.s16       q1,   d19,  d6[1]
		vmull.s16       q2,   d20,  d6[1]
		vmull.s16       q4,   d21,  d6[1]		
		vmull.s16       q5,   d22,  d6[1]

		vmlsl.s16       q0,  d16,  d6[0]
		vmlsl.s16       q1,  d17,  d6[0]
		vmlsl.s16       q2,  d18,  d6[0]
		vmlsl.s16       q4,  d19,  d6[0]
		
		vmull.s16       q15,  d23,  d6[1]
		vmull.s16       q8,   d24,  d6[1]				
		vmull.s16       q9,   d25,  d6[1]		
		
		
		vmlsl.s16       q5,  d20,  d6[0]
		vmlsl.s16       q15, d21,  d6[0]
		vmlsl.s16       q8,  d22,  d6[0]
		vmlsl.s16       q9,  d23,  d6[0]
		
		vmlal.s16       q0,  d20,  d6[2]
		vmlal.s16       q1,  d21,  d6[2]
		vmlal.s16       q2,  d22,  d6[2]
		vmlal.s16       q4,  d23,  d6[2]
		vmlal.s16       q5,  d24,  d6[2]
		vmlal.s16       q15, d25,  d6[2]
		vmlal.s16       q8,  d26,  d6[2]
		vmlal.s16       q9,  d27,  d6[2]
		
		vmlsl.s16       q0,  d22,  d6[3]
		vmlsl.s16       q1,  d23,  d6[3]
		vmlsl.s16       q2,  d24,  d6[3]
		vmlsl.s16       q4,  d25,  d6[3]
		vmlsl.s16       q5,  d26,  d6[3]
		vmlsl.s16       q15, d27, d6[3]
		vmlsl.s16       q8,  d28,  d6[3]
		vmlsl.s16       q9,  d29,  d6[3]		
		
  IF $narrow
        vqrshrun.s32    d0, q0,  #12	
        vqrshrun.s32    d1, q1,  #12
        vqmovn.u16      $d0, q0		
		
		vqrshrun.s32    d2, q2,  #12	
        vqrshrun.s32    d3, q4,  #12
        vqmovn.u16      $d1, q1	
		
		vqrshrun.s32    d4, q5,  #12	
        vqrshrun.s32    d5, q15,  #12
        vqmovn.u16      $d2, q2	
		
		vqrshrun.s32    d8, q8,  #12	
        vqrshrun.s32    d9, q9,  #12
        vqmovn.u16      $d3, q4	
  ELSE	
        vshrn.s32    $d0, q0,  #6	
        vshrn.s32    $d1, q1,  #6	
		
		vshrn.s32    $d2, q2,  #6	
        vshrn.s32    $d3, q4,  #6	
		
		vshrn.s32    $d4, q5,  #6	
        vshrn.s32    $d5, q15,  #6	
		
		vshrn.s32    $d6, q8,  #6	
        vshrn.s32    $d7, q9,  #6	
  ENDIF	
        vmov            q8,  q12
		vmov            q9,  q13		
		vmov            q10, q14
		
		mend
		
		
		macro  
		v0_8_4 $x0, $d0, $d1, $d2, $d3, $narrow={TRUE}

		vmull.u8        q0,  d17,  d13
		vmull.u8        q1,  d18,  d13
		vmull.u8        q2,  d19, d13
		vmull.u8        q3,  d20, d13
		
		vmlsl.u8        q0,  d16,   d12  
		vmlsl.u8        q1,  d17,   d12
		vmlsl.u8        q2,  d18,   d12
		vmlsl.u8        q3,  d19,   d12
		
		
		vmlal.u8        q0,  d18,   d14  
		vmlal.u8        q1,  d19,   d14
		vmlal.u8        q2,  d20,  d14
		vmlal.u8        q3,  d21,  d14
		
		vmlsl.u8        q0,  d19,   d15  
		vmlsl.u8        q1,  d20,   d15
		vmlsl.u8        q2,  d21,  d15
		vmlsl.u8        q3,  d22,  d15
  
  IF $narrow
        vqrshrn.u16    $d0, q0,  #6	
        vqrshrn.u16    $d1, q1,  #6	
		vqrshrn.u16    $d2, q2,  #6	
		vqrshrn.u16    $d3, q3,  #6	
  ENDIF	
        vmov            d16,  d20
		vmov            d17,  d21		
		vmov            d18,  d22
        mend		
		
		macro  
		v1_4_4 $x0, $d0, $d1, $d2, $d3, $narrow={TRUE}
		vsubl.s16       q4,  d22, d16
		vsubl.s16       q5,  d23, d17
		vsubl.s16       q6,  d24, d18
		vsubl.s16       q7,  d25, d19
		
		vmlal.s16       q4,  d17,  d6[0]
		vmlal.s16       q5,  d18,  d6[0]
		vmlal.s16       q6,  d19,  d6[0]
		vmlal.s16       q7,  d20,  d6[0]
		
		vmlsl.s16       q4,  d18,  d7[0]
		vmlsl.s16       q5,  d19,  d7[0]
		vmlsl.s16       q6,  d20,  d7[0]
		vmlsl.s16       q7,  d21,  d7[0]
		
		vmlal.s16       q4,  d19,  d6[2]
		vmlal.s16       q5,  d20,  d6[2]
		vmlal.s16       q6,  d21,  d6[2]
		vmlal.s16       q7,  d22,  d6[2]
		
		vmlal.s16       q4,  d20,  d6[3]
		vmlal.s16       q5,  d21,  d6[3]
		vmlal.s16       q6,  d22,  d6[3]
		vmlal.s16       q7,  d23,  d6[3]
		
		vmlsl.s16       q4,  d21,  d6[1]
		vmlsl.s16       q5,  d22,  d6[1]
		vmlsl.s16       q6,  d23,  d6[1]
		vmlsl.s16       q7,  d24,  d6[1]
		
		vmov            q8,  q10
		vmov            q9,  q11
		vmov            q10, q12
		
  IF $narrow		
        vqrshrun.s32    d8, q4,  #12	
        vqrshrun.s32    d9, q5,  #12
        vqmovn.u16       $d0, q4		
		
		vqrshrun.s32    d12, q6,  #12	
        vqrshrun.s32    d13, q7,  #12
        vqmovn.u16       $d1, q6	
  ELSE
	    vshrn.s32    $d0, q4,  #6	
        vshrn.s32    $d1, q5,  #6	
		
		vshrn.s32    $d2, q6,  #6	
        vshrn.s32    $d3, q7,  #6	
  ENDIF	
		mend
		
        macro	
		v2_8_2 $x0, $d0, $d1, $narrow={TRUE}
	    vaddl.s16       q4,  d18, d28    
        vaddl.s16       q5,  d19, d29	;q9 + q14
		
		vaddl.s16       q6,  d16, d30    
        vaddl.s16       q7,  d17, d31	;q8 + q15
		
		vaddl.s16       q0,  d22, d24    
        vaddl.s16       q1,  d23, d25	;q11 + q12
		
		vaddl.s16       q2,  d20, d26    
        vaddl.s16       q8,  d21, d27	;q10 + q13
		
		vmla.s32        q4,  q0,  d7[0]
        vmla.s32        q5,  q1,  d7[0]
		
		vmla.s32        q6,  q2,  d7[1]
        vmla.s32        q7,  q8,  d7[1]

		vshl.s32        q4,  q4,  #2
		vshl.s32        q5,  q5,  #2
		vmov            q8,  q9		
		vmov            q9,  q10
		vmov            q10, q11	
		
		vsub.s32        q4, q6
		vsub.s32        q5, q7		
		vmov            q11, q12
		vmov            q12, q13		
	
  IF $narrow	
		vqrshrun.s32    d8, q4,  #12	
        vqrshrun.s32    d9, q5,  #12
  ELSE
	    vshrn.s32    $d0, q4,  #6	
        vshrn.s32    $d1, q5,  #6	
  ENDIF	
		vmov            q13, q14
		vmov            q14, q15
	
  IF $narrow	
        vqmovn.u16       $d0, q4
  ENDIF		
        mend
		
		macro	
		v2_4_4 $x0, $d0, $d1, $d2, $d3, $narrow={TRUE}	
		vmov.32          r9, r10,  d26
		
	    vaddl.s16       q0,   d16, d23
		vaddl.s16       q1,   d17, d24
		vaddl.s16       q2,   d18, d25
		vaddl.s16       q4,  d19, d26
		
        vaddl.s16       q5,   d18, d21
		vaddl.s16       q6,   d19, d22
		vaddl.s16       q7,   d20, d23
		vaddl.s16       q14,  d21, d24
		
        vmla.s32        q0,  q5,   d7[1]	
		vmla.s32        q1,  q6,   d7[1]	
		vmla.s32        q2,  q7,   d7[1]	
		vmla.s32        q4,  q14,  d7[1]	
		
        vaddl.s16       q5,   d17, d22
		vaddl.s16       q6,   d18, d23
		vaddl.s16       q7,   d19, d24
		vaddl.s16       q14,  d20, d25
		
        vaddl.s16       q15,  d19, d20
		vaddl.s16       q8,   d20, d21
		vaddl.s16       q9,   d21, d22
		vaddl.s16       q13,  d22, d23
		
        vmla.s32        q5,  q15,   d7[0]	
		vmla.s32        q6,   q8,   d7[0]
		vmla.s32        q7,   q9,   d7[0]
		vmla.s32        q14,  q13,  d7[0]
		
		vshl.s32        q5,   q5,   #2
		vshl.s32        q6,   q6,   #2
		vshl.s32        q7,   q7,   #2
		vshl.s32        q14,  q14,  #2
		
        vsub.s32        q5,   q0	
		vsub.s32        q6,   q1
		vsub.s32        q7,   q2
		vsub.s32        q14,  q4
 
  IF $narrow
		vqrshrun.s32    d8,  q5,  #12	
        vqrshrun.s32    d9,  q6,   #12
		vqrshrun.s32    d10, q7,   #12	
        vqrshrun.s32    d11, q14,  #12
  ELSE
	    vshrn.s32    $d0, q5,   #6	
        vshrn.s32    $d1, q6,   #6	
        vshrn.s32    $d2, q7,   #6	
        vshrn.s32    $d3, q14,  #6					
  ENDIF	
		
		vmov            q8,  q10
		vmov            q9,  q11
		vmov            q10, q12 
		vmov.32         d22, r9, r10	
	
  IF $narrow	
        vqmovn.u16       $d0, q4	
        vqmovn.u16       $d1, q5
  ENDIF		
        mend
		
		macro  
		v3_8_2 $x0, $d0, $d1, $d2, $d3, $narrow={TRUE}	
	    vsubl.s16       q4,  d16, d28    
        vsubl.s16       q5,  d17, d29	;q14 - q8
		
		vsubl.s16       q6,  d18, d30    
        vsubl.s16       q7,  d19, d31	;q15 - q9
		
		vmlsl.s16       q4,  d18,  d6[1]
        vmlsl.s16       q5,  d19,  d6[1] ; + 4 * q9
		
		vmlsl.s16       q6,  d20,  d6[1]
        vmlsl.s16       q7,  d21,  d6[1] ; + 4 * q10
		
		vmlal.s16       q4,  d20,  d6[3]
        vmlal.s16       q5,  d21,  d6[3] ; - 10 * q10
		
		vmlal.s16       q6,  d22,  d6[3]
        vmlal.s16       q7,  d23,  d6[3] ; - 10 * q11
		
		vmlal.s16       q4,  d22,  d6[2]
        vmlal.s16       q5,  d23,  d6[2]
		
		vmlal.s16       q6,  d24,  d6[2]
        vmlal.s16       q7,  d25,  d6[2]
		
        vmlsl.s16       q4,  d24,  d7[0]
        vmlsl.s16       q5,  d25,  d7[0]
		
		vmlsl.s16       q6,  d26,  d7[0]
        vmlsl.s16       q7,  d27,  d7[0]
		
		vmlal.s16       q4,  d26,  d6[0]	
        vmlal.s16       q5,  d27,  d6[0]

        vmlal.s16       q6,  d28,  d6[0]	
        vmlal.s16       q7,  d29,  d6[0]

        vmov            q8,  q10
		vmov            q9,  q11		
		vmov            q10, q12
		vmov            q11, q13
        vmov            q12, q14
		vmov            q13, q15			

  IF $narrow
        vqrshrun.s32    d8, q4,  #12	
        vqrshrun.s32    d9, q5,  #12
		vqmovn.u16       $d0, q4	
		vqrshrun.s32    d12, q6,  #12	
        vqrshrun.s32    d13, q7,  #12
        vqmovn.u16       $d1, q6	
  ELSE
	    vshrn.s32    $d0, q4,   #6	
        vshrn.s32    $d1, q5,   #6
		vshrn.s32    $d2, q6,   #6	
        vshrn.s32    $d3, q7,   #6
  ENDIF	

		mend
		
		macro  
		v3_4_4 $x0, $d0, $d1, $d2, $d3, $narrow={TRUE}
		vsubl.s16       q4,  d16, d22
		vsubl.s16       q5,  d17, d23
		vsubl.s16       q6,  d18, d24
		vsubl.s16       q7,  d19, d25
		
		vmlsl.s16       q4,  d17,  d6[1]
		vmlsl.s16       q5,  d18,  d6[1]
		vmlsl.s16       q6,  d19,  d6[1]
		vmlsl.s16       q7,  d20,  d6[1]
		
		vmlal.s16       q4,  d18,  d6[3]
		vmlal.s16       q5,  d19,  d6[3]
		vmlal.s16       q6,  d20,  d6[3]
		vmlal.s16       q7,  d21,  d6[3]
		
		vmlal.s16       q4,  d19,  d6[2]
		vmlal.s16       q5,  d20,  d6[2]
		vmlal.s16       q6,  d21,  d6[2]
		vmlal.s16       q7,  d22,  d6[2]
		
		vmlsl.s16       q4,  d20,  d7[0]
		vmlsl.s16       q5,  d21,  d7[0]
		vmlsl.s16       q6,  d22,  d7[0]
		vmlsl.s16       q7,  d23,  d7[0]
		
		vmlal.s16       q4,  d21,  d6[0]
		vmlal.s16       q5,  d22,  d6[0]
		vmlal.s16       q6,  d23,  d6[0]
		vmlal.s16       q7,  d24,  d6[0]
		
		vmov            q8,  q10
		vmov            q9,  q11
		vmov            q10, q12
	
  IF $narrow
        vqrshrun.s32    d8, q4,  #12	
        vqrshrun.s32    d9, q5,  #12
        vqmovn.u16       $d0, q4
		vqrshrun.s32    d12, q6,  #12	
        vqrshrun.s32    d13, q7,  #12
        vqmovn.u16       $d1, q6	
  ELSE
	    vshrn.s32    $d0, q4,   #6	
        vshrn.s32    $d1, q5,   #6
		vshrn.s32    $d2, q6,   #6	
        vshrn.s32    $d3, q7,   #6
  ENDIF		
		mend
		
		macro  
		h265_qpel32_h0v0_neon $type

	IF "$type"="put"
1       vld1.64         {q0, q1},  [pTmpSrc], nSrcStride
        vld1.64         {q2, q3},  [pTmpSrc], nSrcStride
        vld1.64         {q4, q5}, [pTmpSrc], nSrcStride
		vld1.64         {q6, q7}, [pTmpSrc], nSrcStride
        subs            nTmpHeight,  nTmpHeight,  #4	
        vst1.64         {q0, q1},     [pTmpDst@128], nDstStride
		vst1.64         {q2, q3},     [pTmpDst@128], nDstStride
        vst1.64         {q4, q5},    [pTmpDst@128], nDstStride
		vst1.64         {q6, q7},    [pTmpDst@128], nDstStride
	ELSE
	  IF "$type"="avg_nornd"
1       vld1.64         {q0, q1},  [pTmpSrc], nSrcStride
        vld1.64         {q2, q3},  [pTmpSrc], nSrcStride
        vld1.64         {q4, q5}, [pTmpSrc], nSrcStride
		vld1.64         {q6, q7}, [pTmpSrc], nSrcStride
        subs            nTmpHeight,  nTmpHeight,  #4	  
        vshll.u8        q8,  d0, #6	 
        vshll.u8        q9,  d1, #6	
        vshll.u8        q10, d2, #6
        vshll.u8        q11, d3, #6
        vshll.u8        q12, d4, #6		
		vshll.u8        q13, d5, #6	
		vshll.u8        q14, d6, #6
        vshll.u8        q15, d7, #6			
        vst1.64         {q8,  q9},   [pTmpDst2@128]!	
        vst1.64         {q10, q11},  [pTmpDst2@128], nDstStride2	
		vst1.64         {q14, q15},  [pTmpDst2@128]	
		sub             pTmpDst2, pTmpDst2, #32
        vst1.64         {q12, q13},  [pTmpDst2@128], nDstStride2
		vshll.u8        q8,  d8,  #6	 
        vshll.u8        q9,  d9,  #6	
        vshll.u8        q10, d10, #6
        vshll.u8        q11, d11, #6
        vshll.u8        q12, d12, #6		
		vshll.u8        q13, d13, #6	
		vshll.u8        q14, d14, #6
        vshll.u8        q15, d15, #6			
        vst1.64         {q8,  q9},   [pTmpDst2@128]	!
        vst1.64         {q10, q11},  [pTmpDst2@128], nDstStride2	
		vst1.64         {q14, q15},  [pTmpDst2@128]
        sub             pTmpDst2, pTmpDst2, #32		
        vst1.64         {q12, q13},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
1       vld1.64         {q4, q5},     [pTmpSrc], nSrcStride
        vld1.64         {q6, q7},     [pTmpSrc], nSrcStride
		vshll.u8        q0,  d8,  #6	 
        vshll.u8        q1,  d9,  #6	
        vshll.u8        q2, d10,  #6
        vshll.u8        q3, d11,  #6
        vshll.u8        q4, d12,  #6		
		vshll.u8        q5, d13,  #6	
		vshll.u8        q6, d14,  #6
        vshll.u8        q7, d15,  #6			

        subs            nTmpHeight,  nTmpHeight,  #2		
        vld1.64          {q8,  q9},   [pTmpDst2@128]!
        vld1.64          {q10, q11},  [pTmpDst2@128], nDstStride2
		vld1.64          {q14, q15},  [pTmpDst2@128]
        sub             pTmpDst2, pTmpDst2, #32		
        vld1.64          {q12, q13},  [pTmpDst2@128], nDstStride2
        vhadd.s16         q0, q8
		vhadd.s16         q1, q9
		vhadd.s16         q2, q10
		vhadd.s16         q3, q11
		vhadd.s16         q4, q12
		vhadd.s16         q5, q13
		vhadd.s16         q6, q14
		vhadd.s16         q7, q15
		
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vqrshrun.s16    d2, q2,  #6
		vqrshrun.s16    d3, q3,  #6
		vqrshrun.s16    d4, q4,  #6
		vqrshrun.s16    d5, q5,  #6
		vqrshrun.s16    d6, q6,  #6
		vqrshrun.s16    d7, q7,  #6
		
        vst1.64           {q0, q1},  [pTmpDst@128], nDstStride	
        vst1.64           {q2, q3},  [pTmpDst@128], nDstStride	
	    ENDIF
	  ENDIF
    ENDIF	
        bgt             %B1
        mend
		
		macro  
		h265_qpel16_h0v0_neon $type
1       vld1.64         {q0},  [pTmpSrc], nSrcStride
        vld1.64         {q1},  [pTmpSrc], nSrcStride
        vld1.64         {q2}, [pTmpSrc], nSrcStride
		vld1.64         {q3}, [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"        	
        vst1.64         {q0},     [pTmpDst@128], nDstStride
		vst1.64         {q1},     [pTmpDst@128], nDstStride
        vst1.64         {q2},    [pTmpDst@128], nDstStride
		vst1.64         {q3},    [pTmpDst@128], nDstStride
	ELSE
	  IF "$type"="avg_nornd"  
        vshll.u8        q8,  d0, #6	 
        vshll.u8        q9,  d1, #6	
        vshll.u8        q10, d2, #6
        vshll.u8        q11, d3, #6
        vshll.u8        q12, d4, #6		
		vshll.u8        q13, d5, #6	
		vshll.u8        q14, d6, #6
        vshll.u8        q15, d7, #6			
        vst1.64         {q8,  q9},   [pTmpDst2@128], nDstStride2	
        vst1.64         {q10, q11},  [pTmpDst2@128], nDstStride2	
		vst1.64         {q12, q13},  [pTmpDst2@128], nDstStride2	
        vst1.64         {q14, q15},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
		vshll.u8        q8,   d0,  #6	 
        vshll.u8        q9,   d1,  #6	
        vshll.u8        q10,  d2,  #6
        vshll.u8        q11,  d3,  #6
        vshll.u8        q12,  d4,  #6		
		vshll.u8        q13,  d5,  #6	
		vshll.u8        q14,  d6,  #6
        vshll.u8        q15,  d7,  #6					
        vld1.64          {q0,  q1},   [pTmpDst2@128], nDstStride2
        vld1.64          {q2,  q3},   [pTmpDst2@128], nDstStride2
		vld1.64          {q4,  q5},   [pTmpDst2@128], nDstStride2	
        vld1.64          {q6,  q7},   [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q8
		vhadd.s16         q1, q9
		vhadd.s16         q2, q10
		vhadd.s16         q3, q11
		vhadd.s16         q4, q12
		vhadd.s16         q5, q13
		vhadd.s16         q6, q14
		vhadd.s16         q7, q15
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vqrshrun.s16    d2, q2,  #6
		vqrshrun.s16    d3, q3,  #6
		vqrshrun.s16    d4, q4,  #6
		vqrshrun.s16    d5, q5,  #6
		vqrshrun.s16    d6, q6,  #6
		vqrshrun.s16    d7, q7,  #6
		
        vst1.64           {q0},  [pTmpDst@128], nDstStride	
        vst1.64           {q1},  [pTmpDst@128], nDstStride
        vst1.64           {q2},  [pTmpDst@128], nDstStride	
        vst1.64           {q3},  [pTmpDst@128], nDstStride		
	    ENDIF
	  ENDIF
    ENDIF	
        bgt             %B1
        mend
		
		macro  
		h265_qpel8_h0v0_neon $type
1       vld1.64         {d0},  [pTmpSrc], nSrcStride
        vld1.64         {d1},  [pTmpSrc], nSrcStride
        vld1.64         {d2}, [pTmpSrc], nSrcStride
		vld1.64         {d3}, [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"        	
        vst1.64         {d0},     [pTmpDst@64], nDstStride
		vst1.64         {d1},     [pTmpDst@64], nDstStride
		blt             %F2
        vst1.64         {d2},    [pTmpDst@64], nDstStride
		vst1.64         {d3},    [pTmpDst@64], nDstStride
	ELSE
	  IF "$type"="avg_nornd"  
        vshll.u8        q8,  d0, #6	 
        vshll.u8        q9,  d1, #6	
        vshll.u8        q10, d2, #6
        vshll.u8        q11, d3, #6	
        vst1.64         {q8},   [pTmpDst2@128], nDstStride2	
        vst1.64         {q9},  [pTmpDst2@128], nDstStride2	
		blt             %F2
		vst1.64         {q10},  [pTmpDst2@128], nDstStride2	
        vst1.64         {q11},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
		vshll.u8        q8,   d0,  #6	 
        vshll.u8        q9,   d1,  #6	
        vshll.u8        q10,  d2,  #6
        vshll.u8        q11,  d3,  #6				
        vld1.64          {q0},   [pTmpDst2@128], nDstStride2
        vld1.64          {q1},   [pTmpDst2@128], nDstStride2
		vld1.64          {q2},   [pTmpDst2@128], nDstStride2	
        vld1.64          {q3},   [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q8
		vhadd.s16         q1, q9
		vhadd.s16         q2, q10
		vhadd.s16         q3, q11
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vqrshrun.s16    d2, q2,  #6
		vqrshrun.s16    d3, q3,  #6
		
        vst1.64           {d0},  [pTmpDst@64], nDstStride	
        vst1.64           {d1},  [pTmpDst@64], nDstStride
		blt             %F2
        vst1.64           {d2},  [pTmpDst@64], nDstStride	
        vst1.64           {d3},  [pTmpDst@64], nDstStride		
	    ENDIF
	  ENDIF
    ENDIF	
        bgt             %B1
2		
        mend
		
				macro  
		h265_qpel4_h0v0_neon $type
1       vld1.32         {d0[0]},  [pTmpSrc], nSrcStride
        vld1.32         {d0[1]},  [pTmpSrc], nSrcStride
        vld1.32         {d1[0]}, [pTmpSrc], nSrcStride
		vld1.32         {d1[1]}, [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"        	
        vst1.32         {d0[0]},     [pTmpDst@32], nDstStride
		vst1.32         {d0[1]},     [pTmpDst@32], nDstStride
		blt             %F2
        vst1.32         {d1[0]},     [pTmpDst@32], nDstStride
		vst1.32         {d1[1]},     [pTmpDst@32], nDstStride
	ELSE
	  IF "$type"="avg_nornd"  
        vshll.u8        q8,  d0, #6	 
        vshll.u8        q9,  d1, #6	
        vst1.64         {d16},   [pTmpDst2@64], nDstStride2	
        vst1.64         {d17},   [pTmpDst2@64], nDstStride2	
		blt             %F2
		vst1.64         {d18},   [pTmpDst2@64], nDstStride2	
        vst1.64         {d19},   [pTmpDst2@64], nDstStride2
	  ELSE
	    IF "$type"="avg"	
		vshll.u8        q8,   d0,  #6	 
        vshll.u8        q9,   d1,  #6			
        vld1.64          {d0},   [pTmpDst2@64], nDstStride2
        vld1.64          {d1},   [pTmpDst2@64], nDstStride2
		vld1.64          {d2},   [pTmpDst2@64], nDstStride2	
        vld1.64          {d3},   [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q8
		vhadd.s16         q1, q9
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.32         {d0[0]},     [pTmpDst@32], nDstStride
		vst1.32         {d0[1]},     [pTmpDst@32], nDstStride
		blt             %F2
        vst1.32         {d1[0]},     [pTmpDst@32], nDstStride
		vst1.32         {d1[1]},     [pTmpDst@32], nDstStride		
	    ENDIF
	  ENDIF
    ENDIF	
        bgt             %B1
2		
        mend
		
		macro  
		h265_qpel2_h0v0_neon $type
1       vld1.16         {d0[0]},  [pTmpSrc], nSrcStride
        vld1.16         {d0[1]},  [pTmpSrc], nSrcStride
        vld1.16         {d0[2]}, [pTmpSrc], nSrcStride
		vld1.16         {d0[3]}, [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"        	
        vst1.16         {d0[0]},     [pTmpDst@16], nDstStride
		vst1.16         {d0[1]},     [pTmpDst@16], nDstStride
		blt             %F2
        vst1.16         {d0[2]},     [pTmpDst@16], nDstStride
		vst1.16         {d0[3]},     [pTmpDst@16], nDstStride
	ELSE
	  IF "$type"="avg_nornd"  
        vshll.u8        q8,  d0, #6	 	
        vst1.32         {d16[0]},   [pTmpDst2@32], nDstStride2	
        vst1.32         {d16[1]},   [pTmpDst2@32], nDstStride2	
		blt             %F2
		vst1.32         {d17[0]},   [pTmpDst2@32], nDstStride2	
        vst1.32         {d17[1]},   [pTmpDst2@32], nDstStride2
	  ELSE
	    IF "$type"="avg"	
		vshll.u8        q8,   d0,  #6	 			
        vld1.32          {d4[0]},   [pTmpDst2@32], nDstStride2
        vld1.32          {d4[1]},   [pTmpDst2@32], nDstStride2
		vld1.32          {d5[0]},   [pTmpDst2@32], nDstStride2	
        vld1.32          {d5[1]},   [pTmpDst2@32], nDstStride2
		vadd.i16         q2, q8
		vqrshrn.u16    d0, q2,  #7
		
        vst1.16         {d0[0]},     [pTmpDst@16], nDstStride
		vst1.16         {d0[1]},     [pTmpDst@16], nDstStride
		blt             %F2
        vst1.16         {d0[2]},     [pTmpDst@16], nDstStride
		vst1.16         {d0[3]},     [pTmpDst@16], nDstStride		
	    ENDIF
	  ENDIF
    ENDIF	
        bgt             %B1
2		
        mend
		
		macro  
		h265_qpel8_h1_neon $type
1       vld1.64         {d0, d1},  [pTmpSrc], nSrcStride
        vld1.64         {d2, d3},  [pTmpSrc], nSrcStride
        vld1.64         {d16,d17}, [pTmpSrc], nSrcStride
		vld1.64         {d18,d19}, [pTmpSrc], nSrcStride
        subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
        h1_8            d0,  d1,  d2, d3, d16, d17, d18, d19, d0,  d1, d16, d17, |
        vst1.64         {d0},     [pTmpDst@64], nDstStride
		vst1.64         {d1},     [pTmpDst@64], nDstStride
        vst1.64         {d16},    [pTmpDst@64], nDstStride
		vst1.64         {d17},    [pTmpDst@64], nDstStride
	ELSE
	    h1_8            d0,  d1,  d2, d3, d16, d17, d18, d19, q2,  q3, q10, q11, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q2},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@128], nDstStride2	
		vst1.8          {q10},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q11},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@128], nDstStride2
		vld1.16          {q8},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q9},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q2
		vhadd.s16         q1, q3
		vhadd.s16         q8, q10
		vhadd.s16         q9, q11
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vqrshrun.s16    d2, q8,  #6
		vqrshrun.s16    d3, q9,  #6
        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride
        vst1.8           {d2},  [pTmpDst@64], nDstStride	
        vst1.8           {d3},  [pTmpDst@64], nDstStride		
	    ENDIF
	  ENDIF
    ENDIF	
        bgt             %B1
        mend
		
		 macro  
		h265_qpel4_h1_neon $type
1       vld1.64         {d0, d1},  [pTmpSrc], nSrcStride
        vld1.64         {d2, d3},  [pTmpSrc], nSrcStride
        vld1.64         {d16,d17}, [pTmpSrc], nSrcStride
		vld1.64         {d18,d19}, [pTmpSrc], nSrcStride
        subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
        h1_8            d0,  d1,  d2, d3, d16, d17, d18, d19, d0,  d1, d16, d17, |
        vst1.32         {d0[0]},     [pTmpDst@32], nDstStride
		vst1.32         {d1[0]},     [pTmpDst@32], nDstStride
        vst1.32         {d16[0]},    [pTmpDst@32], nDstStride
		vst1.32         {d17[0]},    [pTmpDst@32], nDstStride
	ELSE
	    h1_8            d0,  d1,  d2, d3, d16, d17, d18, d19, q2,  q3, q10, q11, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q2},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@64], nDstStride2	
		vst1.8          {q10},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q11},  [pTmpDst2@64], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@64], nDstStride2
		vld1.16          {q8},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q9},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q2
		vhadd.s16         q1, q3
		vhadd.s16         q8, q10
		vhadd.s16         q9, q11
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vqrshrun.s16    d2, q8,  #6
		vqrshrun.s16    d3, q9,  #6
		
        vst1.32           {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d1[0]},  [pTmpDst@32], nDstStride
        vst1.32           {d2[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d3[0]},  [pTmpDst@32], nDstStride		
	    ENDIF
	  ENDIF
    ENDIF	
        bgt             %B1
        mend

        macro    
		h265_qpel8_h2_neon $type
1      vld1.64         {d0, d1},    [pTmpSrc], nSrcStride
        vld1.64         {d2, d3},    [pTmpSrc], nSrcStride
		vld1.64         {d16, d17},  [pTmpSrc], nSrcStride
        vld1.64         {d18, d19},  [pTmpSrc], nSrcStride
        subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
        h2_8            d0,  d1,  d2, d3, d16, d17, d18, d19, d0, d1, d16, d17, |
        vst1.64         {d0},     [pTmpDst@64], nDstStride
		vst1.64         {d1},     [pTmpDst@64], nDstStride
        vst1.64         {d16},    [pTmpDst@64], nDstStride
		vst1.64         {d17},    [pTmpDst@64], nDstStride
	ELSE
	    h2_8            d0,  d1,  d2, d3, d16, d17, d18, d19, q4,  q5, q8, q9, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q5},  [pTmpDst2@128], nDstStride2	
		vst1.8          {q8},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q9},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@128], nDstStride2
		vld1.16          {q10},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q11},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q5
		vhadd.s16         q10, q8
		vhadd.s16         q11, q9
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vqrshrun.s16    d2, q10,  #6
		vqrshrun.s16    d3, q11,  #6
		
        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride
        vst1.8           {d2},  [pTmpDst@64], nDstStride	
        vst1.8           {d3},  [pTmpDst@64], nDstStride		
	    ENDIF
	  ENDIF
    ENDIF	
        bgt             %B1
        mend
		
		 macro    
		h265_qpel4_h2_neon $type
1      vld1.64         {d0, d1},    [pTmpSrc], nSrcStride
        vld1.64         {d2, d3},    [pTmpSrc], nSrcStride
		vld1.64         {d16, d17},  [pTmpSrc], nSrcStride
        vld1.64         {d18, d19},  [pTmpSrc], nSrcStride
        subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
        h2_8            d0,  d1,  d2, d3, d16, d17, d18, d19, d0, d1, d16, d17, |
        vst1.32         {d0[0]},     [pTmpDst@32], nDstStride
		vst1.32         {d1[0]},     [pTmpDst@32], nDstStride
        vst1.32         {d16[0]},    [pTmpDst@32], nDstStride
		vst1.32         {d17[0]},    [pTmpDst@32], nDstStride
	ELSE
	    h2_8            d0,  d1,  d2, d3, d16, d17, d18, d19, q4,  q5, q8, q9, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q5},  [pTmpDst2@64], nDstStride2	
		vst1.8          {q8},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q9},  [pTmpDst2@64], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@64], nDstStride2
		vld1.16          {q10},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q11},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q5
		vhadd.s16         q10, q8
		vhadd.s16         q11, q9
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vqrshrun.s16    d2, q10,  #6
		vqrshrun.s16   d3, q11,  #6		
		
        vst1.32           {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d1[0]},  [pTmpDst@32], nDstStride
        vst1.32           {d2[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d3[0]},  [pTmpDst@32], nDstStride		
	    ENDIF
	  ENDIF
    ENDIF	
        bgt             %B1
        mend


        macro    
		h265_qpel8_h3_neon $type
1       vld1.64         {d0, d1},  [pTmpSrc], nSrcStride
        vld1.64         {d2, d3},  [pTmpSrc], nSrcStride
        vld1.64         {d16,d17}, [pTmpSrc], nSrcStride
		vld1.64         {d18,d19}, [pTmpSrc], nSrcStride
        subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
        h3_8       d0,  d1,  d2, d3, d16, d17, d18, d19, d0,  d1, d16, d17, |
        vst1.64         {d0},     [pTmpDst@64], nDstStride
		vst1.64         {d1},     [pTmpDst@64], nDstStride
        vst1.64         {d16},    [pTmpDst@64], nDstStride
		vst1.64         {d17},    [pTmpDst@64], nDstStride
	ELSE
	    h3_8            d0,  d1,  d2, d3, d16, d17, d18, d19, q2,  q3, q10, q11, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q2},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@128], nDstStride2	
		vst1.8          {q10},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q11},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q4},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q5},  [pTmpDst2@128], nDstStride2
		vld1.16          {q8},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q9},  [pTmpDst2@128], nDstStride2
		
		vhadd.s16         q2, q4
		vhadd.s16         q3, q5
		vhadd.s16         q10, q8
		vhadd.s16         q11, q9
		vqrshrun.s16    d0, q2,  #6
		vqrshrun.s16    d1, q3,  #6
		vqrshrun.s16    d2, q10,  #6
		vqrshrun.s16    d3, q11,  #6
		

        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride
        vst1.8           {d2},  [pTmpDst@64], nDstStride	
        vst1.8           {d3},  [pTmpDst@64], nDstStride		
	    ENDIF
	  ENDIF	     
    ENDIF	
        bgt             %B1
        mend
		
		macro    
		h265_qpel4_h3_neon $type
1       vld1.64         {d0, d1},  [pTmpSrc], nSrcStride
        vld1.64         {d2, d3},  [pTmpSrc], nSrcStride
        vld1.64         {d16,d17}, [pTmpSrc], nSrcStride
		vld1.64         {d18,d19}, [pTmpSrc], nSrcStride
        subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
        h3_8       d0,  d1,  d2, d3, d16, d17, d18, d19, d0,  d1, d16, d17, |
        vst1.32         {d0[0]},     [pTmpDst@32], nDstStride
		vst1.32         {d1[0]},     [pTmpDst@32], nDstStride
        vst1.32         {d16[0]},    [pTmpDst@32], nDstStride
		vst1.32         {d17[0]},    [pTmpDst@32], nDstStride
	ELSE
	    h3_8            d0,  d1,  d2, d3, d16, d17, d18, d19, q2,  q3, q10, q11, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q2},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@64], nDstStride2	
		vst1.8          {q10},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q11},  [pTmpDst2@64], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q4},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q5},  [pTmpDst2@64], nDstStride2
		vld1.16          {q8},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q9},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q2, q4
		vhadd.s16         q3, q5
		vhadd.s16         q10, q8
		vhadd.s16         q11, q9
		vqrshrun.s16    d0, q2,  #6
		vqrshrun.s16    d1, q3,  #6
		vqrshrun.s16    d2, q10,  #6
		vqrshrun.s16    d3, q11,  #6

        vst1.32           {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d1[0]},  [pTmpDst@32], nDstStride
        vst1.32           {d2[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d3[0]},  [pTmpDst@32], nDstStride		
	    ENDIF
	  ENDIF	     
    ENDIF	
        bgt             %B1
        mend

        macro    
		h265_qpel8_v1_neon $type
		vld1.64         {d20},  [pTmpSrc], nSrcStride
        vld1.64         {d21},  [pTmpSrc], nSrcStride
		vld1.64         {d22},  [pTmpSrc], nSrcStride
		vld1.64         {d23},  [pTmpSrc], nSrcStride
		vld1.64         {d24},  [pTmpSrc], nSrcStride
		vld1.64         {d25},  [pTmpSrc], nSrcStride
2		vld1.64         {d26},  [pTmpSrc], nSrcStride
		vld1.64         {d27},  [pTmpSrc], nSrcStride
		vld1.64         {d28},  [pTmpSrc], nSrcStride
		vld1.64         {d29},  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
		v1_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d0, d1, d2, d3, |
		vst1.8          {d0},  [pTmpDst@64], nDstStride
        vst1.8          {d1},  [pTmpDst@64], nDstStride
		vst1.8          {d2},   [pTmpDst@64], nDstStride
        vst1.8          {d3},   [pTmpDst@64], nDstStride
	ELSE
	    v1_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, q1, q3, q5, q7, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q1},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@128], nDstStride2	
		vst1.8          {q5},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q7},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q2},  [pTmpDst2@128], nDstStride2
		vld1.16          {q4},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q6},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q1, q0
		vhadd.s16         q3, q2
		vhadd.s16         q5, q4
		vhadd.s16         q7, q6
		vqrshrun.s16    d0, q1,  #6
		vqrshrun.s16    d1, q3,  #6
		vqrshrun.s16    d2, q5,  #6
		vqrshrun.s16    d3, q7,  #6
		
        vst1.8          {d0},  [pTmpDst@64], nDstStride
        vst1.8          {d1},  [pTmpDst@64], nDstStride
		vst1.8          {d2},   [pTmpDst@64], nDstStride
        vst1.8          {d3},   [pTmpDst@64], nDstStride		
	    ENDIF
	  ENDIF	   
    ENDIF	
		ble             %F1
		vmov            q10, q12
        vmov            q11, q13
        vmov		    q12, q14
		b               %B2
1		
        mend	
		
		macro    
		h265_qpel4_v1_neon $type
		vld1.64         {d20},  [pTmpSrc], nSrcStride
        vld1.64         {d21},  [pTmpSrc], nSrcStride
		vld1.64         {d22},  [pTmpSrc], nSrcStride
		vld1.64         {d23},  [pTmpSrc], nSrcStride
		vld1.64         {d24},  [pTmpSrc], nSrcStride
		vld1.64         {d25},  [pTmpSrc], nSrcStride
2		vld1.64         {d26},  [pTmpSrc], nSrcStride
		vld1.64         {d27},  [pTmpSrc], nSrcStride
		vld1.64         {d28},  [pTmpSrc], nSrcStride
		vld1.64         {d29},  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
		v1_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d0, d1, d2, d3, |
		vst1.32          {d0[0]},  [pTmpDst@32], nDstStride
        vst1.32          {d1[0]},  [pTmpDst@32], nDstStride
		vst1.32          {d2[0]},   [pTmpDst@32], nDstStride
        vst1.32          {d3[0]},   [pTmpDst@32], nDstStride
	ELSE
		v1_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, q1, q3, q5, q7, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q1},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@64], nDstStride2	
		vst1.8          {q5},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q7},  [pTmpDst2@64], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q2},  [pTmpDst2@64], nDstStride2
		vld1.16          {q4},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q6},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q1, q0
		vhadd.s16         q3, q2
		vhadd.s16         q5, q4
		vhadd.s16         q7, q6
		vqshrun.s16    d0, q1,  #6
		vqshrun.s16    d1, q3,  #6
		vqshrun.s16    d2, q5,  #6
		vqshrun.s16    d3, q7,  #6
        vst1.32          {d0[0]},  [pTmpDst@32], nDstStride
        vst1.32          {d1[0]},  [pTmpDst@32], nDstStride
		vst1.32          {d2[0]},   [pTmpDst@32], nDstStride
        vst1.32          {d3[0]},   [pTmpDst@32], nDstStride		
	    ENDIF
	  ENDIF	   	    
    ENDIF	
		ble             %F1
		vmov            q10, q12
        vmov            q11, q13
        vmov		    q12, q14
		b               %B2
1		
        mend
		
        macro    
		h265_qpel8_v2_neon $type
		vld1.64         {d20},  [pTmpSrc], nSrcStride
        vld1.64         {d21},  [pTmpSrc], nSrcStride
		vld1.64         {d22},  [pTmpSrc], nSrcStride
		vld1.64         {d23},  [pTmpSrc], nSrcStride
		vld1.64         {d24},  [pTmpSrc], nSrcStride
		vld1.64         {d25},  [pTmpSrc], nSrcStride
		vld1.64         {d26},  [pTmpSrc], nSrcStride
2		vld1.64         {d27},  [pTmpSrc], nSrcStride
		vld1.64         {d28},  [pTmpSrc], nSrcStride
		vld1.64         {d29},  [pTmpSrc], nSrcStride
		vld1.64         {d30},  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
		v2_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, d0, d1, d2, d3, |
		vst1.8          {d0},  [pTmpDst@64], nDstStride
        vst1.8          {d1},  [pTmpDst@64], nDstStride
		vst1.8          {d2},  [pTmpDst@64], nDstStride
        vst1.8          {d3},  [pTmpDst@64], nDstStride
	ELSE
		v2_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, q1, q3, q5, q7, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q1},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@128], nDstStride2	
		vst1.8          {q5},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q7},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q2},  [pTmpDst2@128], nDstStride2
		vld1.16          {q4},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q6},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q1, q0
		vhadd.s16         q3, q2
		vhadd.s16         q5, q4
		vhadd.s16         q7, q6
		vqrshrun.s16    d0, q1,  #6
		vqrshrun.s16    d1, q3,  #6
		vqrshrun.s16    d2, q5,  #6
		vqrshrun.s16   d3, q7,  #6
        vst1.8          {d0},  [pTmpDst@64], nDstStride
        vst1.8          {d1},  [pTmpDst@64], nDstStride
		vst1.8          {d2},   [pTmpDst@64], nDstStride
        vst1.8          {d3},   [pTmpDst@64], nDstStride		
	    ENDIF
	  ENDIF	   
    ENDIF	
		ble             %F1
		vmov            q10, q12
        vmov            q11, q13
        vmov		    q12, q14
		vmov            d26, d30
		b               %B2
1		
        mend
		
		macro    
		h265_qpel4_v2_neon $type
		vld1.64         {d20},  [pTmpSrc], nSrcStride
        vld1.64         {d21},  [pTmpSrc], nSrcStride
		vld1.64         {d22},  [pTmpSrc], nSrcStride
		vld1.64         {d23},  [pTmpSrc], nSrcStride
		vld1.64         {d24},  [pTmpSrc], nSrcStride
		vld1.64         {d25},  [pTmpSrc], nSrcStride
		vld1.64         {d26},  [pTmpSrc], nSrcStride
2		vld1.64         {d27},  [pTmpSrc], nSrcStride
		vld1.64         {d28},  [pTmpSrc], nSrcStride
		vld1.64         {d29},  [pTmpSrc], nSrcStride
		vld1.64         {d30},  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
		v2_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, d0, d1, d2, d3, |
		vst1.32          {d0[0]},  [pTmpDst@32], nDstStride
        vst1.32          {d1[0]},  [pTmpDst@32], nDstStride
		vst1.32          {d2[0]},  [pTmpDst@32], nDstStride
        vst1.32          {d3[0]},  [pTmpDst@32], nDstStride
	ELSE
		v2_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, q1, q3, q5, q7, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q1},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@64], nDstStride2	
		vst1.8          {q5},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q7},  [pTmpDst2@64], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q2},  [pTmpDst2@64], nDstStride2
		vld1.16          {q4},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q6},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q1, q0
		vhadd.s16         q3, q2
		vhadd.s16         q5, q4
		vhadd.s16         q7, q6
		vqrshrun.s16    d0, q1,  #6
		vqrshrun.s16    d1, q3,  #6
		vqrshrun.s16    d2, q5,  #6
		vqrshrun.s16    d3, q7,  #6
        vst1.32          {d0[0]},  [pTmpDst@32], nDstStride
        vst1.32          {d1[0]},  [pTmpDst@32], nDstStride
		vst1.32          {d2[0]},  [pTmpDst@32], nDstStride
        vst1.32          {d3[0]},  [pTmpDst@32], nDstStride
	    ENDIF
	  ENDIF
    ENDIF	
		ble             %F1
		vmov            q10, q12
        vmov            q11, q13
        vmov		    q12, q14
		vmov            d26, d30
		b               %B2
1		
        mend

        macro    
		h265_qpel8_v3_neon $type
		vld1.64         {d20},  [pTmpSrc], nSrcStride
        vld1.64         {d21},  [pTmpSrc], nSrcStride
		vld1.64         {d22},  [pTmpSrc], nSrcStride
		vld1.64         {d23},  [pTmpSrc], nSrcStride
		vld1.64         {d24},  [pTmpSrc], nSrcStride
		vld1.64         {d25},  [pTmpSrc], nSrcStride
2		vld1.64         {d26},  [pTmpSrc], nSrcStride
		vld1.64         {d27},  [pTmpSrc], nSrcStride
		vld1.64         {d28},  [pTmpSrc], nSrcStride
		vld1.64         {d29},  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
		v3_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d0, d1, d2, d3, |
		vst1.8          {d0},  [pTmpDst@64], nDstStride
        vst1.8          {d1},  [pTmpDst@64], nDstStride
		vst1.8          {d2},  [pTmpDst@64], nDstStride
        vst1.8          {d3},  [pTmpDst@64], nDstStride
	ELSE
	    v3_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, q1, q3, q5, q7, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q1},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@128], nDstStride2	
		vst1.8          {q5},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q7},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q2},  [pTmpDst2@128], nDstStride2
		vld1.16          {q4},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q6},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q1, q0
		vhadd.s16         q3, q2
		vhadd.s16         q5, q4
		vhadd.s16         q7, q6
		vqrshrun.s16    d0, q1,  #6
		vqrshrun.s16    d1, q3,  #6
		vqrshrun.s16    d2, q5,  #6
		vqrshrun.s16    d3, q7,  #6
        vst1.8          {d0},  [pTmpDst@64], nDstStride
        vst1.8          {d1},  [pTmpDst@64], nDstStride
		vst1.8          {d2},   [pTmpDst@64], nDstStride
        vst1.8          {d3},   [pTmpDst@64], nDstStride		
	    ENDIF
	  ENDIF	   	
    ENDIF	
		ble             %F1
		vmov            q10, q12
        vmov            q11, q13
        vmov		    q12, q14
		b               %B2
1
        mend		

        macro    
		h265_qpel4_v3_neon $type
		vld1.64         {d20},  [pTmpSrc], nSrcStride
        vld1.64         {d21},  [pTmpSrc], nSrcStride
		vld1.64         {d22},  [pTmpSrc], nSrcStride
		vld1.64         {d23},  [pTmpSrc], nSrcStride
		vld1.64         {d24},  [pTmpSrc], nSrcStride
		vld1.64         {d25},  [pTmpSrc], nSrcStride
2		vld1.64         {d26},  [pTmpSrc], nSrcStride
		vld1.64         {d27},  [pTmpSrc], nSrcStride
		vld1.64         {d28},  [pTmpSrc], nSrcStride
		vld1.64         {d29},  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
	IF "$type"="put"	
		v3_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d0, d1, d2, d3, |
		vst1.32          {d0[0]},  [pTmpDst@32], nDstStride
        vst1.32          {d1[0]},  [pTmpDst@32], nDstStride
		vst1.32         {d2[0]},  [pTmpDst@32], nDstStride
        vst1.32          {d3[0]},  [pTmpDst@32], nDstStride
	ELSE
	    v3_8            d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, q1, q3, q5, q7, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q1},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@64], nDstStride2	
		vst1.8          {q5},  [pTmpDst2@64], nDstStride2	
        vst1.8          {q7},  [pTmpDst2@64], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q2},  [pTmpDst2@64], nDstStride2
		vld1.16          {q4},  [pTmpDst2@64], nDstStride2	
        vld1.16          {q6},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q1, q0
		vhadd.s16         q3, q2
		vhadd.s16         q5, q4
		vhadd.s16         q7, q6
		vqrshrun.s16    d0, q1,  #6
		vqrshrun.s16    d1, q3,  #6
		vqrshrun.s16    d2, q5,  #6
		vqrshrun.s16    d3, q7,  #6
        vst1.32          {d0[0]},  [pTmpDst@32], nDstStride
        vst1.32          {d1[0]},  [pTmpDst@32], nDstStride
		vst1.32         {d2[0]},  [pTmpDst@32], nDstStride
        vst1.32          {d3[0]},  [pTmpDst@32], nDstStride	
	    ENDIF
	  ENDIF	   		
    ENDIF	
		ble             %F1
		vmov            q10, q12
        vmov            q11, q13
        vmov		    q12, q14
		b               %B2
1
        mend	
		
        macro
        h265_qpel8_h1v1_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride		
			
		h1_8_2          d16, d17, d18, d19,  q8, q9
		h1_8_2          d20, d21, d22, d23,  q10, q11
		h1_8_2          d24, d25, d26, d27,  q12, q13
		
2		vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #2
        h1_8_2          d28, d29, d30, d31,  q14, q15					
	IF  "$type"="put"	
	    v1_8_2          v8, d0, d1, d2, d3, |
		vst1.8          {d0},  [pTmpDst@64], nDstStride	
        vst1.8          {d1},  [pTmpDst@64], nDstStride	
	ELSE
        v1_8_2          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q6},  [pTmpDst2@128], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride			
	    ENDIF
	  ENDIF
	ENDIF	
       
        ble             %F1		
		b               %B2
1		
        mend
		
		 macro
        h265_qpel4_h1v1_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride		
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
       
		h1_8_2          d16, d17, d18, d19,  q8, q9
		vmov            d17,  d18
		h1_8_2          d20, d21, d22, d23,  q9, q10
		vmov            d19,  d20
		h1_8_2          d24, d25, d26, d27,  q10, q11
		vmov            d21,  d22 
		
2		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride	
		h1_8_2          d24, d25, d26, d27,  q11, q12
		vmov            d23, d24		
        vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
        h1_8_2          d28, d29, d30, d31,  q12, q13
        vmov            d25, d26
    IF "$type"="put"		
		v1_4_4          v8, d0, d1, d2, d3, |
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride	
	ELSE
        v1_4_4          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d8},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d9},  [pTmpDst2@64], nDstStride2	
		vst1.8          {d12},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d13},  [pTmpDst2@64], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d1},  [pTmpDst2@64], nDstStride2
		vld1.16          {d2},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d3},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride			
	    ENDIF
	  ENDIF
    ENDIF	
        ble             %F1		
		b               %B2
1		
        mend
		
		macro
        h265_qpel8_h1v2_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
		vld1.64         q14,  [pTmpSrc], nSrcStride
		
			
		h1_8_2          d16, d17, d18, d19,  q8, q9
		h1_8_2          d20, d21, d22, d23,  q10, q11
		h1_8_2          d24, d25, d26, d27,  q12, q13
		h1_8_1          d28, d29, q14
		
2	    vld1.64         q15,  [pTmpSrc], nSrcStride
        h1_8_1          d30, d31, q15   				
		subs            nTmpHeight,  nTmpHeight,  #1	
    IF "$type"="put"		
		v2_8_2          v8, d0, d1, |
        vst1.8          {d0},  [pTmpDst@64], nDstStride		
    ELSE
        v2_8_2          v8, d8, d9, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2		
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
		vhadd.s16         q0, q4
		vqrshrun.s16    d0, q0,  #6
        vst1.8           {d0},  [pTmpDst@64], nDstStride				
	    ENDIF
	  ENDIF		    
    ENDIF	
		ble             %F1		
		b               %B2				
1		
        mend
		
		macro
        h265_qpel4_h1v2_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
		vld1.64         q14,  [pTmpSrc], nSrcStride
			
		h1_8_2          d16, d17, d18, d19,  q8, q9
		vmov            d17,  d18
		h1_8_2          d20, d21, d22, d23,  q9, q10
		vmov            d19,  d20
		h1_8_2          d24, d25, d26, d27,  q10, q11
		vmov            d21,  d22 
		h1_8_1          d28, d29, q14
		vmov            d22,  d28
		
2	    vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		h1_8_2          d28, d29, d30, d31,  q14, q15
        vmov            d23, d28
        vmov            d24, d30 	
        vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		h1_8_2          d28, d29, d30, d31,  q14, q15
        vmov            d25, d28
        vmov            d26, d30		
		subs            nTmpHeight,  nTmpHeight,  #4
    IF "$type"="put"		
		v2_4_4          v8, d0, d1, d2, d3, |
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32         {d0[1]},  [pTmpDst@32], nDstStride	
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[1]},  [pTmpDst@32], nDstStride	
    ELSE
        v2_4_4          v8, d8, d9, d10, d11, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d8},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d9},  [pTmpDst2@64], nDstStride2	
		vst1.8          {d10},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d11},  [pTmpDst2@64], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d1},  [pTmpDst2@64], nDstStride2
		vld1.16          {d2},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d3},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q5
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride			
	    ENDIF
	  ENDIF	
    ENDIF	
		ble             %F1		
		b               %B2				
1		
        mend
		
		macro
        h265_qpel8_h1v3_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
		
			
		h1_8_2          d16, d17, d18, d19,  q8, q9
		h1_8_2          d20, d21, d22, d23,  q10, q11
		h1_8_2          d24, d25, d26, d27,  q12, q13
		
2		vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #2
		h1_8_2          d28, d29, d30, d31,  q14, q15
	IF "$type"="put"			
		v3_8_2          v8, d0, d1, d2, d3, |
        vst1.8          {d0},  [pTmpDst@64], nDstStride	
        vst1.8          {d1},  [pTmpDst@64], nDstStride	
    ELSE
        v3_8_2          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q6},  [pTmpDst2@128], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride			
	    ENDIF
	  ENDIF	
    ENDIF	

        ble             %F1		
		
		b               %B2
1		
        mend
		
		macro
        h265_qpel4_h1v3_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride		
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
       
		h1_8_2          d16, d17, d18, d19,  q8, q9
		vmov            d17,  d18
		h1_8_2          d20, d21, d22, d23,  q9, q10
		vmov            d19,  d20
		h1_8_2          d24, d25, d26, d27,  q10, q11
		vmov            d21,  d22 
		
2		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride	
		h1_8_2          d24, d25, d26, d27,  q11, q12
		vmov            d23, d24		
        vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
        h1_8_2          d28, d29, d30, d31,  q12, q13
        vmov            d25, d26
    IF "$type"="put"		
		v3_4_4          v8, d0, d1, d2, d3, |
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride	
	ELSE
       v3_4_4          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d8},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d9},  [pTmpDst2@64], nDstStride2	
		vst1.8          {d12},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d13},  [pTmpDst2@64], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d1},  [pTmpDst2@64], nDstStride2
		vld1.16          {d2},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d3},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride			
	    ENDIF
	  ENDIF	
	ENDIF
        ble             %F1		
		b               %B2
1		
        mend
		
        macro  
		h265_qpel8_h2v1_neon $type
		vld1.64         {q8},   [pTmpSrc], nSrcStride
        vld1.64         {q9},   [pTmpSrc], nSrcStride
		vld1.64         {q10},  [pTmpSrc], nSrcStride
		vld1.64         {q11},  [pTmpSrc], nSrcStride
		vld1.64         {q12},  [pTmpSrc], nSrcStride
		vld1.64         {q13},  [pTmpSrc], nSrcStride
		
			
		h2_8_2          d16, d17, d18, d19,  q8, q9
		h2_8_2          d20, d21, d22, d23,  q10, q11
		h2_8_2          d24, d25, d26, d27,  q12, q13
		
2		vld1.64         {q14},  [pTmpSrc], nSrcStride
		vld1.64         {q15},  [pTmpSrc], nSrcStride	
        subs            nTmpHeight,  nTmpHeight,  #2		
		h2_8_2          d28, d29, d30, d31,  q14, q15
    IF "$type"="put"		
		v1_8_2          v8, d0, d1, d2, d3,  |
        vst1.8          {d0},  [pTmpDst@64], nDstStride	
        vst1.8          {d1},  [pTmpDst@64], nDstStride					
	ELSE
        v1_8_2          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q6},  [pTmpDst2@128], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride			
	    ENDIF
	  ENDIF		
    ENDIF	
		ble             %F1				
		b               %B2
1		
        mend
		
		macro  
		h265_qpel4_h2v1_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride		
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
       
		h2_8_2          d16, d17, d18, d19,  q8, q9
		vmov            d17,  d18
		h2_8_2          d20, d21, d22, d23,  q9, q10
		vmov            d19,  d20
		h2_8_2          d24, d25, d26, d27,  q10, q11
		vmov            d21,  d22 
		
2		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride	
		h2_8_2          d24, d25, d26, d27,  q11, q12
		vmov            d23, d24		
        vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
        h2_8_2          d28, d29, d30, d31,  q12, q13
        vmov            d25, d26
    IF "$type"="put"		
		v1_4_4          v8, d0, d1, d2, d3, |
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride	
	ELSE
       v1_4_4          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d8},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d9},  [pTmpDst2@64], nDstStride2	
		vst1.8          {d12},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d13},  [pTmpDst2@64], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d1},  [pTmpDst2@64], nDstStride2
		vld1.16          {d2},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d3},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride			
	    ENDIF
	  ENDIF	
    ENDIF	
        ble             %F1		
		b               %B2
1		
        mend

        macro 
		h265_qpel8_h2v2_neon $type
		vld1.64         {q8},   [pTmpSrc], nSrcStride
        vld1.64         {q9},   [pTmpSrc], nSrcStride
		vld1.64         {q10},  [pTmpSrc], nSrcStride
		vld1.64         {q11},  [pTmpSrc], nSrcStride
		vld1.64         {q12},  [pTmpSrc], nSrcStride
		vld1.64         {q13},  [pTmpSrc], nSrcStride
		vld1.64         {q14},  [pTmpSrc], nSrcStride
			
		h2_8_2          d16, d17, d18, d19,  q8, q9
		h2_8_2          d20, d21, d22, d23,  q10, q11
		h2_8_2          d24, d25, d26, d27,  q12, q13
		h2_8_1          d28, d29, q14

2	    vld1.64         {q15},  [pTmpSrc], nSrcStride
        h2_8_1          d30, d31, q15   				
		subs            nTmpHeight,  nTmpHeight,  #1
    IF "$type"="put"		
		v2_8_2          v8, d0, d1, |
        vst1.8          {d0},  [pTmpDst@64], nDstStride	
    ELSE
        v2_8_2          v8, d8, d9, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2		
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
		vhadd.s16         q0, q4
		vqrshrun.s16    d0, q0,  #6
		
        vst1.8           {d0},  [pTmpDst@64], nDstStride				
	    ENDIF
	  ENDIF		    	
    ENDIF	
		ble             %F1		
		b               %B2				
1				
        mend	
		
		macro 
		h265_qpel4_h2v2_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
		vld1.64         q14,  [pTmpSrc], nSrcStride
			
		h2_8_2          d16, d17, d18, d19,  q8, q9
		vmov            d17,  d18
		h2_8_2          d20, d21, d22, d23,  q9, q10
		vmov            d19,  d20
		h2_8_2          d24, d25, d26, d27,  q10, q11
		vmov            d21,  d22 
		h2_8_1          d28, d29, q14
		vmov            d22,  d28
		
2	    vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		h2_8_2          d28, d29, d30, d31,  q14, q15
        vmov            d23, d28
        vmov            d24, d30 	
        vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		h2_8_2          d28, d29, d30, d31,  q14, q15
        vmov            d25, d28
        vmov            d26, d30		
		subs            nTmpHeight,  nTmpHeight,  #4
    IF "$type"="put"		
		v2_4_4          v8, d0, d1, d2, d3, |
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32         {d0[1]},  [pTmpDst@32], nDstStride	
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[1]},  [pTmpDst@32], nDstStride
    ELSE
        v2_4_4          v8, d8, d9, d10, d11, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d8},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d9},  [pTmpDst2@64], nDstStride2	
		vst1.8          {d10},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d11},  [pTmpDst2@64], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d1},  [pTmpDst2@64], nDstStride2
		vld1.16          {d2},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d3},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q5
		vqrshrun.s16   d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride			
	    ENDIF
	  ENDIF		
    ENDIF	
		ble             %F1		
		b               %B2				
1		
        mend	
		
		macro
		h265_qpel8_h2v3_neon $type
		vld1.64         {q8},   [pTmpSrc], nSrcStride
        vld1.64         {q9},   [pTmpSrc], nSrcStride
		vld1.64         {q10},  [pTmpSrc], nSrcStride
		vld1.64         {q11},  [pTmpSrc], nSrcStride
		vld1.64         {q12},  [pTmpSrc], nSrcStride
		vld1.64         {q13},  [pTmpSrc], nSrcStride
		
			
		h2_8_2          d16, d17, d18, d19,  q8, q9
		h2_8_2          d20, d21, d22, d23,  q10, q11
		h2_8_2          d24, d25, d26, d27,  q12, q13
		
2       vld1.64         {q14},  [pTmpSrc], nSrcStride
		vld1.64         {q15},  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #2
		h2_8_2          d28, d29, d30, d31,  q14, q15
    IF "$type"="put"		
		v3_8_2          v8, d0, d1, d2, d3, |
        vst1.8          {d0},  [pTmpDst@64], nDstStride	
        vst1.8          {d1},  [pTmpDst@64], nDstStride
	ELSE
        v3_8_2          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q6},  [pTmpDst2@128], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride			
	    ENDIF
	  ENDIF		
	ENDIF
        ble             %F1	
		
		b               %B2
1		
        mend	
		
		macro
		h265_qpel4_h2v3_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride		
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
       
		h2_8_2          d16, d17, d18, d19,  q8, q9
		vmov            d17,  d18
		h2_8_2          d20, d21, d22, d23,  q9, q10
		vmov            d19,  d20
		h2_8_2          d24, d25, d26, d27,  q10, q11
		vmov            d21,  d22 
		
2		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride	
		h2_8_2          d24, d25, d26, d27,  q11, q12
		vmov            d23, d24		
        vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
        h2_8_2          d28, d29, d30, d31,  q12, q13
        vmov            d25, d26	
    IF "$type"="put"		
		v3_4_4          v8, d0, d1, d2, d3, |
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride	
	ELSE
       v3_4_4          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d8},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d9},  [pTmpDst2@64], nDstStride2	
		vst1.8          {d12},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d13},  [pTmpDst2@64], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d1},  [pTmpDst2@64], nDstStride2
		vld1.16          {d2},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d3},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6

        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride			
	    ENDIF
	  ENDIF	
	ENDIF
        ble             %F1		
		b               %B2
1		
        mend	

		macro 
		h265_qpel8_h3v1_neon $type
		vld1.64         {q8},   [pTmpSrc], nSrcStride
        vld1.64         {q9},   [pTmpSrc], nSrcStride
		vld1.64         {q10},  [pTmpSrc], nSrcStride
		vld1.64         {q11},  [pTmpSrc], nSrcStride
		vld1.64         {q12},  [pTmpSrc], nSrcStride
		vld1.64         {q13},  [pTmpSrc], nSrcStride
		
			
		h3_8_2          d16, d17, d18, d19,  q8, q9
		h3_8_2          d20, d21, d22, d23,  q10, q11
		h3_8_2          d24, d25, d26, d27,  q12, q13
		
2 		vld1.64         {q14},  [pTmpSrc], nSrcStride
		vld1.64         {q15},  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #2
		h3_8_2          d28, d29, d30, d31,  q14, q15
    IF "$type"="put"		
		v1_8_2          v8, d0, d1, d2, d3, |
        vst1.8          {d0},  [pTmpDst@64], nDstStride	
        vst1.8          {d1},  [pTmpDst@64], nDstStride	
    ELSE
        v1_8_2          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q6},  [pTmpDst2@128], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride			
	    ENDIF
	  ENDIF		
    ENDIF	
		ble             %F1		
		b               %B2
1		
        mend
		
		macro 
		h265_qpel4_h3v1_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride		
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
       
		h3_8_2          d16, d17, d18, d19,  q8, q9
		vmov            d17,  d18
		h3_8_2          d20, d21, d22, d23,  q9, q10
		vmov            d19,  d20
		h3_8_2          d24, d25, d26, d27,  q10, q11
		vmov            d21,  d22 
		
2		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride	
		h3_8_2          d24, d25, d26, d27,  q11, q12
		vmov            d23, d24		
        vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
        h3_8_2          d28, d29, d30, d31,  q12, q13
        vmov            d25, d26	
    IF "$type"="put"		
		v1_4_4          v8, d0, d1, d2, d3, |
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride	
	ELSE
       v1_4_4          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d8},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d9},  [pTmpDst2@64], nDstStride2	
		vst1.8          {d12},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d13},  [pTmpDst2@64], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d1},  [pTmpDst2@64], nDstStride2
		vld1.16          {d2},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d3},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6

        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride			
	    ENDIF
	  ENDIF	
	ENDIF
        ble             %F1		
		b               %B2
1		
        mend
		

        macro  
        h265_qpel8_h3v2_neon $type
		vld1.64         {q8},   [pTmpSrc], nSrcStride
        vld1.64         {q9},   [pTmpSrc], nSrcStride
		vld1.64         {q10},  [pTmpSrc], nSrcStride
		vld1.64         {q11},  [pTmpSrc], nSrcStride
		vld1.64         {q12},  [pTmpSrc], nSrcStride
		vld1.64         {q13},  [pTmpSrc], nSrcStride
		vld1.64         {q14},  [pTmpSrc], nSrcStride
		
		h3_8_2          d16, d17, d18, d19,  q8, q9
		h3_8_2          d20, d21, d22, d23,  q10, q11
		h3_8_2          d24, d25, d26, d27,  q12, q13
		h3_8_1          d28, d29, q14	 

2	    vld1.64         {q15},  [pTmpSrc], nSrcStride
        h3_8_1          d30, d31, q15   				
		subs            nTmpHeight,  nTmpHeight,  #1
    IF "$type"="put"		
		v2_8_2          v8, d0, d1, |
        vst1.8          {d0},  [pTmpDst@64], nDstStride		
    ELSE
        v2_8_2          v8, d8, d9, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2		
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
		vhadd.s16         q0, q4
		vqrshrun.s16     d0, q0,  #6
		
        vst1.8           {d0},  [pTmpDst@64], nDstStride				
	    ENDIF
	  ENDIF		    	
    ENDIF	
		ble             %F1		
		b               %B2				
1		   		
        mend		
		
		macro  
        h265_qpel4_h3v2_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
		vld1.64         q14,  [pTmpSrc], nSrcStride
			
		h3_8_2          d16, d17, d18, d19,  q8, q9
		vmov            d17,  d18
		h3_8_2          d20, d21, d22, d23,  q9, q10
		vmov            d19,  d20
		h3_8_2          d24, d25, d26, d27,  q10, q11
		vmov            d21,  d22 
		h3_8_1          d28, d29, q14
		vmov            d22,  d28
		
2	    vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		h3_8_2          d28, d29, d30, d31,  q14, q15
        vmov            d23, d28
        vmov            d24, d30 	
        vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		h3_8_2          d28, d29, d30, d31,  q14, q15
        vmov            d25, d28
        vmov            d26, d30		
		subs            nTmpHeight,  nTmpHeight,  #4
    IF "$type"="put"		
		v2_4_4          v8, d0, d1, d2, d3, |
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32         {d0[1]},  [pTmpDst@32], nDstStride	
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[1]},  [pTmpDst@32], nDstStride	
    ELSE
        v2_4_4          v8, d8, d9, d10, d11, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d8},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d9},  [pTmpDst2@64], nDstStride2	
		vst1.8          {d10},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d11},  [pTmpDst2@64], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d1},  [pTmpDst2@64], nDstStride2
		vld1.16          {d2},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d3},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q5
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride			
	    ENDIF
	  ENDIF		
    ENDIF	
		ble             %F1		
		b               %B2				
1		
        mend		

        macro  
		h265_qpel8_h3v3_neon $type
		vld1.64         {q8},   [pTmpSrc], nSrcStride
        vld1.64         {q9},   [pTmpSrc], nSrcStride
		vld1.64         {q10},  [pTmpSrc], nSrcStride
		vld1.64         {q11},  [pTmpSrc], nSrcStride
		vld1.64         {q12},  [pTmpSrc], nSrcStride
		vld1.64         {q13},  [pTmpSrc], nSrcStride
		
			
		h3_8_2          d16, d17, d18, d19,  q8, q9
		h3_8_2          d20, d21, d22, d23,  q10, q11
		h3_8_2          d24, d25, d26, d27,  q12, q13
		
2		vld1.64         {q14},  [pTmpSrc], nSrcStride
		vld1.64         {q15},  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #2
		h3_8_2          d28, d29, d30, d31,  q14, q15	
    IF "$type"="put"		
		v3_8_2          v8, d0, d1, d2, d3, |
        vst1.8          {d0},  [pTmpDst@64], nDstStride	
        vst1.8          {d1},  [pTmpDst@64], nDstStride
	ELSE
        v3_8_2          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q6},  [pTmpDst2@128], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6

        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride			
	    ENDIF
	  ENDIF		
    ENDIF	
        ble             %F1			
		
		b               %B2
1		
        mend	

        macro  
		h265_qpel4_h3v3_neon $type
		vld1.64         q8,   [pTmpSrc], nSrcStride		
        vld1.64         q9,   [pTmpSrc], nSrcStride
		vld1.64         q10,  [pTmpSrc], nSrcStride
		vld1.64         q11,  [pTmpSrc], nSrcStride
		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride
       
		h3_8_2          d16, d17, d18, d19,  q8, q9
		vmov            d17,  d18
		h3_8_2          d20, d21, d22, d23,  q9, q10
		vmov            d19,  d20
		h3_8_2          d24, d25, d26, d27,  q10, q11
		vmov            d21,  d22 
		
2		vld1.64         q12,  [pTmpSrc], nSrcStride
		vld1.64         q13,  [pTmpSrc], nSrcStride	
		h3_8_2          d24, d25, d26, d27,  q11, q12
		vmov            d23, d24		
        vld1.64         q14,  [pTmpSrc], nSrcStride
		vld1.64         q15,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
        h3_8_2          d28, d29, d30, d31,  q12, q13
        vmov            d25, d26	
    IF "$type"="put"		
		v3_4_4          v8, d0, d1, d2, d3, |
        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride	
	ELSE
        v3_4_4          v8, d8, d9, d12, d13, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d8},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d9},  [pTmpDst2@64], nDstStride2	
		vst1.8          {d12},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d13},  [pTmpDst2@64], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d0},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d1},  [pTmpDst2@64], nDstStride2
		vld1.16          {d2},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d3},  [pTmpDst2@64], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q6
		vqrshrun.s16       d0, q0,  #6
		vqrshrun.s16       d1, q1,  #6

        vst1.32         {d0[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d0[1]},  [pTmpDst@32], nDstStride
        vst1.32         {d1[0]},  [pTmpDst@32], nDstStride	
		vst1.32         {d1[1]},  [pTmpDst@32], nDstStride			
	    ENDIF
	  ENDIF	
    ENDIF	
        ble             %F1		
		b               %B2
1		
        mend	

        macro
        h265_eqpel8_h1v0_neon $type
2		vld1.64         q0,  [pTmpSrc], nSrcStride
		vld1.64         q1,  [pTmpSrc], nSrcStride
		vld1.64         q4,  [pTmpSrc], nSrcStride	
        vld1.64         q5,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4        		
	IF  "$type"="put"	
	    h1_8_4          d0, d1, d2, d3,  d8, d9, d10, d11, q11, q12, q13, q14, {TRUE}
		vst1.8          {d0},  [pTmpDst@64], nDstStride	
        vst1.8          {d1},  [pTmpDst@64], nDstStride	
		blt               %F1
		vst1.8          {d2},  [pTmpDst@64], nDstStride	
        vst1.8          {d3},  [pTmpDst@64], nDstStride	
	ELSE
        h1_8_4          d0, d1, d2, d3,  d8, d9, d10, d11, q11, q12, q13, q14, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {q11},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q12},  [pTmpDst2@128], nDstStride2	
		blt               %F1
		vst1.8          {q13},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q14},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q0},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q1},  [pTmpDst2@128], nDstStride2
		vld1.16          {q4},  [pTmpDst2@128], nDstStride2
		vld1.16          {q5},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q11
		vhadd.s16         q1, q12
		vhadd.s16         q4, q13
		vhadd.s16         q5, q14
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vqrshrun.s16    d2, q4,  #6
		vqrshrun.s16    d3, q5,  #6
        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride	
		blt               %F1
        vst1.8           {d2},  [pTmpDst@64], nDstStride	
        vst1.8           {d3},  [pTmpDst@64], nDstStride		
	    ENDIF
	  ENDIF
	ENDIF	
       
        ble             %F1		
		b               %B2
1		
        mend	
		
		macro
        h265_eqpel4_h1v0_neon $type
2		vld1.64         q0,  [pTmpSrc], nSrcStride
		vld1.64         q1,  [pTmpSrc], nSrcStride
		vld1.64         q4,  [pTmpSrc], nSrcStride	
        vld1.64         q5,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4        		
	IF  "$type"="put"	
	    h1_8_4          d0, d1, d2, d3,  d8, d9, d10, d11, q11, q12, q13, q14, {TRUE}
		vst1.32          {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32          {d1[0]},  [pTmpDst@32], nDstStride	
		blt               %F1
		vst1.32          {d2[0]},  [pTmpDst@32], nDstStride	
        vst1.32          {d3[0]},  [pTmpDst@32], nDstStride	
	ELSE
        h1_8_4          d0, d1, d2, d3,  d8, d9, d10, d11, q11, q12, q13, q14, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.8          {d22},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d24},  [pTmpDst2@64], nDstStride2	
		blt               %F1
		vst1.8          {d26},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d28},  [pTmpDst2@64], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d0},   [pTmpDst2@64], nDstStride2	
        vld1.16          {d2},   [pTmpDst2@64], nDstStride2
		vld1.16          {d8},   [pTmpDst2@64], nDstStride2
		vld1.16          {d10},  [pTmpDst2@64], nDstStride2
		vhadd.s16         d0,  d22
		vhadd.s16         d2,  d24
		vhadd.s16         d8,  d26
		vhadd.s16         d10, d28
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vqrshrun.s16    d2, q4,  #6
		vqrshrun.s16    d3, q5,  #6
        vst1.32           {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d1[0]},  [pTmpDst@32], nDstStride
        blt               %F1		
        vst1.32           {d2[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d3[0]},  [pTmpDst@32], nDstStride		
	    ENDIF
	  ENDIF
	ENDIF	
       
        ble             %F1		
		b               %B2
1		
        mend	
		
		
		macro
        h265_eqpel2_h1v0_neon $type
2		vld1.64         q0,  [pTmpSrc], nSrcStride
		vld1.64         q1,  [pTmpSrc], nSrcStride
		vld1.64         q4,  [pTmpSrc], nSrcStride	
        vld1.64         q5,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4        		
	IF  "$type"="put"	
	    h1_8_4          d0, d1, d2, d3,  d8, d9, d10, d11, q11, q12, q13, q14, {TRUE}
		vst1.16          {d0[0]},  [pTmpDst@16], nDstStride	
        vst1.16          {d1[0]},  [pTmpDst@16], nDstStride	
		blt             %F1
		vst1.16          {d2[0]},  [pTmpDst@16], nDstStride	
        vst1.16          {d3[0]},  [pTmpDst@16], nDstStride	
	ELSE
        h1_8_4          d0, d1, d2, d3,  d8, d9, d10, d11, q11, q12, q13, q14, {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.32          {d22[0]},  [pTmpDst2@32], nDstStride2	
        vst1.32          {d24[0]},  [pTmpDst2@32], nDstStride2	
		blt             %F1
		vst1.32          {d26[0]},  [pTmpDst2@32], nDstStride2	
        vst1.32          {d28[0]},  [pTmpDst2@32], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.32          {d0[0]},   [pTmpDst2@32], nDstStride2	
        vld1.32          {d2[0]},   [pTmpDst2@32], nDstStride2
		vld1.32          {d8[0]},   [pTmpDst2@32], nDstStride2
		vld1.32          {d10[0]},  [pTmpDst2@32], nDstStride2
		vhadd.s16         d0,  d22
		vhadd.s16         d2,  d24
		vhadd.s16         d8,  d26
		vhadd.s16         d10, d28
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6		
        vst1.16           {d0[0]},  [pTmpDst@16], nDstStride	
        vst1.16           {d1[0]},  [pTmpDst@16], nDstStride
        blt             %F1		
        vqrshrun.s16    d2, q4,  #6
		vqrshrun.s16    d3, q5,  #6		
        vst1.16           {d2[0]},  [pTmpDst@16], nDstStride	
        vst1.16           {d3[0]},  [pTmpDst@16], nDstStride		
	    ENDIF
	  ENDIF
	ENDIF	
       
        ble             %F1		
		b               %B2
1		
        mend	

        macro
        h265_eqpel8_h0v1_neon $type
		vld1.64         d16,  [pTmpSrc], nSrcStride
        vld1.64         d17,  [pTmpSrc], nSrcStride
		vld1.64         d18,  [pTmpSrc], nSrcStride
		
2		vld1.64         d19,  [pTmpSrc], nSrcStride
		vld1.64         d20,  [pTmpSrc], nSrcStride
		vld1.64         d21,  [pTmpSrc], nSrcStride	
        vld1.64         d22,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4       	
	IF  "$type"="put"	
	    v0_8_4          v8, d0, d1, d2, d3, {TRUE}	
		vst1.8          {d0},  [pTmpDst@64], nDstStride	
        vst1.8          {d1},  [pTmpDst@64], nDstStride	
		blt               %F1
		vst1.8          {d2},  [pTmpDst@64], nDstStride	
        vst1.8          {d3},  [pTmpDst@64], nDstStride	
	ELSE
        v0_8_4          v8, d0, d1, d2, d3, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q0},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q1},  [pTmpDst2@128], nDstStride2	
		blt               %F1
		vst1.8          {q2},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q3},  [pTmpDst2@128], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q4},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q5},  [pTmpDst2@128], nDstStride2
		vld1.16          {q14},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q15},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q4
		vhadd.s16         q1, q5
		vhadd.s16         q2, q14
		vhadd.s16         q3, q15
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6		
        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride
		blt               %F1
		vqrshrun.s16    d2, q2,  #6
		vqrshrun.s16    d3, q3,  #6
        vst1.8           {d2},  [pTmpDst@64], nDstStride	
        vst1.8           {d3},  [pTmpDst@64], nDstStride		
	    ENDIF
	  ENDIF
	ENDIF	
       
        ble             %F1		
		b               %B2
1		
        mend	

        macro
        h265_eqpel4_h0v1_neon $type
		vld1.64         d16,  [pTmpSrc], nSrcStride
        vld1.64         d17,  [pTmpSrc], nSrcStride
		vld1.64         d18,  [pTmpSrc], nSrcStride
		
2		vld1.64         d19,  [pTmpSrc], nSrcStride
		vld1.64         d20,  [pTmpSrc], nSrcStride
		vld1.64         d21,  [pTmpSrc], nSrcStride	
        vld1.64         d22,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4        		
	IF  "$type"="put"	
	    v0_8_4          v8, d0, d1, d2, d3, {TRUE}
		vst1.32          {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32          {d1[0]},  [pTmpDst@32], nDstStride	
		blt               %F1
		vst1.32          {d2[0]},  [pTmpDst@32], nDstStride	
        vst1.32          {d3[0]},  [pTmpDst@32], nDstStride	
	ELSE
        v0_8_4          v8, d0, d1, d2, d3, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d0},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d2},  [pTmpDst2@64], nDstStride2	
		blt               %F1
		vst1.8          {d4},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d6},  [pTmpDst2@64], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d8},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d9},  [pTmpDst2@64], nDstStride2
		vld1.16          {d10},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d11},  [pTmpDst2@64], nDstStride2
		vhadd.s16         d0, d8
		vhadd.s16         d2, d9
		vhadd.s16         d4, d10
		vhadd.s16         d6, d11
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6		
        vst1.32           {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d1[0]},  [pTmpDst@32], nDstStride
		blt               %F1
		vqrshrun.s16    d2, q2,  #6
		vqrshrun.s16    d3, q3,  #6
        vst1.32           {d2[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d3[0]},  [pTmpDst@32], nDstStride		
	    ENDIF
	  ENDIF
	ENDIF	
       
        ble             %F1		
		b               %B2
1		
        mend		
		
		 macro
        h265_eqpel2_h0v1_neon $type
		vld1.64         d16,  [pTmpSrc], nSrcStride
        vld1.64         d17,  [pTmpSrc], nSrcStride
		vld1.64         d18,  [pTmpSrc], nSrcStride
		
2		vld1.64         d19,  [pTmpSrc], nSrcStride
		vld1.64         d20,  [pTmpSrc], nSrcStride
		vld1.64         d21,  [pTmpSrc], nSrcStride	
        vld1.64         d22,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4       	
	IF  "$type"="put"
        v0_8_4          v8, d0, d1, d2, d3, {TRUE}		
		vst1.16          {d0[0]},  [pTmpDst@16], nDstStride	
        vst1.16          {d1[0]},  [pTmpDst@16], nDstStride	
		blt             %F1	
		vst1.16          {d2[0]},  [pTmpDst@16], nDstStride	
        vst1.16          {d3[0]},  [pTmpDst@16], nDstStride	
	ELSE
        v0_8_4          v8, d0, d1, d2, d3, {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.32          {d0[0]},  [pTmpDst2@32], nDstStride2	
        vst1.32          {d2[0]},  [pTmpDst2@32], nDstStride2	
		blt             %F1	
		vst1.32          {d4[0]},  [pTmpDst2@32], nDstStride2	
        vst1.32          {d6[0]},  [pTmpDst2@32], nDstStride2
	  ELSE
	    IF "$type"="avg"	
        vld1.32          {d8[0]},  [pTmpDst2@32], nDstStride2	
        vld1.32          {d9[0]},  [pTmpDst2@32], nDstStride2
		vld1.32          {d10[0]},  [pTmpDst2@32], nDstStride2	
        vld1.32          {d11[0]},  [pTmpDst2@32], nDstStride2
		vhadd.s16         d0, d8
		vhadd.s16         d2, d9
		vhadd.s16         d4, d10
		vhadd.s16         d6, d11
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vqrshrun.s16    d2, q2,  #6
		vqrshrun.s16    d3, q3,  #6
        vst1.16           {d0[0]},  [pTmpDst@16], nDstStride	
        vst1.16           {d1[0]},  [pTmpDst@16], nDstStride
		blt               %F1	
        vst1.16           {d2[0]},  [pTmpDst@16], nDstStride	
        vst1.16           {d3[0]},  [pTmpDst@16], nDstStride		
	    ENDIF
	  ENDIF
	ENDIF	
       
        ble             %F1		
		b               %B2
1		
        mend	

        macro
        h265_eqpel8_h1v1_neon $type
		vld1.64         q0,   [pTmpSrc], nSrcStride
        vld1.64         q1,   [pTmpSrc], nSrcStride
		vld1.64         q4,  [pTmpSrc], nSrcStride
						
		h1_8_3          d0, d1, d2, d3,  d8, d9, q8, q9, q10
		
2		vld1.64         q0,  [pTmpSrc], nSrcStride
		vld1.64         q1,  [pTmpSrc], nSrcStride
		vld1.64         q4,  [pTmpSrc], nSrcStride	
        vld1.64         q5,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
        h1_8_4          d0, d1, d2, d3,  d8, d9, d10, d11, q11, q12, q13, q14, |		
	IF  "$type"="put"	
	    v1_8_4          v8, d0, d1, d2, d3, d4, d5, d8, d9, |
		vst1.8          {d0},  [pTmpDst@64], nDstStride	
        vst1.8          {d1},  [pTmpDst@64], nDstStride	
		blt               %F1
		vst1.8          {d2},  [pTmpDst@64], nDstStride	
        vst1.8          {d3},  [pTmpDst@64], nDstStride	
	ELSE
        v1_8_4          v8, d0, d1, d2, d3, d4, d5, d8, d9,  {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {q0},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q1},  [pTmpDst2@128], nDstStride2	
		blt               %F1
		vst1.8          {q2},  [pTmpDst2@128], nDstStride2	
        vst1.8          {q4},  [pTmpDst2@128], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {q11},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q12},  [pTmpDst2@128], nDstStride2
		vhadd.s16         q0, q11
		vhadd.s16         q1, q12
		vld1.16          {q13},  [pTmpDst2@128], nDstStride2	
        vld1.16          {q14},  [pTmpDst2@128], nDstStride2
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vhadd.s16         q2, q13
		vhadd.s16         q4, q14
        vst1.8           {d0},  [pTmpDst@64], nDstStride	
        vst1.8           {d1},  [pTmpDst@64], nDstStride
		blt               %F1
        vqrshrun.s16    d4, q2,  #6
		vqrshrun.s16    d5, q4,  #6	
        vst1.8           {d4},  [pTmpDst@64], nDstStride	
        vst1.8           {d5},  [pTmpDst@64], nDstStride		
	    ENDIF
	  ENDIF
	ENDIF	
       
        ble             %F1		
		b               %B2
1		
        mend
		
		
		macro
        h265_eqpel4_h1v1_neon $type
		vld1.64         q0,   [pTmpSrc], nSrcStride
        vld1.64         q1,   [pTmpSrc], nSrcStride
		vld1.64         q4,  [pTmpSrc], nSrcStride
						
		h1_8_3          d0, d1, d2, d3,  d8, d9, q8, q9, q10
		
2		vld1.64         q0,  [pTmpSrc], nSrcStride
		vld1.64         q1,  [pTmpSrc], nSrcStride
		vld1.64         q4,  [pTmpSrc], nSrcStride	
        vld1.64         q5,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
        h1_8_4          d0, d1, d2, d3,  d8, d9, d10, d11, q11, q12, q13, q14, |		
	IF  "$type"="put"	
	    v1_8_4          v8, d0, d1, d2, d3, d4, d5, d8, d9, |
		vst1.32          {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32          {d1[0]},  [pTmpDst@32], nDstStride	
		blt               %F1
		vst1.32          {d2[0]},  [pTmpDst@32], nDstStride	
        vst1.32          {d3[0]},  [pTmpDst@32], nDstStride	
	ELSE
        v1_8_4          v8, d0, d1, d2, d3, d4, d5, d8, d9,  {FALSE}	
	  IF "$type"="avg_nornd"	
        vst1.8          {d0},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d2},  [pTmpDst2@64], nDstStride2
        blt               %F1		
		vst1.8          {d4},  [pTmpDst2@64], nDstStride2	
        vst1.8          {d8},  [pTmpDst2@64], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.16          {d10},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d11},  [pTmpDst2@64], nDstStride2
		vld1.16          {d30},  [pTmpDst2@64], nDstStride2	
        vld1.16          {d31},  [pTmpDst2@64], nDstStride2

		vhadd.s16         d0, d10
		vhadd.s16         d2, d11
		vhadd.s16         d4, d30
		vhadd.s16         d8, d31
       
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vst1.32           {d0[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d1[0]},  [pTmpDst@32], nDstStride
		blt               %F1
        vqrshrun.s16    d4, q2,  #6
		vqrshrun.s16    d5, q4,  #6	
        vst1.32           {d4[0]},  [pTmpDst@32], nDstStride	
        vst1.32           {d5[0]},  [pTmpDst@32], nDstStride		
	    ENDIF
	  ENDIF
	ENDIF	
       
        ble             %F1		
		b               %B2
1		
        mend
		
		macro
        h265_eqpel2_h1v1_neon $type
		vld1.64         q0,   [pTmpSrc], nSrcStride
        vld1.64         q1,   [pTmpSrc], nSrcStride
		vld1.64         q4,  [pTmpSrc], nSrcStride
						
		h1_8_3          d0, d1, d2, d3,  d8, d9, q8, q9, q10
		
2		vld1.64         q0,  [pTmpSrc], nSrcStride
		vld1.64         q1,  [pTmpSrc], nSrcStride
		vld1.64         q4,  [pTmpSrc], nSrcStride	
        vld1.64         q5,  [pTmpSrc], nSrcStride
		subs            nTmpHeight,  nTmpHeight,  #4
        h1_8_4          d0, d1, d2, d3,  d8, d9, d10, d11, q11, q12, q13, q14, |		
	IF  "$type"="put"	
	    v1_8_4          v8, d0, d1, d2, d3, d4, d5, d8, d9, |
		vst1.16          {d0[0]},  [pTmpDst@16], nDstStride	
        vst1.16          {d1[0]},  [pTmpDst@16], nDstStride	
		blt             %F1
		vst1.16          {d2[0]},  [pTmpDst@16], nDstStride	
        vst1.16          {d3[0]},  [pTmpDst@16], nDstStride	
	ELSE
        v1_8_4          v8, d0, d1, d2, d3, d4, d5, d8, d9,  {FALSE}
	  IF "$type"="avg_nornd"	
        vst1.32          {d0[0]},  [pTmpDst2@32], nDstStride2	
        vst1.32          {d2[0]},  [pTmpDst2@32], nDstStride2
        blt               %F1		
		vst1.32          {d4[0]},  [pTmpDst2@32], nDstStride2	
        vst1.32          {d8[0]},  [pTmpDst2@32], nDstStride2	
	  ELSE
	    IF "$type"="avg"	
        vld1.32          {d10[0]},  [pTmpDst2@32], nDstStride2	
        vld1.32          {d11[0]},  [pTmpDst2@32], nDstStride2
		vld1.32          {d30[0]},  [pTmpDst2@32], nDstStride2	
        vld1.32          {d31[0]},  [pTmpDst2@32], nDstStride2

		vhadd.s16         d0, d10
		vhadd.s16         d2, d11
		vhadd.s16         d4, d30
		vhadd.s16         d8, d31
       
		vqrshrun.s16    d0, q0,  #6
		vqrshrun.s16    d1, q1,  #6
		vst1.16           {d0[0]},  [pTmpDst@16], nDstStride	
        vst1.16           {d1[0]},  [pTmpDst@16], nDstStride
		blt               %F1
        vqrshrun.s16    d4, q2,  #6
		vqrshrun.s16    d5, q4,  #6	
        vst1.16           {d4[0]},  [pTmpDst@16], nDstStride	
        vst1.16           {d5[0]},  [pTmpDst@16], nDstStride
        ENDIF		
	   ENDIF   
	ENDIF	
       
        ble             %F1		
		b               %B2
1		
        mend
		
		macro
		x_3y_3
		     sub             pTmpSrc, pSrc,  nSrcStride,  lsl #1
		     sub             pTmpSrc,  pTmpSrc,  nSrcStride
			 sub             pTmpSrc,  pTmpSrc,  #3	
		mend
		
		macro
		x_2y_3
		     sub             pTmpSrc, pSrc,  nSrcStride,  lsl #1
		     sub             pTmpSrc,  pTmpSrc,  nSrcStride
			 sub             pTmpSrc,  pTmpSrc,  #2	
		mend
		
		macro
		x_3y_2
		     sub             pTmpSrc, pSrc,  nSrcStride,  lsl #1
			 sub             pTmpSrc,  pTmpSrc,  #3	
		mend
		
		macro
		x_2y_2
		     sub             pTmpSrc, pSrc,  nSrcStride,  lsl #1
			 sub             pTmpSrc,  pTmpSrc,  #2	
		mend
		
		macro
		x_0y_3
		     sub             pTmpSrc, pSrc,  nSrcStride,  lsl #1
		     sub             pTmpSrc,  pTmpSrc,  nSrcStride
		mend
		
		macro
		x_0y_2
		     sub             pTmpSrc, pSrc,  nSrcStride,  lsl #1
		mend
		
		macro
		x_3y_0
		      sub             pTmpSrc,  pSrc,  #3	
		mend
		
		macro
		x_2y_0
		     sub             pTmpSrc,  pSrc,  #2
		mend
		
		macro
		MC_InterLuma_PutPixels $type
			 push            {r4-r10, lr}
			 IF "$type"="put"
			 ldr             nWidth, [sp, #PIC_WIDTH] ;width
			 ldr             nHeight, [sp, #PIC_HEIGHT] ;height	
             ELSE
			 ldr             nWidth, [sp, #AVG_PIC_WIDTH] ;width
			 ldr             nHeight, [sp, #AVG_PIC_HEIGHT] ;height	
			 ldr             pTmpDst2,    [sp, #AVG_TMP_DST] ;width
			 ldr             nDstStride2, [sp, #AVG_TMP_STRIDE] ;width
             ENDIF

4            cmp             nWidth, #32
             blt             %F5
             ands            pTmpDst, pDst, #15
			 bne             %F5
			 
             mov             nTmpHeight,   nHeight  
             mov             pTmpDst, pDst
             mov             pTmpSrc, pSrc			 	              			 			 
             h265_qpel32_h0v0_neon $type
		  IF "$type"!="put"			 
			 mls             pTmpDst2, nDstStride2, nHeight, pTmpDst2
			 add             pTmpDst2, pTmpDst2, #64             
          ENDIF				 
			 add              pSrc, pSrc,  #32
			 add              pDst, pDst,  #32
			 subs            nWidth, nWidth,     #32
			 bgt              %B4  
			 b                %F8

5            cmp             nWidth, #16
             blt             %F6            
             ands            pTmpDst, pDst, #15
			 bne             %F6
             mov             nTmpHeight,   nHeight  
             mov             pTmpDst, pDst
             mov             pTmpSrc, pSrc			 	              			 			 
             h265_qpel16_h0v0_neon $type
		  IF "$type"!="put"			 
			 mls             pTmpDst2, nDstStride2, nHeight, pTmpDst2
			 add             pTmpDst2, pTmpDst2, #32             
          ENDIF				 
			 add              pSrc, pSrc,    #16
			 add              pDst, pDst,    #16
			 subs            nWidth, nWidth, #16
			 bgt              %B4  
			 b                %F8

6            cmp             nWidth, #8
             blt             %F7           
             ands            pTmpDst, pDst, #7
			 bne             %F7
             mov             nTmpHeight,   nHeight  
             mov             pTmpDst, pDst
             mov             pTmpSrc, pSrc			 	              			 			 
             h265_qpel8_h0v0_neon $type
		  IF "$type"!="put"			 
			 mls             pTmpDst2, nDstStride2, nHeight, pTmpDst2
			 add             pTmpDst2, pTmpDst2, #16             
          ENDIF				 
			 add              pSrc, pSrc,  #8
			 add              pDst, pDst,  #8
			 subs            nWidth, nWidth,     #8
			 bgt              %B4  
			 b                %F8
7            
             cmp             nWidth, #4
             blt             %F9           
             ands            pTmpDst, pDst, #3
			 bne             %F9
             mov             nTmpHeight,   nHeight  
             mov             pTmpDst, pDst
             mov             pTmpSrc, pSrc			 	              			 			 
             h265_qpel4_h0v0_neon $type
		  IF "$type"!="put"			 
			 mls             pTmpDst2, nDstStride2, nHeight, pTmpDst2
			 add             pTmpDst2, pTmpDst2, #8             
          ENDIF				 
			 add              pSrc, pSrc,  #4
			 add              pDst, pDst,  #4
			 subs            nWidth, nWidth,  #4
			 bgt              %B4  
			 b                %F8	
9           
             mov             nTmpHeight,   nHeight  
             mov             pTmpDst, pDst
             mov             pTmpSrc, pSrc			 	              			 			 
             h265_qpel2_h0v0_neon $type
		  IF "$type"!="put"			 
			 mls             pTmpDst2, nDstStride2, nHeight, pTmpDst2
			 add             pTmpDst2, pTmpDst2, #4             
          ENDIF				 
			 add              pSrc, pSrc,  #2
			 add              pDst, pDst,  #2
			 subs            nWidth, nWidth,  #2
			 bgt              %B4  			 
8            pop             {r4-r10, pc}	
		mend
          
		macro
		MC_InterLuma_HxVx $type, $name, $src_pos,  $tap
   		     push            {r4-r10, lr}
			 $tap            r6, r7
			 IF "$type"="put"
			 ldr             nWidth, [sp, #PIC_WIDTH] ;width
			 ldr             nHeight, [sp, #PIC_HEIGHT] ;height	
             ELSE
			 ldr             nWidth, [sp, #AVG_PIC_WIDTH] ;width
			 ldr             nHeight, [sp, #AVG_PIC_HEIGHT] ;height	
			 ldr             pTmpDst2,    [sp, #AVG_TMP_DST] ;width
			 ldr             nDstStride2, [sp, #AVG_TMP_STRIDE] ;width
             ENDIF			 
			 ands            pTmpDst, pDst, #7
			 bne             %F8
5            mov             nTmpHeight,   nHeight  
             mov             pTmpDst, pDst  
             $src_pos			 	 
             subs            nWidth, nWidth,     #4
             ble             %F6			 
             h265_qpel8_$name._neon $type
		  IF "$type"!="put"			 
			 mls             pTmpDst2, nDstStride2, nHeight, pTmpDst2
			 add             pTmpDst2, pTmpDst2, #16             
          ENDIF				 			 
			 subs             nWidth, nWidth,     #4
			 add              pSrc, pSrc,  #8
			 add              pDst, pDst,  #8
			 bgt              %B5  
			 b                %F7
8            
             mov             nTmpHeight,   nHeight  
             mov             pTmpDst, pDst   		 
             $src_pos 
             sub             nWidth, nWidth,     #4             			 
6			 
             h265_qpel4_$name._neon $type
		  IF "$type"!="put"			 
			 mls             pTmpDst2, nDstStride2, nHeight, pTmpDst2
			 add             pTmpDst2, pTmpDst2, #8             
          ENDIF				 
			 add              pSrc, pSrc,  #4
			 add              pDst, pDst,  #4
			 cmp              nWidth, #0
			 bgt              %B5  
7            pop             {r4-r10, pc}			
		mend
		
		MACRO 
	    MC_InterLuma $type
		func VO_$type._MC_InterLuma_H0V0_neon, {TRUE}
			 MC_InterLuma_PutPixels $type	
        endfunc
		func VO_$type._MC_InterLuma_H1V0_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h1, x_3y_0, tap1_const 
		endfunc	
        func VO_$type._MC_InterLuma_H2V0_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h2, x_3y_0, tap2_const 
		endfunc	
        func VO_$type._MC_InterLuma_H3V0_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h3, x_2y_0, tap3_const 
		endfunc	
        func VO_$type._MC_InterLuma_H0V1_neon, {TRUE}
		    MC_InterLuma_HxVx $type, v1, x_0y_3, tap8_1_const 
		endfunc	
        func VO_$type._MC_InterLuma_H0V2_neon, {TRUE}
		    MC_InterLuma_HxVx $type, v2, x_0y_3, tap8_2_const 
		endfunc	
        func VO_$type._MC_InterLuma_H0V3_neon, {TRUE}
		    MC_InterLuma_HxVx $type, v3, x_0y_2, tap8_3_const 
		endfunc	
        func VO_$type._MC_InterLuma_H1V1_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h1v1, x_3y_3, tap123_const 
		endfunc	
        func VO_$type._MC_InterLuma_H1V2_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h1v2, x_3y_3, tap123_const 
		endfunc	
        func VO_$type._MC_InterLuma_H1V3_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h1v3, x_3y_2, tap123_const 
		endfunc	
        func VO_$type._MC_InterLuma_H2V1_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h2v1, x_3y_3, tap123_const 
		endfunc	
        func VO_$type._MC_InterLuma_H2V2_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h2v2, x_3y_3, tap123_const 
		endfunc	
        func VO_$type._MC_InterLuma_H2V3_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h2v3, x_3y_2, tap123_const 
		endfunc
        func VO_$type._MC_InterLuma_H3V1_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h3v1, x_2y_3, tap123_const 
		endfunc
        func VO_$type._MC_InterLuma_H3V2_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h3v2, x_2y_3, tap123_const 
		endfunc
        func VO_$type._MC_InterLuma_H3V3_neon, {TRUE}
		    MC_InterLuma_HxVx $type, h3v3, x_2y_2, tap123_const 
		endfunc	
		mend
		
		macro
		epel_tap_x0		$type  
          IF "$type"="put"		
		     ldr             mx, [sp, #CHROMA_MX] ;width			 
		  ELSE
		     ldr             mx, [sp, #AVG_CHROMA_MX] ;width
          ENDIF	
             adrl            nTmp0, ChromaCoeff		  
			 add             nTmp1, nTmp0, mx, lsl #3
			 vld1.64         {d7}, [nTmp1]
			 
			 vdup.8          d12, d7[0]
			 vdup.8          d13, d7[2]
			 vdup.8          d14, d7[4]
			 vdup.8          d15, d7[6]
		mend
		
		macro
		epel_tap_0x	   $type
          IF "$type"="put"		    
		     ldr             my, [sp, #CHROMA_MY] ;height
		  ELSE
		     ldr             my, [sp, #AVG_CHROMA_MY] ;height
          ENDIF		  
			 adrl            nTmp0, ChromaCoeff
			 add             nTmp1, nTmp0, my, lsl #3
			 vld1.64         {d6}, [nTmp1]
			 
			 vdup.8          d12, d6[0]
			 vdup.8          d13, d6[2]
			 vdup.8          d14, d6[4]
			 vdup.8          d15, d6[6]
		mend
		
		macro
		epel_tap_xx	  $type
          IF "$type"="put"		    
		     ldr             mx, [sp, #CHROMA_MX] ;width
			 ldr             my, [sp, #CHROMA_MY] ;height
		  ELSE
		     ldr             mx, [sp, #AVG_CHROMA_MX] ;width
			 ldr             my, [sp, #AVG_CHROMA_MY] ;height
          ENDIF		  
			 adrl            nTmp0, ChromaCoeff
			 add             nTmp1, nTmp0, mx, lsl #3
			 vld1.64         {d7}, [nTmp1]
			 add             nTmp1, nTmp0, my, lsl #3
			 vld1.64         {d6}, [nTmp1]
			 
			 vdup.8          d12, d7[0]
			 vdup.8          d13, d7[2]
			 vdup.8          d14, d7[4]
			 vdup.8          d15, d7[6]
		mend
		
		macro
		epel_x_1y0	
              sub             pTmpSrc,  pSrc,  #1	    
		mend
		
		macro
		epel_x0y_1	
              sub             pTmpSrc, pSrc,  nSrcStride			    
		mend
		
		macro
		epel_x_1y_1		    
		      sub             pTmpSrc, pSrc,  nSrcStride
              sub             pTmpSrc,  pTmpSrc,  #1			  
		mend
	 
		macro
		MC_InterChroma_HxVx $type, $name, $src_pos,  $tap
		     push            {r4-r10, lr}			 
			 $tap		   $type  			 
			 IF "$type"="put"
			 ldr             nWidth, [sp, #PIC_WIDTH] ;width
			 ldr             nHeight, [sp, #PIC_HEIGHT] ;height	
             ELSE
			 ldr             nWidth, [sp, #AVG_PIC_WIDTH] ;width
			 ldr             nHeight, [sp, #AVG_PIC_HEIGHT] ;height	
			 ldr             pTmpDst2,    [sp, #AVG_TMP_DST] ;width
			 ldr             nDstStride2, [sp, #AVG_TMP_STRIDE] ;width
             ENDIF			 			 
			 
			 ands            pTmpDst, pDst, #7
			 bne             %F8
5            mov             nTmpHeight,   nHeight  
             mov             pTmpDst, pDst        
			 $src_pos			 
             subs            nWidth, nWidth,     #2
             ble             %F9
             subs            nWidth, nWidth,     #2
             ble             %F6			 
             h265_eqpel8_$name._neon $type
		  IF "$type"!="put"			 
			 mls             pTmpDst2, nDstStride2, nHeight, pTmpDst2
			 add             pTmpDst2, pTmpDst2, #16             
          ENDIF				 			 
			 subs             nWidth, nWidth,     #4
			 add              pSrc, pSrc,  #8
			 add              pDst, pDst,  #8
			 bgt              %B5  
			 b                %F7
8           
             ands            pTmpDst, pDst, #3
			 bne             %F10  
             mov             nTmpHeight,   nHeight  
             mov             pTmpDst, pDst        
             $src_pos
			 subs            nWidth, nWidth,     #2
             ble             %F9
             sub             nWidth, nWidth,     #2
			 
6			 		 			 
             h265_eqpel4_$name._neon $type
		  IF "$type"!="put"			 
			 mls             pTmpDst2, nDstStride2, nHeight, pTmpDst2
			 add             pTmpDst2, pTmpDst2, #8             
          ENDIF			  
			 add              pSrc, pSrc,  #4
			 add              pDst, pDst,  #4
			 cmp              nWidth, #0
			 bgt              %B5
			 b                %F7
10
             mov             nTmpHeight,   nHeight  
             mov             pTmpDst, pDst        
             $src_pos			 
             sub             nWidth, nWidth,     #2   
9
             h265_eqpel2_$name._neon $type
		  IF "$type"!="put"			 
			 mls             pTmpDst2, nDstStride2, nHeight, pTmpDst2
			 add             pTmpDst2, pTmpDst2, #4             
          ENDIF				 			 
			 add              pSrc, pSrc,  #2
			 add              pDst, pDst,  #2
			 cmp              nWidth, #0
			 bgt              %B5			 
7            pop             {r4-r10, pc}	
		mend
    				
		MACRO 
	    MC_InterChroma $type
		func VO_$type._MC_InterChroma_H0V0_neon, {TRUE}
		    MC_InterLuma_PutPixels $type
		endfunc
		func VO_$type._MC_InterChroma_H1V0_neon, {TRUE}
		     MC_InterChroma_HxVx $type, h1v0, epel_x_1y0, epel_tap_x0
		endfunc
		func VO_$type._MC_InterChroma_H0V1_neon, {TRUE}
		     MC_InterChroma_HxVx $type, h0v1, epel_x0y_1, epel_tap_0x
		endfunc
		func VO_$type._MC_InterChroma_H1V1_neon, {TRUE}
		     MC_InterChroma_HxVx $type, h1v1, epel_x_1y_1, epel_tap_xx
		endfunc
		mend
			
		
		MC_InterLuma put
		MC_InterLuma avg_nornd
		MC_InterLuma avg
		MC_InterChroma  put
		MC_InterChroma  avg_nornd
		MC_InterChroma  avg
	
    END    