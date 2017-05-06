
	AREA	|.text|, CODE

  macro 
  h_loop_code
	ldr			r14, [sp, #4]			;SrcStride
	ldr			r9, [sp, #12]			;16-rd	
	ldrb        r1, [r0, #1]
	ldrb        r2, [r0, #2]
	ldrb        r3, [r0, #3]
	ldrb        r4, [r0, #4]	
	ldrb        r5, [r0, #5]
	ldrb        r6, [r0, #6]
	ldrb        r7, [r0, #7]
	ldrb        r8, [r0, #8]
	ldrb        r10, [r0], r14
	str			r0, [sp, #16]			;Src
		
;;1				r1~r8, r10,can't use, r0, r9, r11, r12, r14 can use	
	ldr			r11, W_23_14
	ldr			r14, W_3_7
	pkhbt		r0, r3, r2, lsl #16		;[2][3]	
	pkhbt		r12, r10, r1, lsl #16	;[1][0]		
	smlsdx		r0, r0, r14, r9		
	smlad		r12, r12, r11, r0		;C = 16-rd +14*Src[0] +23*Src[1] - 7*Src[2] + 3*Src[3] - Src[4];	
	sub			r12, r12, r4
	pkhbt		r0, r5, r6, lsl #16		;[6][5]		
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
	smlsdx		r0, r0, r14, r9			;	
	strb		r12, [sp, #20]

	pkhbt		r12, r8, r7, lsl #16	;[7][8]		

	smlad		r12, r12, r11, r0		;C = 16-rd - Src[4] +3*Src[5] -7*Src[6] + 23*Src[7] + 14*Src[8];
	ldr			r11, W_20_19		

	sub			r14, r14, #1			;W_3_6		
	sub			r12, r12, r4
	sub			r0, r4, r10	
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
	pkhbt		r0, r0, r3, lsl #16		;[3[4-0]]	
	strb		r12, [sp, #27]

;;2				r1~r8, r10,can't use, r0, r9, r11, r12, r14 can use

	
	pkhbt		r12, r1, r2, lsl #16	;[2][1]		
	smlsdx		r0, r0, r14, r9		
	smlad		r12, r12, r11, r0		;C = 16-rd - 3*(Src[0]-Src[4]) +19*Src[1] +20*Src[2] - 6*Src[3] - Src[5];	
	sub			r12, r12, r5
	sub			r0, r4, r8	
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
	pkhbt		r0, r0, r5, lsl #16		;[5][4-8]	
	strb		r12, [sp, #21]
	
	
	
	pkhbt		r12, r7, r6, lsl #16	;[6][7]		
	smlsdx		r0, r0, r14, r9			;	
	smlad		r12, r12, r11, r0		;C = 16-rd - Src[3] +3*(Src[4]-Src[8]) -6*Src[5] + 20*Src[6] + 19*Src[7];	
	sub			r12, r12, r3
	add			r0, r1, r4	
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
	sub			r11, r11, #17			;W_20_2	
	strb		r12, [sp, #26]

;;3				r1~r8, r10,can't use, r0, r9, r11, r12, r14 can use
;	ldr			r11, W_20_19

	add			r12, r2, r3
	pkhbt		r0, r5, r0, lsl #16		;[1+4][5]	
	pkhbt		r12, r10, r12, lsl #16	;[2+3][0]		
	smlsdx		r0, r0, r14, r9		
	smlad		r12, r12, r11, r0		;C = 16-rd + 2*Src[0] - 6*(Src[1]+Src[4]) +20*(Src[2]+Src[3]) + 3*Src[5] - Src[6];	
	sub			r12, r12, r6
	add			r0, r4, r7	
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
	strb		r12, [sp, #22]
	

	add			r12, r5, r6		
	pkhbt		r0, r3, r0, lsl #16		;[4+7][3]	
	pkhbt		r12, r8, r12, lsl #16	;[5+6][8]		
	smlsdx		r0, r0, r14, r9			;	
	smlad		r12, r12, r11, r0		;C = 16-rd - Src[2] +3*Src[3] -6*(Src[4]+Src[7]) + 20*(Src[5]+Src[6]) +2*Src[8];	
	sub			r12, r12, r2
	add			r11, r11, #4			;W_20_6	
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
	strb		r12, [sp, #25]		

;		C = 16-rd - (Src[0]+Src[7]) + 3*(Src[1]+Src[6])-6*(Src[2]+Src[5]) + 20*(Src[3]+Src[4]);
;		CLIP_STORE(3,C);
;		C = 16-rd - (Src[1]+Src[8]) + 3*(Src[2]+Src[7])-6*(Src[3]+Src[6]) + 20*(Src[4]+Src[5]);
;		CLIP_STORE(4,C);
;;4				r1~r8, r10,can't use, r0, r9, r11, r12, r14 can use
	add			r12, r2, r5
	add			r0, r3, r4
	pkhbt		r0, r0, r12, lsl #16	;[2+5][3+4]
	add			r12, r1, r6			
	smlsdx		r0, r0, r11, r9
	add			r12, r12, r12, lsl #1
	add			r12, r0, r12
	sub			r12, r12, r10
	sub			r12, r12, r7
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
	strb		r12, [sp, #23]

	add			r12, r3, r6	
	add			r0, r4, r5

	pkhbt		r0, r0, r12, lsl #16	;[3+6][4+5]
	add			r12, r2, r7		
	smlsdx		r0, r0, r11, r9
	add			r12, r12, r12, lsl #1
	add			r12, r0, r12
	sub			r12, r12, r1
	sub			r12, r12, r8
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
	strb		r12, [sp, #24]
	
  mend	
	
	EXPORT Arm11InterQ2
Arm11InterQ2 PROC
;Arm11InterQ2(VO_U8 *Src, VO_U8 *Dst, VO_S32 SrcStride, VO_S32 DstStride, VO_S32 nHeight, VO_S32 rd)
; 53   : {
	stmdb       sp!, {r4 - r11, lr}
	sub         sp, sp, #28
	ldr         r10, [sp, #68]		;rd
;	ldr         r14, [sp, #64]		;nHeight 
	str			r1, [sp, #0]			;Dst
	str			r2, [sp, #4]			;SrcStride
	str			r3, [sp, #8]			;DstStride
	rsb			r10, r10, #16			;16-rd	
	str			r10, [sp, #12]		;16-rd	
	
Arm11InterQ2_loop

	h_loop_code
	
	ldrd			r4, [sp, #20]
;	ldr			r5, [sp, #24]	
	
	ldr			r1, [sp, #0]		;Dst
	ldr			r3, [sp, #8]		;DstStride
	ldr         r14, [sp, #64]		;nHeight	
	ldr			r0, [sp, #16]		;Src
;	ldrd		r6, [r1], r3	
	strd		r4, [r1], r3 
	
	subs        r14, r14, #1
	str         r14, [sp, #64]		;nHeight
	str			r1, [sp, #0]		;Dst		
	bne         Arm11InterQ2_loop
	
	
	add         sp, sp, #28
	ldmia       sp!, {r4 - r11, pc}

	ENDP  ;
		
	EXPORT Arm11InterQ1
Arm11InterQ1 PROC
;qpel_ha_8x8(VO_U8 *Src, VO_U8 *Dst, VO_S32 SrcStride, VO_S32 DstStride, VO_S32 nHeight, VO_S32 rd)
; 53   : {
	stmdb       sp!, {r4 - r11, lr}
	sub         sp, sp, #28
	ldr         r10, [sp, #68]		;rd
;	ldr         r14, [sp, #64]		;nHeight 
	str			r1, [sp, #0]			;Dst
	str			r2, [sp, #4]			;SrcStride
	str			r3, [sp, #8]			;DstStride
	rsb			r10, r10, #16			;16-rd	
	str			r10, [sp, #12]		;16-rd	
	
Arm11InterQ1_loop

	h_loop_code
	
;	sub			r9, r9, #15				;1-rd
	
	
	mov	r3,r3,lsl #24
	mov	r7,r7,lsl #24 
;	orr	r9, r9, r9, lsl #8
	orr	r3, r3, r2, lsl #16 
	orr	r7, r7, r6, lsl #16
;	orr	r9, r9, r9, lsl #16	
	orr	r3, r3, r1, lsl #8 
	orr	r7, r7, r5, lsl #8
	orr	r3, r3, r10 
	ldrd		r10, [sp, #20]
	orr	r7, r7, r4
	
;	ldr			r11, [sp, #24]
		  	   	  	  
;	uqadd8	r3, r3, r9
;	uqadd8	r7, r7, r9	
;	uhadd8	r4, r3, r10	
;	uhadd8	r5, r7, r11
		  
	subs		r9, r9, #15				;1-rd
	
	uhadd8eq	r4, r3, r10	
	uhadd8eq	r5, r7, r11	
	
	uhsub8ne	r3, r10, r3
	uhsub8ne	r7, r11, r7
	usub8ne		r4, r10, r3
	usub8ne		r5, r11, r7
	

	ldr			r1, [sp, #0]		;Dst
	ldr			r3, [sp, #8]		;DstStride
	ldr         r14, [sp, #64]		;nHeight	
	ldr			r0, [sp, #16]		;Src
;	ldrd		r6, [r1], r3	
	strd		r4, [r1], r3 
	
	subs        r14, r14, #1
	str         r14, [sp, #64]		;nHeight
	str			r1, [sp, #0]		;Dst		
	bne         Arm11InterQ1_loop
	
	
	add         sp, sp, #28
	ldmia       sp!, {r4 - r11, pc}
	
W_3_7		dcd 0x00030007		;W_3_6
W_23_14		dcd	0x0017000e
W_20_19		dcd	0x00140013		;W_20_02	W_20_06

	ENDP  ;


	EXPORT Arm11InterQ3
Arm11InterQ3 PROC
;qpel_ha_up_8x8(VO_U8 *Src, VO_U8 *Dst, VO_S32 SrcStride, VO_S32 DstStride, VO_S32 nHeight, VO_S32 rd)
; 53   : {
	stmdb       sp!, {r4 - r11, lr}
	sub         sp, sp, #28
	ldr         r10, [sp, #68]		;rd
;	ldr         r14, [sp, #64]		;nHeight 
	str			r1, [sp, #0]			;Dst
	str			r2, [sp, #4]			;SrcStride
	str			r3, [sp, #8]			;DstStride
	rsb			r10, r10, #16			;16-rd	
	str			r10, [sp, #12]		;16-rd	
	
Arm11InterQ3_loop

	h_loop_code
	
;	sub			r9, r9, #15				;1-rd	

	ldrd		r10, [sp, #20]
;	ldr			r11, [sp, #24]
	
	mov	r4,r4,lsl #24
	mov	r8,r8,lsl #24 
;	orr	r9, r9, r9, lsl #8
	orr	r4, r4, r3, lsl #16 
	orr	r8, r8, r7, lsl #16
;	orr	r9, r9, r9, lsl #16	
	orr	r4, r4, r2, lsl #8 
	orr	r8, r8, r6, lsl #8
	orr	r4, r4, r1 
	orr	r8, r8, r5
		  	   	  	  			  	   	  	  
;	uqadd8	r4, r4, r9
;	uqadd8	r8, r8, r9	
;	uhadd8	r4, r4, r10	
;	uhadd8	r5, r8, r11		  
	
	subs		r9, r9, #15				;1-rd
	
	uhadd8eq	r4, r4, r10	
	uhadd8eq	r5, r8, r11	
	
	uhsub8ne	r4, r10, r4
	uhsub8ne	r8, r11, r8
	usub8ne		r4, r10, r4
	usub8ne		r5, r11, r8

	ldr			r1, [sp, #0]		;Dst
	ldr			r3, [sp, #8]		;DstStride
	ldr         r14, [sp, #64]		;nHeight	
	ldr			r0, [sp, #16]		;Src
;	ldrd		r6, [r1], r3	
	strd		r4, [r1], r3 
	
	subs        r14, r14, #1
	str         r14, [sp, #64]		;nHeight
	str			r1, [sp, #0]		;Dst		
	bne         Arm11InterQ3_loop
	
	
	add         sp, sp, #28
	ldmia       sp!, {r4 - r11, pc}

	ENDP  ;


    macro 
  v_loop_code $Va_up, $Up, $CONST
	;r0 = src ;r14 = SrcStride, r9 = 16-rd	

	ldrb        r10, [r0], r14
	rsb			r9, r9, #32		
	ldrb        r1, [r0], r14
	add			r9, sp, r9	
	ldrb        r2, [r0], r14
	ldr			r11, W_23_14	
	ldrb        r3, [r0], r14
	pkhbt		r12, r10, r1, lsl #16	;[1][0]		
	ldrb        r4, [r0], r14
	ldrb        r5, [r0], r14
	ldrb        r6, [r0], r14
	ldrb        r7, [r0], r14
	ldr			r14, W_3_7	
	ldrb        r8, [r0]
	pkhbt		r0, r3, r2, lsl #16		;[2][3]	
		
;;1				r1~r8, r10,can't use, r0, r9, r11, r12, r14 can use	
	
	smusdx		r0, r0, r14		
	smlad		r12, r12, r11, r0		;C = 16-rd +14*Src[0] +23*Src[1] - 7*Src[2] + 3*Src[3] - Src[4];	
	sub			r12, r12, r4
	add			r12, r12, #$CONST			;16-rd
	if $Va_up >0
	if $Up > 0		
	strb		r1, [r9, #8]
	else
	strb		r10, [r9, #8]	
	endif
	endif	

	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));	
	pkhbt		r0, r5, r6, lsl #16		;[6][5]				
	strb		r12, [r9]
	
	
	pkhbt		r12, r8, r7, lsl #16	;[7][8]		
	smusdx		r0, r0, r14			;	
	smlad		r12, r12, r11, r0		;C = 16-rd - Src[4] +3*Src[5] -7*Src[6] + 23*Src[7] + 14*Src[8];	
	sub			r12, r12, r4
	add			r12, r12, #$CONST			;16-rd	
	if $Va_up > 0
	if $Up > 0		
	strb		r8, [r9, #120]
	else
	strb		r7, [r9, #120]	
	endif	
	endif	
	ldr			r11, W_20_19	
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));		
	sub			r14, r14, #1			;W_3_6	
	strb		r12, [r9, #112]

;;2				r1~r8, r10,can't use, r0, r9, r11, r12, r14 can use


	sub			r0, r4, r10	
	pkhbt		r0, r0, r3, lsl #16		;[3[4-0]]
	pkhbt		r12, r1, r2, lsl #16	;[2][1]				
	smusdx		r0, r0, r14		
	smlad		r12, r12, r11, r0		;C = 16-rd - 3*(Src[0]-Src[4]) +19*Src[1] +20*Src[2] - 6*Src[3] - Src[5];	
	sub			r12, r12, r5
	add			r12, r12, #$CONST			;16-rd
	if $Va_up > 0	
	if $Up > 0		
	strb		r2, [r9, #24]
	else
	strb		r1, [r9, #24]	
	endif		
	endif	
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));	
	sub			r0, r4, r8				
	strb		r12, [r9, #16]
	
	
	pkhbt		r12, r7, r6, lsl #16	;[6][7]		
	pkhbt		r0, r0, r5, lsl #16		;[5][4-8]		
	smusdx		r0, r0, r14			;	
	smlad		r12, r12, r11, r0		;C = 16-rd - Src[3] +3*(Src[4]-Src[8]) -6*Src[5] + 20*Src[6] + 19*Src[7];	
	sub			r12, r12, r3
	add			r12, r12, #$CONST			;16-rd
	if $Va_up > 0	
	if $Up > 0		
	strb		r7, [r9, #104]
	else
	strb		r6, [r9, #104]	
	endif	
	endif	
	sub			r11, r11, #17			;W_20_2
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
	add			r0, r1, r4					
	strb		r12, [r9, #96]

;;3				r1~r8, r10,can't use, r0, r9, r11, r12, r14 can use
;	ldr			r11, W_20_19
	add			r12, r2, r3
	pkhbt		r0, r5, r0, lsl #16		;[1+4][5]	
	pkhbt		r12, r10, r12, lsl #16	;[2+3][0]		
	smusdx		r0, r0, r14	
	smlad		r12, r12, r11, r0		;C = 16-rd + 2*Src[0] - 6*(Src[1]+Src[4]) +20*(Src[2]+Src[3]) + 3*Src[5] - Src[6];	
	sub			r12, r12, r6
	add			r12, r12, #$CONST			;16-rd
	if $Va_up > 0	
	if $Up > 0		
	strb		r3, [r9, #40]
	else
	strb		r2, [r9, #40]	
	endif	
	endif		
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));	
	add			r0, r4, r7		
	strb		r12, [r9, #32]
	

	add			r12, r5, r6		
	pkhbt		r0, r3, r0, lsl #16		;[4+7][3]	
	pkhbt		r12, r8, r12, lsl #16	;[5+6][8]		
	smusdx		r0, r0, r14			;	
	smlad		r12, r12, r11, r0		;C = 16-rd - Src[2] +3*Src[3] -6*(Src[4]+Src[7]) + 20*(Src[5]+Src[6]) +2*Src[8];	
	sub			r12, r12, r2
	add			r12, r12, #$CONST			;16-rd	
	if $Va_up > 0	
	if $Up > 0		
	strb		r6, [r9, #88]
	else
	strb		r5, [r9, #88]	
	endif		
	endif	
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
	add			r11, r11, #4			;W_20_6					
	strb		r12, [r9, #80]	

;		C = 16-rd - (Src[0]+Src[7]) + 3*(Src[1]+Src[6])-6*(Src[2]+Src[5]) + 20*(Src[3]+Src[4]);
;		CLIP_STORE(3,C);
;		C = 16-rd - (Src[1]+Src[8]) + 3*(Src[2]+Src[7])-6*(Src[3]+Src[6]) + 20*(Src[4]+Src[5]);
;		CLIP_STORE(4,C);
;;4				r1~r8, r10,can't use, r0, r9, r11, r12, r14 can use

	add			r12, r2, r5
	add			r0, r3, r4	
	pkhbt		r0, r0, r12, lsl #16	;[2+5][3+4]		
	add			r12, r1, r6	
	smusdx		r0, r0, r11
	add			r12, r12, r12, lsl #1	
	add			r12, r0, r12
	sub			r12, r12, r10
	sub			r12, r12, r7
	add			r12, r12, #$CONST			;16-rd	
	if $Va_up > 0	
	if $Up > 0		
	strb		r4, [r9, #56]
	else
	strb		r3, [r9, #56]	
	endif		
	endif	
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));
				
	strb		r12, [r9, #48]
	add			r12, r3, r6	
	add			r0, r4, r5

	pkhbt		r0, r0, r12, lsl #16	;[3+6][4+5]	
	add			r12, r2, r7	
	smusdx		r0, r0, r11
	add			r12, r12, r12, lsl #1
	add			r12, r0, r12
	sub			r12, r12, r1
	sub			r12, r12, r8
	add			r12, r12, #$CONST			;16-rd	
	if $Va_up > 0	
	if $Up > 0		
	strb		r5, [r9, #72]
	else
	strb		r4, [r9, #72]	
	endif	
	endif
	ldr		r0, [sp, #0]		;src+=1		
	usat		r12, #8, r12, asr #5	;C = C>>5; C = (C < 0 ? 0: (C > 255 ? 255: C));

	ldr		r14, [sp, #8]		;SrcStride				
	strb		r12, [r9, #64]
	
	ldr			r9, [sp, #16]			;nHeight	
	;r0 = src ;r14 = SrcStride	
	add			r0, r0, #1
	str		r0, [sp, #0]		;src+=1	
	subs        r9, r9, #1
	strne		r9, [sp, #16]		;nHeight
		
  mend	
    
	EXPORT Arm11InterQ8
Arm11InterQ8 PROC
;qpel_v_8x8(VO_U8 *Src, VO_U8 *Dst, VO_S32 SrcStride, VO_S32 DstStride, VO_S32 nHeight, VO_S32 rd)
; 53   : {
	stmdb       sp!, {r4 - r12, lr}
	sub			sp, sp,	#152
	ldr         r9, [sp, #192]		;nHeight	
	ldr         r10, [sp, #196]		;rd
 	
	str			r0, [sp, #0]			;Src
	str			r1, [sp, #4]			;Dst
	str			r2, [sp, #8]			;SrcStride
	str			r3, [sp, #12]			;DstStride
	str			r9, [sp, #16]			;nHeight
	mov			r14, r2
	
	cmp			r10, #1
	bne			Arm11InterQ8_rd0	
		
	
Arm11InterQ8_loop
  v_loop_code 0, 0, 15
	bne         Arm11InterQ8_loop
		 
	add			r0, sp, #24		 	 
	ldr			r14, [sp, #4]			;Dst
	

;1,2;3,4
	ldrd		r2, [r0], #16
	ldr			r12, [sp, #12]			;DstStride	
	ldrd		r4, [r0], #16
	strd		r2, [r14], r12		
	ldrd		r6, [r0], #16
	strd		r4, [r14], r12	
	ldrd		r8, [r0], #16			
	strd		r6, [r14], r12	
		
;5,6;7,8	
	ldrd		r2, [r0], #16
	strd		r8, [r14], r12	
	ldrd		r4, [r0], #16
	strd		r2, [r14], r12		
	ldrd		r6, [r0], #16
	strd		r4, [r14], r12		
	ldrd		r8, [r0], #16			
	strd		r6, [r14], r12	
	add         sp, sp, #152	
	strd		r8, [r14], r12		
	

	ldmia       sp!, {r4 - r12, pc}
	
Arm11InterQ8_rd0	
	
Arm11InterQ8_loop_rd0

  v_loop_code 0, 0, 16

	bne         Arm11InterQ8_loop_rd0
	
	add			r0, sp, #24		 	 
	ldr			r14, [sp, #4]			;Dst
	
	
	
;1,2;3,4
	ldrd		r2, [r0], #16
	ldr			r12, [sp, #12]			;DstStride	
	ldrd		r4, [r0], #16
	strd		r2, [r14], r12		
	ldrd		r6, [r0], #16
	strd		r4, [r14], r12	
	ldrd		r8, [r0], #16			
	strd		r6, [r14], r12	
		
;5,6;7,8	
	ldrd		r2, [r0], #16
	strd		r8, [r14], r12	
	ldrd		r4, [r0], #16
	strd		r2, [r14], r12		
	ldrd		r6, [r0], #16
	strd		r4, [r14], r12		
	ldrd		r8, [r0], #16			
	strd		r6, [r14], r12	
	add         sp, sp, #152	
	strd		r8, [r14], r12		
	

	ldmia       sp!, {r4 - r12, pc}

	ENDP  ;
		
	
	
	EXPORT Arm11InterQ4
Arm11InterQ4 PROC
;qpel_va_8x8(VO_U8 *Src, VO_U8 *Dst, VO_S32 SrcStride, VO_S32 DstStride, VO_S32 nHeight, VO_S32 rd)
; 53   : {
	stmdb       sp!, {r4 - r12, lr}
	sub			sp, sp,	#152
	ldr         r9, [sp, #192]		;nHeight	
	ldr         r10, [sp, #196]		;rd
 	
	str			r0, [sp, #0]			;Src
	str			r1, [sp, #4]			;Dst
	str			r2, [sp, #8]			;SrcStride
	str			r3, [sp, #12]			;DstStride
	str			r9, [sp, #16]			;nHeight
	mov			r14, r2
	
	cmp			r10, #1
	bne			Arm11InterQ4_rd0	
		
	
Arm11InterQ4_loop

  v_loop_code 1, 0, 15
  
	bne         Arm11InterQ4_loop

	add			r0, sp, #24		 
	ldr			r14, [sp, #4]			;Dst

;1,2
	ldrd		r4, [r0, #8]
	ldrd		r2, [r0], #16
	ldr			r12, [sp, #12]			;DstStride	
	ldrd		r8, [r0, #8]
	ldrd		r6, [r0], #16		
	
	uhadd8		r2, r2, r4	
	uhadd8		r3, r3, r5	
	uhadd8		r6, r6, r8	
	uhadd8		r7, r7, r9
	strd		r2, [r14], r12	
	
;3,4	
	ldrd		r4, [r0, #8]
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]
	ldrd		r6, [r0], #16			
	
	uhadd8		r2, r2, r4	
	uhadd8		r3, r3, r5	
	uhadd8		r6, r6, r8	
	uhadd8		r7, r7, r9
	strd		r2, [r14], r12	
		
;5,6	
	ldrd		r4, [r0, #8]
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]
	ldrd		r6, [r0], #16		
	
	uhadd8		r2, r2, r4	
	uhadd8		r3, r3, r5	
	uhadd8		r6, r6, r8	
	uhadd8		r7, r7, r9
	strd		r2, [r14], r12	
	
;7,8		  
	ldrd		r4, [r0, #8]
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]
	ldrd		r6, [r0], #16		
	
	uhadd8		r2, r2, r4	
	uhadd8		r3, r3, r5	
	uhadd8		r6, r6, r8	

	strd		r2, [r14], r12
	uhadd8		r7, r7, r9	
	add         sp, sp, #152		
	strd		r6, [r14], r12		
	

	ldmia       sp!, {r4 - r12, pc}
	
Arm11InterQ4_rd0	
	
Arm11InterQ4_loop_rd0

  v_loop_code 1, 0, 16
  
	bne         Arm11InterQ4_loop_rd0
		 
	ldr			r14, [sp, #4]			;Dst
	
	add			r0, sp, #24
;	mov			r10, #1

	
;1,2
	ldrd		r4, [r0, #8]
	ldrd		r2, [r0], #16
;	orr	r10, r10, r10, lsl #8
	ldr			r12, [sp, #12]			;DstStride	
;	orr	r10, r10, r10, lsl #16		
	ldrd		r8, [r0, #8]
	
;	uqadd8		r4, r4, r10
;	uqadd8		r5, r5, r10	
;	uqadd8		r8, r8, r10
;	uqadd8		r9, r9, r10	
			
;	uhadd8		r2, r2, r4	
;	uhadd8		r3, r3, r5	
;	uhadd8		r6, r6, r8	
;	uhadd8		r7, r7, r9

	uhsub8	r2, r4, r2
	uhsub8	r3, r5, r3
	ldrd		r6, [r0], #16		
	usub8	r2, r4, r2
	usub8	r3, r5, r3
	
	uhsub8	r6, r8, r6
	strd		r2, [r14], r12	
	uhsub8	r7, r9, r7
	ldrd		r4, [r0, #8]
	usub8	r6, r8, r6
	usub8	r7, r9, r7
	
;3,4	
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]
	
;	uqadd8		r4, r4, r10
;	uqadd8		r5, r5, r10	
;	uqadd8		r8, r8, r10
;	uqadd8		r9, r9, r10	
	
;	uhadd8		r2, r2, r4	
;	uhadd8		r3, r3, r5	
;	uhadd8		r6, r6, r8	
;	uhadd8		r7, r7, r9

	uhsub8	r2, r4, r2
	uhsub8	r3, r5, r3
	ldrd		r6, [r0], #16			
	usub8	r2, r4, r2
	usub8	r3, r5, r3

	uhsub8	r6, r8, r6
	strd		r2, [r14], r12	
	uhsub8	r7, r9, r7
	ldrd		r4, [r0, #8]
	usub8	r6, r8, r6
	usub8	r7, r9, r7

		
;5,6	
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]

;	uqadd8		r4, r4, r10
;	uqadd8		r5, r5, r10	
;	uqadd8		r8, r8, r10
;	uqadd8		r9, r9, r10	
		
;	uhadd8		r2, r2, r4	
;	uhadd8		r3, r3, r5	
;	uhadd8		r6, r6, r8	
;	uhadd8		r7, r7, r9

	uhsub8	r2, r4, r2
	uhsub8	r3, r5, r3
	ldrd		r6, [r0], #16		
	usub8	r2, r4, r2
	usub8	r3, r5, r3
	
	uhsub8	r6, r8, r6
	strd		r2, [r14], r12	
	uhsub8	r7, r9, r7
	ldrd		r4, [r0, #8]
	usub8	r6, r8, r6
	usub8	r7, r9, r7

;7,8		  
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]

;	uqadd8		r4, r4, r10
;	uqadd8		r5, r5, r10	
;	uqadd8		r8, r8, r10
;	uqadd8		r9, r9, r10	
		
;	uhadd8		r2, r2, r4	
;	uhadd8		r3, r3, r5	
;	uhadd8		r6, r6, r8	
;	uhadd8		r7, r7, r9

	uhsub8	r2, r4, r2
	uhsub8	r3, r5, r3
	ldrd		r6, [r0], #16		
	usub8	r2, r4, r2
	usub8	r3, r5, r3
	strd		r2, [r14], r12
	
	uhsub8	r6, r8, r6
	uhsub8	r7, r9, r7
	usub8	r2, r8, r6
	usub8	r3, r9, r7
	
	add         sp, sp, #152		
	strd		r2, [r14], r12		

	ldmia       sp!, {r4 - r12, pc}

	ENDP  ;

	
	EXPORT Arm11InterQ12
Arm11InterQ12 PROC
;qpel_va_up_8x8(VO_U8 *Src, VO_U8 *Dst, VO_S32 SrcStride, VO_S32 DstStride, VO_S32 nHeight, VO_S32 rd)
; 53   : {
	stmdb       sp!, {r4 - r12, lr}
	sub			sp, sp,	#152
	ldr         r9, [sp, #192]		;nHeight	
	ldr         r10, [sp, #196]		;rd
 	
	str			r0, [sp, #0]			;Src
	str			r1, [sp, #4]			;Dst
	str			r2, [sp, #8]			;SrcStride
	str			r3, [sp, #12]			;DstStride
	str			r9, [sp, #16]			;nHeight
	mov			r14, r2
	
	cmp			r10, #1
	bne			Arm11InterQ12_rd0	

	
Arm11InterQ12_loop

  v_loop_code 1, 1, 15
  
	bne         Arm11InterQ12_loop

	add			r0, sp, #24		 
	ldr			r14, [sp, #4]			;Dst

;1,2
	ldrd		r4, [r0, #8]
	ldrd		r2, [r0], #16
	ldr			r12, [sp, #12]			;DstStride	
	ldrd		r8, [r0, #8]
	ldrd		r6, [r0], #16		
	
	uhadd8		r2, r2, r4	
	uhadd8		r3, r3, r5	
	uhadd8		r6, r6, r8	
	uhadd8		r7, r7, r9
	strd		r2, [r14], r12	
	
;3,4	
	ldrd		r4, [r0, #8]
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]
	ldrd		r6, [r0], #16			
	
	uhadd8		r2, r2, r4	
	uhadd8		r3, r3, r5	
	uhadd8		r6, r6, r8	
	uhadd8		r7, r7, r9
	strd		r2, [r14], r12	
		
;5,6	
	ldrd		r4, [r0, #8]
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]
	ldrd		r6, [r0], #16		
	
	uhadd8		r2, r2, r4	
	uhadd8		r3, r3, r5	
	uhadd8		r6, r6, r8	
	uhadd8		r7, r7, r9
	strd		r2, [r14], r12	
	
;7,8		  
	ldrd		r4, [r0, #8]
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]
	ldrd		r6, [r0], #16		
	
	uhadd8		r2, r2, r4	
	uhadd8		r3, r3, r5	
	uhadd8		r6, r6, r8
	strd		r2, [r14], r12		
	uhadd8		r7, r7, r9
	add         sp, sp, #152		
	strd		r6, [r14], r12		

	ldmia       sp!, {r4 - r12, pc}
	
Arm11InterQ12_rd0	
	
Arm11InterQ12_loop_rd0

  v_loop_code 1, 1, 16
  
	bne         Arm11InterQ12_loop_rd0
		 
	ldr			r14, [sp, #4]			;Dst

	
	add			r0, sp, #24	
;	mov			r10, #1	
	
;1,2
	ldrd		r4, [r0, #8]
	ldrd		r2, [r0], #16
;	orr	r10, r10, r10, lsl #16			
	ldr			r12, [sp, #12]			;DstStride
;	orr	r10, r10, r10, lsl #8
	ldrd		r8, [r0, #8]		
	
;	uqadd8		r4, r4, r10
;	uqadd8		r5, r5, r10	
;	uqadd8		r8, r8, r10
;	uqadd8		r9, r9, r10	
			
;	uhadd8		r2, r2, r4	
;	uhadd8		r3, r3, r5	
;	uhadd8		r6, r6, r8	
;	uhadd8		r7, r7, r9

	uhsub8	r2, r4, r2
	uhsub8	r3, r5, r3
	ldrd		r6, [r0], #16		
	usub8	r2, r4, r2
	usub8	r3, r5, r3
	
	uhsub8	r6, r8, r6
	strd		r2, [r14], r12	
	uhsub8	r7, r9, r7
	ldrd		r4, [r0, #8]
	usub8	r6, r8, r6
	usub8	r7, r9, r7

	
;3,4	
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]
	
;	uqadd8		r4, r4, r10
;	uqadd8		r5, r5, r10	
;	uqadd8		r8, r8, r10
;	uqadd8		r9, r9, r10	
	
;	uhadd8		r2, r2, r4	
;	uhadd8		r3, r3, r5	
;	uhadd8		r6, r6, r8	
;	uhadd8		r7, r7, r9

	uhsub8	r2, r4, r2
	uhsub8	r3, r5, r3
	ldrd		r6, [r0], #16			
	usub8	r2, r4, r2
	usub8	r3, r5, r3
	
	uhsub8	r6, r8, r6
	strd		r2, [r14], r12	
	uhsub8	r7, r9, r7
	ldrd		r4, [r0, #8]
	usub8	r6, r8, r6
	usub8	r7, r9, r7

		
;5,6	
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]

;	uqadd8		r4, r4, r10
;	uqadd8		r5, r5, r10	
;	uqadd8		r8, r8, r10
;	uqadd8		r9, r9, r10	
		
;	uhadd8		r2, r2, r4	
;	uhadd8		r3, r3, r5	
;	uhadd8		r6, r6, r8	
;	uhadd8		r7, r7, r9

	uhsub8	r2, r4, r2
	uhsub8	r3, r5, r3
	ldrd		r6, [r0], #16		
	usub8	r2, r4, r2
	usub8	r3, r5, r3
	
	uhsub8	r6, r8, r6
	strd		r2, [r14], r12	
	uhsub8	r7, r9, r7
	ldrd		r4, [r0, #8]
	usub8	r6, r8, r6
	usub8	r7, r9, r7

	
;7,8		  
	ldrd		r2, [r0], #16
	strd		r6, [r14], r12	
	ldrd		r8, [r0, #8]

;	uqadd8		r4, r4, r10
;	uqadd8		r5, r5, r10	
;	uqadd8		r8, r8, r10
;	uqadd8		r9, r9, r10	
		
;	uhadd8		r2, r2, r4	
;	uhadd8		r3, r3, r5	
;	uhadd8		r6, r6, r8
;	uhadd8		r7, r7, r9

	uhsub8	r2, r4, r2
	uhsub8	r3, r5, r3
	ldrd		r6, [r0], #16		
	usub8	r2, r4, r2
	usub8	r3, r5, r3
	strd		r2, [r14], r12		
	
	uhsub8	r6, r8, r6
	uhsub8	r7, r9, r7
	usub8	r2, r8, r6
	usub8	r3, r9, r7

	add         sp, sp, #152		
	strd		r2, [r14], r12		
	

	ldmia       sp!, {r4 - r12, pc}

	ENDP  ;				
	END
