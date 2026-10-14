	.arch armv8-a
	.file	"memory_pipelines.cpp"
	.text
#APP
	.globl _ZSt21ios_base_library_initv
#NO_APP
	.align	2
	.p2align 5,,15
	.global	_Z10gray_valuehhh
	.type	_Z10gray_valuehhh, %function
_Z10gray_valuehhh:
.LFB13761:
	.cfi_startproc
	and	w1, w1, 255
	and	w0, w0, 255
	adrp	x3, .LC0
	and	w2, w2, 255
	scvtf	d1, w1
	scvtf	d31, w0
	adrp	x0, .LC1
	ldr	d0, [x3, #:lo12:.LC0]
	scvtf	d30, w2
	mov	w1, 255
	ldr	d28, [x0, #:lo12:.LC1]
	adrp	x0, .LC2
	fmul	d0, d1, d0
	ldr	d29, [x0, #:lo12:.LC2]
	fmadd	d28, d31, d28, d0
	fmadd	d29, d30, d29, d28
	fcvtzu	w0, d29
	and	w2, w0, 65535
	cmp	w2, 255
	csel	w0, w0, w1, ls
	ret
	.cfi_endproc
.LFE13761:
	.size	_Z10gray_valuehhh, .-_Z10gray_valuehhh
	.align	2
	.p2align 5,,15
	.global	_Z18gradient_magnitudeii
	.type	_Z18gradient_magnitudeii, %function
_Z18gradient_magnitudeii:
.LFB13762:
	.cfi_startproc
	mul	w1, w1, w1
	madd	w0, w0, w0, w1
	scvtf	d0, w0
	fcmp	d0, #0.0
	bpl	.L7
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	bl	sqrt
	fcvtzs	w0, d0
	mov	w1, 255
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	cmp	w0, w1
	csel	w0, w0, w1, le
	ret
	.p2align 2,,3
.L7:
	fsqrt	d0, d0
	mov	w1, 255
	fcvtzs	w0, d0
	cmp	w0, w1
	csel	w0, w0, w1, le
	ret
	.cfi_endproc
.LFE13762:
	.size	_Z18gradient_magnitudeii, .-_Z18gradient_magnitudeii
	.align	2
	.p2align 5,,15
	.global	_Z12grayscale_atPN2cv3MatES1_
	.type	_Z12grayscale_atPN2cv3MatES1_, %function
_Z12grayscale_atPN2cv3MatES1_:
.LFB13763:
	.cfi_startproc
	cmp	x0, 0
	ccmp	x1, 0, 4, ne
	beq	.L21
	ldr	w2, [x0, 8]
	cmp	w2, 0
	ble	.L19
	adrp	x2, .LC0
	ldr	w3, [x0, 12]
	mov	x7, 0
	mov	w10, 255
	ldr	d31, [x2, #:lo12:.LC0]
	adrp	x2, .LC1
	ldr	d30, [x2, #:lo12:.LC1]
	adrp	x2, .LC2
	ldr	d29, [x2, #:lo12:.LC2]
	cmp	w3, 0
	ble	.L19
	.p2align 5,,15
.L22:
	mov	x2, 0
	.p2align 5,,15
.L17:
	ldr	x3, [x0, 72]
	ubfiz	x4, x2, 1, 32
	add	x4, x4, w2, uxtw
	ldr	x6, [x0, 16]
	ldr	x3, [x3]
	ldr	x8, [x1, 72]
	madd	x3, x7, x3, x4
	ldr	x9, [x1, 16]
	add	x5, x6, x3
	ldr	x4, [x8]
	ldrb	w8, [x5, 1]
	ldrb	w6, [x6, x3]
	ldrb	w3, [x5, 2]
	madd	x4, x7, x4, x9
	scvtf	d27, w8
	scvtf	d0, w6
	scvtf	d28, w3
	fmul	d27, d27, d31
	fmadd	d27, d0, d30, d27
	fmadd	d28, d28, d29, d27
	fcvtzu	w3, d28
	and	w5, w3, 65535
	cmp	w5, 255
	csel	w3, w3, w10, ls
	strb	w3, [x4, x2]
	add	x2, x2, 1
	ldr	w3, [x0, 12]
	cmp	w3, w2
	bgt	.L17
	ldr	w2, [x0, 8]
	add	w4, w7, 1
	cmp	w4, w2
	bge	.L19
	add	x7, x7, 1
	cmp	w3, 0
	bgt	.L22
.L19:
	mov	w0, 1
	ret
.L21:
	mov	w0, 0
	ret
	.cfi_endproc
.LFE13763:
	.size	_Z12grayscale_atPN2cv3MatES1_, .-_Z12grayscale_atPN2cv3MatES1_
	.align	2
	.p2align 5,,15
	.global	_Z8sobel_atPN2cv3MatES1_
	.type	_Z8sobel_atPN2cv3MatES1_, %function
_Z8sobel_atPN2cv3MatES1_:
.LFB13764:
	.cfi_startproc
	cmp	x0, 0
	ccmp	x1, 0, 4, ne
	beq	.L38
	stp	x29, x30, [sp, -128]!
	.cfi_def_cfa_offset 128
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -80
	.cfi_offset 24, -72
	mov	x23, x1
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -64
	.cfi_offset 26, -56
	mov	x25, x0
	ldp	w4, w3, [x0, 8]
	cmp	w4, 2
	ccmp	w3, 2, 4, gt
	ble	.L50
	sub	w4, w4, #1
	mov	x0, 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -104
	.cfi_offset 19, -112
	sxtw	x5, w4
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -88
	.cfi_offset 21, -96
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -40
	.cfi_offset 27, -48
	.p2align 5,,15
.L31:
	ldr	x1, [x23, 16]
	strb	wzr, [x1, x0]
	ldr	x1, [x23, 72]
	ldr	x2, [x23, 16]
	ldr	x1, [x1]
	madd	x1, x5, x1, x2
	strb	wzr, [x1, x0]
	add	x0, x0, 1
	cmp	w3, w0
	bgt	.L31
	sub	w26, w3, #1
	adrp	x20, Gx
	adrp	x19, Gy
	add	x20, x20, :lo12:Gx
	sxtw	x5, w26
	add	x19, x19, :lo12:Gy
	mov	x3, 1
	mov	w28, 255
	.p2align 5,,15
.L37:
	ldr	x0, [x23, 72]
	sub	x27, x3, #1
	ldr	x1, [x23, 16]
	mov	x24, x3
	ldr	x0, [x0]
	mov	x21, 1
	mul	x0, x3, x0
	add	x3, x3, x21
	strb	wzr, [x1, x0]
	.p2align 5,,15
.L36:
	ldr	x2, [x25, 72]
	sub	x1, x21, #1
	ldr	x0, [x25, 16]
	add	x22, x21, 1
	ldr	x2, [x2]
	ldrsb	w8, [x19, 1]
	ldrsb	w6, [x20, 1]
	madd	x9, x2, x27, x0
	ldrsb	w16, [x19]
	mul	x7, x2, x24
	ldrsb	w10, [x20]
	ldrsb	w12, [x19, 2]
	add	x13, x0, x7
	add	x2, x2, x7
	ldrb	w7, [x9, x21]
	add	x0, x0, x2
	ldrb	w17, [x9, x1]
	ldrb	w15, [x9, x22]
	ldrb	w11, [x13, x1]
	mul	w2, w8, w7
	ldrsb	w9, [x19, 3]
	ldrsb	w8, [x20, 2]
	madd	w16, w16, w17, w2
	ldrb	w14, [x13, x21]
	mul	w2, w6, w7
	ldrsb	w6, [x20, 3]
	madd	w2, w10, w17, w2
	ldrsb	w7, [x19, 4]
	madd	w12, w12, w15, w16
	madd	w9, w9, w11, w12
	ldrb	w13, [x13, x22]
	madd	w8, w8, w15, w2
	ldrsb	w10, [x19, 5]
	ldrsb	w2, [x20, 4]
	ldrb	w12, [x0, x1]
	madd	w7, w7, w14, w9
	madd	w1, w6, w11, w8
	ldrsb	w9, [x19, 6]
	ldrsb	w8, [x20, 5]
	madd	w10, w10, w13, w7
	ldrb	w11, [x0, x21]
	madd	w1, w2, w14, w1
	ldrsb	w7, [x19, 7]
	ldrsb	w6, [x20, 6]
	madd	w9, w9, w12, w10
	madd	w8, w8, w13, w1
	ldrb	w10, [x0, x22]
	ldrsb	w1, [x19, 8]
	ldrsb	w2, [x20, 7]
	madd	w7, w7, w11, w9
	ldrsb	w0, [x20, 8]
	madd	w6, w6, w12, w8
	madd	w1, w1, w10, w7
	madd	w2, w2, w11, w6
	madd	w0, w0, w10, w2
	mul	w1, w1, w1
	madd	w0, w0, w0, w1
	scvtf	d0, w0
	fcmp	d0, #0.0
	bpl	.L39
	str	x3, [sp, 104]
	str	w4, [sp, 116]
	str	x5, [sp, 120]
	bl	sqrt
	ldr	x1, [x23, 72]
	fcvtzs	w0, d0
	ldr	x6, [x23, 16]
	mov	w2, 255
	ldr	x1, [x1]
	cmp	w0, w2
	ldr	w4, [sp, 116]
	csel	w0, w0, w2, le
	cmp	w26, w22
	madd	x1, x24, x1, x6
	ldr	x3, [sp, 104]
	ldr	x5, [sp, 120]
	strb	w0, [x1, x21]
	ble	.L35
	.p2align 5,,15
.L34:
	mov	x21, x22
	b	.L36
	.p2align 2,,3
.L39:
	fsqrt	d0, d0
	ldr	x0, [x23, 72]
	ldr	x1, [x0]
	ldr	x0, [x23, 16]
	madd	x1, x24, x1, x0
	fcvtzs	w0, d0
	cmp	w0, 255
	csel	w0, w0, w28, le
	strb	w0, [x1, x21]
	cmp	w26, w22
	bgt	.L34
.L35:
	ldr	x1, [x23, 72]
	ldr	x0, [x23, 16]
	ldr	x1, [x1]
	madd	x24, x24, x1, x0
	strb	wzr, [x24, x5]
	cmp	w4, w3
	bgt	.L37
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
.L27:
	mov	w0, 1
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 128
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_def_cfa_offset 0
	ret
.L50:
	.cfi_restore_state
	cmp	w4, 0
	ble	.L27
	cmp	w3, 0
	ble	.L27
	sxtw	x3, w3
	sxtw	x5, w4
	mov	x4, 0
.L29:
	mov	x0, 0
	.p2align 5,,15
.L30:
	ldr	x1, [x23, 72]
	ldr	x2, [x23, 16]
	ldr	x1, [x1]
	madd	x1, x4, x1, x2
	strb	wzr, [x1, x0]
	add	x0, x0, 1
	cmp	x3, x0
	bne	.L30
	add	x4, x4, 1
	cmp	x5, x4
	bne	.L29
	ldp	x23, x24, [sp, 48]
	mov	w0, 1
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 128
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_def_cfa_offset 0
	ret
.L38:
	mov	w0, 0
	ret
	.cfi_endproc
.LFE13764:
	.size	_Z8sobel_atPN2cv3MatES1_, .-_Z8sobel_atPN2cv3MatES1_
	.align	2
	.p2align 5,,15
	.global	_Z17grayscale_row_ptrPKhPhi
	.type	_Z17grayscale_row_ptrPKhPhi, %function
_Z17grayscale_row_ptrPKhPhi:
.LFB13765:
	.cfi_startproc
	cmp	w2, 0
	ble	.L51
	add	x5, x1, w2, sxtw
	adrp	x2, .LC0
	mov	w6, 255
	ldr	d31, [x2, #:lo12:.LC0]
	adrp	x2, .LC1
	ldr	d30, [x2, #:lo12:.LC1]
	adrp	x2, .LC2
	ldr	d29, [x2, #:lo12:.LC2]
	.p2align 5,,15
.L53:
	ldrb	w4, [x0, 1]
	add	x0, x0, 3
	ldrb	w3, [x0, -3]
	ldrb	w2, [x0, -1]
	scvtf	d27, w4
	scvtf	d0, w3
	scvtf	d28, w2
	fmul	d27, d27, d31
	fmadd	d27, d0, d30, d27
	fmadd	d28, d28, d29, d27
	fcvtzu	w2, d28
	and	w3, w2, 65535
	cmp	w3, 255
	csel	w2, w2, w6, ls
	strb	w2, [x1], 1
	cmp	x5, x1
	bne	.L53
.L51:
	ret
	.cfi_endproc
.LFE13765:
	.size	_Z17grayscale_row_ptrPKhPhi, .-_Z17grayscale_row_ptrPKhPhi
	.align	2
	.p2align 5,,15
	.global	_Z13sobel_row_ptrPKhS0_S0_Phi
	.type	_Z13sobel_row_ptrPKhS0_S0_Phi, %function
_Z13sobel_row_ptrPKhS0_S0_Phi:
.LFB13766:
	.cfi_startproc
	strb	wzr, [x3]
	cmp	w4, 2
	ble	.L64
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	sub	w25, w4, #2
	add	x25, x0, x25
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	adrp	x20, Gx
	adrp	x19, Gy
	add	x20, x20, :lo12:Gx
	add	x19, x19, :lo12:Gy
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	mov	x21, x0
	mov	x22, x2
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	mov	x23, x1
	add	x24, x3, 1
	mov	w26, 255
	.p2align 5,,15
.L60:
	ldrb	w7, [x21, 1]
	ldrsb	w0, [x19, 1]
	ldrsb	w5, [x20, 1]
	ldrb	w9, [x21]
	ldrsb	w6, [x19]
	ldrb	w8, [x21, 2]
	mul	w0, w0, w7
	ldrsb	w2, [x19, 2]
	mul	w5, w5, w7
	ldrsb	w1, [x20]
	ldrb	w11, [x23]
	madd	w6, w6, w9, w0
	ldrsb	w7, [x19, 3]
	ldrsb	w0, [x20, 2]
	madd	w2, w2, w8, w6
	madd	w1, w1, w9, w5
	ldrb	w10, [x23, 1]
	ldrsb	w6, [x19, 4]
	ldrsb	w5, [x20, 3]
	madd	w7, w7, w11, w2
	ldrb	w9, [x23, 2]
	madd	w0, w0, w8, w1
	ldrsb	w2, [x19, 5]
	ldrsb	w1, [x20, 4]
	madd	w6, w6, w10, w7
	madd	w5, w5, w11, w0
	ldrb	w8, [x22]
	ldrsb	w0, [x19, 6]
	ldrsb	w7, [x20, 5]
	madd	w2, w2, w9, w6
	ldrb	w11, [x22, 1]
	madd	w1, w1, w10, w5
	ldrsb	w6, [x19, 7]
	ldrsb	w5, [x20, 6]
	madd	w0, w0, w8, w2
	ldrb	w10, [x22, 2]
	madd	w7, w7, w9, w1
	ldrsb	w2, [x20, 7]
	ldrsb	w1, [x19, 8]
	madd	w6, w6, w11, w0
	ldrsb	w0, [x20, 8]
	madd	w5, w5, w8, w7
	madd	w2, w2, w11, w5
	madd	w1, w1, w10, w6
	madd	w0, w0, w10, w2
	mul	w1, w1, w1
	madd	w0, w0, w0, w1
	scvtf	d0, w0
	fcmp	d0, #0.0
	bpl	.L61
	str	x3, [sp, 80]
	add	x21, x21, 1
	str	w4, [sp, 92]
	bl	sqrt
	fcvtzs	w0, d0
	mov	w1, 255
	ldr	x3, [sp, 80]
	add	x23, x23, 1
	ldr	w4, [sp, 92]
	add	x22, x22, 1
	cmp	w0, w1
	csel	w0, w0, w1, le
	strb	w0, [x24], 1
	cmp	x21, x25
	bne	.L60
	add	x4, x3, w4, sxtw
	strb	wzr, [x4, -1]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L61:
	.cfi_restore_state
	fsqrt	d0, d0
	add	x21, x21, 1
	add	x23, x23, 1
	add	x22, x22, 1
	fcvtzs	w0, d0
	cmp	w0, 255
	csel	w0, w0, w26, le
	strb	w0, [x24], 1
	cmp	x25, x21
	bne	.L60
	add	x4, x3, w4, sxtw
	strb	wzr, [x4, -1]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L64:
	add	x4, x3, w4, sxtw
	strb	wzr, [x4, -1]
	ret
	.cfi_endproc
.LFE13766:
	.size	_Z13sobel_row_ptrPKhS0_S0_Phi, .-_Z13sobel_row_ptrPKhS0_S0_Phi
	.align	2
	.p2align 5,,15
	.global	_Z12zero_row_ptrPhi
	.type	_Z12zero_row_ptrPhi, %function
_Z12zero_row_ptrPhi:
.LFB13767:
	.cfi_startproc
	cmp	w1, 0
	ble	.L67
	uxtw	x2, w1
	mov	w1, 0
	b	memset
	.p2align 2,,3
.L67:
	ret
	.cfi_endproc
.LFE13767:
	.size	_Z12zero_row_ptrPhi, .-_Z12zero_row_ptrPhi
	.align	2
	.p2align 5,,15
	.global	_Z13grayscale_ptrPN2cv3MatES1_
	.type	_Z13grayscale_ptrPN2cv3MatES1_, %function
_Z13grayscale_ptrPN2cv3MatES1_:
.LFB13768:
	.cfi_startproc
	cmp	x0, 0
	ccmp	x1, 0, 4, ne
	beq	.L76
	ldr	w2, [x0, 8]
	mov	x9, 0
	cmp	w2, 0
	ble	.L75
	adrp	x2, .LC0
	mov	w10, 3
	mov	w8, 255
	ldr	d31, [x2, #:lo12:.LC0]
	adrp	x2, .LC1
	ldr	d30, [x2, #:lo12:.LC1]
	adrp	x2, .LC2
	ldr	d29, [x2, #:lo12:.LC2]
	.p2align 5,,15
.L71:
	ldr	x2, [x0, 72]
	ldr	x3, [x1, 72]
	ldr	x2, [x2]
	ldr	x3, [x3]
	ldr	x5, [x0, 16]
	ldr	w7, [x0, 12]
	mul	x3, x9, x3
	ldr	x4, [x1, 16]
	madd	x2, x9, x2, x5
	cmp	w7, 0
	ble	.L75
	umaddl	x7, w7, w10, x2
	add	x4, x4, x3
	.p2align 5,,15
.L73:
	ldrb	w6, [x2, 1]
	add	x2, x2, 3
	ldrb	w5, [x2, -3]
	ldrb	w3, [x2, -1]
	scvtf	d27, w6
	scvtf	d0, w5
	scvtf	d28, w3
	fmul	d27, d27, d31
	fmadd	d27, d0, d30, d27
	fmadd	d28, d28, d29, d27
	fcvtzu	w3, d28
	and	w5, w3, 65535
	cmp	w5, 255
	csel	w3, w3, w8, ls
	strb	w3, [x4], 1
	cmp	x2, x7
	bne	.L73
	ldr	w2, [x0, 8]
	add	w3, w9, 1
	cmp	w3, w2
	bge	.L75
	add	x9, x9, 1
	b	.L71
	.p2align 2,,3
.L75:
	mov	w0, 1
	ret
.L76:
	mov	w0, 0
	ret
	.cfi_endproc
.LFE13768:
	.size	_Z13grayscale_ptrPN2cv3MatES1_, .-_Z13grayscale_ptrPN2cv3MatES1_
	.align	2
	.p2align 5,,15
	.global	_Z9sobel_ptrPN2cv3MatES1_
	.type	_Z9sobel_ptrPN2cv3MatES1_, %function
_Z9sobel_ptrPN2cv3MatES1_:
.LFB13769:
	.cfi_startproc
	cmp	x0, 0
	ccmp	x1, 0, 4, ne
	beq	.L87
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x20, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x21, x0
	str	x23, [sp, 48]
	.cfi_offset 23, -16
	ldp	w22, w23, [x0, 8]
	cmp	w22, 2
	ccmp	w23, 2, 4, gt
	ble	.L94
	ldr	x0, [x20, 16]
	uxtw	x19, w23
	mov	x2, x19
	mov	w1, 0
	sub	w22, w22, #1
	bl	memset
	ldr	x0, [x20, 72]
	sxtw	x4, w22
	ldr	x3, [x20, 16]
	mov	x2, x19
	ldr	x0, [x0]
	mov	w1, 0
	mov	x19, 1
	madd	x0, x4, x0, x3
	bl	memset
	.p2align 5,,15
.L86:
	ldr	x1, [x20, 72]
	sub	x0, x19, #1
	ldr	x2, [x21, 72]
	mov	w4, w23
	ldr	x3, [x1]
	ldr	x5, [x2]
	ldr	x1, [x21, 16]
	ldr	x7, [x20, 16]
	mul	x6, x5, x19
	madd	x0, x0, x5, x1
	add	x2, x6, x5
	madd	x3, x19, x3, x7
	add	x2, x1, x2
	add	x19, x19, 1
	add	x1, x1, x6
	bl	_Z13sobel_row_ptrPKhS0_S0_Phi
	cmp	w22, w19
	bgt	.L86
.L84:
	ldr	x23, [sp, 48]
	mov	w0, 1
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L94:
	.cfi_restore_state
	cmp	w22, 0
	ble	.L84
	cmp	w23, 0
	ble	.L84
	sxtw	x22, w22
	uxtw	x23, w23
	mov	x19, 0
	.p2align 5,,15
.L85:
	ldr	x3, [x20, 72]
	mov	x2, x23
	ldr	x0, [x20, 16]
	mov	w1, 0
	ldr	x3, [x3]
	madd	x0, x19, x3, x0
	add	x19, x19, 1
	bl	memset
	cmp	x19, x22
	bne	.L85
	ldr	x23, [sp, 48]
	mov	w0, 1
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L87:
	mov	w0, 0
	ret
	.cfi_endproc
.LFE13769:
	.size	_Z9sobel_ptrPN2cv3MatES1_, .-_Z9sobel_ptrPN2cv3MatES1_
	.align	2
	.p2align 5,,15
	.global	_Z15sobel_streamingPN2cv3MatES1_S1_
	.type	_Z15sobel_streamingPN2cv3MatES1_S1_, %function
_Z15sobel_streamingPN2cv3MatES1_S1_:
.LFB13770:
	.cfi_startproc
	cmp	x1, 0
	ccmp	x2, 0, 4, ne
	ccmp	x0, 0, 4, ne
	beq	.L105
	stp	x29, x30, [sp, -128]!
	.cfi_def_cfa_offset 128
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -80
	.cfi_offset 24, -72
	mov	x23, x2
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -64
	.cfi_offset 26, -56
	mov	x25, x0
	mov	w0, 0
	ldr	w2, [x1, 8]
	cmp	w2, 2
	ble	.L95
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -88
	.cfi_offset 21, -96
	ldr	w2, [x1, 12]
	ldr	w21, [x25, 12]
	cmp	w2, w21
	blt	.L117
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -104
	.cfi_offset 19, -112
	ldr	w19, [x25, 8]
	cmp	w19, 2
	ccmp	w21, 2, 4, gt
	bgt	.L97
	cmp	w19, 0
	ble	.L99
	cmp	w21, 0
	ble	.L99
	sxtw	x19, w19
	uxtw	x21, w21
	mov	x20, 0
	.p2align 5,,15
.L100:
	ldr	x3, [x23, 72]
	mov	x2, x21
	ldr	x0, [x23, 16]
	mov	w1, 0
	ldr	x3, [x3]
	madd	x0, x20, x3, x0
	add	x20, x20, 1
	bl	memset
	cmp	x20, x19
	bne	.L100
.L99:
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	mov	w0, 1
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
.L95:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 128
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L105:
	mov	w0, 0
	ret
	.p2align 2,,3
.L97:
	.cfi_def_cfa_offset 128
	.cfi_offset 19, -112
	.cfi_offset 20, -104
	.cfi_offset 21, -96
	.cfi_offset 22, -88
	.cfi_offset 23, -80
	.cfi_offset 24, -72
	.cfi_offset 25, -64
	.cfi_offset 26, -56
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -40
	.cfi_offset 27, -48
	mov	x2, 0
	mov	w5, 255
	stp	d13, d14, [sp, 96]
	.cfi_offset 78, -24
	.cfi_offset 77, -32
	ldr	x0, [x1, 72]
	ldr	x27, [x1, 16]
	adrp	x1, .LC0
	ldr	x22, [x0]
	adrp	x0, .LC1
	ldr	d31, [x1, #:lo12:.LC0]
	adrp	x1, .LC2
	add	x28, x27, x22
	ldr	d30, [x0, #:lo12:.LC1]
	ldr	d29, [x1, #:lo12:.LC2]
	add	x22, x27, x22, lsl 1
	ldr	x0, [x25, 16]
	str	d15, [sp, 112]
	.cfi_offset 79, -16
	.p2align 5,,15
.L101:
	ldrb	w4, [x0, 1]
	add	x0, x0, 3
	ldrb	w3, [x0, -3]
	ldrb	w1, [x0, -1]
	scvtf	d27, w4
	scvtf	d0, w3
	scvtf	d28, w1
	fmul	d27, d27, d31
	fmadd	d27, d0, d30, d27
	fmadd	d28, d28, d29, d27
	fcvtzu	w1, d28
	and	w3, w1, 65535
	cmp	w3, 255
	csel	w1, w1, w5, ls
	strb	w1, [x27, x2]
	add	x2, x2, 1
	cmp	w21, w2
	bgt	.L101
	ldr	x1, [x25, 72]
	adrp	x3, .LC0
	ldr	x0, [x25, 16]
	mov	x2, 0
	ldr	d26, [x3, #:lo12:.LC0]
	adrp	x3, .LC1
	ldr	x1, [x1]
	mov	w5, 255
	ldr	d25, [x3, #:lo12:.LC1]
	adrp	x3, .LC2
	add	x0, x0, x1
	ldr	d24, [x3, #:lo12:.LC2]
	.p2align 5,,15
.L102:
	ldrb	w4, [x0, 1]
	add	x0, x0, 3
	ldrb	w3, [x0, -3]
	ldrb	w1, [x0, -1]
	scvtf	d22, w4
	scvtf	d1, w3
	scvtf	d23, w1
	fmul	d22, d22, d26
	fmadd	d22, d1, d25, d22
	fmadd	d23, d23, d24, d22
	fcvtzu	w1, d23
	and	w3, w1, 65535
	cmp	w3, 255
	csel	w1, w1, w5, ls
	strb	w1, [x28, x2]
	add	x2, x2, 1
	cmp	w21, w2
	bgt	.L102
	ldr	x0, [x23, 16]
	uxtw	x20, w21
	mov	x2, x20
	mov	w1, 0
	sub	w19, w19, #1
	mov	x26, 1
	bl	memset
	mov	w24, 255
	adrp	x0, .LC0
	ldr	d15, [x0, #:lo12:.LC0]
	adrp	x0, .LC1
	ldr	d14, [x0, #:lo12:.LC1]
	adrp	x0, .LC2
	ldr	d13, [x0, #:lo12:.LC2]
	.p2align 5,,15
.L104:
	ldr	x1, [x25, 72]
	mov	x9, x26
	ldr	x0, [x25, 16]
	add	x26, x26, 1
	ldr	x1, [x1]
	mov	x6, 0
	madd	x1, x26, x1, x0
	.p2align 5,,15
.L103:
	ldrb	w8, [x1, 1]
	add	x1, x1, 3
	ldrb	w7, [x1, -3]
	ldrb	w5, [x1, -1]
	scvtf	d20, w8
	scvtf	d2, w7
	scvtf	d21, w5
	fmul	d20, d20, d15
	fmadd	d20, d2, d14, d20
	fmadd	d21, d21, d13, d20
	fcvtzu	w5, d21
	and	w7, w5, 65535
	cmp	w7, 255
	csel	w5, w5, w24, ls
	strb	w5, [x22, x6]
	add	x6, x6, 1
	cmp	w21, w6
	bgt	.L103
	ldr	x0, [x23, 72]
	mov	x2, x22
	ldr	x5, [x23, 16]
	mov	x1, x28
	ldr	x3, [x0]
	mov	w4, w21
	mov	x0, x27
	madd	x3, x9, x3, x5
	bl	_Z13sobel_row_ptrPKhS0_S0_Phi
	mov	x0, x28
	mov	x28, x22
	mov	x22, x27
	cmp	w19, w26
	ble	.L118
	mov	x27, x0
	b	.L104
	.p2align 2,,3
.L117:
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 77
	.cfi_restore 78
	.cfi_restore 79
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 128
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L118:
	.cfi_def_cfa_offset 128
	.cfi_offset 19, -112
	.cfi_offset 20, -104
	.cfi_offset 21, -96
	.cfi_offset 22, -88
	.cfi_offset 23, -80
	.cfi_offset 24, -72
	.cfi_offset 25, -64
	.cfi_offset 26, -56
	.cfi_offset 27, -48
	.cfi_offset 28, -40
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	.cfi_offset 77, -32
	.cfi_offset 78, -24
	.cfi_offset 79, -16
	ldr	x1, [x23, 72]
	sxtw	x19, w19
	ldr	x0, [x23, 16]
	mov	x2, x20
	ldr	x3, [x1]
	mov	w1, 0
	madd	x0, x19, x3, x0
	bl	memset
	ldr	d15, [sp, 112]
	.cfi_restore 79
	mov	w0, 1
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	d13, d14, [sp, 96]
	.cfi_restore 78
	.cfi_restore 77
	b	.L95
	.cfi_endproc
.LFE13770:
	.size	_Z15sobel_streamingPN2cv3MatES1_S1_, .-_Z15sobel_streamingPN2cv3MatES1_S1_
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
	.section	.rodata.cst8,"aM",@progbits,8
	.align	3
.LC0:
	.word	474164389
	.word	1072095979
	.align	3
.LC1:
	.word	-20615843
	.word	1068661682
	.align	3
.LC2:
	.word	261134012
	.word	1070282362
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
