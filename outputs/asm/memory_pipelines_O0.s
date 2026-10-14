	.arch armv8-a
	.file	"memory_pipelines.cpp"
	.text
#APP
	.globl _ZSt21ios_base_library_initv
#NO_APP
	.section	.rodata
	.align	3
	.type	_ZN7cvflannL8WORDSIZEE, %object
	.size	_ZN7cvflannL8WORDSIZEE, 8
_ZN7cvflannL8WORDSIZEE:
	.xword	16
	.align	3
	.type	_ZN7cvflannL9BLOCKSIZEE, %object
	.size	_ZN7cvflannL9BLOCKSIZEE, 8
_ZN7cvflannL9BLOCKSIZEE:
	.xword	8192
	.weak	Gx
	.section	.data.Gx,"awG",@progbits,Gx,comdat
	.align	3
	.type	Gx, %gnu_unique_object
	.size	Gx, 9
Gx:
	.string	"\377"
	.ascii	"\001"
	.string	"\376"
	.ascii	"\002"
	.string	"\377"
	.ascii	"\001"
	.weak	Gy
	.section	.data.Gy,"awG",@progbits,Gy,comdat
	.align	3
	.type	Gy, %gnu_unique_object
	.size	Gy, 9
Gy:
	.ascii	"\001\002\001"
	.string	""
	.string	""
	.string	""
	.ascii	"\377\376\377"
	.section	.rodata
	.align	2
	.type	_ZL11START_FRAME, %object
	.size	_ZL11START_FRAME, 4
_ZL11START_FRAME:
	.word	60
	.align	2
	.type	_ZL12BENCH_FRAMES, %object
	.size	_ZL12BENCH_FRAMES, 4
_ZL12BENCH_FRAMES:
	.word	120
	.align	2
	.type	_ZL13CAPTURE_INDEX, %object
	.size	_ZL13CAPTURE_INDEX, 4
_ZL13CAPTURE_INDEX:
	.word	119
	.align	2
	.type	_ZL13CAPTURE_FRAME, %object
	.size	_ZL13CAPTURE_FRAME, 4
_ZL13CAPTURE_FRAME:
	.word	179
	.align	2
	.type	_ZL13BENCH_REPEATS, %object
	.size	_ZL13BENCH_REPEATS, 4
_ZL13BENCH_REPEATS:
	.word	3
	.align	3
.LC0:
	.string	"captures"
	.section	.data.rel.ro.local,"aw"
	.align	3
	.type	_ZL11CAPTURE_DIR, %object
	.size	_ZL11CAPTURE_DIR, 8
_ZL11CAPTURE_DIR:
	.xword	.LC0
	.text
	.align	2
	.global	_Z10gray_valuehhh
	.type	_Z10gray_valuehhh, %function
