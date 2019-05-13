	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	softfloat
	.module	oddspreg
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.align	2
	.globl	get_digit
.LFB0 = .
	.file 1 "seg7led.c"
	.loc 1 20 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	get_digit
	.type	get_digit, @function
get_digit:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
.LVL0 = .
	.loc 1 21 0
	sltu	$2,$4,16
	beq	$2,$0,.L2
	nop

	sll	$2,$4,2
	lui	$4,%hi(.L4)
.LVL1 = .
	addiu	$4,$4,%lo(.L4)
	addu	$4,$4,$2
	lw	$2,0($4)
	jr	$2
	nop

	.rdata
	.align	2
	.align	2
.L4:
	.word	.L20
	.word	.L5
	.word	.L6
	.word	.L7
	.word	.L8
	.word	.L9
	.word	.L10
	.word	.L11
	.word	.L12
	.word	.L13
	.word	.L14
	.word	.L15
	.word	.L16
	.word	.L17
	.word	.L18
	.word	.L19
	.text
.L5:
	.loc 1 25 0
	jr	$31
	li	$2,249			# 0xf9

.L6:
	.loc 1 27 0
	jr	$31
	li	$2,164			# 0xa4

.L7:
	.loc 1 29 0
	jr	$31
	li	$2,176			# 0xb0

.L8:
	.loc 1 31 0
	jr	$31
	li	$2,153			# 0x99

.L9:
	.loc 1 33 0
	jr	$31
	li	$2,146			# 0x92

.L10:
	.loc 1 35 0
	jr	$31
	li	$2,130			# 0x82

.L11:
	.loc 1 37 0
	jr	$31
	li	$2,248			# 0xf8

.L12:
	.loc 1 39 0
	jr	$31
	li	$2,128			# 0x80

.L13:
	.loc 1 41 0
	jr	$31
	li	$2,144			# 0x90

.L14:
	.loc 1 43 0
	jr	$31
	li	$2,136			# 0x88

.L15:
	.loc 1 45 0
	jr	$31
	li	$2,131			# 0x83

.L16:
	.loc 1 47 0
	jr	$31
	li	$2,198			# 0xc6

.L17:
	.loc 1 49 0
	jr	$31
	li	$2,161			# 0xa1

.L18:
	.loc 1 51 0
	jr	$31
	li	$2,134			# 0x86

.L19:
	.loc 1 53 0
	jr	$31
	li	$2,142			# 0x8e

.LVL2 = .
.L2:
	.loc 1 55 0
	jr	$31
	li	$2,255			# 0xff

.LVL3 = .
.L20:
	.loc 1 57 0
	jr	$31
	li	$2,192			# 0xc0

	.set	macro
	.set	reorder
	.end	get_digit
	.cfi_endproc
.LFE0:
	.size	get_digit, .-get_digit
	.align	2
	.globl	set_seg7led
.LFB1 = .
	.loc 1 59 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	set_seg7led
	.type	set_seg7led, @function
set_seg7led:
	.frame	$sp,40,$31		# vars= 0, regs= 5/0, args= 16, gp= 0
	.mask	0x800f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
.LVL4 = .
	addiu	$sp,$sp,-40
	.cfi_def_cfa_offset 40
	sw	$31,36($sp)
	sw	$19,32($sp)
	sw	$18,28($sp)
	sw	$17,24($sp)
	sw	$16,20($sp)
	.cfi_offset 31, -4
	.cfi_offset 19, -8
	.cfi_offset 18, -12
	.cfi_offset 17, -16
	.cfi_offset 16, -20
	move	$16,$4
.LVL5 = .
	.loc 1 60 0
	jal	get_digit
	ext	$4,$4,12,4

.LVL6 = .
	move	$17,$2
	.loc 1 61 0
	jal	get_digit
	ext	$4,$16,8,4

.LVL7 = .
	.loc 1 60 0
	sll	$17,$17,24
	.loc 1 61 0
	sll	$2,$2,16
	.loc 1 60 0
	or	$17,$17,$2
	.loc 1 62 0
	jal	get_digit
	ext	$4,$16,4,4

.LVL8 = .
	move	$18,$2
	.loc 1 63 0
	jal	get_digit
	andi	$4,$16,0xf

