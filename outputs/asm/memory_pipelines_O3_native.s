	.arch armv8.2-a+dotprod+crc+crypto+fp16+rcpc
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
	adrp	x3, .LC0
	and	w1, w1, 255
	and	w0, w0, 255
	and	w2, w2, 255
	ldr	d0, [x3, #:lo12:.LC0]
	scvtf	d1, w1
	adrp	x3, .LC1
	scvtf	d31, w0
	adrp	x0, .LC2
	scvtf	d30, w2
	ldr	d28, [x3, #:lo12:.LC1]
	mov	w3, 255
	ldr	d29, [x0, #:lo12:.LC2]
	fmul	d0, d1, d0
	fmadd	d28, d31, d28, d0
	fmadd	d29, d30, d29, d28
	fcvtzu	w0, d29
	and	w1, w0, 65535
	cmp	w1, 255
	csel	w0, w0, w3, ls
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
	ubfiz	x5, x2, 1, 32
	add	x5, x5, w2, uxtw
	ldr	x6, [x0, 16]
	ldr	x4, [x1, 72]
	ldr	x3, [x3]
	ldr	x9, [x1, 16]
	ldr	x4, [x4]
	madd	x3, x7, x3, x5
	add	x5, x6, x3
	ldrb	w8, [x6, x3]
	madd	x4, x7, x4, x9
	ldrb	w6, [x5, 1]
	ldrb	w3, [x5, 2]
	scvtf	d0, w8
	scvtf	d27, w6
	scvtf	d28, w3
	fmul	d27, d27, d31
	fmadd	d27, d0, d30, d27
	fmadd	d28, d28, d29, d27
	fcvtzu	w3, d28
	and	w5, w3, 65535
	cmp	w5, 255
	csel	w3, w3, w10, ls
	strb	w3, [x4, x2]
	ldr	w3, [x0, 12]
	add	x2, x2, 1
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
	sxtw	x5, w26
	add	x20, x20, :lo12:Gx
	add	x19, x19, :lo12:Gy
	mov	x3, 1
	mov	w28, 255
	.p2align 5,,15
.L37:
	ldr	x0, [x23, 72]
	mov	x21, 1
	sub	x27, x3, #1
	mov	x24, x3
	ldr	x1, [x23, 16]
	ldr	x0, [x0]
	mul	x0, x3, x0
	add	x3, x3, x21
	strb	wzr, [x1, x0]
	.p2align 5,,15
.L36:
	ldr	x2, [x25, 72]
	sub	x1, x21, #1
	add	x22, x21, 1
	ldr	x0, [x25, 16]
	ldrsb	w7, [x19, 1]
	ldr	x2, [x2]
	ldrsb	w6, [x19]
	ldrsb	w10, [x20, 1]
	madd	x12, x2, x27, x0
	mul	x11, x2, x24
	ldrsb	w8, [x19, 2]
	ldrb	w14, [x12, x21]
	add	x9, x0, x11
	add	x2, x2, x11
	ldrb	w11, [x12, x1]
	add	x0, x0, x2
	ldrb	w13, [x12, x22]
	mul	w7, w7, w14
	ldrsb	w2, [x20]
	mul	w10, w10, w14
	madd	w6, w6, w11, w7
	ldrb	w12, [x9, x1]
	ldrsb	w7, [x19, 3]
	madd	w8, w8, w13, w6
	ldrsb	w6, [x20, 2]
	madd	w2, w2, w11, w10
	ldrb	w11, [x9, x21]
	madd	w7, w7, w12, w8
	ldrsb	w8, [x19, 4]
	madd	w6, w6, w13, w2
	ldrsb	w2, [x20, 3]
	ldrb	w10, [x9, x22]
	madd	w8, w8, w11, w7
	ldrsb	w7, [x19, 5]
	madd	w2, w2, w12, w6
	ldrsb	w6, [x20, 4]
	ldrb	w9, [x0, x1]
	madd	w7, w7, w10, w8
	ldrsb	w1, [x19, 6]
	madd	w6, w6, w11, w2
	ldrsb	w2, [x20, 5]
	ldrb	w8, [x0, x21]
	madd	w1, w1, w9, w7
	ldrsb	w7, [x19, 7]
	madd	w2, w2, w10, w6
	ldrsb	w6, [x20, 6]
	ldrb	w10, [x0, x22]
	madd	w7, w7, w8, w1
	ldrsb	w1, [x19, 8]
	madd	w6, w6, w9, w2
	ldrsb	w2, [x20, 7]
	ldrsb	w0, [x20, 8]
	madd	w1, w1, w10, w7
	madd	w2, w2, w8, w6
	mul	w1, w1, w1
	madd	w0, w0, w10, w2
	madd	w0, w0, w0, w1
	scvtf	d0, w0
	fcmp	d0, #0.0
	bpl	.L39
	str	w4, [sp, 108]
	stp	x5, x3, [sp, 112]
	bl	sqrt
	ldr	x0, [x23, 72]
	mov	w2, 255
	ldr	x6, [x23, 16]
	ldr	w4, [sp, 108]
	ldr	x1, [x0]
	fcvtzs	w0, d0
	madd	x1, x24, x1, x6
	cmp	w0, w2
	csel	w0, w0, w2, le
	cmp	w26, w22
	strb	w0, [x1, x21]
	ldp	x5, x3, [sp, 112]
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
	sxtw	x5, w4
	sxtw	x3, w3
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
	movi	v28.4s, 0
	cmp	w2, 0
	ble	.L51
	sub	w3, w2, #1
	sxtw	x4, w2
	cmp	w3, 14
	bls	.L53
	ubfiz	x3, x2, 1, 32
	sxtw	x4, w2
	add	x3, x3, w2, uxtw
	add	x3, x0, x3
	add	x5, x1, x4
	cmp	x1, x3
	ccmp	x0, x5, 2, cc
	bcc	.L53
	adrp	x6, .LC4
	adrp	x3, .LC3
	movi	v24.8h, 0xff
	mov	x4, x0
	lsr	w5, w2, 4
	add	x5, x1, w5, uxtw 4
	ldr	q26, [x6, #:lo12:.LC4]
	adrp	x6, .LC5
	ldr	q25, [x6, #:lo12:.LC5]
	ldr	q27, [x3, #:lo12:.LC3]
	mov	x3, x1
	.p2align 5,,15
.L54:
	ld3	{v29.16b - v31.16b}, [x4], 48
	mov	v22.16b, v30.16b
	mov	v23.16b, v29.16b
	zip1	v30.16b, v30.16b, v28.16b
	zip1	v29.16b, v29.16b, v28.16b
	zip2	v21.16b, v31.16b, v28.16b
	zip2	v22.16b, v22.16b, v28.16b
	zip2	v23.16b, v23.16b, v28.16b
	zip1	v6.8h, v30.8h, v28.8h
	zip1	v20.8h, v29.8h, v28.8h
	zip1	v5.8h, v22.8h, v28.8h
	zip2	v22.8h, v22.8h, v28.8h
	zip1	v19.8h, v23.8h, v28.8h
	sxtl2	v4.2d, v6.4s
	sxtl	v2.2d, v5.2s
	sxtl	v1.2d, v22.2s
	sxtl2	v5.2d, v5.4s
	sxtl2	v22.2d, v22.4s
	scvtf	v2.2d, v2.2d
	sxtl	v6.2d, v6.2s
	zip2	v23.8h, v23.8h, v28.8h
	sxtl	v16.2d, v19.2s
	zip2	v30.8h, v30.8h, v28.8h
	scvtf	v5.2d, v5.2d
	scvtf	v22.2d, v22.2d
	scvtf	v1.2d, v1.2d
	scvtf	v6.2d, v6.2d
	scvtf	v16.2d, v16.2d
	sxtl	v7.2d, v23.2s
	sxtl2	v18.2d, v20.4s
	sxtl	v3.2d, v30.2s
	sxtl2	v19.2d, v19.4s
	sxtl2	v23.2d, v23.4s
	sxtl	v20.2d, v20.2s
	sxtl2	v30.2d, v30.4s
	zip2	v29.8h, v29.8h, v28.8h
	fmul	v2.2d, v2.2d, v27.2d
	zip1	v31.16b, v31.16b, v28.16b
	scvtf	v19.2d, v19.2d
	scvtf	v23.2d, v23.2d
	scvtf	v7.2d, v7.2d
	scvtf	v20.2d, v20.2d
	scvtf	v4.2d, v4.2d
	scvtf	v3.2d, v3.2d
	scvtf	v30.2d, v30.2d
	sxtl	v17.2d, v29.2s
	fmul	v5.2d, v5.2d, v27.2d
	fmul	v22.2d, v22.2d, v27.2d
	fmul	v1.2d, v1.2d, v27.2d
	fmul	v6.2d, v6.2d, v27.2d
	sxtl2	v29.2d, v29.4s
	zip1	v0.8h, v31.8h, v28.8h
	fmla	v2.2d, v16.2d, v26.2d
	zip2	v31.8h, v31.8h, v28.8h
	zip1	v16.8h, v21.8h, v28.8h
	zip2	v21.8h, v21.8h, v28.8h
	scvtf	v18.2d, v18.2d
	scvtf	v17.2d, v17.2d
	scvtf	v29.2d, v29.2d
	fmla	v5.2d, v19.2d, v26.2d
	sxtl2	v19.2d, v0.4s
	fmla	v22.2d, v23.2d, v26.2d
	sxtl	v0.2d, v0.2s
	fmla	v1.2d, v7.2d, v26.2d
	sxtl	v23.2d, v16.2s
	fmla	v6.2d, v20.2d, v26.2d
	sxtl	v7.2d, v31.2s
	sxtl	v20.2d, v21.2s
	fmul	v4.2d, v4.2d, v27.2d
	fmul	v3.2d, v3.2d, v27.2d
	fmul	v30.2d, v30.2d, v27.2d
	sxtl2	v16.2d, v16.4s
	sxtl2	v21.2d, v21.4s
	sxtl2	v31.2d, v31.4s
	scvtf	v23.2d, v23.2d
	scvtf	v16.2d, v16.2d
	scvtf	v20.2d, v20.2d
	scvtf	v21.2d, v21.2d
	scvtf	v0.2d, v0.2d
	scvtf	v19.2d, v19.2d
	scvtf	v7.2d, v7.2d
	scvtf	v31.2d, v31.2d
	fmla	v4.2d, v18.2d, v26.2d
	fmla	v3.2d, v17.2d, v26.2d
	fmla	v30.2d, v29.2d, v26.2d
	fmla	v2.2d, v23.2d, v25.2d
	fmla	v5.2d, v16.2d, v25.2d
	fmla	v1.2d, v20.2d, v25.2d
	fmla	v22.2d, v21.2d, v25.2d
	fmla	v6.2d, v0.2d, v25.2d
	fmla	v4.2d, v19.2d, v25.2d
	fmla	v3.2d, v7.2d, v25.2d
	fmla	v30.2d, v31.2d, v25.2d
	fcvtzs	v2.2d, v2.2d
	fcvtzs	v5.2d, v5.2d
	fcvtzs	v1.2d, v1.2d
	fcvtzs	v22.2d, v22.2d
	fcvtzs	v6.2d, v6.2d
	fcvtzs	v4.2d, v4.2d
	fcvtzs	v3.2d, v3.2d
	fcvtzs	v30.2d, v30.2d
	uzp1	v5.4s, v2.4s, v5.4s
	uzp1	v22.4s, v1.4s, v22.4s
	uzp1	v4.4s, v6.4s, v4.4s
	uzp1	v30.4s, v3.4s, v30.4s
	uzp1	v22.8h, v5.8h, v22.8h
	uzp1	v30.8h, v4.8h, v30.8h
	umin	v22.8h, v22.8h, v24.8h
	umin	v30.8h, v30.8h, v24.8h
	uzp1	v22.16b, v30.16b, v22.16b
	str	q22, [x3], 16
	cmp	x5, x3
	bne	.L54
	and	w3, w2, -16
	cmp	w2, w3
	beq	.L51
	adrp	x4, .LC0
	adrp	x5, .LC1
	mov	w7, 255
	ldr	d31, [x4, #:lo12:.LC0]
	uxtw	x4, w3
	add	w3, w3, w3, lsl 1
	add	x0, x0, w3, sxtw
	adrp	x3, .LC2
	ldr	d30, [x5, #:lo12:.LC1]
	ldr	d29, [x3, #:lo12:.LC2]
	.p2align 5,,15
.L56:
	add	x0, x0, 3
	ldrb	w6, [x0, -2]
	ldrb	w5, [x0, -3]
	ldrb	w3, [x0, -1]
	scvtf	d27, w6
	scvtf	d0, w5
	scvtf	d28, w3
	fmul	d27, d27, d31
	fmadd	d27, d0, d30, d27
	fmadd	d28, d28, d29, d27
	fcvtzu	w3, d28
	and	w5, w3, 65535
	cmp	w5, 255
	csel	w3, w3, w7, ls
	strb	w3, [x1, x4]
	add	x4, x4, 1
	cmp	w2, w4
	bgt	.L56
.L51:
	ret
	.p2align 2,,3
.L53:
	adrp	x2, .LC0
	add	x4, x1, x4
	mov	w6, 255
	ldr	d26, [x2, #:lo12:.LC0]
	adrp	x2, .LC1
	ldr	d25, [x2, #:lo12:.LC1]
	adrp	x2, .LC2
	ldr	d24, [x2, #:lo12:.LC2]
	.p2align 5,,15
.L57:
	add	x0, x0, 3
	ldrb	w5, [x0, -2]
	ldrb	w3, [x0, -3]
	ldrb	w2, [x0, -1]
	scvtf	d22, w5
	scvtf	d1, w3
	scvtf	d23, w2
	fmul	d22, d22, d26
	fmadd	d22, d1, d25, d22
	fmadd	d23, d23, d24, d22
	fcvtzu	w2, d23
	and	w3, w2, 65535
	cmp	w3, 255
	csel	w2, w2, w6, ls
	strb	w2, [x1], 1
	cmp	x4, x1
	bne	.L57
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
	ble	.L76
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	adrp	x20, Gx
	adrp	x19, Gy
	add	x20, x20, :lo12:Gx
	add	x19, x19, :lo12:Gy
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	sub	w25, w4, #2
	mov	w26, 255
	add	x25, x0, x25
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
	.p2align 5,,15
.L72:
	ldrb	w8, [x21, 1]
	ldrsb	w0, [x19, 1]
	ldrb	w6, [x21]
	ldrsb	w5, [x19]
	mul	w0, w0, w8
	ldrsb	w2, [x20, 1]
	ldrb	w7, [x21, 2]
	madd	w5, w5, w6, w0
	ldrsb	w1, [x19, 2]
	mul	w2, w2, w8
	ldrsb	w0, [x20]
	ldrb	w8, [x23]
	madd	w1, w1, w7, w5
	ldrsb	w5, [x19, 3]
	madd	w0, w0, w6, w2
	ldrsb	w2, [x20, 2]
	ldrb	w6, [x23, 1]
	madd	w5, w5, w8, w1
	ldrsb	w1, [x19, 4]
	madd	w2, w2, w7, w0
	ldrsb	w0, [x20, 3]
	ldrb	w7, [x23, 2]
	madd	w1, w1, w6, w5
	ldrsb	w5, [x19, 5]
	madd	w0, w0, w8, w2
	ldrsb	w2, [x20, 4]
	ldrb	w9, [x22]
	madd	w5, w5, w7, w1
	ldrsb	w1, [x19, 6]
	madd	w2, w2, w6, w0
	ldrsb	w0, [x20, 5]
	ldrb	w8, [x22, 1]
	madd	w1, w1, w9, w5
	ldrsb	w6, [x19, 7]
	madd	w0, w0, w7, w2
	ldrsb	w5, [x20, 6]
	ldrb	w7, [x22, 2]
	madd	w6, w6, w8, w1
	ldrsb	w2, [x20, 7]
	madd	w5, w5, w9, w0
	ldrsb	w1, [x19, 8]
	ldrsb	w0, [x20, 8]
	madd	w2, w2, w8, w5
	madd	w1, w1, w7, w6
	madd	w0, w0, w7, w2
	mul	w1, w1, w1
	madd	w0, w0, w0, w1
	scvtf	d0, w0
	fcmp	d0, #0.0
	bpl	.L73
	str	x3, [sp, 80]
	add	x21, x21, 1
	add	x23, x23, 1
	str	w4, [sp, 92]
	add	x22, x22, 1
	bl	sqrt
	fcvtzs	w0, d0
	mov	w1, 255
	ldr	x3, [sp, 80]
	ldr	w4, [sp, 92]
	cmp	w0, w1
	csel	w0, w0, w1, le
	strb	w0, [x24], 1
	cmp	x21, x25
	bne	.L72
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
.L73:
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
	bne	.L72
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
.L76:
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
	ble	.L79
	uxtw	x2, w1
	mov	w1, 0
	b	memset
	.p2align 2,,3
.L79:
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
	beq	.L93
	ldr	w2, [x0, 8]
	mov	x10, 0
	cmp	w2, 0
	ble	.L105
	adrp	x2, .LC0
	movi	v28.4s, 0
	movi	v21.8h, 0xff
	mov	w11, 3
	mov	w9, 255
	stp	d14, d15, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 78, -16
	.cfi_offset 79, -8
	ldr	d27, [x2, #:lo12:.LC0]
	adrp	x2, .LC1
	ldr	d26, [x2, #:lo12:.LC1]
	adrp	x2, .LC2
	ldr	d25, [x2, #:lo12:.LC2]
	dup	v24.2d, v27.d[0]
	dup	v23.2d, v26.d[0]
	dup	v22.2d, v25.d[0]
	.p2align 5,,15
.L83:
	ldr	x3, [x0, 72]
	ldr	x2, [x1, 72]
	ldr	x7, [x0, 16]
	ldr	x4, [x3]
	ldr	x2, [x2]
	ldr	w5, [x0, 12]
	mul	x4, x10, x4
	ldr	x8, [x1, 16]
	mul	x2, x10, x2
	add	x6, x7, x4
	cmp	w5, 0
	ble	.L92
	sub	w3, w5, #1
	cmp	w3, 14
	bls	.L109
	ubfiz	x3, x5, 1, 32
	add	x3, x3, w5, uxtw
	add	x3, x3, x4
	add	x3, x7, x3
	add	x7, x8, x2
	add	x2, x2, w5, sxtw
	cmp	x7, x3
	add	x8, x8, x2
	ccmp	x6, x8, 2, cc
	bcc	.L85
	mov	x3, x6
	mov	x2, x7
	lsr	w4, w5, 4
	add	x4, x7, w4, uxtw 4
	.p2align 5,,15
.L86:
	ld3	{v29.16b - v31.16b}, [x3], 48
	mov	v16.16b, v30.16b
	mov	v17.16b, v29.16b
	zip1	v30.16b, v30.16b, v28.16b
	zip1	v29.16b, v29.16b, v28.16b
	zip2	v7.16b, v31.16b, v28.16b
	zip2	v16.16b, v16.16b, v28.16b
	zip1	v0.8h, v30.8h, v28.8h
	zip2	v30.8h, v30.8h, v28.8h
	zip2	v17.16b, v17.16b, v28.16b
	zip1	v15.8h, v16.8h, v28.8h
	zip2	v16.8h, v16.8h, v28.8h
	sxtl	v20.2d, v30.2s
	sxtl2	v30.2d, v30.4s
	sxtl	v19.2d, v15.2s
	zip1	v5.8h, v17.8h, v28.8h
	zip1	v6.8h, v29.8h, v28.8h
	zip2	v29.8h, v29.8h, v28.8h
	sxtl	v18.2d, v16.2s
	sxtl2	v14.2d, v0.4s
	scvtf	v19.2d, v19.2d
	scvtf	v30.2d, v30.2d
	sxtl2	v15.2d, v15.4s
	sxtl2	v16.2d, v16.4s
	sxtl	v0.2d, v0.2s
	zip2	v17.8h, v17.8h, v28.8h
	sxtl	v2.2d, v5.2s
	sxtl	v3.2d, v29.2s
	sxtl2	v29.2d, v29.4s
	scvtf	v15.2d, v15.2d
	scvtf	v16.2d, v16.2d
	scvtf	v18.2d, v18.2d
	scvtf	v0.2d, v0.2d
	scvtf	v2.2d, v2.2d
	scvtf	v29.2d, v29.2d
	sxtl	v1.2d, v17.2s
	sxtl2	v4.2d, v6.4s
	sxtl2	v5.2d, v5.4s
	sxtl2	v17.2d, v17.4s
	sxtl	v6.2d, v6.2s
	fmul	v19.2d, v19.2d, v24.2d
	fmul	v30.2d, v30.2d, v24.2d
	zip1	v31.16b, v31.16b, v28.16b
	scvtf	v5.2d, v5.2d
	scvtf	v17.2d, v17.2d
	scvtf	v1.2d, v1.2d
	scvtf	v6.2d, v6.2d
	scvtf	v14.2d, v14.2d
	scvtf	v20.2d, v20.2d
	fmul	v15.2d, v15.2d, v24.2d
	fmul	v16.2d, v16.2d, v24.2d
	fmul	v18.2d, v18.2d, v24.2d
	fmul	v0.2d, v0.2d, v24.2d
	fmla	v19.2d, v2.2d, v23.2d
	fmla	v30.2d, v29.2d, v23.2d
	zip1	v2.8h, v7.8h, v28.8h
	zip1	v29.8h, v31.8h, v28.8h
	zip2	v7.8h, v7.8h, v28.8h
	zip2	v31.8h, v31.8h, v28.8h
	scvtf	v4.2d, v4.2d
	scvtf	v3.2d, v3.2d
	fmla	v15.2d, v5.2d, v23.2d
	sxtl2	v5.2d, v29.4s
	fmla	v16.2d, v17.2d, v23.2d
	sxtl	v29.2d, v29.2s
	fmla	v18.2d, v1.2d, v23.2d
	sxtl	v17.2d, v2.2s
	fmla	v0.2d, v6.2d, v23.2d
	sxtl	v1.2d, v31.2s
	sxtl	v6.2d, v7.2s
	fmul	v14.2d, v14.2d, v24.2d
	fmul	v20.2d, v20.2d, v24.2d
	sxtl2	v2.2d, v2.4s
	sxtl2	v7.2d, v7.4s
	sxtl2	v31.2d, v31.4s
	scvtf	v17.2d, v17.2d
	scvtf	v2.2d, v2.2d
	scvtf	v6.2d, v6.2d
	scvtf	v7.2d, v7.2d
	scvtf	v29.2d, v29.2d
	scvtf	v5.2d, v5.2d
	scvtf	v1.2d, v1.2d
	scvtf	v31.2d, v31.2d
	fmla	v14.2d, v4.2d, v23.2d
	fmla	v20.2d, v3.2d, v23.2d
	fmla	v19.2d, v17.2d, v22.2d
	fmla	v15.2d, v2.2d, v22.2d
	fmla	v18.2d, v6.2d, v22.2d
	fmla	v16.2d, v7.2d, v22.2d
	fmla	v0.2d, v29.2d, v22.2d
	fmla	v14.2d, v5.2d, v22.2d
	fmla	v20.2d, v1.2d, v22.2d
	fmla	v30.2d, v31.2d, v22.2d
	fcvtzs	v19.2d, v19.2d
	fcvtzs	v15.2d, v15.2d
	fcvtzs	v18.2d, v18.2d
	fcvtzs	v16.2d, v16.2d
	fcvtzs	v0.2d, v0.2d
	fcvtzs	v14.2d, v14.2d
	fcvtzs	v20.2d, v20.2d
	fcvtzs	v30.2d, v30.2d
	uzp1	v15.4s, v19.4s, v15.4s
	uzp1	v16.4s, v18.4s, v16.4s
	uzp1	v14.4s, v0.4s, v14.4s
	uzp1	v30.4s, v20.4s, v30.4s
	uzp1	v16.8h, v15.8h, v16.8h
	uzp1	v30.8h, v14.8h, v30.8h
	umin	v16.8h, v16.8h, v21.8h
	umin	v30.8h, v30.8h, v21.8h
	uzp1	v16.16b, v30.16b, v16.16b
	str	q16, [x2], 16
	cmp	x2, x4
	bne	.L86
	and	w2, w5, -16
	cmp	w5, w2
	beq	.L90
	uxtw	x4, w2
	add	w2, w2, w2, lsl 1
	add	x2, x6, w2, sxtw
	.p2align 5,,15
.L88:
	ldrb	w8, [x2, 1]
	add	x2, x2, 3
	ldrb	w6, [x2, -3]
	ldrb	w3, [x2, -1]
	scvtf	d16, w8
	scvtf	d18, w6
	fmul	d16, d16, d27
	fmadd	d16, d18, d26, d16
	scvtf	d18, w3
	fmadd	d18, d18, d25, d16
	fcvtzu	w3, d18
	and	w6, w3, 65535
	cmp	w6, 255
	csel	w3, w3, w9, ls
	strb	w3, [x7, x4]
	add	x4, x4, 1
	cmp	w5, w4
	bgt	.L88
.L90:
	ldr	w2, [x0, 8]
	add	w3, w10, 1
	cmp	w3, w2
	bge	.L92
.L110:
	add	x10, x10, 1
	b	.L83
	.p2align 2,,3
.L109:
	add	x7, x8, x2
.L85:
	umaddl	x5, w5, w11, x6
	mov	x2, x6
	.p2align 5,,15
.L89:
	ldrb	w6, [x2, 1]
	add	x2, x2, 3
	ldrb	w4, [x2, -3]
	ldrb	w3, [x2, -1]
	scvtf	d19, w6
	scvtf	d20, w4
	scvtf	d18, w3
	fmul	d19, d19, d27
	fmadd	d19, d20, d26, d19
	fmadd	d18, d18, d25, d19
	fcvtzu	w3, d18
	and	w4, w3, 65535
	cmp	w4, 255
	csel	w3, w3, w9, ls
	strb	w3, [x7], 1
	cmp	x5, x2
	bne	.L89
	ldr	w2, [x0, 8]
	add	w3, w10, 1
	cmp	w3, w2
	blt	.L110
.L92:
	mov	w0, 1
	ldp	d14, d15, [sp], 16
	.cfi_restore 79
	.cfi_restore 78
	.cfi_def_cfa_offset 0
	ret
.L93:
	mov	w0, 0
	ret
.L105:
	mov	w0, 1
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
	beq	.L118
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
	ble	.L125
	uxtw	x19, w23
	ldr	x0, [x20, 16]
	mov	w1, 0
	mov	x2, x19
	sub	w22, w22, #1
	bl	memset
	ldr	x0, [x20, 72]
	sxtw	x4, w22
	mov	x2, x19
	mov	w1, 0
	mov	x19, 1
	ldr	x3, [x20, 16]
	ldr	x0, [x0]
	madd	x0, x4, x0, x3
	bl	memset
	.p2align 5,,15
.L117:
	ldr	x3, [x21, 72]
	sub	x0, x19, #1
	mov	x7, x19
	mov	w4, w23
	ldr	x1, [x20, 72]
	ldr	x2, [x21, 16]
	ldr	x5, [x3]
	ldr	x3, [x1]
	ldr	x6, [x20, 16]
	mul	x1, x5, x19
	add	x19, x19, 1
	madd	x0, x0, x5, x2
	add	x5, x1, x5
	add	x1, x2, x1
	madd	x3, x7, x3, x6
	add	x2, x2, x5
	bl	_Z13sobel_row_ptrPKhS0_S0_Phi
	cmp	w22, w19
	bgt	.L117
.L115:
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
.L125:
	.cfi_restore_state
	cmp	w22, 0
	ble	.L115
	cmp	w23, 0
	ble	.L115
	mov	x19, 0
	sxtw	x22, w22
	uxtw	x23, w23
	.p2align 5,,15
.L116:
	ldr	x3, [x20, 72]
	mov	x2, x23
	mov	w1, 0
	ldr	x0, [x20, 16]
	ldr	x3, [x3]
	madd	x0, x19, x3, x0
	add	x19, x19, 1
	bl	memset
	cmp	x19, x22
	bne	.L116
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
.L118:
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
	beq	.L152
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	mov	x29, sp
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	mov	x25, x2
	mov	x26, x0
	mov	w0, 0
	ldr	w2, [x1, 8]
	cmp	w2, 2
	ble	.L126
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -152
	.cfi_offset 23, -160
	ldr	w2, [x1, 12]
	ldr	w23, [x26, 12]
	cmp	w2, w23
	blt	.L182
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -184
	.cfi_offset 19, -192
	ldr	w19, [x26, 8]
	cmp	w19, 2
	ccmp	w23, 2, 4, gt
	bgt	.L128
	cmp	w19, 0
	ble	.L130
	cmp	w23, 0
	ble	.L130
	sxtw	x19, w19
	uxtw	x20, w23
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -168
	.cfi_offset 21, -176
	mov	x21, 0
	.p2align 5,,15
.L131:
	mov	x2, x20
	mov	w1, 0
	ldr	x3, [x25, 72]
	ldr	x0, [x25, 16]
	ldr	x3, [x3]
	madd	x0, x21, x3, x0
	add	x21, x21, 1
	bl	memset
	cmp	x21, x19
	bne	.L131
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
.L130:
	mov	w0, 1
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
.L126:
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 208
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L152:
	mov	w0, 0
	ret
	.p2align 2,,3
.L128:
	.cfi_def_cfa_offset 208
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -168
	.cfi_offset 21, -176
	uxtw	x20, w23
	sxtw	x21, w23
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -120
	.cfi_offset 27, -128
	stp	d8, d9, [sp, 96]
	.cfi_offset 73, -104
	.cfi_offset 72, -112
	stp	d10, d11, [sp, 112]
	.cfi_offset 75, -88
	.cfi_offset 74, -96
	stp	d12, d13, [sp, 128]
	.cfi_offset 77, -72
	.cfi_offset 76, -80
	stp	d14, d15, [sp, 144]
	.cfi_offset 79, -56
	.cfi_offset 78, -64
	ldr	x0, [x1, 72]
	ldr	x28, [x1, 16]
	ldr	x3, [x26, 16]
	ldr	x5, [x0]
	add	x24, x28, x5, lsl 1
	add	x22, x28, x5
	cmp	w23, 15
	ble	.L132
	add	x0, x20, w23, uxtw 1
	add	x0, x3, x0
	add	x1, x28, x21
	cmp	x28, x0
	ccmp	x3, x1, 2, cc
	bcc	.L132
	adrp	x4, .LC4
	adrp	x0, .LC3
	movi	v22.8h, 0xff
	mov	x1, x3
	lsr	w2, w23, 4
	add	x2, x28, w2, uxtw 4
	ldr	q24, [x4, #:lo12:.LC4]
	adrp	x4, .LC5
	ldr	q25, [x4, #:lo12:.LC5]
	ldr	q23, [x0, #:lo12:.LC3]
	mov	x0, x28
	.p2align 5,,15
.L133:
	ld3	{v16.16b - v18.16b}, [x1], 48
	uxtl2	v29.8h, v17.16b
	mov	v21.16b, v18.16b
	uxtl	v19.8h, v17.8b
	uxtl2	v28.8h, v16.16b
	uxtl	v13.8h, v16.8b
	uxtl	v17.4s, v29.4h
	uxtl	v31.4s, v19.4h
	uxtl2	v29.4s, v29.8h
	uxtl2	v19.4s, v19.8h
	sxtl	v30.2d, v17.2s
	sxtl2	v17.2d, v17.4s
	uxtl	v3.4s, v28.4h
	sxtl	v15.2d, v29.2s
	sxtl2	v26.2d, v29.4s
	scvtf	v17.2d, v17.2d
	sxtl	v29.2d, v19.2s
	sxtl2	v19.2d, v19.4s
	sxtl	v12.2d, v3.2s
	sxtl2	v3.2d, v3.4s
	uxtl2	v21.8h, v21.16b
	scvtf	v30.2d, v30.2d
	uxtl	v14.8h, v18.8b
	sxtl2	v20.2d, v31.4s
	scvtf	v18.2d, v19.2d
	sxtl	v31.2d, v31.2s
	uxtl	v9.4s, v13.4h
	uxtl2	v16.4s, v13.8h
	uxtl2	v28.4s, v28.8h
	scvtf	v3.2d, v3.2d
	fmul	v17.2d, v17.2d, v23.2d
	uxtl	v11.4s, v21.4h
	uxtl2	v21.4s, v21.8h
	scvtf	v15.2d, v15.2d
	scvtf	v12.2d, v12.2d
	scvtf	v26.2d, v26.2d
	scvtf	v20.2d, v20.2d
	scvtf	v31.2d, v31.2d
	scvtf	v29.2d, v29.2d
	sxtl	v4.2d, v28.2s
	sxtl	v5.2d, v9.2s
	sxtl2	v28.2d, v28.4s
	sxtl	v7.2d, v16.2s
	fmul	v30.2d, v30.2d, v23.2d
	sxtl2	v9.2d, v9.4s
	sxtl2	v16.2d, v16.4s
	uxtl	v13.4s, v14.4h
	fmul	v18.2d, v18.2d, v23.2d
	uxtl2	v14.4s, v14.8h
	sxtl	v8.2d, v21.2s
	fmla	v17.2d, v3.2d, v24.2d
	sxtl2	v21.2d, v21.4s
	scvtf	v19.2d, v28.2d
	scvtf	v4.2d, v4.2d
	scvtf	v5.2d, v5.2d
	scvtf	v9.2d, v9.2d
	scvtf	v7.2d, v7.2d
	scvtf	v16.2d, v16.2d
	fmla	v30.2d, v12.2d, v24.2d
	sxtl	v6.2d, v11.2s
	fmul	v28.2d, v15.2d, v23.2d
	sxtl	v10.2d, v13.2s
	sxtl	v12.2d, v14.2s
	fmul	v26.2d, v26.2d, v23.2d
	fmul	v20.2d, v20.2d, v23.2d
	fmul	v31.2d, v31.2d, v23.2d
	fmul	v29.2d, v29.2d, v23.2d
	sxtl2	v11.2d, v11.4s
	sxtl2	v13.2d, v13.4s
	sxtl2	v14.2d, v14.4s
	scvtf	v15.2d, v21.2d
	mov	v21.16b, v18.16b
	scvtf	v6.2d, v6.2d
	scvtf	v11.2d, v11.2d
	scvtf	v8.2d, v8.2d
	scvtf	v10.2d, v10.2d
	scvtf	v13.2d, v13.2d
	scvtf	v12.2d, v12.2d
	scvtf	v14.2d, v14.2d
	fmla	v26.2d, v19.2d, v24.2d
	mov	v19.16b, v17.16b
	fmla	v28.2d, v4.2d, v24.2d
	fmla	v31.2d, v5.2d, v24.2d
	fmla	v20.2d, v9.2d, v24.2d
	fmla	v29.2d, v7.2d, v24.2d
	fmla	v21.2d, v16.2d, v24.2d
	fmla	v30.2d, v6.2d, v25.2d
	fmla	v19.2d, v11.2d, v25.2d
	fmla	v28.2d, v8.2d, v25.2d
	fmla	v26.2d, v15.2d, v25.2d
	fmla	v31.2d, v10.2d, v25.2d
	fmla	v20.2d, v13.2d, v25.2d
	fmla	v29.2d, v12.2d, v25.2d
	fmla	v21.2d, v14.2d, v25.2d
	fcvtzs	v30.2d, v30.2d
	fcvtzs	v19.2d, v19.2d
	fcvtzs	v28.2d, v28.2d
	fcvtzs	v26.2d, v26.2d
	fcvtzs	v31.2d, v31.2d
	fcvtzs	v20.2d, v20.2d
	fcvtzs	v29.2d, v29.2d
	fcvtzs	v21.2d, v21.2d
	uzp1	v30.4s, v30.4s, v19.4s
	uzp1	v28.4s, v28.4s, v26.4s
	uzp1	v31.4s, v31.4s, v20.4s
	uzp1	v29.4s, v29.4s, v21.4s
	uzp1	v30.8h, v30.8h, v28.8h
	uzp1	v31.8h, v31.8h, v29.8h
	umin	v30.8h, v30.8h, v22.8h
	umin	v31.8h, v31.8h, v22.8h
	uzp1	v31.16b, v31.16b, v30.16b
	str	q31, [x0], 16
	cmp	x2, x0
	bne	.L133
	and	w0, w23, -16
	cmp	w23, w0
	beq	.L134
	adrp	x1, .LC0
	mov	w6, 255
	uxtw	x2, w0
	add	w0, w0, w0, lsl 1
	add	x0, x3, w0, sxtw
	ldr	d25, [x1, #:lo12:.LC0]
	adrp	x1, .LC1
	ldr	d26, [x1, #:lo12:.LC1]
	adrp	x1, .LC2
	ldr	d28, [x1, #:lo12:.LC2]
	.p2align 5,,15
.L135:
	add	x0, x0, 3
	ldrb	w4, [x0, -2]
	ldrb	w3, [x0, -3]
	ldrb	w1, [x0, -1]
	scvtf	d31, w4
	scvtf	d29, w3
	scvtf	d30, w1
	fmul	d31, d31, d25
	fmadd	d31, d29, d26, d31
	fmadd	d31, d30, d28, d31
	fcvtzu	w1, d31
	and	w3, w1, 65535
	cmp	w3, 255
	csel	w1, w1, w6, ls
	strb	w1, [x28, x2]
	add	x2, x2, 1
	cmp	w23, w2
	bgt	.L135
.L134:
	ldr	x0, [x26, 72]
	ldr	x1, [x26, 16]
	ldr	x4, [x0]
	add	x3, x1, x4
.L138:
	mov	w2, 3
	add	x0, x5, x21
	add	x0, x28, x0
	umaddl	x2, w23, w2, x4
	add	x1, x1, x2
	cmp	x22, x1
	ccmp	x3, x0, 2, cc
	bcc	.L139
	adrp	x4, .LC4
	adrp	x0, .LC3
	movi	v22.8h, 0xff
	mov	x1, x3
	lsr	w2, w23, 4
	add	x2, x22, w2, uxtw 4
	ldr	q24, [x4, #:lo12:.LC4]
	adrp	x4, .LC5
	ldr	q25, [x4, #:lo12:.LC5]
	ldr	q23, [x0, #:lo12:.LC3]
	mov	x0, x22
	.p2align 5,,15
.L140:
	ld3	{v19.16b - v21.16b}, [x1], 48
	uxtl2	v30.8h, v20.16b
	mov	v17.16b, v21.16b
	uxtl	v15.8h, v19.8b
	uxtl2	v28.8h, v19.16b
	uxtl	v26.8h, v20.8b
	uxtl	v19.4s, v30.4h
	uxtl2	v30.4s, v30.8h
	uxtl	v4.4s, v28.4h
	uxtl	v31.4s, v26.4h
	sxtl	v9.2d, v19.2s
	uxtl2	v26.4s, v26.8h
	uxtl	v16.8h, v21.8b
	sxtl	v11.2d, v30.2s
	scvtf	v9.2d, v9.2d
	sxtl2	v21.2d, v31.4s
	sxtl2	v30.2d, v30.4s
	sxtl	v29.2d, v26.2s
	sxtl	v13.2d, v4.2s
	sxtl	v31.2d, v31.2s
	sxtl2	v19.2d, v19.4s
	sxtl2	v26.2d, v26.4s
	uxtl	v10.4s, v15.4h
	uxtl2	v28.4s, v28.8h
	uxtl2	v15.4s, v15.8h
	uxtl2	v17.8h, v17.16b
	scvtf	v11.2d, v11.2d
	scvtf	v20.2d, v30.2d
	scvtf	v13.2d, v13.2d
	scvtf	v19.2d, v19.2d
	scvtf	v21.2d, v21.2d
	scvtf	v31.2d, v31.2d
	scvtf	v29.2d, v29.2d
	scvtf	v26.2d, v26.2d
	fmul	v30.2d, v9.2d, v23.2d
	sxtl	v5.2d, v28.2s
	sxtl	v6.2d, v10.2s
	sxtl2	v28.2d, v28.4s
	sxtl	v8.2d, v15.2s
	sxtl2	v4.2d, v4.4s
	sxtl2	v10.2d, v10.4s
	sxtl2	v15.2d, v15.4s
	uxtl	v12.4s, v17.4h
	uxtl	v14.4s, v16.4h
	uxtl2	v17.4s, v17.8h
	uxtl2	v16.4s, v16.8h
	scvtf	v18.2d, v28.2d
	scvtf	v4.2d, v4.2d
	scvtf	v5.2d, v5.2d
	scvtf	v6.2d, v6.2d
	scvtf	v10.2d, v10.2d
	scvtf	v8.2d, v8.2d
	scvtf	v15.2d, v15.2d
	fmla	v30.2d, v13.2d, v24.2d
	sxtl	v7.2d, v12.2s
	fmul	v28.2d, v11.2d, v23.2d
	sxtl	v9.2d, v17.2s
	sxtl	v11.2d, v14.2s
	sxtl	v13.2d, v16.2s
	fmul	v19.2d, v19.2d, v23.2d
	fmul	v20.2d, v20.2d, v23.2d
	fmul	v21.2d, v21.2d, v23.2d
	fmul	v31.2d, v31.2d, v23.2d
	fmul	v29.2d, v29.2d, v23.2d
	fmul	v26.2d, v26.2d, v23.2d
	sxtl2	v12.2d, v12.4s
	sxtl2	v17.2d, v17.4s
	sxtl2	v14.2d, v14.4s
	sxtl2	v16.2d, v16.4s
	scvtf	v7.2d, v7.2d
	scvtf	v12.2d, v12.2d
	scvtf	v9.2d, v9.2d
	scvtf	v17.2d, v17.2d
	scvtf	v11.2d, v11.2d
	scvtf	v14.2d, v14.2d
	scvtf	v13.2d, v13.2d
	scvtf	v16.2d, v16.2d
	fmla	v19.2d, v4.2d, v24.2d
	fmla	v28.2d, v5.2d, v24.2d
	fmla	v20.2d, v18.2d, v24.2d
	fmla	v31.2d, v6.2d, v24.2d
	fmla	v21.2d, v10.2d, v24.2d
	fmla	v29.2d, v8.2d, v24.2d
	fmla	v26.2d, v15.2d, v24.2d
	fmla	v30.2d, v7.2d, v25.2d
	fmla	v19.2d, v12.2d, v25.2d
	fmla	v28.2d, v9.2d, v25.2d
	fmla	v20.2d, v17.2d, v25.2d
	fmla	v31.2d, v11.2d, v25.2d
	fmla	v21.2d, v14.2d, v25.2d
	fmla	v29.2d, v13.2d, v25.2d
	fmla	v26.2d, v16.2d, v25.2d
	fcvtzs	v30.2d, v30.2d
	fcvtzs	v19.2d, v19.2d
	fcvtzs	v28.2d, v28.2d
	fcvtzs	v20.2d, v20.2d
	fcvtzs	v31.2d, v31.2d
	fcvtzs	v21.2d, v21.2d
	fcvtzs	v29.2d, v29.2d
	fcvtzs	v26.2d, v26.2d
	uzp1	v30.4s, v30.4s, v19.4s
	uzp1	v28.4s, v28.4s, v20.4s
	uzp1	v31.4s, v31.4s, v21.4s
	uzp1	v29.4s, v29.4s, v26.4s
	uzp1	v30.8h, v30.8h, v28.8h
	uzp1	v31.8h, v31.8h, v29.8h
	umin	v30.8h, v30.8h, v22.8h
	umin	v31.8h, v31.8h, v22.8h
	uzp1	v31.16b, v31.16b, v30.16b
	str	q31, [x0], 16
	cmp	x0, x2
	bne	.L140
	and	w0, w23, -16
	cmp	w23, w0
	beq	.L144
	adrp	x1, .LC0
	mov	w5, 255
	uxtw	x2, w0
	add	w0, w0, w0, lsl 1
	add	x0, x3, w0, sxtw
	ldr	d25, [x1, #:lo12:.LC0]
	adrp	x1, .LC1
	ldr	d26, [x1, #:lo12:.LC1]
	adrp	x1, .LC2
	ldr	d28, [x1, #:lo12:.LC2]
	.p2align 5,,15
.L142:
	add	x0, x0, 3
	ldrb	w4, [x0, -2]
	ldrb	w3, [x0, -3]
	ldrb	w1, [x0, -1]
	scvtf	d31, w4
	scvtf	d29, w3
	scvtf	d30, w1
	fmul	d31, d31, d25
	fmadd	d31, d29, d26, d31
	fmadd	d31, d30, d28, d31
	fcvtzu	w1, d31
	and	w3, w1, 65535
	cmp	w3, 255
	csel	w1, w1, w5, ls
	strb	w1, [x22, x2]
	add	x2, x2, 1
	cmp	w23, w2
	bgt	.L142
.L144:
	ldr	x0, [x25, 16]
	mov	x2, x20
	mov	w1, 0
	bl	memset
	adrp	x0, .LC0
	movi	v27.4s, 0
	sub	w19, w19, #1
	mov	x27, 1
	ldr	d14, [x0, #:lo12:.LC0]
	add	x0, x20, x20, lsl 1
	str	x0, [sp, 200]
	adrp	x0, .LC1
	ldr	d15, [x0, #:lo12:.LC1]
	adrp	x0, .LC2
	dup	v17.2d, v14.d[0]
	ldr	d13, [x0, #:lo12:.LC2]
	dup	v18.2d, v15.d[0]
	.p2align 5,,15
.L151:
	ldr	x0, [x26, 72]
	mov	x8, x27
	add	x27, x27, 1
	ldr	x2, [x26, 16]
	ldr	x1, [x0]
	mul	x1, x27, x1
	add	x0, x2, x1
	cmp	w23, 15
	ble	.L145
	ldr	x3, [sp, 200]
	add	x1, x3, x1
	add	x3, x24, x21
	add	x2, x2, x1
	cmp	x24, x2
	ccmp	x0, x3, 2, cc
	bcc	.L145
	adrp	x1, .LC5
	movi	v16.8h, 0xff
	mov	x5, x0
	lsr	w2, w23, 4
	add	x2, x24, w2, uxtw 4
	ldr	q19, [x1, #:lo12:.LC5]
	mov	x1, x24
	.p2align 5,,15
.L146:
	ld3	{v10.16b - v12.16b}, [x5], 48
	zip1	v26.16b, v11.16b, v27.16b
	zip2	v28.16b, v11.16b, v27.16b
	zip1	v7.16b, v10.16b, v27.16b
	zip2	v29.16b, v10.16b, v27.16b
	zip1	v31.8h, v26.8h, v27.8h
	zip1	v25.8h, v28.8h, v27.8h
	zip2	v26.8h, v26.8h, v27.8h
	zip2	v28.8h, v28.8h, v27.8h
	sxtl2	v22.2d, v31.4s
	sxtl	v30.2d, v25.2s
	sxtl	v23.2d, v26.2s
	sxtl	v24.2d, v28.2s
	sxtl	v31.2d, v31.2s
	sxtl2	v25.2d, v25.4s
	sxtl2	v28.2d, v28.4s
	sxtl2	v26.2d, v26.4s
	zip1	v3.8h, v29.8h, v27.8h
	zip1	v4.8h, v7.8h, v27.8h
	zip2	v29.8h, v29.8h, v27.8h
	zip2	v7.8h, v7.8h, v27.8h
	zip2	v21.16b, v12.16b, v27.16b
	zip1	v20.16b, v12.16b, v27.16b
	scvtf	v30.2d, v30.2d
	scvtf	v25.2d, v25.2d
	scvtf	v24.2d, v24.2d
	scvtf	v28.2d, v28.2d
	scvtf	v22.2d, v22.2d
	scvtf	v31.2d, v31.2d
	scvtf	v23.2d, v23.2d
	scvtf	v26.2d, v26.2d
	sxtl	v8.2d, v3.2s
	sxtl	v9.2d, v29.2s
	sxtl	v10.2d, v4.2s
	sxtl	v11.2d, v7.2s
	sxtl2	v3.2d, v3.4s
	sxtl2	v29.2d, v29.4s
	sxtl2	v4.2d, v4.4s
	sxtl2	v7.2d, v7.4s
	zip1	v5.8h, v21.8h, v27.8h
	zip1	v6.8h, v20.8h, v27.8h
	zip2	v21.8h, v21.8h, v27.8h
	zip2	v20.8h, v20.8h, v27.8h
	scvtf	v8.2d, v8.2d
	scvtf	v3.2d, v3.2d
	scvtf	v9.2d, v9.2d
	scvtf	v29.2d, v29.2d
	scvtf	v10.2d, v10.2d
	scvtf	v4.2d, v4.2d
	scvtf	v11.2d, v11.2d
	scvtf	v7.2d, v7.2d
	sxtl	v12.2d, v5.2s
	sxtl	v0.2d, v21.2s
	sxtl	v1.2d, v6.2s
	sxtl	v2.2d, v20.2s
	fmul	v30.2d, v30.2d, v17.2d
	fmul	v25.2d, v25.2d, v17.2d
	fmul	v24.2d, v24.2d, v17.2d
	fmul	v28.2d, v28.2d, v17.2d
	fmul	v22.2d, v22.2d, v17.2d
	fmul	v31.2d, v31.2d, v17.2d
	fmul	v23.2d, v23.2d, v17.2d
	fmul	v26.2d, v26.2d, v17.2d
	sxtl2	v5.2d, v5.4s
	sxtl2	v21.2d, v21.4s
	sxtl2	v6.2d, v6.4s
	sxtl2	v20.2d, v20.4s
	scvtf	v12.2d, v12.2d
	scvtf	v5.2d, v5.2d
	scvtf	v0.2d, v0.2d
	scvtf	v21.2d, v21.2d
	scvtf	v1.2d, v1.2d
	scvtf	v6.2d, v6.2d
	scvtf	v2.2d, v2.2d
	scvtf	v20.2d, v20.2d
	fmla	v30.2d, v8.2d, v18.2d
	fmla	v25.2d, v3.2d, v18.2d
	fmla	v24.2d, v9.2d, v18.2d
	fmla	v28.2d, v29.2d, v18.2d
	fmla	v31.2d, v10.2d, v18.2d
	fmla	v22.2d, v4.2d, v18.2d
	fmla	v23.2d, v11.2d, v18.2d
	fmla	v26.2d, v7.2d, v18.2d
	fmla	v30.2d, v12.2d, v19.2d
	fmla	v25.2d, v5.2d, v19.2d
	fmla	v24.2d, v0.2d, v19.2d
	fmla	v28.2d, v21.2d, v19.2d
	fmla	v31.2d, v1.2d, v19.2d
	fmla	v22.2d, v6.2d, v19.2d
	fmla	v23.2d, v2.2d, v19.2d
	fmla	v26.2d, v20.2d, v19.2d
	fcvtzs	v30.2d, v30.2d
	fcvtzs	v25.2d, v25.2d
	fcvtzs	v24.2d, v24.2d
	fcvtzs	v28.2d, v28.2d
	fcvtzs	v31.2d, v31.2d
	fcvtzs	v22.2d, v22.2d
	fcvtzs	v23.2d, v23.2d
	fcvtzs	v26.2d, v26.2d
	uzp1	v30.4s, v30.4s, v25.4s
	uzp1	v24.4s, v24.4s, v28.4s
	uzp1	v31.4s, v31.4s, v22.4s
	uzp1	v23.4s, v23.4s, v26.4s
	uzp1	v30.8h, v30.8h, v24.8h
	uzp1	v31.8h, v31.8h, v23.8h
	umin	v30.8h, v30.8h, v16.8h
	umin	v31.8h, v31.8h, v16.8h
	uzp1	v31.16b, v31.16b, v30.16b
	str	q31, [x1], 16
	cmp	x2, x1
	bne	.L146
	and	w1, w23, -16
	cmp	w1, w23
	beq	.L150
	mov	w2, 255
	uxtw	x6, w1
	add	w1, w1, w1, lsl 1
	add	x1, x0, w1, sxtw
	.p2align 5,,15
.L148:
	ldrb	w0, [x1, 1]
	add	x1, x1, 3
	ldrb	w5, [x1, -3]
	ldrb	w4, [x1, -1]
	scvtf	d31, w0
	scvtf	d29, w5
	scvtf	d30, w4
	fmul	d31, d31, d14
	fmadd	d31, d29, d15, d31
	fmadd	d31, d30, d13, d31
	fcvtzu	w5, d31
	and	w4, w5, 65535
	cmp	w4, 255
	csel	w5, w5, w2, ls
	strb	w5, [x24, x6]
	add	x6, x6, 1
	cmp	w23, w6
	bgt	.L148
.L150:
	ldr	x5, [x25, 72]
	mov	x2, x24
	mov	x1, x22
	mov	x0, x28
	mov	w4, w23
	ldr	x3, [x25, 16]
	ldr	x5, [x5]
	stp	q17, q18, [sp, 160]
	madd	x3, x8, x5, x3
	bl	_Z13sobel_row_ptrPKhS0_S0_Phi
	cmp	w19, w27
	mov	x0, x22
	ldp	q17, q18, [sp, 160]
	mov	x22, x24
	movi	v27.4s, 0
	mov	x24, x28
	ble	.L183
	mov	x28, x0
	b	.L151
	.p2align 2,,3
.L145:
	mov	x2, 0
	mov	w5, 255
	.p2align 5,,15
.L149:
	ldrb	w4, [x0, 1]
	add	x0, x0, 3
	ldrb	w3, [x0, -3]
	ldrb	w1, [x0, -1]
	scvtf	d31, w4
	scvtf	d29, w3
	scvtf	d30, w1
	fmul	d31, d31, d14
	fmadd	d31, d29, d15, d31
	fmadd	d31, d30, d13, d31
	fcvtzu	w1, d31
	and	w3, w1, 65535
	cmp	w3, 255
	csel	w1, w1, w5, ls
	strb	w1, [x24, x2]
	add	x2, x2, 1
	cmp	w23, w2
	bgt	.L149
	b	.L150
	.p2align 2,,3
.L182:
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 72
	.cfi_restore 73
	.cfi_restore 74
	.cfi_restore 75
	.cfi_restore 76
	.cfi_restore 77
	.cfi_restore 78
	.cfi_restore 79
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 208
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L183:
	.cfi_def_cfa_offset 208
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	.cfi_offset 72, -112
	.cfi_offset 73, -104
	.cfi_offset 74, -96
	.cfi_offset 75, -88
	.cfi_offset 76, -80
	.cfi_offset 77, -72
	.cfi_offset 78, -64
	.cfi_offset 79, -56
	ldr	x3, [x25, 72]
	sxtw	x19, w19
	mov	x2, x20
	mov	w1, 0
	ldr	x0, [x25, 16]
	ldr	x3, [x3]
	madd	x0, x19, x3, x0
	bl	memset
	ldp	d8, d9, [sp, 96]
	.cfi_remember_state
	.cfi_restore 73
	.cfi_restore 72
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldp	d10, d11, [sp, 112]
	.cfi_restore 75
	.cfi_restore 74
	ldp	d12, d13, [sp, 128]
	.cfi_restore 77
	.cfi_restore 76
	ldp	d14, d15, [sp, 144]
	.cfi_restore 79
	.cfi_restore 78
	b	.L130
.L132:
	.cfi_restore_state
	adrp	x1, .LC1
	adrp	x0, .LC0
	mov	x2, 0
	mov	w6, 255
	ldr	d26, [x1, #:lo12:.LC1]
	adrp	x1, .LC2
	ldr	d28, [x1, #:lo12:.LC2]
	ldr	d25, [x0, #:lo12:.LC0]
	mov	x0, x3
	.p2align 5,,15
.L136:
	add	x0, x0, 3
	ldrb	w4, [x0, -2]
	ldrb	w3, [x0, -3]
	ldrb	w1, [x0, -1]
	scvtf	d31, w4
	scvtf	d29, w3
	scvtf	d30, w1
	fmul	d31, d31, d25
	fmadd	d31, d29, d26, d31
	fmadd	d31, d30, d28, d31
	fcvtzu	w1, d31
	and	w3, w1, 65535
	cmp	w3, 255
	csel	w1, w1, w6, ls
	strb	w1, [x28, x2]
	add	x2, x2, 1
	cmp	w23, w2
	bgt	.L136
	ldr	x0, [x26, 72]
	ldr	x1, [x26, 16]
	ldr	x4, [x0]
	add	x3, x1, x4
	cmp	w23, 15
	bgt	.L138
.L139:
	adrp	x1, .LC1
	adrp	x0, .LC0
	mov	x2, 0
	mov	w5, 255
	ldr	d26, [x1, #:lo12:.LC1]
	adrp	x1, .LC2
	ldr	d28, [x1, #:lo12:.LC2]
	ldr	d25, [x0, #:lo12:.LC0]
	mov	x0, x3
	.p2align 5,,15
.L143:
	add	x0, x0, 3
	ldrb	w4, [x0, -2]
	ldrb	w3, [x0, -3]
	ldrb	w1, [x0, -1]
	scvtf	d31, w4
	scvtf	d29, w3
	scvtf	d30, w1
	fmul	d31, d31, d25
	fmadd	d31, d29, d26, d31
	fmadd	d31, d30, d28, d31
	fcvtzu	w1, d31
	and	w3, w1, 65535
	cmp	w3, 255
	csel	w1, w1, w5, ls
	strb	w1, [x22, x2]
	add	x2, x2, 1
	cmp	w23, w2
	bgt	.L143
	b	.L144
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
	.set	.LC0,.LC3
	.set	.LC1,.LC4
	.set	.LC2,.LC5
	.section	.rodata.cst16,"aM",@progbits,16
	.align	4
.LC3:
	.word	474164389
	.word	1072095979
	.word	474164389
	.word	1072095979
	.align	4
.LC4:
	.word	-20615843
	.word	1068661682
	.word	-20615843
	.word	1068661682
	.align	4
.LC5:
	.word	261134012
	.word	1070282362
	.word	261134012
	.word	1070282362
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