_Z10gray_valuehhh:
.LFB13715:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	strb	w0, [sp, 15]
	strb	w1, [sp, 14]
	strb	w2, [sp, 13]
	ldrb	w0, [sp, 15]
	scvtf	d31, w0
	adrp	x0, .LC1
	ldr	d30, [x0, #:lo12:.LC1]
	fmul	d30, d31, d30
	ldrb	w0, [sp, 14]
	scvtf	d31, w0
	adrp	x0, .LC2
	ldr	d29, [x0, #:lo12:.LC2]
	fmul	d31, d31, d29
	fadd	d30, d30, d31
	ldrb	w0, [sp, 13]
	scvtf	d31, w0
	adrp	x0, .LC3
	ldr	d29, [x0, #:lo12:.LC3]
	fmul	d31, d31, d29
	fadd	d31, d30, d31
	fcvtzu	w0, d31
	strh	w0, [sp, 30]
	ldrh	w0, [sp, 30]
	cmp	w0, 255
	bls	.L3
	mov	w0, 255
	strh	w0, [sp, 30]
.L3:
	ldrh	w0, [sp, 30]
	and	w0, w0, 255
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13715:
	.size	_Z10gray_valuehhh, .-_Z10gray_valuehhh
	.align	2
	.global	_Z18gradient_magnitudeii
	.type	_Z18gradient_magnitudeii, %function
_Z18gradient_magnitudeii:
.LFB13716:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	w0, [sp, 28]
	str	w1, [sp, 24]
	ldr	w0, [sp, 28]
	mul	w1, w0, w0
	ldr	w0, [sp, 24]
	mul	w0, w0, w0
	add	w0, w1, w0
	str	w0, [sp, 44]
	ldr	w0, [sp, 44]
	bl	_ZSt4sqrtIiEN9__gnu_cxx11__enable_ifIXsrSt12__is_integerIT_E7__valueEdE6__typeES3_
	fmov	d31, d0
	fcvtzs	w0, d31
	str	w0, [sp, 44]
	ldr	w0, [sp, 44]
	cmp	w0, 255
	ble	.L6
	mov	w0, 255
	str	w0, [sp, 44]
.L6:
	ldr	w0, [sp, 44]
	and	w0, w0, 255
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13716:
	.size	_Z18gradient_magnitudeii, .-_Z18gradient_magnitudeii
	.align	2
	.global	_Z12grayscale_atPN2cv3MatES1_
	.type	_Z12grayscale_atPN2cv3MatES1_, %function
_Z12grayscale_atPN2cv3MatES1_:
.LFB13717:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L9
	ldr	x0, [sp, 32]
	cmp	x0, 0
	bne	.L10
.L9:
	mov	w0, 0
	b	.L16
.L10:
	add	x0, sp, 48
	mov	w1, 0
	bl	_ZN2cv3VecIhLi3EEC1Eh
	str	wzr, [sp, 60]
	b	.L12
.L15:
	str	wzr, [sp, 56]
	b	.L13
.L14:
	ldr	w2, [sp, 56]
	ldr	w1, [sp, 60]
	ldr	x0, [sp, 40]
	bl	_ZN2cv3Mat2atINS_3VecIhLi3EEEEERT_ii
	mov	x1, x0
	add	x0, sp, 48
	ldrh	w2, [x1]
	ldrb	w1, [x1, 2]
	strh	w2, [x0]
	strb	w1, [x0, 2]
	add	x0, sp, 48
	mov	w1, 0
	bl	_ZN2cv3VecIhLi3EEixEi
	ldrb	w19, [x0]
	add	x0, sp, 48
	mov	w1, 1
	bl	_ZN2cv3VecIhLi3EEixEi
	ldrb	w20, [x0]
	add	x0, sp, 48
	mov	w1, 2
	bl	_ZN2cv3VecIhLi3EEixEi
	ldrb	w0, [x0]
	mov	w2, w0
	mov	w1, w20
	mov	w0, w19
	bl	_Z10gray_valuehhh
	and	w19, w0, 255
	ldr	w2, [sp, 56]
	ldr	w1, [sp, 60]
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat2atIhEERT_ii
	mov	w1, w19
	strb	w1, [x0]
	ldr	w0, [sp, 56]
	add	w0, w0, 1
	str	w0, [sp, 56]
.L13:
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 12]
	ldr	w1, [sp, 56]
	cmp	w1, w0
	blt	.L14
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	str	w0, [sp, 60]
.L12:
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 8]
	ldr	w1, [sp, 60]
	cmp	w1, w0
	blt	.L15
	mov	w0, 1
.L16:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13717:
	.size	_Z12grayscale_atPN2cv3MatES1_, .-_Z12grayscale_atPN2cv3MatES1_
	.align	2
	.global	_Z8sobel_atPN2cv3MatES1_
	.type	_Z8sobel_atPN2cv3MatES1_, %function
_Z8sobel_atPN2cv3MatES1_:
.LFB13718:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -80
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L18
	ldr	x0, [sp, 32]
	cmp	x0, 0
	bne	.L19
.L18:
	mov	w0, 0
	b	.L20
.L19:
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 8]
	str	w0, [sp, 56]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 12]
	str	w0, [sp, 52]
	strb	wzr, [sp, 51]
	str	wzr, [sp, 92]
	str	wzr, [sp, 88]
	ldr	w0, [sp, 56]
	cmp	w0, 2
	ble	.L21
	ldr	w0, [sp, 52]
	cmp	w0, 2
	bgt	.L22
.L21:
	str	wzr, [sp, 84]
	b	.L23
.L26:
	str	wzr, [sp, 80]
	b	.L24
.L25:
	ldr	w2, [sp, 80]
	ldr	w1, [sp, 84]
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat2atIhEERT_ii
	strb	wzr, [x0]
	ldr	w0, [sp, 80]
	add	w0, w0, 1
	str	w0, [sp, 80]
.L24:
	ldr	w1, [sp, 80]
	ldr	w0, [sp, 52]
	cmp	w1, w0
	blt	.L25
	ldr	w0, [sp, 84]
	add	w0, w0, 1
	str	w0, [sp, 84]
.L23:
	ldr	w1, [sp, 84]
	ldr	w0, [sp, 56]
	cmp	w1, w0
	blt	.L26
	mov	w0, 1
	b	.L20
.L22:
	str	wzr, [sp, 76]
	b	.L27
.L28:
	ldr	w2, [sp, 76]
	mov	w1, 0
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat2atIhEERT_ii
	strb	wzr, [x0]
	ldr	w0, [sp, 56]
	sub	w0, w0, #1
	ldr	w2, [sp, 76]
	mov	w1, w0
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat2atIhEERT_ii
	strb	wzr, [x0]
	ldr	w0, [sp, 76]
	add	w0, w0, 1
	str	w0, [sp, 76]
