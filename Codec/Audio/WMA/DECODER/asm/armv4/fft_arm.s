;//*@@@+++@@@@******************************************************************
;//
;// Microsoft Windows Media
;// Copyright (C) Microsoft Corporation. All rights reserved.
;//
;//*@@@---@@@@******************************************************************

;// Module Name:
;//
;//     fft_arm.s
;//
;// Abstract:
;// 
;//     ARM specific transforms
;//     Optimized assembly routines to implement DCTIV & FFT and other routines
;//
;//     Custom build with 
;//          armasm $(InputDir)\$(InputName).s $(OutDir)\$(InputName).obj
;//     and
;//          $(OutDir)\$(InputName).obj
;// 
;// Author:
;// 
;//     Chuang Gu (chuanggu) December 14, 2001
;//     Jerry He (yamihe) rewrite Jan 15, 2004 
;//
;// Revision History:
;//
;//     Jerry He (yamihe) Nov 18, 2003 
;//
;//****************************************************************************
;//
;// void prvFFT4DCT(Void *ptrNotUsed, CoefType data[], Int nLog2np, FftDirection fftDirection)
;// void prvDctIV_ARM ( rgiCoef, nLog2cSB, CR, CI, CR1, CI1, STEP)
;//
;//****************************************************************************

  OPT			2       ; disable listing 
  INCLUDE		kxarm.h
  INCLUDE		../wma_member_arm.inc
  INCLUDE		../wma_arm_version.h
  OPT			1       ; enable listing

 
  AREA    |.text|, CODE, READONLY
	IF	WMA_R4FFT = 0
  IF WMA_OPT_FFT_ARM = 1

  IMPORT  icosPIbynp
  IMPORT  isinPIbynp
  IMPORT  FFT4DCT16_STEP

  EXPORT  prvFFT4DCT
  EXPORT  prvDctIV_ARM
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   Registers for FFT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
j       RN  0
k       RN  1

n       RN  8
m       RN  9
l       RN  7

CR      RN  6
SI      RN  7
STEP    RN  10


n1      RN  2
np      RN  3
px1     RN  4
np1     RN  5
i       RN  7

CR1     RN  2
SI1     RN  3
CR2     RN  4
SI2     RN  5

