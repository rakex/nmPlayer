;************************************************************************
;									                                    *
;	VisualOn, Inc. Confidential and Proprietary, 2005		            *
;								 	                                    *
;***********************************************************************/

	AREA	|.text|, CODE

   ;---------------------------------------
   ;EXPORT WmmxIdctC
   ;EXPORT wmmx_CopyBlock16x16
   ;EXPORT wmmx_CopyBlock8x8
   ;EXPORT wmmx_CopyBlock8x16
   ;EXPORT wmmx_CopyBlock4x8
   ;----------------------------------------
   	EXPORT __voMPEG2D0021
	EXPORT __voMPEG2D0017
	EXPORT __voMPEG2D0018
	EXPORT __voMPEG2D0019
	EXPORT __voMPEG2D0020
	
	ALIGN 16

	ALIGN 16
;WmmxIdctC(int v,VO_U8 * Dst,int DstStride, VO_U8 * Src)
;WmmxIdctC PROC
__voMPEG2D0021 PROC
	stmdb	sp!, {r4}		; save regs used
	ldr	r4, [sp, #4]	;SrcStride
	cmp r0,#0
	bgt const8x8add
	blt const8x8sub
	cmp r1,r3
	beq const8x8done

	macro
	const8x8copyrow
	wldrd   wr1,[r3]
	add		r3,r3,r4
	wldrd   wr2,[r3]
	add		r3,r3,r4
	wstrd   wr1,[r1]
	add		r1,r1,r2
	wstrd   wr2,[r1]
	add		r1,r1,r2
	mend
	
	const8x8copyrow
	const8x8copyrow
	const8x8copyrow
	const8x8copyrow

const8x8done
	ldmia	sp!, {r4}		; restore and return 
	mov pc,lr

const8x8add	
	macro
	const8x8addrow
	wldrd   wr1,[r3]
	add		r3,r3,r4
	wldrd   wr2,[r3]
	add		r3,r3,r4
	waddbus wr1,wr1,wr0
	waddbus wr2,wr2,wr0
	wstrd   wr1,[r1]
	add		r1,r1,r2
	wstrd   wr2,[r1]
	add		r1,r1,r2
	mend

	tbcstb  wr0,r0
	const8x8addrow
	const8x8addrow
	const8x8addrow
	const8x8addrow
	ldmia	sp!, {r4}		; restore and return 
	mov pc,lr

const8x8sub
	macro
	const8x8subrow
	wldrd   wr1,[r3]
	add		r3,r3,r4
	wldrd   wr2,[r3]
	add		r3,r3,r4
	wsubbus wr1,wr1,wr0
	wsubbus wr2,wr2,wr0
	wstrd   wr1,[r1]
	add		r1,r1,r2
	wstrd   wr2,[r1]
	add		r1,r1,r2
	mend

	rsb r0,r0,#0
	tbcstb  wr0,r0
	const8x8subrow
	const8x8subrow
	const8x8subrow
	const8x8subrow
	ldmia	sp!, {r4}		; restore and return 
	mov pc,lr

	endp

;wmmx_CopyBlock16x16 PROC
__voMPEG2D0017 PROC
;// Dst[p] = Src[p]
;VO_VOID CCopy16X16(VO_U8 *Src, VO_U8 *Dst, const VO_S32 SrcStride, const VO_S32 DstStride)
;{
;	VO_U8 *SrcEnd = Src + 16*SrcStride;
;	VO_U32 a,b,c,d;
;	do
;	{
;		a=((VO_U32*)Src)[0];
;		b=((VO_U32*)Src)[1];
;		c=((VO_U32*)Src)[2];
;		d=((VO_U32*)Src)[3];
;		((VO_U32*)Dst)[0]=a;
;		((VO_U32*)Dst)[1]=b;
;		((VO_U32*)Dst)[2]=c;
;		((VO_U32*)Dst)[3]=d;
;		Dst += DstStride;
;		Src += SrcStride;
;	}
;	while (Src != SrcEnd);
;}
;0
	wldrd   wr0,[r0]
	wldrd   wr1,[r0, #8]
	add		r0, r0, r2
	wldrd   wr2,[r0]
	wldrd   wr3,[r0, #8]
	add		r0, r0, r2
	wldrd   wr4,[r0]
	wldrd   wr5,[r0, #8]
	add		r0, r0, r2
	wldrd   wr6,[r0]
	wldrd   wr7,[r0, #8]
	add		r0, r0, r2


	wstrd   wr0,[r1]
	wstrd   wr1,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr2,[r1]
	wstrd   wr3,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr4,[r1]
	wstrd   wr5,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr6,[r1]
	wstrd   wr7,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
;1
	wldrd   wr0,[r0]
	wldrd   wr1,[r0, #8]
	add		r0, r0, r2
	wldrd   wr2,[r0]
	wldrd   wr3,[r0, #8]
	add		r0, r0, r2
	wldrd   wr4,[r0]
	wldrd   wr5,[r0, #8]
	add		r0, r0, r2
	wldrd   wr6,[r0]
	wldrd   wr7,[r0, #8]
	add		r0, r0, r2


	wstrd   wr0,[r1]
	wstrd   wr1,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr2,[r1]
	wstrd   wr3,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr4,[r1]
	wstrd   wr5,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr6,[r1]
	wstrd   wr7,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
;2
	wldrd   wr0,[r0]
	wldrd   wr1,[r0, #8]
	add		r0, r0, r2
	wldrd   wr2,[r0]
	wldrd   wr3,[r0, #8]
	add		r0, r0, r2
	wldrd   wr4,[r0]
	wldrd   wr5,[r0, #8]
	add		r0, r0, r2
	wldrd   wr6,[r0]
	wldrd   wr7,[r0, #8]
	add		r0, r0, r2


	wstrd   wr0,[r1]
	wstrd   wr1,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr2,[r1]
	wstrd   wr3,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr4,[r1]
	wstrd   wr5,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr6,[r1]
	wstrd   wr7,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
;3
	wldrd   wr0,[r0]
	wldrd   wr1,[r0, #8]
	add		r0, r0, r2
	wldrd   wr2,[r0]
	wldrd   wr3,[r0, #8]
	add		r0, r0, r2
	wldrd   wr4,[r0]
	wldrd   wr5,[r0, #8]
	add		r0, r0, r2
	wldrd   wr6,[r0]
	wldrd   wr7,[r0, #8]
	add		r0, r0, r2


	wstrd   wr0,[r1]
	wstrd   wr1,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr2,[r1]
	wstrd   wr3,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr4,[r1]
	wstrd   wr5,[r1, #8]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr6,[r1]
	wstrd   wr7,[r1, #8]	
	mov pc,lr

	endp

;// Dst[p] = Src[p]
;VO_VOID CCopy8X8(VO_U8 *Src, VO_U8 *Dst, const VO_S32 SrcStride, const VO_S32 DstStride)
;{
;	VO_U8 *SrcEnd = Src + 8*SrcStride;
;	VO_U32 a,b,c,d;
;	do
;	{
;		a=((VO_U32*)Src)[0];
;		b=((VO_U32*)Src)[1];
;		Src += SrcStride;
;		c=((VO_U32*)Src)[0];
;		d=((VO_U32*)Src)[1];
;		Src += SrcStride;
;		((VO_U32*)Dst)[0]=a;
;		((VO_U32*)Dst)[1]=b;
;		Dst += DstStride;
;		((VO_U32*)Dst)[0]=c;
;		((VO_U32*)Dst)[1]=d;
;		Dst += DstStride;
;	}
;	while (Src != SrcEnd);
;}
;wmmx_CopyBlock8x8 PROC
__voMPEG2D0018 PROC

	wldrd   wr0,[r0]
	add		r0, r0, r2
	wldrd   wr1,[r0]
	add		r0, r0, r2
	wldrd   wr2,[r0]
	add		r0, r0, r2
	wldrd   wr3,[r0]
	add		r0, r0, r2
	wldrd   wr4,[r0]
	add		r0, r0, r2
	wldrd   wr5,[r0]
	add		r0, r0, r2
	wldrd   wr6,[r0]
	add		r0, r0, r2
	wldrd   wr7,[r0]
	add		r0, r0, r2

	wstrd   wr0,[r1]
	add		r1, r1, r3				;dst += dst_stride;
	wstrd   wr1,[r1]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr2,[r1]
	add		r1, r1, r3				;dst += dst_stride;
	wstrd   wr3,[r1]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr4,[r1]
	add		r1, r1, r3				;dst += dst_stride;
	wstrd   wr5,[r1]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr6,[r1]
	add		r1, r1, r3				;dst += dst_stride;
	wstrd   wr7,[r1]

	mov pc,lr

	endp
;wmmx_CopyBlock8x16 PROC
__voMPEG2D0019 PROC
;// Dst[p] = Src[p]
;VO_VOID CCopy8X16(VO_U8 *Src, VO_U8 *Dst, const VO_S32 SrcStride, const VO_S32 DstStride)

;0
	wldrd   wr0,[r0]
	add	r0, r0, r2
	wldrd   wr2,[r0]
	add	r0, r0, r2
	wldrd   wr4,[r0]
	add	r0, r0, r2
	wldrd   wr6,[r0]
	add	r0, r0, r2


	wstrd   wr0,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr2,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr4,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr6,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
;1
	wldrd   wr0,[r0]
	add	r0, r0, r2
	wldrd   wr2,[r0]
	add	r0, r0, r2
	wldrd   wr4,[r0]
	add	r0, r0, r2
	wldrd   wr6,[r0]
	add	r0, r0, r2


	wstrd   wr0,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr2,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr4,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr6,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
;2
	wldrd   wr0,[r0]
	add	r0, r0, r2
	wldrd   wr2,[r0]
	add	r0, r0, r2
	wldrd   wr4,[r0]
	add	r0, r0, r2
	wldrd   wr6,[r0]
	add	r0, r0, r2


	wstrd   wr0,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr2,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr4,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr6,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
;3
	wldrd   wr0,[r0]
	add	r0, r0, r2
	wldrd   wr2,[r0]
	add	r0, r0, r2
	wldrd   wr4,[r0]
	add	r0, r0, r2
	wldrd   wr6,[r0]
	add	r0, r0, r2


	wstrd   wr0,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr2,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrd   wr4,[r1]
	add		r1, r1, r3				;dst += dst_stride;	
	wstrd   wr6,[r1]	
	mov pc,lr

	endp

;// Dst[p] = Src[p]
;VO_VOID CCopy4X8(VO_U8 *Src, VO_U8 *Dst, const VO_S32 SrcStride, const VO_S32 DstStride)
;wmmx_CopyBlock4x8 PROC
__voMPEG2D0020 PROC

	wldrw   wr0,[r0]
	add	r0, r0, r2
	wldrw   wr1,[r0]
	add	r0, r0, r2
	wldrw   wr2,[r0]
	add	r0, r0, r2
	wldrw   wr3,[r0]
	add	r0, r0, r2
	wldrw   wr4,[r0]
	add	r0, r0, r2
	wldrw   wr5,[r0]
	add	r0, r0, r2
	wldrw   wr6,[r0]
	add	r0, r0, r2
	wldrw   wr7,[r0]
	add	r0, r0, r2

	wstrw   wr0,[r1]
	add	r1, r1, r3				;dst += dst_stride;
	wstrw   wr1,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrw   wr2,[r1]
	add	r1, r1, r3				;dst += dst_stride;
	wstrw   wr3,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrw   wr4,[r1]
	add	r1, r1, r3				;dst += dst_stride;
	wstrw   wr5,[r1]
	add	r1, r1, r3				;dst += dst_stride;	
	wstrw   wr6,[r1]
	add	r1, r1, r3				;dst += dst_stride;
	wstrw   wr7,[r1]

	mov pc,lr

	endp
	end