.L27:
	ldr	w1, [sp, 76]
	ldr	w0, [sp, 52]
	cmp	w1, w0
	blt	.L28
	mov	w0, 1
	str	w0, [sp, 72]
	b	.L29
.L36:
	mov	w2, 0
	ldr	w1, [sp, 72]
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat2atIhEERT_ii
	strb	wzr, [x0]
	mov	w0, 1
	str	w0, [sp, 68]
	b	.L30
.L35:
	str	wzr, [sp, 92]
	str	wzr, [sp, 88]
	str	wzr, [sp, 64]
	b	.L31
.L34:
	str	wzr, [sp, 60]
	b	.L32
.L33:
	ldr	w1, [sp, 72]
	ldr	w0, [sp, 64]
	add	w0, w1, w0
	sub	w3, w0, #1
	ldr	w1, [sp, 68]
	ldr	w0, [sp, 60]
	add	w0, w1, w0
	sub	w0, w0, #1
	mov	w2, w0
	mov	w1, w3
	ldr	x0, [sp, 40]
	bl	_ZN2cv3Mat2atIhEERT_ii
	ldrb	w0, [x0]
	strb	w0, [sp, 51]
	ldrb	w2, [sp, 51]
	adrp	x0, Gx
	add	x4, x0, :lo12:Gx
	ldrsw	x3, [sp, 60]
	ldrsw	x1, [sp, 64]
	mov	x0, x1
	lsl	x0, x0, 1
	add	x0, x0, x1
	add	x0, x4, x0
	add	x0, x0, x3
	ldrsb	w0, [x0]
	mul	w0, w2, w0
	ldr	w1, [sp, 92]
	add	w0, w1, w0
	str	w0, [sp, 92]
	ldrb	w2, [sp, 51]
	adrp	x0, Gy
	add	x4, x0, :lo12:Gy
	ldrsw	x3, [sp, 60]
	ldrsw	x1, [sp, 64]
	mov	x0, x1
	lsl	x0, x0, 1
	add	x0, x0, x1
	add	x0, x4, x0
	add	x0, x0, x3
	ldrsb	w0, [x0]
	mul	w0, w2, w0
	ldr	w1, [sp, 88]
	add	w0, w1, w0
	str	w0, [sp, 88]
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	str	w0, [sp, 60]
.L32:
	ldr	w0, [sp, 60]
	cmp	w0, 2
	ble	.L33
	ldr	w0, [sp, 64]
	add	w0, w0, 1
	str	w0, [sp, 64]
.L31:
	ldr	w0, [sp, 64]
	cmp	w0, 2
	ble	.L34
	ldr	w1, [sp, 88]
	ldr	w0, [sp, 92]
	bl	_Z18gradient_magnitudeii
	and	w19, w0, 255
	ldr	w2, [sp, 68]
	ldr	w1, [sp, 72]
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat2atIhEERT_ii
	mov	w1, w19
	strb	w1, [x0]
	ldr	w0, [sp, 68]
	add	w0, w0, 1
	str	w0, [sp, 68]
.L30:
	ldr	w0, [sp, 52]
	sub	w0, w0, #1
	ldr	w1, [sp, 68]
	cmp	w1, w0
	blt	.L35
	ldr	w0, [sp, 52]
	sub	w0, w0, #1
	mov	w2, w0
	ldr	w1, [sp, 72]
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat2atIhEERT_ii
	strb	wzr, [x0]
	ldr	w0, [sp, 72]
	add	w0, w0, 1
	str	w0, [sp, 72]
.L29:
	ldr	w0, [sp, 56]
	sub	w0, w0, #1
	ldr	w1, [sp, 72]
	cmp	w1, w0
	blt	.L36
	mov	w0, 1
.L20:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13718:
	.size	_Z8sobel_atPN2cv3MatES1_, .-_Z8sobel_atPN2cv3MatES1_
	.align	2
	.global	_Z17grayscale_row_ptrPKhPhi
	.type	_Z17grayscale_row_ptrPKhPhi, %function
_Z17grayscale_row_ptrPKhPhi:
.LFB13719:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -64
	str	x0, [sp, 56]
	str	x1, [sp, 48]
	str	w2, [sp, 44]
	str	wzr, [sp, 76]
	b	.L38
