;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;// Filename fft_arm_v6.s
;
;// Copyright (c) VisualOn SoftWare Co., Ltd. All rights reserved.
;
;//*@@@---@@@@******************************************************************
;//
;// Abstract:
;// 
;//     ARM specific transforms
;//     Optimized assembly armv6 routines to implement DCTIV & FFT and other routines
;//
;//     Custom build with 
;//          armasm -cpu arm1136 $(InputPath) "$(IntDir)/$(InputName).obj"
;//     and
;//          $(OutDir)\$(InputName).obj
;// 
;// Author:
;// 
;//     Witten Wen (Shanghai, China) September 1, 2008
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
    LDRD	r8, [$pxk]
    LDRD	r10, [$pxi]    
    MOV		r8, r8, ASR #1
    SUB		r6, r8, r10, ASR #1
    ADD		r8, r8, r10, ASR #1
    MOV		r9, r9, ASR #1
    SUB		r7, r9, r11, ASR #1
    ADD		r9, r9, r11, ASR #1   
    STRD	r8, [$pxk], #8
    STRD	r6, [$pxi], #8
    MEND

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MACRO             
	FFTBUTTERFLY_N $pxk, $pxi, $CR, $SI ; assuming reg 1,2 are free
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDRD	r8, [$pxk]
	LDRD	r6, [$pxi]
	MOV     r8, r8, ASR #1
	SUB     r10, r8, r6, ASR #1
	ADD     r8, r8, r6, ASR #1		;r6, r11 is free
	SMMULR  r6, $CR, r10    	; 32*32
	MOV     r9, r9, ASR #1
	SMMULR  r11, $SI, r10		; 32*32
	SUB     r10, r9, r7, ASR #1
	ADD     r9, r9, r7, ASR #1
	SMMLSR  r6, $SI, r10, r6		; +32*32; MULT_CBP2(CR,ur) - MULT_CBP2(SI,ui)
	STRD    r8, [$pxk], #8      ;r7, r8, r9 is free	
	SMMLAR  r7, $CR, r10, r11    ; +32*32: MULT_BP2(SI,ur) + MULT_BP2(CR,ui)	
	MOV     r8, r6, LSL #2    ; temp1 = MULT_BP2(CR,ur) - MULT_BP2(SI,ui)
	MOV     r9, r7, LSL #2    ; temp2 = MULT_CBP2(CR,ui) + MULT_CBP2(SI,ur)
	STRD    r8, [$pxi], #8
	MEND


    ;;;;;;;;;;;;;;;;;;;;;;;;
	MACRO             
	FFTBUTTERFLY0 $pxk, $pxi
    ;;;;;;;;;;;;;;;;;;;;;;;;
	LDRD	r8, [$pxk]              ; tk = *pxk
	LDRD	r10, [$pxi]              ; ti = *pxi	
	ADD     r6, r8, r10            ; temp = *pxk + *pxi
	SUB     r8, r8, r10              ; ur = *pxk - *pxi
	ADD     r7, r9, r11            ; temp = *pxk + *pxi
	SUB     r9, r9, r11              ; ui = *pxk - *pxi;	
	STRD	r8, [$pxi], #8          ; *pxi++ = ui;
	STRD	r6, [$pxk], #8        ; *pxk++ += *pxi;
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

    SMMUL   CR1, STEP, SI     		; 32*32, MULT_BP2(STEP,SI)
    MOV     l, m, ASR #1            ; l = m >> 1;
    MVN     CR2, #3, 2              ; CR2 = BP2_FROM_FLOAT(1)
    STR     l, [sp, #iOffset_l]     ; save l  

    SMMUL   SI1, STEP, CR     		; 32*32, MULT_BP2(STEP,CR)
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
        SMMUL   temp1, STEP, SI1  		; 32*32, MULT_BP2(STEP,SI1)        
        ADD     j, j, #4
        ; stall      
       
        SMMUL   temp2, STEP, CR1 		; 32*32, MULT_BP2(STEP,CR1)
        SUB     CR2, CR2, temp1, LSL #2 ; CR2 -= MULT_BP2(STEP,SI1)
        ; stall
         
        SMMUL   temp1, STEP, CR2 		; 32*32, MULT_BP2(STEP,CR2)
        ADD     SI2, SI2, temp2, LSL #2 ; SI2 += MULT_BP2(STEP,CR1)
        ; stall

        SMMUL   temp2, STEP, SI2  		; 32*32, MULT_BP2(STEP,SI2)
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

LoopThirdStage    
        CMP     i, j
        BGE     ThirdStageEscape
        
		ADD     pxk, px1, j, LSL #2 ; pxk = &px[j];
        LDRD    r10, [pxk]        ; temp1 = *pxk;
        ADD     pxi, px1, i, LSL #2 ; pxi = &px[i];        
        LDRD    r8, [pxi]          ; tmp = *pxi;        
        STRD    r10, [pxi], #8    ; *pxi++ = *pxk;  
        ADD     pxi, pxi, np, LSL #2 ; pxi  += np1;       
        STRD    r8, [pxk], #8      ; *pxk++ = tmp;
        ADD     pxk, pxk, np, LSL #2 ; pxk  += np1; 
        LDRD    r8, [pxi]          ; tmp = *pxi;        		  
        LDRD    r10, [pxk]        ; temp1 = *pxk;        
        STRD    r8, [pxk], #8      ; *pxk++ = tmp;        
        STRD    r10, [pxi], #8    ; *pxi++ = *pxk;
		
ThirdStageEscape

	ADD     temp1, i, #2
    ADD     pxi, px1, temp1, LSL #2     ; pxi = &px[i+2];
    LDRD    r8, [pxi]                  ; tmp = *pxi;
    ADD     temp1, j, np                
    ADD     pxk, px1, temp1, LSL #2     ; pxk = &px[j+np];    
    LDRD    r10, [pxk]                ; temp1 = *pxk
    STRD    r8, [pxk], #4              ; *pxk++ = tmp;
    MOV     k, np, ASR #1               ; k = n2;
    STRD    r10, [pxi], #4            ; *pxi++ = *pxk; 

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
    
    LDRD	iTr, [piCoefTop]							; iTr = piCoefTop[0]; temp5_DCT = piCoefTop[1];
    ADD     piCoefBottom, piCoefTop, temp0_DCT, LSL #2  ; piCoefBottom = rgiCoef + (1<<nLog2cSB) - 1;
    
    STR     i_DCT, [sp, #iOffset_FFTSize]
    STR     piCoefTop, [sp, #iOffset_rgiCoef]

FirstDCTStageLoop
	LDR     r14, [piCoefBottom]                     ; iBi = piCoefBottom[0]; r14 is iBi here
    SMMULR	temp1_DCT, CR_DCT, iTr       			; MULT_BP1(CR,iTr)
    STR		temp5_DCT, [piCoefBottom], #-8          ; piCoefBottom[0] = piCoefTop[1];
    SMMULR	temp2_DCT, CR_DCT, r14       			; MULT_BP1(CR,iBi)
    SUBS    i_DCT, i_DCT, #1                        ; i --;	
    SMMLSR	temp1_DCT, CI_DCT, r14, temp1_DCT		; MULT_BP1(CI,iBi)
    
    MOV     temp3_DCT, CR_DCT
    SMMLAR	temp2_DCT, CI_DCT, iTr, temp2_DCT		; temp2 = MULT_BP1(CR,iBi) + MULT_BP1(CI,iTr)
    MOV     temp1_DCT, temp1_DCT, LSL #1            ; temp1 = MULT_BP1(CR,iTr) - MULT_BP1(CI,iBi)

    SMMUL   temp5_DCT, STEP_DCT, CI_DCT  			; MULT_BP1(STEP,CI)
    MOV     temp2_DCT, temp2_DCT, LSL #1            ; temp2 = MULT_BP1(CR,iBi) + MULT_BP1(CI,iTr);
    STRD	temp1_DCT, [piCoefTop], #8              ; piCoefTop[0] = MULT_BP1(CR,iTr) - MULT_BP1(CI,iBi);piCoefTop[1] = MULT_BP1(CR,iBi) + MULT_BP1(CI,iTr);
    
    SMMUL   temp2_DCT, STEP_DCT, CR_DCT  			; MULT_BP1(STEP,CR)
    SUB     CR_DCT, CR1_DCT, temp5_DCT, LSL #1      ; CR = CR1 - MULT_BP1(STEP,CI);
    MOV     CR1_DCT, temp3_DCT                      ; CR1 = CR;
	LDRD	iTr, [piCoefTop]						; iTr = piCoefTop[0]; r9 = piCoefTop[1];
	
    MOV     temp3_DCT, CI_DCT
    ADD     CI_DCT, CI1_DCT, temp2_DCT, LSL #1      ; CI = CI1 + MULT_BP1(STEP,CR);  
    MOV     CI1_DCT, temp3_DCT                      ; CI1 = CI;

    BNE     FirstDCTStageLoop


    LDR     i_DCT, [sp, #iOffset_FFTSize]

SecondDCTStageLoop                                  
    SMMULR   temp1_DCT, CR_DCT, iTr       			; MULT_BP1(CR,iTr)
    MOV     temp3_DCT, CR_DCT						;	

    SMMULR   temp2_DCT, CR_DCT, iTi       			; MULT_BP1(CR,iTi)
    SUBS    i_DCT, i_DCT, #1                        ; i --;
    
    SMMLSR  temp1_DCT, CI_DCT, iTi, temp1_DCT		; MULT_BP1(CR,iTr) + MULT_BP1(-CI,iTi)

    SMMUL   temp0_DCT, STEP_DCT, CR_DCT  			; MULT_BP1(STEP,CR)
    
    SMMLAR	temp2_DCT, CI_DCT, iTr, temp2_DCT		; MULT_BP1(CR,iTi) + MULT_BP1(CI,iTr)    
    MOV     temp1_DCT, temp1_DCT, LSL #1            ; temp1 = MULT_BP1(CR,iTr) - MULT_BP1(CI,iTi);
    
	SMMUL   temp5_DCT, STEP_DCT, CI_DCT  			; MULT_BP1(STEP,CI)		
	MOV     temp2_DCT, temp2_DCT, LSL #1            ; temp2 = MULT_BP1(CI,iTr) + MULT_BP1(CR,iTi);
	STRD	temp1_DCT, [piCoefTop], #8              ; piCoefTop[0] = MULT_BP1(CR,iTr) - MULT_BP1(CI,iTi);piCoefTop[1] = MULT_BP1(CR,iTi) + MULT_BP1(CI,iTr);
    
    MOV     temp4_DCT, CI_DCT							
    
    SUB     CR_DCT, CR1_DCT, temp5_DCT, LSL #1      ; CR = CR1 - MULT_BP1(STEP,CI);
    MOV     CR1_DCT, temp3_DCT                      ; CR1 = CR;
    
	LDRD	iTr, [piCoefTop]						; iTr = piCoefTop[0]; iTi = piCoefTop[1];
    ADD     CI_DCT, CI1_DCT, temp0_DCT, LSL #1      ; CI = CI1 + MULT_BP1(STEP,CR);
    
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
    MOV     CI_DCT, #0   								; CI = 0
                                   
	LDRD	iTr, [piCoefTop]							;iTr = piCoefTop[0]; iTi = piCoefTop[1];
    LDR     i_DCT, [sp, #iOffset_FFTSize]
    LDR     CR2_DCT, [sp, #iOffset_CR2_DCT]             ; get CR2

    MOV     CI2_DCT, STEP_DCT, ASR #1                   ; DIV2 of STEP
    RSB     CI2_DCT, CI2_DCT, #0                        ; CI2  = -DIV2(STEP); 


ThirdDCTStageLoop
    SMMULR	temp1_DCT, CR_DCT, iTr       			; MULT_BP1(CR,iTr)    
    SMMULR	temp2_DCT, CI_DCT, iTr       			; MULT_BP1(CI,iTr)    
    SMMLSR	temp1_DCT, CI_DCT, iTi, temp1_DCT       ; MULT_BP1(CR,iTr) -  MULT_BP1(CI,iTi);    
    SMMLAR	temp2_DCT, CR_DCT, iTi, temp2_DCT       ; MULT_BP1(CI,iTr) + MULT_BP1(CR,iTi);
    MOV     temp1_DCT, temp1_DCT, LSL #1            ; temp1 = MULT_BP1(CR,iTr) -  MULT_BP1(CI,iTi);
    STR     temp1_DCT, [piCoefTop], #4              ; piCoefTop[0] =  MULT_BP1(CR,iTr) -  MULT_BP1(CI,iTi);
    RSB		temp2_DCT, temp2_DCT, #0				; MULT_BP1(-CI,iTr) - MULT_BP1(CR,iTi);
    SUBS    i_DCT, i_DCT, #1                        ; i --;
    SMMULR	temp1_DCT, STEP_DCT, CI_DCT  			; MULT_BP1(STEP,CI);
    MOV     temp2_DCT, temp2_DCT, LSL #1            ; temp2 = MULT_BP1(-CI,iTr) - MULT_BP1(CR,iTi);
    LDRD	iBr, [piCoefBottom]						; iBr; iBi
    STR     temp2_DCT, [piCoefBottom, #4]           ; piCoefBottom[1] =  MULT_BP1(-CI,iTr) - MULT_BP1(CR,iTi);
    
    SMMULR	temp2_DCT, STEP_DCT, CR_DCT  			; MULT_BP1(STEP,CR);
    MOV     temp3_DCT, CR_DCT	 
    SUB     CR_DCT, CR2_DCT, temp1_DCT, LSL #1      ; CR = CR2 - MULT_BP1(STEP,CI);
    MOV     CR2_DCT, temp3_DCT                      ; CR2 = CR;  
    MOV     temp3_DCT, CI_DCT 

    SMMULR	temp1_DCT, CR_DCT, iBr       			; MULT_BP1(CR,iBr)
    ADD     CI_DCT, CI2_DCT, temp2_DCT, LSL #1      ; CI = CI2 + MULT_BP1(STEP,CR);    
	SMMULR	temp2_DCT, CR_DCT, iBi					; MULT_BP1(CR,iBi);
	
    SMMLAR	temp1_DCT, CI_DCT, iBi, temp1_DCT		; MULT_BP1(CR,iBr) + MULT_BP1(CI,iBi);
    MOV     CI2_DCT, temp3_DCT                      ; CI2 = CI;
    
    SMMLSR	temp2_DCT, CI_DCT, iBr, temp2_DCT		; MULT_BP1(-CI,iBr) +  MULT_BP1(CR,iBi);
    MOV     temp1_DCT, temp1_DCT, LSL #1            ; temp1 = MULT_BP1(CR,iBr) + MULT_BP1(CI,iBi);
    STR     temp1_DCT, [piCoefTop], #4              ; piCoefTop[1] = MULT_BP1(CR,iBr) + MULT_BP1(CI,iBi);
   
	MOV     temp2_DCT, temp2_DCT, LSL #1            ; temp2 = MULT_BP1(-CI,iBr) +  MULT_BP1(CR,iBi);
	LDRD	iTr, [piCoefTop]						;iTr = piCoefTop[0]; iTi = piCoefTop[1];
    STR     temp2_DCT, [piCoefBottom], #-8          ; piCoefBottom[0] = MULT_BP1(-CI,iBr) +  MULT_BP1(CR,iBi);
        
    BNE     ThirdDCTStageLoop

EndOfprvDctIV_ARM
    ADD     sp, sp, #iStackSpaceRevDCT  ; give back rev stack space
    LDMFD   sp!, {r4 - r11, PC}         ; prvDctIV_ARM
    ENTRY_END   prvDctIV_ARM

    ENDIF ; WMA_OPT_FFT_ARM
	ENDIF	;WMA_R4FFT
    END
