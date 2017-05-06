;************************************************************************
;																		*
;	VisualOn, Inc. Confidential and Proprietary, 2005		            *
;																		*
;***********************************************************************/

;R0 src
;R1 dst
;R2 srcpitch
;R3 dstpitch

	AREA	|.text|, CODE

  macro 
  GenCodeCpy $Name,$Sub,$Round,$Add,$Fast,$ARM5,$ARMv6, $ARM11

	align 16
	export $Name
$Name proc
	stmdb	sp!, {r4 - r12, lr}
	if $Fast>0	  
	if $ARM11>0
	$Sub	$Name.0_v11,0,$Round,$Add,0
	else
	movs	r4,r0,lsl #30
	beq		$Name.LAB4
	cmps	r4,#0x80000000
	beq		$Name.LAB2
	bhi		$Name.LAB3
$Name.LAB1
	bic		r0,r0,#3
	$Sub	$Name.8,8,$Round,$Add,$ARMv6
$Name.LAB2	
	bic		r0,r0,#3
	$Sub	$Name.16,16,$Round,$Add,$ARMv6
$Name.LAB3	
	bic		r0,r0,#3
	$Sub	$Name.24,24,$Round,$Add,$ARMv6
$Name.LAB4	
	$Sub	$Name.0,0,$Round,$Add,$ARMv6
	endif
	else
	$Sub	$Name.s,-1,$Round,$Add,$ARMv6
	endif
	endp
  mend