.LVL9 = .
	.loc 1 62 0
	sll	$18,$18,8
	or	$2,$2,$17
	or	$18,$18,$2
	.loc 1 60 0
	li	$19,-1082130432			# 0xffffffffbf800000
	sw	$18,12($19)
	.loc 1 64 0
	jal	get_digit
	srl	$4,$16,28

.LVL10 = .
	move	$17,$2
	.loc 1 65 0
	jal	get_digit
	ext	$4,$16,24,4

.LVL11 = .
	.loc 1 64 0
	sll	$17,$17,24
	.loc 1 65 0
	sll	$2,$2,16
	.loc 1 64 0
	or	$17,$17,$2
	.loc 1 66 0
	jal	get_digit
	ext	$4,$16,20,4

.LVL12 = .
	move	$18,$2
	.loc 1 67 0
	jal	get_digit
	ext	$4,$16,16,4

.LVL13 = .
	.loc 1 66 0
	sll	$18,$18,8
	or	$2,$2,$17
	or	$18,$18,$2
	.loc 1 64 0
	sw	$18,16($19)
	.loc 1 68 0
	lw	$31,36($sp)
	lw	$19,32($sp)
	lw	$18,28($sp)
	lw	$17,24($sp)
	lw	$16,20($sp)
.LVL14 = .
	jr	$31
	addiu	$sp,$sp,40

	.cfi_def_cfa_offset 0
	.cfi_restore 16
	.cfi_restore 17
	.cfi_restore 18
	.cfi_restore 19
	.cfi_restore 31
	.set	macro
	.set	reorder
	.end	set_seg7led
	.cfi_endproc
.LFE1:
	.size	set_seg7led, .-set_seg7led
	.align	2
	.globl	set_seg7led_arduino
.LFB2 = .
	.loc 1 70 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	set_seg7led_arduino
	.type	set_seg7led_arduino, @function
set_seg7led_arduino:
	.frame	$sp,32,$31		# vars= 0, regs= 4/0, args= 16, gp= 0
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
.LVL15 = .
	addiu	$sp,$sp,-32
	.cfi_def_cfa_offset 32
	sw	$31,28($sp)
	sw	$18,24($sp)
	sw	$17,20($sp)
	sw	$16,16($sp)
	.cfi_offset 31, -4
	.cfi_offset 18, -8
	.cfi_offset 17, -12
	.cfi_offset 16, -16
	move	$18,$4
.LVL16 = .
	.loc 1 71 0
	jal	get_digit
	ext	$4,$4,12,4

.LVL17 = .
	move	$16,$2
	.loc 1 72 0
	jal	get_digit
	ext	$4,$18,8,4

.LVL18 = .
	.loc 1 71 0
	sll	$16,$16,24
	.loc 1 72 0
	sll	$2,$2,16
	.loc 1 71 0
	or	$16,$16,$2
	.loc 1 73 0
	jal	get_digit
	ext	$4,$18,4,4

.LVL19 = .
	move	$17,$2
	.loc 1 74 0
	jal	get_digit
	andi	$4,$18,0xf

.LVL20 = .
	.loc 1 73 0
	sll	$17,$17,8
	or	$2,$2,$16
	or	$17,$17,$2
	.loc 1 71 0
	li	$2,-1082130432			# 0xffffffffbf800000
	sw	$17,24($2)
	.loc 1 75 0
	lw	$31,28($sp)
	lw	$18,24($sp)
.LVL21 = .
	lw	$17,20($sp)
	lw	$16,16($sp)
	jr	$31
	addiu	$sp,$sp,32

	.cfi_def_cfa_offset 0
	.cfi_restore 16
	.cfi_restore 17
	.cfi_restore 18
	.cfi_restore 31
	.set	macro
	.set	reorder
	.end	set_seg7led_arduino
	.cfi_endproc
.LFE2:
	.size	set_seg7led_arduino, .-set_seg7led_arduino
	.align	2
	.globl	set_seg7led_pixel
.LFB3 = .
	.loc 1 77 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	set_seg7led_pixel
	.type	set_seg7led_pixel, @function