.L39:
	ldr	w1, [sp, 76]
	mov	w0, w1
	lsl	w0, w0, 1
	add	w0, w0, w1
	sxtw	x0, w0
	ldr	x1, [sp, 56]
	add	x0, x1, x0
	ldrb	w3, [x0]
	ldr	w1, [sp, 76]
	mov	w0, w1
	lsl	w0, w0, 1
	add	w0, w0, w1
	sxtw	x0, w0
	add	x0, x0, 1
	ldr	x1, [sp, 56]
	add	x0, x1, x0
	ldrb	w4, [x0]
	ldr	w1, [sp, 76]
	mov	w0, w1
	lsl	w0, w0, 1
	add	w0, w0, w1
	sxtw	x0, w0
	add	x0, x0, 2
	ldr	x1, [sp, 56]
	add	x0, x1, x0
	ldrb	w2, [x0]
	ldrsw	x0, [sp, 76]
	ldr	x1, [sp, 48]
	add	x19, x1, x0
	mov	w1, w4
	mov	w0, w3
	bl	_Z10gray_valuehhh
	and	w0, w0, 255
	strb	w0, [x19]
	ldr	w0, [sp, 76]
	add	w0, w0, 1
	str	w0, [sp, 76]
.L38:
	ldr	w1, [sp, 76]
	ldr	w0, [sp, 44]
	cmp	w1, w0
	blt	.L39
	nop
	nop
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13719:
	.size	_Z17grayscale_row_ptrPKhPhi, .-_Z17grayscale_row_ptrPKhPhi
	.align	2
	.global	_Z13sobel_row_ptrPKhS0_S0_Phi
	.type	_Z13sobel_row_ptrPKhS0_S0_Phi, %function
_Z13sobel_row_ptrPKhS0_S0_Phi:
.LFB13720:
	.cfi_startproc
	stp	x29, x30, [sp, -128]!
	.cfi_def_cfa_offset 128
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -112
	str	x0, [sp, 72]
	str	x1, [sp, 64]
	str	x2, [sp, 56]
	str	x3, [sp, 48]
	str	w4, [sp, 44]
	ldr	x0, [sp, 72]
	str	x0, [sp, 80]
	ldr	x0, [sp, 64]
	str	x0, [sp, 88]
	ldr	x0, [sp, 56]
	str	x0, [sp, 96]
	strb	wzr, [sp, 107]
	str	wzr, [sp, 124]
	str	wzr, [sp, 120]
	ldr	x0, [sp, 48]
	strb	wzr, [x0]
	mov	w0, 1
	str	w0, [sp, 116]
	b	.L41
.L46:
	str	wzr, [sp, 124]
	str	wzr, [sp, 120]
	str	wzr, [sp, 112]
	b	.L42
.L45:
	str	wzr, [sp, 108]
	b	.L43
.L44:
	ldrsw	x0, [sp, 112]
	lsl	x0, x0, 3
	add	x1, sp, 80
	ldr	x1, [x1, x0]
	ldr	w2, [sp, 116]
	ldr	w0, [sp, 108]
	add	w0, w2, w0
	sxtw	x0, w0
	sub	x0, x0, #1
	add	x0, x1, x0
	ldrb	w0, [x0]
	strb	w0, [sp, 107]
	ldrb	w2, [sp, 107]
	adrp	x0, Gx
	add	x4, x0, :lo12:Gx
	ldrsw	x3, [sp, 108]
	ldrsw	x1, [sp, 112]
	mov	x0, x1
	lsl	x0, x0, 1
	add	x0, x0, x1
	add	x0, x4, x0
	add	x0, x0, x3
	ldrsb	w0, [x0]
	mul	w0, w2, w0
	ldr	w1, [sp, 124]
	add	w0, w1, w0
	str	w0, [sp, 124]
	ldrb	w2, [sp, 107]
	adrp	x0, Gy
	add	x4, x0, :lo12:Gy
	ldrsw	x3, [sp, 108]
	ldrsw	x1, [sp, 112]
	mov	x0, x1
	lsl	x0, x0, 1
	add	x0, x0, x1
	add	x0, x4, x0
	add	x0, x0, x3
	ldrsb	w0, [x0]
	mul	w0, w2, w0
	ldr	w1, [sp, 120]
	add	w0, w1, w0
	str	w0, [sp, 120]
	ldr	w0, [sp, 108]
	add	w0, w0, 1
	str	w0, [sp, 108]
.L43:
	ldr	w0, [sp, 108]
	cmp	w0, 2
	ble	.L44
	ldr	w0, [sp, 112]
	add	w0, w0, 1
	str	w0, [sp, 112]
.L42:
	ldr	w0, [sp, 112]
	cmp	w0, 2
	ble	.L45
	ldrsw	x0, [sp, 116]
	ldr	x1, [sp, 48]
	add	x19, x1, x0
	ldr	w1, [sp, 120]
	ldr	w0, [sp, 124]
	bl	_Z18gradient_magnitudeii
	and	w0, w0, 255
	strb	w0, [x19]
	ldr	w0, [sp, 116]
	add	w0, w0, 1
	str	w0, [sp, 116]