;------------------------------------------
;BArmInter8x4
;------------------------------------------

  macro
  CpyBlkRArm $ARMv6,$Pos
	if $Pos > 0
	  ldr	r5,[r0,#8]
	  ldr	r6,[r0,#4]
	  ldr	r4,[r0],r2
	  ldr	r9,[r0,#8]
	  ldr	r10,[r0,#4]
	  ldr	r8,[r0],r2  		
	  mov	r5,r5,lsl #32-$Pos
	  mov	r4,r4,lsr #$Pos
	  orr	r5,r5,r6,lsr #$Pos
	  orr	r4,r4,r6,lsl #32-$Pos
	  mov	r9,r9,lsl #32-$Pos
	  mov	r8,r8,lsr #$Pos
	  orr	r9,r9,r10,lsr #$Pos
	  orr	r8,r8,r10,lsl #32-$Pos	  
	  str	r5,[r1,#4]
	  str	r4,[r1],r3
	  str	r9,[r1,#4]
	  str	r8,[r1],r3

	  
	  ldr	r5,[r0,#8]
	  ldr	r6,[r0,#4]
	  ldr	r4,[r0],r2
	  ldr	r9,[r0,#8]
	  ldr	r10,[r0,#4]
	  ldr	r8,[r0],r2	  		
	  mov	r5,r5,lsl #32-$Pos
	  mov	r4,r4,lsr #$Pos
	  orr	r5,r5,r6,lsr #$Pos
	  orr	r4,r4,r6,lsl #32-$Pos
	  mov	r9,r9,lsl #32-$Pos
	  mov	r8,r8,lsr #$Pos
	  orr	r9,r9,r10,lsr #$Pos
	  orr	r8,r8,r10,lsl #32-$Pos	  
	  str	r5,[r1,#4]
	  str	r4,[r1],r3
	  str	r9,[r1,#4]
	  str	r8,[r1],r3  
	  subs	r12, r12, #4	   	  
	else
		ldr		r5,[r0,#4]
		ldr		r4,[r0],r2	
		ldr		r7,[r0,#4]
		ldr		r6,[r0],r2	
		ldr		r9,[r0,#4]
		ldr		r8,[r0],r2
		ldr		r11,[r0,#4]
		ldr		r10,[r0],r2		  
		subs	r12, r12, #4		  		  	  	  
		str		r5,[r1,#4]
		str		r4,[r1],r3
		str		r7,[r1,#4]
		str		r6,[r1],r3
		str		r9,[r1,#4]
		str		r8,[r1],r3
		str		r11,[r1,#4]
		str		r10,[r1],r3	  		  		  		  
	endif
  mend

  macro
  BArmInter8x4 $Id, $Pos, $Round, $Add, $ARMv6

	ldr		r12, [sp, #40]
$Id.loop_again
;	pld [r0,r2]
	CpyBlkRArm $ARMv6,$Pos 
	bne		$Id.loop_again
	ldmia	sp!, {r4 - r12, pc}
  mend

;------------------------------------------
;BArmInter2_8x4 
;------------------------------------------

  macro
  arm_addblkRow $Pos, $ARMv6

	if $Pos > 0
	  ldr	r5,[r0,#8]
	  ldr	r6,[r0,#4]
	  ldr	r4,[r0],r2
		
	  mov	r5,r5,lsl #32-$Pos
	  mov	r4,r4,lsr #$Pos
	  orr	r5,r5,r6,lsr #$Pos
	  orr	r4,r4,r6,lsl #32-$Pos
	else	
	  ldr	r5,[r0,#4]
	  ldr	r4,[r0],r2	  
	endif

   if $ARMv6 > 0
	ldrd	r6,[r1] 
	uqadd8  r4, r4, r14
	uqadd8  r5, r5, r14	
	uhadd8	r6, r6, r4
	uhadd8	r7, r7, r5	

	strd	r6,[r1], r3  
		  			  		  		  	  		  		  
  else	
	ldr		r7,[r1,#4]
	ldr		r6,[r1]
	
	and		r9,r12,r5,lsr #1
	and		r8,r12,r4,lsr #1
	orr		r5,r7,r5
	orr		r4,r6,r4
	and		r7,r12,r7,lsr #1
	and		r6,r12,r6,lsr #1
	add		r7,r7,r9
	add		r6,r6,r8
	and		r5,r5,r14
	and		r4,r4,r14
	add		r7,r7,r5
	add		r6,r6,r4

	str		r7,[r1,#4]
	str		r6,[r1],r3		
   endif	  	

  mend

  macro
  BArmInter2_8x4  $Id, $Pos, $Round, $Add, $ARMv6

;	PldBI $ARM5,$Pos
	ldr		r14,$Id.LABM

	ldr		r11, [sp, #40]

;	mov		r11,#8
	mvn		r12,r14,lsl #7

$Id.LABLOOP
;	pld [r0,r2]
	arm_addblkRow $Pos, $ARMv6
	subs r11,r11,#1 
	bne  $Id.LABLOOP

	ldmia	sp!, {r4 - r12, pc}
$Id.LABM dcd 0x01010101
  mend
  
;------------------------------------------
; BArmInter8x4H
;------------------------------------------

  macro
  LoadHorRow $Id, $Pos, $ARMv6

    ; result is r4,r5 and r8,r9 (one pixel to the right)
    ; r6,r7 can be used

    ldr		r5,[r0,#4]
    ldr		r6,[r0,#8]
    ldr		r4,[r0],r2

    if $Pos+8 < 32
	  mov	r9,r5,lsr #$Pos+8
	  mov	r8,r4,lsr #$Pos+8
	  orr	r9,r9,r6,lsl #32-$Pos-8
	  orr	r8,r8,r5,lsl #32-$Pos-8
    else
	  mov	r8,r5
	  mov	r9,r6
    endif

	if $Pos > 0
	  mov	r4,r4,lsr #$Pos
	  mov	r6,r6,lsl #32-$Pos
	  orr	r4,r4,r5,lsl #32-$Pos
	  orr	r5,r6,r5,lsr #$Pos
	endif
	
  mend

  macro
  CopyHorRow $Id, $Pos, $Round, $Add, $ARMv6

;r14 01010101
;r12 7f7f7f7f

	LoadHorRow	$Id,$Pos, $ARMv6
	if $ARMv6>0
	
	if $Round>0
	else
	uqadd8  r4, r4, r14
	uqadd8  r5, r5, r14	
	endif
	
	uhadd8	r4, r4, r8
	uhadd8	r5, r5, r9
	
	if $Add>0
	  ldr	r7,[r1,#4]
	  ldr	r6,[r1]

	uqadd8  r4, r4, r14
	uqadd8  r5, r5, r14		  
	uhadd8	r4, r4, r6
	uhadd8	r5, r5, r7	
	
	endif	
	  strd	r4,[r1],r3
	  	
	else
	
	and		r6,r12,r4,lsr #1
	and		r7,r12,r5,lsr #1
	if $Round>0
	  and	r4,r4,r8
	  and	r5,r5,r9
	else
	  orr	r4,r4,r8
	  orr	r5,r5,r9
	endif

	and		r8,r12,r8,lsr #1
	and		r9,r12,r9,lsr #1

	and		r4,r4,r14
	and		r5,r5,r14

	add		r4,r4,r6
	add		r5,r5,r7
	add		r4,r4,r8
	add		r5,r5,r9
	
	if $Add>0
	  ldr	r7,[r1,#4]
	  ldr	r6,[r1]
	  
	  and	r9,r12,r5,lsr #1
	  and	r8,r12,r4,lsr #1
	  orr	r5,r7,r5
	  orr	r4,r6,r4
	  and	r7,r12,r7,lsr #1
	  and	r6,r12,r6,lsr #1
	  add	r7,r7,r9
	  add	r6,r6,r8
	  and	r5,r5,r14
	  and	r4,r4,r14
	  add	r5,r7,r5
	  add	r4,r6,r4
	endif	
	  str	r5,[r1,#4]
	  str	r4,[r1],r3
	  
	endif	  

  mend

  macro
  BArmInter8x4H $Id, $Pos, $Round, $Add, $ARMv6

	if $ARMv6>0
		ldr		r14,$Id.LABM_ARMv6
		ldr		r11, [sp, #40]
;		mvn		r12,r14,lsl #7

$Id.LABLOOP_ARMv6
;		pld [r0,r2]
		CopyHorRow_ARMv6 $Id,$Pos,$Round,$Add, $ARMv6
;		subs r11,r11,#1
		bne  $Id.LABLOOP_ARMv6
		ldmia	sp!, {r4 - r12, pc}
$Id.LABM_ARMv6 dcd 0x01010101
		  
	else	  
;		PldBI $ARM5,$Pos
		ldr		r14,$Id.LABM
		ldr		r11, [sp, #40]

;		mov		r11,#8
		mvn		r12,r14,lsl #7
$Id.LABLOOP
		pld [r0,r2]
		CopyHorRow $Id,$Pos,$Round,$Add, $ARMv6
		subs r11,r11,#1
		bne  $Id.LABLOOP

		ldmia	sp!, {r4 - r12, pc}
$Id.LABM dcd 0x01010101
	endif
  mend

  macro
  LoadHorRow_ARMv6 $Id, $Pos, $ARMv6

    ; result is r4,r5 and r8,r9 (one pixel to the right)
    ; r6,r7 can be used

    	ldr	r5,[r0,#4]
    	ldr	r6,[r0,#8]
    	ldr	r4,[r0],r2
	subs	r11,r11,#1
    if $Pos+8 < 32
	  mov	r9,r5,lsr #$Pos+8
	  orr	r9,r9,r6,lsl #32-$Pos-8
	  mov	r8,r4,lsr #$Pos+8	  
	  orr	r8,r8,r5,lsl #32-$Pos-8
    else
	  mov	r8,r5
	  mov	r9,r6
    endif

	if $Pos > 0
	  mov	r4,r4,lsr #$Pos
	  mov	r6,r6,lsl #32-$Pos
	  orr	r4,r4,r5,lsl #32-$Pos
	  orr	r5,r6,r5,lsr #$Pos
	endif
	
  mend

  macro
  CopyHorRow_ARMv6 $Id, $Pos, $Round, $Add, $ARMv6

;r14 01010101
;r12 7f7f7f7f

	LoadHorRow_ARMv6	$Id,$Pos, $ARMv6
	
	if $Round>0
	else
		uqadd8  r4, r4, r14
		uqadd8  r5, r5, r14	
	endif
	
		uhadd8	r4, r4, r8
		uhadd8	r5, r5, r9
	
	if $Add>0
		ldrd	r6,[r1]
		uqadd8  r4, r4, r14
		uqadd8  r5, r5, r14		  
		uhadd8	r4, r4, r6
		uhadd8	r5, r5, r7	
	endif	
	  strd	r4,[r1],r3
  mend
;------------------------------------------
; BArmInter8x4V
;------------------------------------------

  macro
  LoadVerRow $Id, $Pos, $Parity, $ARMv6
  if $Parity>0
    ; result is r8,r9 (r10=r8>>1,r11=r9>>1) 
    ; r10,r11 can be used
    if $Pos > 0
	  ldr	r9,[r0,#8]
	  ldr	r10,[r0,#4]
	  ldr	r8,[r0],r2

	  mov	r9,r9,lsl #32-$Pos
	  mov	r8,r8,lsr #$Pos
	  orr	r9,r9,r10,lsr #$Pos
	  orr	r8,r8,r10,lsl #32-$Pos
    else
	  ldr	r9,[r0,#4]
	  ldr	r8,[r0],r2
    endif
	if $ARMv6>0
	else    
	and		r11,r12,r9,lsr #1
	and		r10,r12,r8,lsr #1
	endif
  else
    ; result is r4,r5 (r6=r4>>1,r7=r5>>1) 
    ; r6,r7 can be used

    if $Pos > 0
	  ldr	r5,[r0,#8]
	  ldr	r6,[r0,#4]
	  ldr	r4,[r0],r2

	  mov	r5,r5,lsl #32-$Pos
	  mov	r4,r4,lsr #$Pos
	  orr	r5,r5,r6,lsr #$Pos
	  orr	r4,r4,r6,lsl #32-$Pos
    else 
	  ldr	r5,[r0,#4]
	  ldr	r4,[r0],r2    
    endif
	if $ARMv6>0 
	else  	   
	and		r7,r12,r5,lsr #1
	and		r6,r12,r4,lsr #1
        endif    
  endif
  mend

  macro
  CopyVerRow $Id, $Pos, $Parity, $Round, $Add, $ARMv6

;r14 01010101
;r12 7f7f7f7f

	LoadVerRow $Id,$Pos,$Parity, $ARMv6
	if $ARMv6>0 

		if $Round>0
		else
		uqadd8  r4, r4, r14
		uqadd8  r5, r5, r14	
		endif
	
		uhadd8	r4, r4, r8
		uhadd8	r5, r5, r9
	
		if $Add>0
	  	ldrd	r10,[r1]

		uqadd8  r4, r4, r14
		uqadd8  r5, r5, r14		  
		uhadd8	r4, r4, r10
		uhadd8	r5, r5, r11				
		endif	
	  	strd	r4,[r1],r3  
	else
		if $Round>0
	    	and	r4,r4,r8
	    	and	r5,r5,r9
	  	else
	    	orr	r4,r4,r8
	    	orr	r5,r5,r9
	  	endif
	  	and	r4,r4,r14
	  	and	r5,r5,r14

	  	add	r4,r4,r6
	  	add	r5,r5,r7

  	  	add	r4,r4,r10
	  	add	r5,r5,r11

	  	if $Add>0
	    	ldr	r7,[r1,#4]
	    	ldr	r6,[r1]
	    	and	r3,r12,r5,lsr #1
		orr r5,r7,r5
		and	r7,r12,r7,lsr #1
		add r7,r7,r3
		and	r3,r12,r4,lsr #1
		orr r4,r6,r4
		and	r6,r12,r6,lsr #1
		add r6,r6,r3
		and r5,r5,r14
		and r4,r4,r14
		add r5,r5,r7
		add r4,r4,r6
		ldr	r3,[sp, #4]		;			
		ldr	r7,[sp]		;end src for loop compare
		str	r5,[r1,#4]
		str	r4,[r1],r3
		else
		ldr	r7,[sp]		;end src for loop compare
		str	r5,[r1,#4]
		str	r4,[r1],r3
		endif
	endif    	
  mend


  macro
  BArmInter8x4V $Id, $Pos, $Round, $Add, $ARMv6

     if $ARMv6>0
	ldr		r4, [sp, #40]
	mul		r4, r2, r4
	ldr		r14,$Id.LABM_ARMv6
	add		r4, r4, r0
	mov		r7, r4
	mov		r2, r2,lsr #1
	;add		r7, r4, r2, lsr #2	
$Id.LABLOOP_ARMv6
	LoadVerRow_ARMv6 $Id,$Pos,0, $ARMv6
	CopyVerRow_ARMv6 $Id,$Pos,1,$Round,$Add, $ARMv6

	cmp		r0,r7
	bne		$Id.LABLOOP_ARMv6
	ldmia	sp!, {r4 - r12, pc}
$Id.LABM_ARMv6 dcd 0x01010101
		  
      else
	  
	ldr		r4, [sp, #40]
	sub		sp,sp,#8
	mul		r4, r2, r4
	ldr		r14,$Id.LABM
	add		r4, r4, r0
	mov		r2, r2, lsr #1

	if $ARMv6>0 
	mov		r7,r4
	;add		r7,r4,r2,lsr #2	
	else  	   
	;add		r4,r4,r2,lsr #2
	str		r4,[sp]		;end src
	str		r3,[sp, #4]	
	endif 

	mvn		r12,r14,lsl #7
$Id.LABLOOP

	LoadVerRow $Id,$Pos,0, $ARMv6
	CopyVerRow $Id,$Pos,1,$Round,$Add, $ARMv6

	cmp		r0,r7
	bne		$Id.LABLOOP
	add		sp,sp,#8
	ldmia	sp!, {r4 - r12, pc}
$Id.LABM dcd 0x01010101
	endif
  mend


  macro
  LoadVerRow_ARMv6 $Id, $Pos, $Parity, $ARMv6
  if $Parity>0
    ; result is r8,r9 (r10=r8>>1,r11=r9>>1) 
    ; r10,r11 can be used
    if $Pos > 0
	  ldr	r9,[r0,#8]
	  ldr	r10,[r0,#4]
	  ldr	r8,[r0],r2

	  mov	r9,r9,lsl #32-$Pos
	  orr	r9,r9,r10,lsr #$Pos
	  mov	r8,r8,lsr #$Pos	  
	  orr	r8,r8,r10,lsl #32-$Pos
    else  
	  ;ldrd	r8,[r0],r2
	  ldr   r9,[r0,#4]
	  ldr   r8,[r0],r2
    endif
  else
    ; result is r4,r5 (r6=r4>>1,r7=r5>>1) 
    ; r6,r7 can be used

    if $Pos > 0
	  ldr	r5,[r0,#8]
	  ldr	r6,[r0,#4]
	  ;ldr	r4,[r0],r2
	  ldr	r4,[r0],r2

	  mov	r5,r5,lsl #32-$Pos
	  orr	r5,r5,r6,lsr #$Pos
	  mov	r4,r4,lsr #$Pos	  
	  orr	r4,r4,r6,lsl #32-$Pos
    else
	  ;ldrd	r4,[r0],r2
	  ldr   r5,[r0, #4]
	  ldr   r4,[r0],r2
    endif  
  endif
  mend

  macro
  CopyVerRow_ARMv6 $Id, $Pos, $Parity, $Round, $Add, $ARMv6

;r14 01010101
;r12 7f7f7f7f

    LoadVerRow_ARMv6 $Id,$Pos,$Parity, $ARMv6 
    if $Round>0
    else
	uqadd8  r4, r4, r14
	uqadd8  r5, r5, r14	
    endif
	
	uhadd8	r4, r4, r8
	uhadd8	r5, r5, r9
	
    if $Add>0
	ldrd	r10,[r1]

	uqadd8  r4, r4, r14
	uqadd8  r5, r5, r14		  
	uhadd8	r4, r4, r10
	uhadd8	r5, r5, r11				
    endif	
	strd	r4,[r1],r3  

  mend

;------------------------------------------
; BArmInter8x4HV
;------------------------------------------

; load needs r2,r3 for temporary (r2 is restored from stack)

  macro
  LoadHorVerRow $Id, $Pos, $Parity, $ARMv6
  if $Parity>0

	;read result r4,r5 and r2,r3 (one pixel to right)
	;r6,r7 can be used

    ldr		r5,[r0,#4]
    ldr		r6,[r0,#8]
    ldr		r4,[r0],r2

    if $Pos+8 < 32
	  mov	r3,r5,lsr #$Pos+8
	  mov	r2,r4,lsr #$Pos+8
	  orr	r3,r3,r6,lsl #32-$Pos-8
	  orr	r2,r2,r5,lsl #32-$Pos-8
    else
	  mov	r2,r5
	  mov	r3,r6
    endif

	if $Pos > 0
	  mov	r4,r4,lsr #$Pos
	  mov	r6,r6,lsl #32-$Pos
	  orr	r4,r4,r5,lsl #32-$Pos
	  orr	r5,r6,r5,lsr #$Pos
	endif

	and		r6,r2,r14
	and		r2,r12,r2,lsr #2
	and		r7,r4,r14
	and		r4,r12,r4,lsr #2
	add		r4,r4,r2
	add		r6,r6,r7

	and		r2,r3,r14
	and		r3,r12,r3,lsr #2
	and		r7,r5,r14
	and		r5,r12,r5,lsr #2
	add		r5,r5,r3
	add		r7,r2,r7
  else
	;read result r8,r9 and r2,r3 (one pixel to right)
	;r10,r11 can be used

    ldr		r9,[r0,#4]
    ldr		r10,[r0,#8]
    ldr		r8,[r0],r2

    if $Pos+8 < 32
	  mov	r3,r9,lsr #$Pos+8
	  mov	r2,r8,lsr #$Pos+8
	  orr	r3,r3,r10,lsl #32-$Pos-8
	  orr	r2,r2,r9,lsl #32-$Pos-8
    else
	  mov	r2,r9
	  mov	r3,r10
    endif

	if $Pos > 0
	  mov	r8,r8,lsr #$Pos
	  mov	r10,r10,lsl #32-$Pos
	  orr	r8,r8,r9,lsl #32-$Pos
	  orr	r9,r10,r9,lsr #$Pos
	endif

	and		r10,r2,r14
	and		r2,r12,r2,lsr #2
	and		r11,r8,r14
	and		r8,r12,r8,lsr #2
	add		r8,r8,r2
	add		r10,r10,r11

	and		r2,r3,r14
	and		r3,r12,r3,lsr #2
	and		r11,r9,r14
	and		r9,r12,r9,lsr #2
	add		r9,r9,r3
	add		r11,r2,r11
  endif
	ldr		r2,[sp]
  mend

  macro
  CopyHorVerRow $Id, $Pos, $Parity, $Round, $Add, $ARMv6

;r14 03030303
;r12 3f3f3f3f

	LoadHorVerRow $Id,$Pos,$Parity, $ARMv6

	if $Round>0
	  and r3,r14,r14,lsr #1		;0x01010101
	else
	  and r3,r14,r14,lsl #1		;0x02020202
	endif
	
	  add	r8,r8,r4
	  add	r9,r9,r5
	  add	r10,r10,r6
	  add	r11,r11,r7

	  add	r10,r10,r3
	  add	r11,r11,r3
	  and	r10,r14,r10,lsr #2
	  and	r11,r14,r11,lsr #2

	  if $Add>0
	    add	r8,r8,r10 
	    add	r9,r9,r11
		orr	r12,r12,r12,lsl #1  ;0x7F7F7F7F
	    ldr	r11,[r1,#4]
	    ldr	r10,[r1]
	    and	r3,r12,r9,lsr #1
		orr r9,r11,r9
	    and	r11,r12,r11,lsr #1
		add r11,r11,r3
	    and	r3,r12,r8,lsr #1
		orr r8,r10,r8
	    and	r10,r12,r10,lsr #1
		add r10,r10,r3
		and r3,r14,r14,lsr #1 ;0x01010101
		mvn	r12,r14,lsl #6    ;restore r12
		and r9,r9,r3
		and r8,r8,r3
		add r11,r11,r9
	    str	r11,[r1,#4]	
	    ldr	r11,[sp,#8]  ;dstpitch	    	
		add r10,r10,r8
	    ldr	r3,[sp,#4]	;end src for loop compare
	    str	r10,[r1],r11
	  else
	    add	r8,r8,r10
	    ldr	r10,[sp,#8]  ;dstpitch
	    add	r9,r9,r11
	    ldr	r3,[sp,#4]	;end src for loop compare
	    str	r9,[r1,#4]
	    str	r8,[r1],r10
	  endif
  mend

  macro
  BArmInter8x4HV $Id, $Pos, $Round, $Add, $ARMv6

	if $ARMv6>0
	ldr		r4, [sp, #40]
	sub		sp,sp,#12
	mul		r4, r2, r4
	mov		r7, r3
	add		r4, r4, r0

	;add		r4,r4,r2
	mov		r2, r2, lsr #1
	mov		r12, r2
	str		r4,[sp,#4]	;end src


	ldr		r14,$Id.LABM_ARMv6

$Id.LABLOOP_ARMv6
	LoadHorVerRow_ARMv6 $Id,$Pos,0, $ARMv6
	CopyHorVerRow_ARMv6 $Id,$Pos,1,$Round,$Add, $ARMv6
	cmp		r0,r3
	bne		$Id.LABLOOP_ARMv6

	add		sp,sp,#12
	ldmia	sp!, {r4 - r12, pc}
$Id.LABM_ARMv6 dcd 0x01010101
		  
	  else
	ldr		r4, [sp, #40]
	sub		sp,sp,#12
	mul		r4, r2, r4
	str		r3,[sp,#8]	;dstpitch
	add		r4, r4, r0
	
	;add		r4,r4,r2
	mov		r2, r2, lsr #1
	str		r2,[sp]		;srcpitch
	str		r4,[sp,#4]	;end src


	ldr		r14,$Id.LABM
	mvn		r12,r14,lsl #6
	
$Id.LABLOOP
	LoadHorVerRow $Id,$Pos,0, $ARMv6
	CopyHorVerRow $Id,$Pos,1,$Round,$Add, $ARMv6
	cmp		r0,r3
	bne		$Id.LABLOOP

	add		sp,sp,#12
	ldmia	sp!, {r4 - r12, pc}
$Id.LABM dcd 0x03030303
	endif
  mend


; load needs r2,r3 for temporary (r2 is restored from stack)

  macro
  LoadHorVerRow_ARMv6 $Id, $Pos, $Parity, $ARMv6
  
;	ldr		r2,[sp]
	  
  if $Parity>0
	;read result r4,r5 and r2,r3 (one pixel to right)
	;r6,r7 can be used

    ldr		r5,[r0,#4]
    ldr		r6,[r0,#8]
    ldr		r4,[r0],r12

    if $Pos+8 < 32
	  mov	r3,r5,lsr #$Pos+8
	  orr	r3,r3,r6,lsl #32-$Pos-8
	  mov	r2,r4,lsr #$Pos+8	  
	  orr	r2,r2,r5,lsl #32-$Pos-8
    else
	  mov	r2,r5
	  mov	r3,r6
    endif

	if $Pos > 0
	  mov	r4,r4,lsr #$Pos
	  mov	r6,r6,lsl #32-$Pos
	  orr	r4,r4,r5,lsl #32-$Pos
	  orr	r5,r6,r5,lsr #$Pos
	endif
	uhadd8	r4, r4, r2
	uhadd8	r5, r5, r3
  else
	;read result r8,r9 and r2,r3 (one pixel to right)
	;r10,r11 can be used

    ldr		r9,[r0,#4]
    ldr		r10,[r0,#8]
    ldr		r8,[r0],r12

    if $Pos+8 < 32
	  mov	r3,r9,lsr #$Pos+8
	  orr	r3,r3,r10,lsl #32-$Pos-8
	  mov	r2,r8,lsr #$Pos+8	  
	  orr	r2,r2,r9,lsl #32-$Pos-8
    else
	  mov	r2,r9
	  mov	r3,r10
    endif

	if $Pos > 0
	  mov	r8,r8,lsr #$Pos
	  mov	r10,r10,lsl #32-$Pos
	  orr	r8,r8,r9,lsl #32-$Pos
	  orr	r9,r10,r9,lsr #$Pos
	endif
	uhadd8	r8, r8, r2
	uhadd8	r9, r9, r3	
  endif
  mend

  macro
  CopyHorVerRow_ARMv6 $Id, $Pos, $Parity, $Round, $Add, $ARMv6

;r14 03030303
;r12 3f3f3f3f

	LoadHorVerRow_ARMv6 $Id,$Pos,$Parity, $ARMv6

	if $Round>0
	  mov r3,r14				;0x01010101
	else
	  mov r3, r14, lsl #1		;0x02020202
	endif 
		
	uqadd8  r8, r8, r3
	uqadd8  r9, r9, r3	
		   
	uhadd8	r8, r8, r4
	uhadd8	r9, r9, r5
;	    ldr	r2,[sp,#8]  ;dstpitch
	    ldr	r3,[sp,#4]	;end src for loop compare 	    
	  if $Add>0
	  ldrd	r10,[r1]
	if $Round>0
	else
	uqadd8  r8, r8, r14
	uqadd8  r9, r9, r14	
	endif				  
	uhadd8	r8, r10, r8
	uhadd8	r9, r11, r9
	endif		  
	  strd	r8,[r1],r7 
  mend

;----------------------------------------------------------------------------------------
; general unaligned copy (use PldA)
;
;	GenCodeCpy BArmCopy4x8,BArmCopy8x4,0,0,0,1,0
;	GenCodeCpy BArmCopy8x16,BArmCopy16x8,0,0,0,1,0
;---------------------------------------------------------------------------------------
;---------------------------------------------------
; smaller versions without PldA
;
;	GenCodeCpy BArmInter8x4,BArmInter8x4,0,0,1,0
;	GenCodeCpy BArmInter8x4V,BArmInter8x4V,0,0,0,0
;	GenCodeCpy BArmInter8x4H,BArmInter8x4H,0,0,0,0
;	GenCodeCpy BArmInter8x4HV,BArmInter8x4HV,0,0,0,0
;
;	GenCodeCpy BArmInter2_8x4 ,BArmInter2_8x4 ,0,1,0,0
;	GenCodeCpy BArmInter2_8x4V,BArmInter8x4V,0,1,0,0
;	GenCodeCpy BArmInter2_8x4H,BArmInter8x4H,0,1,0,0
;	GenCodeCpy BArmInter2_8x4HV,BArmInter8x4HV,0,1,0,0
;
;---------------------------------------------------
; smaller versions with PldA
;
;	GenCodeCpy PldAarm_copyblk,BArmInter8x4,0,0,1,1
;	GenCodeCpy PldAarm_copyblkv,BArmInter8x4V,0,0,0,1
;	GenCodeCpy PldAarm_copyblkh,BArmInter8x4H,0,0,0,1
;	GenCodeCpy PldAarm_copyblkhv,BArmInter8x4HV,0,0,0,1
;
;	GenCodeCpy PldAarm_addblk,BArmInter2_8x4 ,0,1,0,1
;	GenCodeCpy PldAarm_addblkv,BArmInter8x4V,0,1,0,1
;	GenCodeCpy PldAarm_addblkh,BArmInter8x4H,0,1,0,1
;	GenCodeCpy PldAarm_addblkhv,BArmInter8x4HV,0,1,0,1
;
;---------------------------------------------------
; larger versions with PldA
; (faster if there is enough intstruction cache available)
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;   GenCodeCpy		$Name,			$Sub,		$Round,	$Add,	$Fast,	$ARM5,	$ARMv6,	$ARM11
;
;	GenCodeCpy BArmInter8x4,	BArmInter8x4,	0,	0,	1,	1,	1,	0
;	GenCodeCpy BArmInter8x4V,	BArmInter8x4V,	0,	0,	1,	1,	1,	0
;	GenCodeCpy BArmInter8x4H,	BArmInter8x4H,	0,	0,	1,	1,	1,	0
;	GenCodeCpy BArmInter8x4HV,	BArmInter8x4HV,	0,	0,	1,	1,	1,	0
;                                                                 	  	  	  	
;	GenCodeCpy BArmInter2_8x4 ,	BArmInter2_8x4 ,0,	1,	1,	1,  1,	0
;	GenCodeCpy BArmInter2_8x4V,	BArmInter8x4V,	0,	1,	1,	1,	1,	0
;	GenCodeCpy BArmInter2_8x4H,	BArmInter8x4H,	0,	1,	1,	1,	1,	0
;	GenCodeCpy BArmInter2_8x4HV,BArmInter8x4HV,	0,	1,	1,	1,  1,	0
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	;   GenCodeCpy		$Name,			$Sub,		$Round,	$Add,	$Fast,	$ARM5,	$ARMv6,	$ARM11
	
	;GenCodeCpy __voMPEG2D0223,	ArmCopy8x4,				0,	0,	0,	0,	0,	0
	;GenCodeCpy __voMPEG2D0239,	BArmCopy16x8,			0,	0,	0,	0,	0,	0				
	;GenCodeCpy __voMPEG2D0240,	BArmCopy8x4,			0,	0,	0,	0,	0,	0

	GenCodeCpy __voMPEG2D0214,	BArmInter8x4,			0,	0,	1,	1,	0,	0
	GenCodeCpy __voMPEG2D0216,	BArmInter8x4V,			0,	0,	1,	1,	0,	0
	GenCodeCpy __voMPEG2D0215,	BArmInter8x4H,			0,	0,	1,	1,	0,	0
	GenCodeCpy __voMPEG2D0217,	BArmInter8x4HV,         0,	0,	1,	1,	0,	0
                                                                  	  	  	  	
	GenCodeCpy __voMPEG2D0218 ,	BArmInter2_8x4 ,		0,	1,	1,	1,	0,	0
	GenCodeCpy __voMPEG2D0220,	BArmInter8x4V,			0,	1,	1,	1,	0,	0
	GenCodeCpy __voMPEG2D0219,	BArmInter8x4H,			0,	1,	1,	1,	0,	0
	GenCodeCpy __voMPEG2D0221,	BArmInter8x4HV,         0,	1,	1,	1,	0,	0

	END
