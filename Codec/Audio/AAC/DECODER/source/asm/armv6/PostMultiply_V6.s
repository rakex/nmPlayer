	INCLUDE LDRDATA.H

	IMPORT	|AAD_srtidata81|
	IMPORT	|AAD_srtdata67|
	IMPORT	|AAD_srtidata82|
	
	EXPORT	|AAD_srtidata514|

	AREA	|.text|, CODE, READONLY

|AAD_srtidata514| PROC
	stmdb     sp!, {r4 - r11, lr}
|$M2907|
	mov       r5, r1
	mov       r2, r0
	ldr       r0, |$L2910| + 8
	ldr       r3, |$L2910| + 4
	ldr       r4, [r0, +r2, lsl #2]
	ldr       r0, |$L2910|

	;ldrd      r10, [r3, #0]
	LOAD_DATA	r10, r11, r3, #0
	add       r1, r5, r4, lsl #2
	ldr       r2, [r0, +r2, lsl #2]

	movs      r12, r4, asr #2
	mov       r7, r2, lsl #2
	sub       r4, r1, #8
	add		  r7, r7, #4		
	add       r6, r3, r7
	sub       r9, r10, r11, lsl #1
	beq       |$L2276|	
|$L2274|
	ldrd	  r0, [r5, #0]
	ldrd      r2, [r4, #0]	
	add		  lr, r0, r1
	smmul	  r8, lr, r11
	rsb		  r3, r3, #0
	smmls	  r1, r10, r1, r8
	;ldrd	  r10, [r6, #0]
	LOAD_DATA	r10, r11, r6, #0
	smmla	  r0, r9, r0, r8
	add		  lr, r3, r2
	sub		  r9, r10, r11, lsl #1 	
	smmul	  r8, lr, r11
	add		  r6, r6, r7
	mov		  lr, r1
	smmla     r1, r2, r9, r8
	smmls	  r2, r3, r10, r8
	mov		  r3, lr
	strd	  r0, [r5, #0]		
	strd	  r2, [r4, #0]	
	add		  r5, r5, #8
	sub       r12, r12, #1	
	sub		  r4, r4, #8
	cmp       r12, #0
	bhi       |$L2274|	
|$L2276|
	ldmia     sp!, {r4 - r11, pc}
|$L2910|
	DCD       |AAD_srtidata82|
	DCD       |AAD_srtdata67|
	DCD       |AAD_srtidata81|
|$M2908|

	ENDP  ; |AAD_srtidata514|

	EXPORT	|AAD_srtidata515|

	AREA	|.text|, CODE, READONLY

|AAD_srtidata515| PROC
	stmdb     sp!, {r4 - r11, lr}
	sub       sp, sp, #8 
|$M3907|
	str       r2, [sp, #0]
	mov       r5, r1
	mov       r2, r0
	ldr       r0, |$L3910| + 8
	ldr       r3, |$L3910| + 4
	ldr       r4, [r0, +r2, lsl #2]
	ldr       r0, |$L3910|

	;ldrd      r10, [r3, #0]
	LOAD_DATA r10, r11, r3, #0
	add       r1, r5, r4, lsl #2
	ldr       r2, [r0, +r2, lsl #2]

	movs      r12, r4, asr #2
	mov       r7, r2, lsl #2
	sub       r4, r1, #8
	add		  r7, r7, #4		
	add       r6, r3, r7
	sub       r9, r10, r11, lsl #1
	beq       |$L3276|	
|$L3274|
	ldrd	  r0, [r5, #0]
	ldrd      r2, [r4, #0]	
	add		  lr, r0, r1
	smmul	  r8, lr, r11
	rsb		  r3, r3, #0
	smmls	  r1, r10, r1, r8
	;ldrd	  r10, [r6, #0]
	LOAD_DATA r10, r11, r6, #0
	smmla	  r0, r9, r0, r8
	add		  lr, r3, r2
	sub		  r9, r10, r11, lsl #1 	
	smmul	  r8, lr, r11
	add		  r6, r6, r7
	mov		  lr, r1
	smmla     r1, r2, r9, r8
	smmls	  r2, r3, r10, r8
	mov		  r3, lr
	ldr       r8, [sp, #0]
	mov       r0, r0, lsl r8
	mov       r1, r1, lsl r8
	mov       r2, r2, lsl r8
	mov       r3, r3, lsl r8
	ssat	  r0, #30, r0
	ssat	  r1, #30, r1
	ssat	  r2, #30, r2
	ssat	  r3, #30, r3
	strd	  r0, [r5, #0]		
	strd	  r2, [r4, #0]	
	add		  r5, r5, #8
	sub       r12, r12, #1
	sub		  r4, r4, #8	
	cmp       r12, #0
	bhi       |$L3274|	
|$L3276|
	add       sp, sp, #8 
	ldmia     sp!, {r4 - r11, pc}
|$L3910|
	DCD       |AAD_srtidata82|
	DCD       |AAD_srtdata67|
	DCD       |AAD_srtidata81|
|$M3908|

	ENDP  ; |AAD_srtidata515|
	END