.L41:
	ldr	w0, [sp, 44]
	sub	w0, w0, #1
	ldr	w1, [sp, 116]
	cmp	w1, w0
	blt	.L46
	ldrsw	x0, [sp, 44]
	sub	x0, x0, #1
	ldr	x1, [sp, 48]
	add	x0, x1, x0
	strb	wzr, [x0]
	nop
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 128
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13720:
	.size	_Z13sobel_row_ptrPKhS0_S0_Phi, .-_Z13sobel_row_ptrPKhS0_S0_Phi
	.align	2
	.global	_Z12zero_row_ptrPhi
	.type	_Z12zero_row_ptrPhi, %function
_Z12zero_row_ptrPhi:
.LFB13721:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	str	wzr, [sp, 28]
	b	.L48
.L49:
	ldrsw	x0, [sp, 28]
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	strb	wzr, [x0]
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
.L48:
	ldr	w1, [sp, 28]
	ldr	w0, [sp, 4]
	cmp	w1, w0
	blt	.L49
	nop
	nop
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13721:
	.size	_Z12zero_row_ptrPhi, .-_Z12zero_row_ptrPhi
	.align	2
	.global	_Z13grayscale_ptrPN2cv3MatES1_
	.type	_Z13grayscale_ptrPN2cv3MatES1_, %function
_Z13grayscale_ptrPN2cv3MatES1_:
.LFB13722:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -48
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L51
	ldr	x0, [sp, 32]
	cmp	x0, 0
	bne	.L52
.L51:
	mov	w0, 0
	b	.L53
.L52:
	str	wzr, [sp, 60]
	b	.L54
.L55:
	ldr	w1, [sp, 60]
	ldr	x0, [sp, 40]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	mov	x19, x0
	ldr	w1, [sp, 60]
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	mov	x1, x0
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 12]
	mov	w2, w0
	mov	x0, x19
	bl	_Z17grayscale_row_ptrPKhPhi
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	str	w0, [sp, 60]
.L54:
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 8]
	ldr	w1, [sp, 60]
	cmp	w1, w0
	blt	.L55
	mov	w0, 1
.L53:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13722:
	.size	_Z13grayscale_ptrPN2cv3MatES1_, .-_Z13grayscale_ptrPN2cv3MatES1_
	.align	2
	.global	_Z9sobel_ptrPN2cv3MatES1_
	.type	_Z9sobel_ptrPN2cv3MatES1_, %function
_Z9sobel_ptrPN2cv3MatES1_:
.LFB13723:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	str	x21, [sp, 32]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 21, -48
	str	x0, [sp, 56]
	str	x1, [sp, 48]
	ldr	x0, [sp, 56]
	cmp	x0, 0
	beq	.L57
	ldr	x0, [sp, 48]
	cmp	x0, 0
	bne	.L58
.L57:
	mov	w0, 0
	b	.L59
.L58:
	ldr	x0, [sp, 56]
	ldr	w0, [x0, 8]
	str	w0, [sp, 68]
	ldr	x0, [sp, 56]
	ldr	w0, [x0, 12]
	str	w0, [sp, 64]
	ldr	w0, [sp, 68]
	cmp	w0, 2
	ble	.L60
	ldr	w0, [sp, 64]
	cmp	w0, 2
	bgt	.L61
.L60:
	str	wzr, [sp, 76]
	b	.L62
.L63:
	ldr	w1, [sp, 76]
	ldr	x0, [sp, 48]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w1, [sp, 64]
	bl	_Z12zero_row_ptrPhi
	ldr	w0, [sp, 76]
	add	w0, w0, 1
	str	w0, [sp, 76]
.L62:
	ldr	w1, [sp, 76]
	ldr	w0, [sp, 68]
	cmp	w1, w0
	blt	.L63
	mov	w0, 1
	b	.L59
.L61:
	mov	w1, 0
	ldr	x0, [sp, 48]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w1, [sp, 64]
	bl	_Z12zero_row_ptrPhi
	ldr	w0, [sp, 68]
	sub	w0, w0, #1
	mov	w1, w0
	ldr	x0, [sp, 48]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w1, [sp, 64]
	bl	_Z12zero_row_ptrPhi
	mov	w0, 1
	str	w0, [sp, 72]
	b	.L64
.L65:
	ldr	w0, [sp, 72]
	sub	w0, w0, #1
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	mov	x19, x0
	ldr	w1, [sp, 72]
	ldr	x0, [sp, 56]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	mov	x20, x0
	ldr	w0, [sp, 72]
	add	w0, w0, 1
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	mov	x21, x0
	ldr	w1, [sp, 72]
	ldr	x0, [sp, 48]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w4, [sp, 64]
	mov	x3, x0
	mov	x2, x21
	mov	x1, x20
	mov	x0, x19
	bl	_Z13sobel_row_ptrPKhS0_S0_Phi
	ldr	w0, [sp, 72]
	add	w0, w0, 1
	str	w0, [sp, 72]