set_seg7led_pixel:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
.LVL22 = .
	.loc 1 78 0
	li	$2,-1082130432			# 0xffffffffbf800000
	sw	$5,12($2)
	.loc 1 79 0
	sw	$4,16($2)
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	set_seg7led_pixel
	.cfi_endproc
.LFE3:
	.size	set_seg7led_pixel, .-set_seg7led_pixel
	.align	2
	.globl	set_seg7led_arduino_pixel
.LFB4 = .
	.loc 1 82 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	set_seg7led_arduino_pixel
	.type	set_seg7led_arduino_pixel, @function
set_seg7led_arduino_pixel:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
.LVL23 = .
	.loc 1 82 0
	li	$2,-1082130432			# 0xffffffffbf800000
	sw	$4,24($2)
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	set_seg7led_arduino_pixel
	.cfi_endproc
.LFE4:
	.size	set_seg7led_arduino_pixel, .-set_seg7led_arduino_pixel
.Letext0:
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x1fd
	.2byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF8
	.byte	0xc
	.4byte	.LASF9
	.4byte	.LASF10
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.4byte	.LASF0
	.byte	0x1
	.byte	0x52
	.4byte	.LFB4
	.4byte	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x48
	.uleb128 0x3
	.4byte	.LASF2
	.byte	0x1
	.byte	0x52
	.4byte	0x48
	.uleb128 0x1
	.byte	0x54
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.byte	0x7
	.4byte	.LASF6
	.uleb128 0x2
	.4byte	.LASF1
	.byte	0x1
	.byte	0x4d
	.4byte	.LFB3
	.4byte	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7f
	.uleb128 0x3
	.4byte	.LASF3
	.byte	0x1
	.byte	0x4d
	.4byte	0x48
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x5
	.ascii	"low\000"
	.byte	0x1
	.byte	0x4d
	.4byte	0x48
	.uleb128 0x1
	.byte	0x55
	.byte	0
	.uleb128 0x2
	.4byte	.LASF4
	.byte	0x1
	.byte	0x46
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xfb
	.uleb128 0x6
	.4byte	.LASF2
	.byte	0x1
	.byte	0x46
	.4byte	0x48
	.4byte	.LLST2
	.uleb128 0x7
	.4byte	.LVL17
	.4byte	0x1d2
	.4byte	0xba
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x5
	.byte	0x82
	.sleb128 0
	.byte	0x9
	.byte	0xf4
	.byte	0x24
	.byte	0
	.uleb128 0x7
	.4byte	.LVL18
	.4byte	0x1d2
	.4byte	0xd1
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x5
	.byte	0x82
	.sleb128 0
	.byte	0x9
	.byte	0xf8
	.byte	0x24
	.byte	0
	.uleb128 0x7
	.4byte	.LVL19
	.4byte	0x1d2
	.4byte	0xe8
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x5
	.byte	0x82
	.sleb128 0
	.byte	0x9
	.byte	0xfc
	.byte	0x24
	.byte	0
	.uleb128 0x9
	.4byte	.LVL20
	.4byte	0x1d2
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x4
	.byte	0x82
	.sleb128 0
	.byte	0x3f
	.byte	0x1a
	.byte	0
	.byte	0
	.uleb128 0x2
	.4byte	.LASF5
	.byte	0x1
	.byte	0x3b
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x1d2
	.uleb128 0x6
	.4byte	.LASF2
	.byte	0x1
	.byte	0x3b
	.4byte	0x48
	.4byte	.LLST1
	.uleb128 0x7
	.4byte	.LVL6
	.4byte	0x1d2
	.4byte	0x136
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x5
	.byte	0x80
	.sleb128 0
	.byte	0x9
	.byte	0xf4
	.byte	0x24
	.byte	0
	.uleb128 0x7
	.4byte	.LVL7
	.4byte	0x1d2
	.4byte	0x14d
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x5
	.byte	0x80
	.sleb128 0
	.byte	0x9
	.byte	0xf8
	.byte	0x24
	.byte	0
	.uleb128 0x7
	.4byte	.LVL8
	.4byte	0x1d2
	.4byte	0x164
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x5
	.byte	0x80
	.sleb128 0
	.byte	0x9
	.byte	0xfc
	.byte	0x24
	.byte	0
	.uleb128 0x7
	.4byte	.LVL9
	.4byte	0x1d2
	.4byte	0x17a
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x4
	.byte	0x80
	.sleb128 0
	.byte	0x3f
	.byte	0x1a
	.byte	0
	.uleb128 0x7
	.4byte	.LVL10
	.4byte	0x1d2
	.4byte	0x190
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x4
	.byte	0x80
	.sleb128 0
	.byte	0x4c
	.byte	0x25
	.byte	0
	.uleb128 0x7
	.4byte	.LVL11
	.4byte	0x1d2
	.4byte	0x1a7
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x5
	.byte	0x80
	.sleb128 0
	.byte	0x9
	.byte	0xe8
	.byte	0x24
	.byte	0
	.uleb128 0x7
	.4byte	.LVL12
	.4byte	0x1d2
	.4byte	0x1be
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x5
	.byte	0x80
	.sleb128 0
	.byte	0x9
	.byte	0xec
	.byte	0x24
	.byte	0
	.uleb128 0x9
	.4byte	.LVL13
	.4byte	0x1d2
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x5
	.byte	0x80
	.sleb128 0
	.byte	0x9
	.byte	0xf0
	.byte	0x24
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	.LASF11
	.byte	0x1
	.byte	0x14
	.4byte	0x1f9
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x1f9
	.uleb128 0xb
	.ascii	"x\000"
	.byte	0x1
	.byte	0x14
	.4byte	0x1f9
	.4byte	.LLST0
	.byte	0
	.uleb128 0x4
	.byte	0x1
	.byte	0x8
	.4byte	.LASF7
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x410a
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x2111
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LLST2:
	.4byte	.LVL15-.Ltext0
	.4byte	.LVL16-.Ltext0
	.2byte	0x1
	.byte	0x54
	.4byte	.LVL16-.Ltext0
	.4byte	.LVL21-.Ltext0
	.2byte	0x1
	.byte	0x62
	.4byte	.LVL21-.Ltext0
	.4byte	.LFE2-.Ltext0
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x54
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST1:
	.4byte	.LVL4-.Ltext0
	.4byte	.LVL5-.Ltext0
	.2byte	0x1
	.byte	0x54
	.4byte	.LVL5-.Ltext0
	.4byte	.LVL14-.Ltext0
	.2byte	0x1
	.byte	0x60
	.4byte	.LVL14-.Ltext0
	.4byte	.LFE1-.Ltext0
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x54
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST0:
	.4byte	.LVL0-.Ltext0
	.4byte	.LVL1-.Ltext0
	.2byte	0x1
	.byte	0x54
	.4byte	.LVL1-.Ltext0
	.4byte	.LVL2-.Ltext0
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x54
	.byte	0x9f
	.4byte	.LVL2-.Ltext0
	.4byte	.LVL3-.Ltext0
	.2byte	0x1
	.byte	0x54
	.4byte	.LVL3-.Ltext0
	.4byte	.LFE0-.Ltext0
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x54
	.byte	0x9f
	.4byte	0
	.4byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	0
	.4byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF6:
	.ascii	"unsigned int\000"
.LASF1:
	.ascii	"set_seg7led_pixel\000"
.LASF4:
	.ascii	"set_seg7led_arduino\000"
.LASF11:
	.ascii	"get_digit\000"
.LASF10:
	.ascii	"C:\\Users\\zengkai\\Desktop\\MIPSfpga-on-SWORD\\programm"
	.ascii	"ing\\Exp2_7segled\000"
.LASF0:
	.ascii	"set_seg7led_arduino_pixel\000"
.LASF5:
	.ascii	"set_seg7led\000"
.LASF3:
	.ascii	"high\000"
.LASF9:
	.ascii	"seg7led.c\000"
.LASF7:
	.ascii	"unsigned char\000"
.LASF2:
	.ascii	"data\000"
.LASF8:
	.ascii	"GNU C11 6.3.0 -mel -march=m14kc -msoft-float -mplt -mips"
	.ascii	"32r2 -msynci -mabi=32 -g -O1\000"
	.ident	"GCC: (Codescape GNU Tools 2017.10-05 for MIPS MTI Bare Metal) 6.3.0"