px      RN  10
pxk     RN  12
pxi     RN  14
tk      RN  8
ti      RN  9
ur      RN  10
ui      RN  10
tmp     RN  11
temp    RN  11
temp1   RN  6
temp2   RN  7


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   Constants for FFT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
iStackSpaceRev  EQU 8*4    
iOffset_px      EQU iStackSpaceRev-4
iOffset_np      EQU iStackSpaceRev-8
iOffset_CR      EQU iStackSpaceRev-12                
iOffset_SI      EQU iStackSpaceRev-16
iOffset_STEP    EQU iStackSpaceRev-20
iOffset_l       EQU iStackSpaceRev-24
iOffset_m       EQU iStackSpaceRev-28
iOffset_n       EQU iStackSpaceRev-32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   MACROs for FFT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MACRO             
    FFTBUTTERFLY0_N $pxk, $pxi
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDR     tk, [$pxk]
    LDR     ti, [$pxi]
    MOV     tk, tk, ASR #1
    SUB     ur, tk, ti, ASR #1
    ADD     tk, tk, ti, ASR #1
    STR     tk, [$pxk], #4
    STR     ur, [$pxi], #4
    LDR     tk, [$pxk]
    LDR     ti, [$pxi]
    MOV     tk, tk, ASR #1
    SUB     ui, tk, ti, ASR #1
    ADD     tk, tk, ti, ASR #1   
    STR     tk, [$pxk], #4
    STR     ui, [$pxi], #4
	MEND
	
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MACRO             
    FFTBUTTERFLY_N $pxk, $pxi, $CR, $SI ; assuming reg 1,2 are free
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    LDR     tk, [$pxk]
    LDR     ti, [$pxi], #4
    MOV     tk, tk, ASR #1
    SUB     ur, tk, ti, ASR #1
    SMULL   temp, temp1, $CR, ur    ; 32*32
    ADD     tk, tk, ti, ASR #1
    STR     tk, [$pxk], #4
    LDR     ti, [$pxi], #-4
    SMULL   temp, temp2, $SI, ur    ; 32*32
    LDR     tk, [$pxk]
    MOV     tk, tk, ASR #1
    SUB     ui, tk, ti, ASR #1
    RSB     $SI, $SI, #0            ; SI = -SI
    SMLAL   temp, temp1, $SI, ui    ; +32*32; MULT_CBP2(CR,ur) - MULT_CBP2(SI,ui)
    ADD     tk, tk, ti, ASR #1
    STR     tk, [$pxk], #4          ;
    RSB     $SI, $SI, #0            ; SI = +SI
    SMLAL   temp, temp2, $CR, ui    ; +32*32: MULT_BP2(SI,ur) + MULT_BP2(CR,ui)
    MOV     temp1, temp1, LSL #2    ; temp1 = MULT_BP2(CR,ur) - MULT_BP2(SI,ui)
    STR     temp1, [$pxi], #4       ;
    MOV     temp2, temp2, LSL #2    ; temp2 = MULT_CBP2(CR,ui) + MULT_CBP2(SI,ur)
    STR     temp2, [$pxi], #4
    MEND    


    ;;;;;;;;;;;;;;;;;;;;;;;;
    MACRO             
    FFTBUTTERFLY0 $pxk, $pxi
    ;;;;;;;;;;;;;;;;;;;;;;;;
    LDR     tk, [$pxk]              ; tk = *pxk
    LDR     ti, [$pxi]              ; ti = *pxi
    SUB     ur, tk, ti              ; ur = *pxk - *pxi
    ADD     temp, tk, ti            ; temp = *pxk + *pxi
    STR     ur, [$pxi], #4          ; *pxi++ = ur;
    STR     temp, [$pxk], #4        ; *pxk++ += *pxi;
    LDR     tk, [$pxk]              ; tk = *pxk
    LDR     ti, [$pxi]              ; ti = *pxi
    SUB     ui, tk, ti              ; ui = *pxk - *pxi;
    ADD     temp, tk, ti            ; temp = *pxk + *pxi
    STR     ui, [$pxi], #4          ; *pxi++ = ui;
    STR     temp, [$pxk], #4        ; *pxk++ += *pxi;
    MEND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;//****************************************************************************
;//
;// void prvFFT4DCT(Void *ptrNotUsed, CoefType data[], Int nLog2np, FftDirection fftDirection)
;// 
;//****************************************************************************
	IF LINUX_RVDS = 1
  	PRESERVE8
	ENDIF
  	AREA    |.text|, CODE
  	LEAF_ENTRY prvFFT4DCT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Input parameters
; r0 = ptrNotUsed
; r1 = data
; r2 = nLog2np
; r3 = fftDirection

    STMFD   sp!, {r4 - r11, r14}
    SUB     sp, sp, #iStackSpaceRev ; rev stack space

;   if ( nLog2np < 16 )
    CMP   r2, #16
    BLT   gLOG2NPLT16

;   CR = BP2_FROM_FLOAT(cos(dPI/np));
;   STEP = BP2_FROM_FLOAT(2*sin(-dPI/np));

;   call C stub function
    STMFD sp!, {r1 - r2}  ;save r1, r2
    SUB   sp, sp, #4      ;allocate pCR

    MOV   r0, r2
    MOV   r1, sp
    BL    FFT4DCT16_STEP

    MOV   r4, r0
    LDR   r3, [sp]

    ADD   sp, sp, #4      ;release pCR
    LDMFD sp!, {r1 - r2}  ;restore r1, r2
    B     gPrvFFT_ARM

gLOG2NPLT16
;   CR = BP2_FROM_BP1(icosPIbynp[nLog2np]);         // CR = (I32)(cos(PI/np) * NF2BP2)
    LDR   r12, =icosPIbynp
    