.L64:
	ldr	w0, [sp, 68]
	sub	w0, w0, #1
	ldr	w1, [sp, 72]
	cmp	w1, w0
	blt	.L65
	mov	w0, 1
.L59:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13723:
	.size	_Z9sobel_ptrPN2cv3MatES1_, .-_Z9sobel_ptrPN2cv3MatES1_
	.align	2
	.global	_Z15sobel_streamingPN2cv3MatES1_S1_
	.type	_Z15sobel_streamingPN2cv3MatES1_S1_, %function
_Z15sobel_streamingPN2cv3MatES1_S1_:
.LFB13724:
	.cfi_startproc
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L67
	ldr	x0, [sp, 32]
	cmp	x0, 0
	beq	.L67
	ldr	x0, [sp, 24]
	cmp	x0, 0
	bne	.L68
.L67:
	mov	w0, 0
	b	.L69
.L68:
	ldr	x0, [sp, 32]
	ldr	w0, [x0, 8]
	cmp	w0, 2
	ble	.L70
	ldr	x0, [sp, 32]
	ldr	w1, [x0, 12]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 12]
	cmp	w1, w0
	bge	.L71
.L70:
	mov	w0, 0
	b	.L69
.L71:
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 8]
	str	w0, [sp, 72]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 12]
	str	w0, [sp, 68]
	ldr	w0, [sp, 72]
	cmp	w0, 2
	ble	.L72
	ldr	w0, [sp, 68]
	cmp	w0, 2
	bgt	.L73
.L72:
	str	wzr, [sp, 108]
	b	.L74
.L75:
	ldr	w1, [sp, 108]
	ldr	x0, [sp, 24]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w1, [sp, 68]
	bl	_Z12zero_row_ptrPhi
	ldr	w0, [sp, 108]
	add	w0, w0, 1
	str	w0, [sp, 108]
.L74:
	ldr	w1, [sp, 108]
	ldr	w0, [sp, 72]
	cmp	w1, w0
	blt	.L75
	mov	w0, 1
	b	.L69
.L73:
	mov	w1, 0
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	str	x0, [sp, 96]
	mov	w1, 1
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	str	x0, [sp, 88]
	mov	w1, 2
	ldr	x0, [sp, 32]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	str	x0, [sp, 80]
	str	xzr, [sp, 56]
	mov	w1, 0
	ldr	x0, [sp, 40]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w2, [sp, 68]
	ldr	x1, [sp, 96]
	bl	_Z17grayscale_row_ptrPKhPhi
	mov	w1, 1
	ldr	x0, [sp, 40]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w2, [sp, 68]
	ldr	x1, [sp, 88]
	bl	_Z17grayscale_row_ptrPKhPhi
	mov	w1, 0
	ldr	x0, [sp, 24]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w1, [sp, 68]
	bl	_Z12zero_row_ptrPhi
	mov	w0, 1
	str	w0, [sp, 76]
	b	.L76
.L77:
	ldr	w0, [sp, 76]
	add	w0, w0, 1
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w2, [sp, 68]
	ldr	x1, [sp, 80]
	bl	_Z17grayscale_row_ptrPKhPhi
	ldr	w1, [sp, 76]
	ldr	x0, [sp, 24]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w4, [sp, 68]
	mov	x3, x0
	ldr	x2, [sp, 80]
	ldr	x1, [sp, 88]
	ldr	x0, [sp, 96]
	bl	_Z13sobel_row_ptrPKhS0_S0_Phi
	ldr	x0, [sp, 96]
	str	x0, [sp, 56]
	ldr	x0, [sp, 88]
	str	x0, [sp, 96]
	ldr	x0, [sp, 80]
	str	x0, [sp, 88]
	ldr	x0, [sp, 56]
	str	x0, [sp, 80]
	ldr	w0, [sp, 76]
	add	w0, w0, 1
	str	w0, [sp, 76]
.L76:
	ldr	w0, [sp, 72]
	sub	w0, w0, #1
	ldr	w1, [sp, 76]
	cmp	w1, w0
	blt	.L77
	ldr	w0, [sp, 72]
	sub	w0, w0, #1
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	_ZN2cv3Mat3ptrIhEEPT_i
	ldr	w1, [sp, 68]
	bl	_Z12zero_row_ptrPhi
	mov	w0, 1
.L69:
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13724:
	.size	_Z15sobel_streamingPN2cv3MatES1_S1_, .-_Z15sobel_streamingPN2cv3MatES1_S1_
	.section	.text._ZSt4sqrtIiEN9__gnu_cxx11__enable_ifIXsrSt12__is_integerIT_E7__valueEdE6__typeES3_,"axG",@progbits,_ZSt4sqrtIiEN9__gnu_cxx11__enable_ifIXsrSt12__is_integerIT_E7__valueEdE6__typeES3_,comdat
	.align	2
	.weak	_ZSt4sqrtIiEN9__gnu_cxx11__enable_ifIXsrSt12__is_integerIT_E7__valueEdE6__typeES3_
	.type	_ZSt4sqrtIiEN9__gnu_cxx11__enable_ifIXsrSt12__is_integerIT_E7__valueEdE6__typeES3_, %function
_ZSt4sqrtIiEN9__gnu_cxx11__enable_ifIXsrSt12__is_integerIT_E7__valueEdE6__typeES3_:
.LFB14911:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	w0, [sp, 28]
	ldr	w0, [sp, 28]
	scvtf	d31, w0
	fmov	d0, d31
	bl	sqrt
	fmov	d31, d0
	fmov	d0, d31
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE14911:
	.size	_ZSt4sqrtIiEN9__gnu_cxx11__enable_ifIXsrSt12__is_integerIT_E7__valueEdE6__typeES3_, .-_ZSt4sqrtIiEN9__gnu_cxx11__enable_ifIXsrSt12__is_integerIT_E7__valueEdE6__typeES3_
	.section	.text._ZN2cv3VecIhLi3EEC2Eh,"axG",@progbits,_ZN2cv3VecIhLi3EEC5Eh,comdat
	.align	2
	.weak	_ZN2cv3VecIhLi3EEC2Eh
	.type	_ZN2cv3VecIhLi3EEC2Eh, %function
_ZN2cv3VecIhLi3EEC2Eh:
.LFB14913:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x0, [sp, 24]
	strb	w1, [sp, 23]
	ldr	x0, [sp, 24]
	ldrb	w1, [sp, 23]
	bl	_ZN2cv4MatxIhLi3ELi1EEC2Eh
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE14913:
	.size	_ZN2cv3VecIhLi3EEC2Eh, .-_ZN2cv3VecIhLi3EEC2Eh
	.weak	_ZN2cv3VecIhLi3EEC1Eh
	.set	_ZN2cv3VecIhLi3EEC1Eh,_ZN2cv3VecIhLi3EEC2Eh
	.section	.text._ZN2cv3Mat2atINS_3VecIhLi3EEEEERT_ii,"axG",@progbits,_ZN2cv3Mat2atINS_3VecIhLi3EEEEERT_ii,comdat
	.align	2
	.weak	_ZN2cv3Mat2atINS_3VecIhLi3EEEEERT_ii
	.type	_ZN2cv3Mat2atINS_3VecIhLi3EEEEERT_ii, %function
_ZN2cv3Mat2atINS_3VecIhLi3EEEEERT_ii:
.LFB14915:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	str	w2, [sp]
	ldr	x0, [sp, 8]
	ldr	x2, [x0, 16]
	ldr	x0, [sp, 8]
	ldr	x0, [x0, 72]
	ldr	x1, [x0]
	ldrsw	x0, [sp, 4]
	mul	x3, x1, x0
	ldrsw	x1, [sp]
	mov	x0, x1
	lsl	x0, x0, 1
	add	x0, x0, x1
	add	x0, x3, x0
	add	x0, x2, x0
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE14915:
	.size	_ZN2cv3Mat2atINS_3VecIhLi3EEEEERT_ii, .-_ZN2cv3Mat2atINS_3VecIhLi3EEEEERT_ii
	.section	.text._ZN2cv3Mat2atIhEERT_ii,"axG",@progbits,_ZN2cv3Mat2atIhEERT_ii,comdat
	.align	2
	.weak	_ZN2cv3Mat2atIhEERT_ii
	.type	_ZN2cv3Mat2atIhEERT_ii, %function
_ZN2cv3Mat2atIhEERT_ii:
.LFB14916:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	str	w2, [sp]
	ldr	x0, [sp, 8]
	ldr	x1, [x0, 16]
	ldr	x0, [sp, 8]
	ldr	x0, [x0, 72]
	ldr	x2, [x0]
	ldrsw	x0, [sp, 4]
	mul	x2, x2, x0
	ldrsw	x0, [sp]
	add	x0, x2, x0
	add	x0, x1, x0
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE14916:
	.size	_ZN2cv3Mat2atIhEERT_ii, .-_ZN2cv3Mat2atIhEERT_ii
	.section	.text._ZN2cv3VecIhLi3EEixEi,"axG",@progbits,_ZN2cv3VecIhLi3EEixEi,comdat
	.align	2
	.weak	_ZN2cv3VecIhLi3EEixEi
	.type	_ZN2cv3VecIhLi3EEixEi, %function