;   STEP = isinPIbynp[nLog2np];                     // STEP = (I32)(2*sin(-PI/np) * NF2BP2)
    LDR   r11, =isinPIbynp
    
    LDR   r4, [r12, r2, LSL #2]
    MOV   r3, r4, ASR #1   
    LDR   r4, [r11, r2, LSL #2]

; fftDirection is always FFT_FORWARD at decoder side, so ignore it 
; if (fftDirection == FFT_INVERSE) STEP *= -1;


gPrvFFT_ARM
    MOV     temp, #1
    MOV     r2, temp, LSL r2        ; np (r2) = 1<<nLog2np;
    MOV     r5, r4, ASR #1          ; SI = STEP/2;

    STR     r1, [sp, #iOffset_px]   ;
    STR     r2, [sp, #iOffset_np]   ;

    STR     r3, [sp, #iOffset_CR]   ;
    STR     r4, [sp, #iOffset_STEP] ;
    STR     r5, [sp, #iOffset_SI]   ;

    MOV     m, r2, LSL #1           ; m = n = 2 * np

    STR     m, [sp, #iOffset_n]     ; save n
    STR     m, [sp, #iOffset_m]     ; save m

LoopFirstStage
    CMP     m, #4                   ; m > 4?
    BLE     SecondStage

    LDR     STEP,[sp, #iOffset_STEP]; get STEP
    LDR     SI, [sp, #iOffset_SI]   ; get SI
    LDR     CR, [sp, #iOffset_CR]   ; get CR 

    SMULL   temp, CR1, STEP, SI     ; 32*32, MULT_BP2(STEP,SI)
    MOV     l, m, ASR #1            ; l = m >> 1;
    MVN     CR2, #3, 2              ; CR2 = BP2_FROM_FLOAT(1)
    STR     l, [sp, #iOffset_l]     ; save l  

    SMULL   temp, SI1, STEP, CR     ; 32*32, MULT_BP2(STEP,CR)
    SUB     CR1, CR2, CR1, LSL #2   ; CR1 = BP2_FROM_FLOAT(1) - MULT_BP2(STEP,SI);
    MOV     SI2, #0                 ; SI2 = 0
    STR     CR1, [sp, #iOffset_CR]  ; save CR

    MOV     SI1, SI1, LSL #2        ; shift arithmetic left 2
    MOV     STEP, SI1, LSL #1       ; STEP = MUL2(SI1);    

    STR     SI1, [sp, #iOffset_SI]  ; save SI
    STR     STEP,[sp, #iOffset_STEP]; save STEP
     
TrivialButterfly   
    MOV     k, #0                   ; init k = 0

LoopTrivalButterfly
        LDR     px, [sp, #iOffset_px]   ; get px
        LDR     j, [sp, #iOffset_m]     ; j = m 

        ADD     pxk, px, k, LSL #2      ; pxk = &px[k];
        ADD     pxi, pxk, j, LSL #1     ; pxi = &px[k+l];

        FFTBUTTERFLY0_N pxk, pxi        
        FFTBUTTERFLY_N pxk, pxi, CR1, SI1

        LDR     n, [sp, #iOffset_n]  
        ADD     k, k, j                 ; k += m 
        CMP     k, n
        BLT     LoopTrivalButterfly

NontrivialButterfly
    LDR     l, [sp, #iOffset_l]
    MOV     j, #4
    CMP     j, l
    BGE     OutOfJ

LoopNontrivialButterfly_j
        LDR     STEP, [sp, #iOffset_STEP]
		MOV     k, j                    ; k = j
        SMULL   temp, temp1, STEP, SI1  ; 32*32, MULT_BP2(STEP,SI1)        
        ADD     j, j, #4
        ; stall      
       
        SMULL   temp, temp2, STEP, CR1 ; 32*32, MULT_BP2(STEP,CR1)
        SUB     CR2, CR2, temp1, LSL #2 ; CR2 -= MULT_BP2(STEP,SI1)
        ; stall
         
        SMULL   temp, temp1, STEP, CR2 ; 32*32, MULT_BP2(STEP,CR2)
        ADD     SI2, SI2, temp2, LSL #2 ; SI2 += MULT_BP2(STEP,CR1)
        ; stall

        SMULL   temp, temp2, STEP, SI2  ; 32*32, MULT_BP2(STEP,SI2)
        ADD     SI1, SI1, temp1, LSL #2 ; SI1 += MULT_BP2(STEP,CR2);
        ; stall

        SUB     CR1, CR1, temp2, LSL #2 ; CR1 -= MULT_BP2(STEP,SI2);      
      
LoopCoreButterfly_k
            LDR     px, [sp, #iOffset_px] ; get px
            LDR     m, [sp, #iOffset_m] ; get m

            ADD     pxk, px, k, LSL #2  ; pxk = &px[k];
            ADD     pxi, pxk, m, LSL #1 ; pxi = &px[k+l];                                   
            ADD     k, k, m             ; k = k + m

            FFTBUTTERFLY_N pxk, pxi, CR2, SI2
            FFTBUTTERFLY_N pxk, pxi, CR1, SI1                    

            LDR     n, [sp, #iOffset_n] ; get n
            CMP     k, n                ; k <= n?
            BLE     LoopCoreButterfly_k

        LDR     l, [sp, #iOffset_l]
        CMP     j, l
        BLT     LoopNontrivialButterfly_j

OutOfJ
    MOV     m, l                    ; m = l
    STR     l, [sp, #iOffset_m]     ; save m 
    B       LoopFirstStage    
        
SecondStage
    LDR     px1, [sp, #iOffset_px]      ; get px
    CMP     m, #2                       ; Now m is available, m > 2?
    BLE     ThirdStage

    MOV     j, #0
    LDR     n1, [sp, #iOffset_n]

LoopSecondStage
    ADD     pxk, px1, j, LSL #2         ; pxk = px+j
    ADD     pxi, pxk, #8                ; pxi = pxk + 2;

    FFTBUTTERFLY0 pxk, pxi

    ADD     j, j, #4
    CMP     j, n1
    BLT     LoopSecondStage

ThirdStage
    CMP     n1, #4                      ; Now n is available, n > 4?
    BLE     EndOfprvFFT_ARM

    LDR     np, [sp, #iOffset_np]       ; get np
    MOV     j, #0
    MOV     i, #0
    ADD     np1, np, #1                 ; np1 = np + 1;

LoopThirdStage    
        CMP     i, j
        BGE     ThirdStageEscape
        
        ADD     pxi, px1, i, LSL #2 ; pxi = &px[i];
        ADD     pxk, px1, j, LSL #2 ; pxk = &px[j];
        LDR     tmp, [pxi]          ; tmp = *pxi;   
        LDR     temp1, [pxk]        ; temp1 = *pxk;
        STR     temp1, [pxi], #4    ; *pxi++ = *pxk;
        STR     tmp, [pxk], #4      ; *pxk++ = tmp;
        LDR     tmp, [pxi]          ; tmp = *pxi;
        LDR     temp1, [pxk]        ; temp1 = *pxk
        STR     temp1, [pxi]        ; *pxi = *pxk;
        STR     tmp, [pxk]          ; *pxk = tmp;
        ADD     pxi, pxi, np1, LSL #2 ; pxi  += np1;
        ADD     pxk, pxk, np1, LSL #2 ; pxk  += np1;
        LDR     tmp, [pxi]          ; tmp = *pxi;
        LDR     temp1, [pxk]        ; temp1 = *pxk
        STR     temp1, [pxi], #4    ; *pxi++ = *pxk;
        STR     tmp, [pxk], #4      ; *pxk++ = tmp;
        LDR     tmp, [pxi]          ; tmp = *pxi;
        LDR     temp1, [pxk]        ; temp1 = *pxk;
        STR     temp1, [pxi]        ; *pxi = *pxk;
        STR     tmp, [pxk]          ; *pxk = tmp;
		
ThirdStageEscape

	ADD     temp1, i, #2
    ADD     pxi, px1, temp1, LSL #2     ; pxi = &px[i+2];   
    ADD     temp1, j, np                
    ADD     pxk, px1, temp1, LSL #2     ; pxk = &px[j+np];
    LDR     tmp, [pxi]                  ; tmp = *pxi;
    LDR     temp1, [pxk]                ; temp1 = *pxk
    STR     temp1, [pxi], #4            ; *pxi++ = *pxk;
    STR     tmp, [pxk], #4              ; *pxk++ = tmp;
    LDR     tmp, [pxi]                  ; tmp = *pxi;
    LDR     temp1, [pxk]                ; temp1 = *pxk
    STR     temp1, [pxi]                ; *pxi = *pxk;
    STR     tmp, [pxk]                  ; *pxk = tmp;
    MOV     k, np, ASR #1               ; k = n2;

Cmp_k_j 
    CMP     k, j                        ; k <= j?
    BGT     Out
        SUB     j, j, k                 ; j -= k;
        MOV     k, k, ASR #1            ; k = k / 2
        B       Cmp_k_j
Out
    ADD     j, j, k                     ; j += k
    ADD     i, i, #4                    ; i = i + 4
    CMP     i, np                       ; i < np? 
    BLT     LoopThirdStage

; fftDirection is always FFT_FORWARD at decoder side, so ignore it 
; if (fftDirection == FFT_INVERSE) // Normalization to match Intel library
;   for (i = 0; i < 2 * np; i++) data[i] /= np;

    
EndOfprvFFT_ARM
    ADD     sp, sp, #iStackSpaceRev     ; give back rev stack space
    LDMFD   sp!, {r4 - r11, PC}         ; prvFFT4DCT
    ENTRY_END   prvFFT4DCT


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   Registers for DCTIV
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

piCoefTop       RN  0
piCoefBottom    RN  1
CR_DCT          RN  2
CI_DCT          RN  3
CR1_DCT         RN  4
CI1_DCT         RN  5
STEP_DCT        RN  6
CR2_DCT         RN  4
CI2_DCT         RN  5
iTi             RN  9  
iTr             RN  8
iBi             RN  9
iBr             RN  8
i_DCT           RN  7
temp0_DCT       RN  12
temp1_DCT       RN  10
temp2_DCT       RN  11
temp3_DCT       RN  14
temp4_DCT       RN  1
temp5_DCT		RN	9


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   Constants for DCTIV
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

iRegSpaceDCT        EQU 9*4   ; {r4 - r11, r14}

iStackSpaceRevDCT   EQU 3*4    
iOffset_FFTSize     EQU iStackSpaceRevDCT-4
iOffset_nLog2cSB    EQU iStackSpaceRevDCT-8 
iOffset_rgiCoef     EQU iStackSpaceRevDCT-12

iOffset_CR1_DCT     EQU iRegSpaceDCT+iStackSpaceRevDCT
iOffset_CI1_DCT     EQU iRegSpaceDCT+iStackSpaceRevDCT+4
iOffset_STEP_DCT    EQU iRegSpaceDCT+iStackSpaceRevDCT+8
iOffset_CR2_DCT     EQU iRegSpaceDCT+iStackSpaceRevDCT+12


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	PRESERVE8
    AREA    |.text|, CODE
    LEAF_ENTRY prvDctIV_ARM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    STMFD   sp!, {r4 - r11, r14}
    SUB     sp, sp, #iStackSpaceRevDCT  ;setup stack

    MOV     temp0_DCT, #1
    SUB     temp1_DCT, r1, #2
    MOV     i_DCT, temp0_DCT, LSL temp1_DCT             ; iFFTSize/2 = 1<<(nLog2cSB-2);

    LDR     CR1_DCT, [sp, #iOffset_CR1_DCT]             ; get CR1
    LDR     CI1_DCT, [sp, #iOffset_CI1_DCT]             ; get CI1
    LDR     STEP_DCT, [sp, #iOffset_STEP_DCT]           ; get STEP

    MOV     temp0_DCT, temp0_DCT, LSL r1                ; temp = 1<<nLog2cSB
    STR     r1, [sp, #iOffset_nLog2cSB]

    SUB     temp0_DCT, temp0_DCT, #1                    ; temp = (1<<nLog2cSB) - 1
    
    ADD     piCoefBottom, piCoefTop, temp0_DCT, LSL #2  ; piCoefBottom = rgiCoef + (1<<nLog2cSB) - 1;
    
    STR     i_DCT, [sp, #iOffset_FFTSize]
    STR     piCoefTop, [sp, #iOffset_rgiCoef]

FirstDCTStageLoop
    LDR     iTr, [piCoefTop]                        ; iTr = piCoefTop[0];
    SMULL   temp0_DCT, temp1_DCT, CR_DCT, iTr       ; MULT_BP1(CR,iTr)
    LDR     iBi, [piCoefBottom]                     ; iBi = piCoefBottom[0];
    RSB     CI_DCT, CI_DCT, #0

    SMLAL   temp0_DCT, temp1_DCT, CI_DCT, iBi       ; MULT_BP1(CI,iBi)
    LDR     temp2_DCT, [piCoefTop, #4]              ; temp2 = piCoefTop[1];
    STR     temp2_DCT, [piCoefBottom], #-8          ; piCoefBottom[0] = piCoefTop[1];

    SMULL   temp0_DCT, temp2_DCT, CR_DCT, iBi       ; MULT_BP1(CR,iBi)
    RSB     CI_DCT, CI_DCT, #0
    MOV     temp3_DCT, CR_DCT

    SMLAL   temp0_DCT, temp2_DCT, CI_DCT, iTr       ; temp2 = MULT_BP1(CR,iBi) + MULT_BP1(CI,iTr)
    MOV     temp1_DCT, temp1_DCT, LSL #1            ; temp1 = MULT_BP1(CR,iTr) - MULT_BP1(CI,iBi)
    STR     temp1_DCT, [piCoefTop], #4              ; piCoefTop[0] = MULT_BP1(CR,iTr) - MULT_BP1(CI,iBi);

    SMULL   temp0_DCT, temp1_DCT, STEP_DCT, CI_DCT  ; MULT_BP1(STEP,CI)
    MOV     temp2_DCT, temp2_DCT, LSL #1            ; temp2 = MULT_BP1(CR,iBi) + MULT_BP1(CI,iTr);
    STR     temp2_DCT, [piCoefTop], #4              ; piCoefTop[1] = MULT_BP1(CR,iBi) + MULT_BP1(CI,iTr);
    SUBS    i_DCT, i_DCT, #1                        ; i --;

    SMULL   temp0_DCT, temp2_DCT, STEP_DCT, CR_DCT  ; MULT_BP1(STEP,CR)
    SUB     CR_DCT, CR1_DCT, temp1_DCT, LSL #1      ; CR = CR1 - MULT_BP1(STEP,CI);
    MOV     CR1_DCT, temp3_DCT                      ; CR1 = CR;

    MOV     temp3_DCT, CI_DCT
    ADD     CI_DCT, CI1_DCT, temp2_DCT, LSL #1      ; CI = CI1 + MULT_BP1(STEP,CR);  
    MOV     CI1_DCT, temp3_DCT                      ; CI1 = CI;

    BNE     FirstDCTStageLoop


    LDR     i_DCT, [sp, #iOffset_FFTSize]

SecondDCTStageLoop                                  
    LDR     iTr, [piCoefTop]                        ; iTr = piCoefTop[0]
    SMULL   temp0_DCT, temp1_DCT, CR_DCT, iTr       ; MULT_BP1(CR,iTr)
    LDR     iTi, [piCoefTop, #4]                    ; iTi = piCoefTop[1]
    RSB     CI_DCT, CI_DCT, #0                      ; CI_DCT = -CI

    SMLAL   temp0_DCT, temp1_DCT, CI_DCT, iTi       ; MULT_BP1(CR,iTr) + MULT_BP1(-CI,iTi)
    RSB     CI_DCT, CI_DCT, #0                      ; CI_DCT = CI
    MOV     temp3_DCT, CR_DCT

    SMULL   temp0_DCT, temp2_DCT, CR_DCT, iTi       ; MULT_BP1(CR,iTi)
    MOV     temp1_DCT, temp1_DCT, LSL #1            ; temp1 = MULT_BP1(CR,iTr) - MULT_BP1(CI,iTi);
    STR     temp1_DCT, [piCoefTop], #4              ; piCoefTop[0] = MULT_BP1(CR,iTr) - MULT_BP1(CI,iTi);

    SMLAL   temp0_DCT, temp2_DCT, CI_DCT, iTr       ; MULT_BP1(CR,iTi) + MULT_BP1(CI,iTr)
    MOV     temp4_DCT, CI_DCT
    SUBS    i_DCT, i_DCT, #1                        ; i --;

    SMULL   temp0_DCT, temp1_DCT, STEP_DCT, CI_DCT  ; MULT_BP1(STEP,CI)
    MOV     temp2_DCT, temp2_DCT, LSL #1            ; temp2 = MULT_BP1(CI,iTr) + MULT_BP1(CR,iTi)
    STR     temp2_DCT, [piCoefTop], #4              ; piCoefTop[1] = MULT_BP1(CR,iTi) + MULT_BP1(CI,iTr);
    
    SMULL   temp0_DCT, temp2_DCT, STEP_DCT, CR_DCT  ; MULT_BP1(STEP,CR)
    SUB     CR_DCT, CR1_DCT, temp1_DCT, LSL #1      ; CR = CR1 - MULT_BP1(STEP,CI);
    MOV     CR1_DCT, temp3_DCT                      ; CR1 = CR;

    ADD     CI_DCT, CI1_DCT, temp2_DCT, LSL #1      ; CI = CI1 + MULT_BP1(STEP,CR);
    
    MOV     CI1_DCT, temp4_DCT                      ; CI1 = CI;

    BNE     SecondDCTStageLoop

CallFFT
;   prvFFT4DCT(NULL, rgiCoef, nLog2cSB - 1, FFT_FORWARD);
	LDR     r2, [sp, #iOffset_nLog2cSB]
    LDR     r1, [sp, #iOffset_rgiCoef]    
    SUB     r2, r2, #1
;   MOV     r3, #0
    bl      prvFFT4DCT

    LDR     temp1_DCT, [sp, #iOffset_nLog2cSB]
    LDR     piCoefTop, [sp, #iOffset_rgiCoef]

    MOV     temp0_DCT, #1
    MOV     temp0_DCT, temp0_DCT, LSL temp1_DCT         ; temp = 1<<nLog2cSB
    SUB     temp0_DCT, temp0_DCT, #2                    ; temp = (1<<nLog2cSB) - 2
    ADD     piCoefBottom, piCoefTop, temp0_DCT, LSL #2  ; piCoefBottom = rgiCoef + (1<<nLog2cSB) - 2;

    MVN     CR_DCT, #2, 2                               ; CR = BP1_FROM_FLOAT(1);
    MOV     CI_DCT, #0   
                                   ; CI = 0
    LDR     i_DCT, [sp, #iOffset_FFTSize]
    LDR     CR2_DCT, [sp, #iOffset_CR2_DCT]             ; get CR2

    MOV     CI2_DCT, STEP_DCT, ASR #1                   ; DIV2 of STEP
    RSB     CI2_DCT, CI2_DCT, #0                        ; CI2  = -DIV2(STEP); 


ThirdDCTStageLoop
    LDR     iTr, [piCoefTop]                        ; 
    SMULL   temp0_DCT, temp1_DCT, CR_DCT, iTr       ; MULT_BP1(CR,iTr)
    LDR     iTi, [piCoefTop, #4]
    RSB     CI_DCT, CI_DCT, #0                      ; CI_DCT = -CI

    SMLAL   temp0_DCT, temp1_DCT, CI_DCT, iTi       ; MULT_BP1(CR,iTr) -  MULT_BP1(CI,iTi);
    MOV     temp3_DCT, CR_DCT
    RSB     CR_DCT, CR_DCT, #0                      ; CR_DCT = -CR

    SMULL   temp0_DCT, temp2_DCT, CI_DCT, iTr       ; MULT_BP1(-CI,iTr)
    RSB     CI_DCT, CI_DCT, #0                      ; CI_DCT = CI
    MOV     temp1_DCT, temp1_DCT, LSL #1            ; temp1 = MULT_BP1(CR,iTr) -  MULT_BP1(CI,iTi);
    LDR     iBr, [piCoefBottom]

    SMLAL   temp0_DCT, temp2_DCT, CR_DCT, iTi       ; MULT_BP1(-CI,iTr) - MULT_BP1(CR,iTi);
    RSB     CR_DCT, CR_DCT, #0                      ; CR_DCT = CR
    STR     temp1_DCT, [piCoefTop], #4              ; piCoefTop[0] =  MULT_BP1(CR,iTr) -  MULT_BP1(CI,iTi);
    LDR     iBi, [piCoefBottom, #4]

    SMULL   temp0_DCT, temp1_DCT, STEP_DCT, CI_DCT  ; MULT_BP1(STEP,CI);
    MOV     temp2_DCT, temp2_DCT, LSL #1            ; temp2 = MULT_BP1(-CI,iTr) - MULT_BP1(CR,iTi);
    STR     temp2_DCT, [piCoefBottom, #4]           ; piCoefBottom[1] =  MULT_BP1(-CI,iTr) - MULT_BP1(CR,iTi);

    SMULL   temp0_DCT, temp2_DCT, STEP_DCT, CR_DCT  ; MULT_BP1(STEP,CR);
    SUB     CR_DCT, CR2_DCT, temp1_DCT, LSL #1      ; CR = CR2 - MULT_BP1(STEP,CI);
    MOV     CR2_DCT, temp3_DCT                      ; CR2 = CR;  
    MOV     temp3_DCT, CI_DCT

    SMULL   temp0_DCT, temp1_DCT, CR_DCT, iBr       ; MULT_BP1(CR,iBr)
    ADD     CI_DCT, CI2_DCT, temp2_DCT, LSL #1      ; CI = CI2 + MULT_BP1(STEP,CR);
    MOV     CI2_DCT, temp3_DCT                      ; CI2 = CI;

    SMLAL   temp0_DCT, temp1_DCT, CI_DCT, iBi       ; MULT_BP1(CR,iBr) + MULT_BP1(CI,iBi);
    RSB     CI_DCT, CI_DCT, #0                      ; CI_DCT = -CI
    
    SMULL   temp0_DCT, temp2_DCT, CI_DCT, iBr       ; MULT_BP1(-CI,iBr)
    MOV     temp1_DCT, temp1_DCT, LSL #1            ; temp1 = MULT_BP1(CR,iBr) + MULT_BP1(CI,iBi);
    STR     temp1_DCT, [piCoefTop], #4              ; piCoefTop[1] = MULT_BP1(CR,iBr) + MULT_BP1(CI,iBi);

    SMLAL   temp0_DCT, temp2_DCT, CR_DCT, iBi       ; MULT_BP1(-CI,iBr) +  MULT_BP1(CR,iBi);
    RSB     CI_DCT, CI_DCT, #0                      ; CI_DCT = CI
    SUBS    i_DCT, i_DCT, #1                        ; i --;

    MOV     temp2_DCT, temp2_DCT, LSL #1            ; temp2 = MULT_BP1(-CI,iBr) +  MULT_BP1(CR,iBi);
    STR     temp2_DCT, [piCoefBottom], #-8          ; piCoefBottom[0] = MULT_BP1(-CI,iBr) +  MULT_BP1(CR,iBi);
        
    BNE     ThirdDCTStageLoop


EndOfprvDctIV_ARM
    ADD     sp, sp, #iStackSpaceRevDCT  ; give back rev stack space
    LDMFD   sp!, {r4 - r11, PC}         ; prvDctIV_ARM
    ENTRY_END   prvDctIV_ARM



    ENDIF ; WMA_OPT_FFT_ARM
	ENDIF	;WMA_R4FFT
    END