_ZN2cv3VecIhLi3EEixEi:
.LFB14917:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	ldrsw	x0, [sp, 4]
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE14917:
	.size	_ZN2cv3VecIhLi3EEixEi, .-_ZN2cv3VecIhLi3EEixEi
	.section	.text._ZN2cv3Mat3ptrIhEEPT_i,"axG",@progbits,_ZN2cv3Mat3ptrIhEEPT_i,comdat
	.align	2
	.weak	_ZN2cv3Mat3ptrIhEEPT_i
	.type	_ZN2cv3Mat3ptrIhEEPT_i, %function
_ZN2cv3Mat3ptrIhEEPT_i:
.LFB14918:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	ldr	x0, [sp, 8]
	ldr	x1, [x0, 16]
	ldr	x0, [sp, 8]
	ldr	x0, [x0, 72]
	ldr	x2, [x0]
	ldrsw	x0, [sp, 4]
	mul	x0, x2, x0
	add	x0, x1, x0
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE14918:
	.size	_ZN2cv3Mat3ptrIhEEPT_i, .-_ZN2cv3Mat3ptrIhEEPT_i
	.section	.text._ZN2cv4MatxIhLi3ELi1EEC2Eh,"axG",@progbits,_ZN2cv4MatxIhLi3ELi1EEC5Eh,comdat
	.align	2
	.weak	_ZN2cv4MatxIhLi3ELi1EEC2Eh
	.type	_ZN2cv4MatxIhLi3ELi1EEC2Eh, %function
_ZN2cv4MatxIhLi3ELi1EEC2Eh:
.LFB15787:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, 8]
	strb	w1, [sp, 7]
	ldr	x0, [sp, 8]
	ldrb	w1, [sp, 7]
	strb	w1, [x0]
	mov	w0, 1
	str	w0, [sp, 28]
	b	.L90
.L91:
	ldr	x1, [sp, 8]
	ldrsw	x0, [sp, 28]
	strb	wzr, [x1, x0]
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
.L90:
	ldr	w0, [sp, 28]
	cmp	w0, 2
	ble	.L91
	nop
	nop
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE15787:
	.size	_ZN2cv4MatxIhLi3ELi1EEC2Eh, .-_ZN2cv4MatxIhLi3ELi1EEC2Eh
	.weak	_ZN2cv4MatxIhLi3ELi1EEC1Eh
	.set	_ZN2cv4MatxIhLi3ELi1EEC1Eh,_ZN2cv4MatxIhLi3ELi1EEC2Eh
	.section	.rodata
	.type	_ZNSt8__detail30__integer_to_chars_is_unsignedIjEE, %object
	.size	_ZNSt8__detail30__integer_to_chars_is_unsignedIjEE, 1
_ZNSt8__detail30__integer_to_chars_is_unsignedIjEE:
	.byte	1
	.type	_ZNSt8__detail30__integer_to_chars_is_unsignedImEE, %object
	.size	_ZNSt8__detail30__integer_to_chars_is_unsignedImEE, 1
_ZNSt8__detail30__integer_to_chars_is_unsignedImEE:
	.byte	1
	.type	_ZNSt8__detail30__integer_to_chars_is_unsignedIyEE, %object
	.size	_ZNSt8__detail30__integer_to_chars_is_unsignedIyEE, 1
_ZNSt8__detail30__integer_to_chars_is_unsignedIyEE:
	.byte	1
	.type	_ZSt12__is_ratio_vISt5ratioILl1ELl1000000000EEE, %object
	.size	_ZSt12__is_ratio_vISt5ratioILl1ELl1000000000EEE, 1
_ZSt12__is_ratio_vISt5ratioILl1ELl1000000000EEE:
	.byte	1
	.type	_ZSt12__is_ratio_vISt5ratioILl1ELl1EEE, %object
	.size	_ZSt12__is_ratio_vISt5ratioILl1ELl1EEE, 1
_ZSt12__is_ratio_vISt5ratioILl1ELl1EEE:
	.byte	1
	.type	_ZSt12__is_ratio_vISt5ratioILl1000000000ELl1EEE, %object
	.size	_ZSt12__is_ratio_vISt5ratioILl1000000000ELl1EEE, 1
_ZSt12__is_ratio_vISt5ratioILl1000000000ELl1EEE:
	.byte	1
	.align	3
.LC1:
	.word	-20615843
	.word	1068661682
	.align	3
.LC2:
	.word	474164389
	.word	1072095979
	.align	3
.LC3:
	.word	261134012
	.word	1070282362
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
