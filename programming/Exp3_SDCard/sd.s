	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	softfloat
	.module	oddspreg
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.section	.sdata,"aw",@progbits
	.align	2
	.type	SD_CTRL, @object
	.size	SD_CTRL, 4
SD_CTRL:
	.word	-1090514944
	.align	2
	.type	SD_BUF, @object
	.size	SD_BUF, 4
SD_BUF:
	.word	-1090519040
	.text
	.align	2
.LFB0 = .
	.file 1 "sd.c"
	.loc 1 3 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	sd_send_cmd_blocking
	.type	sd_send_cmd_blocking, @function
sd_send_cmd_blocking:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	.cfi_def_cfa_offset 16
	sw	$fp,12($sp)
	.cfi_offset 30, -4
	move	$fp,$sp
	.cfi_def_cfa_register 30
	sw	$4,16($fp)
	sw	$5,20($fp)
	.loc 1 5 0
	li	$2,-1090519040			# 0xffffffffbf000000
	ori	$2,$2,0x1000
	addiu	$2,$2,4
	lw	$3,16($fp)
	sw	$3,0($2)
	.loc 1 6 0
	li	$2,-1090519040			# 0xffffffffbf000000
	ori	$2,$2,0x1000
	lw	$3,20($fp)
	sw	$3,0($2)
	.loc 1 8 0
	li	$2,4096			# 0x1000
	sw	$2,0($fp)
	.loc 1 9 0
	nop
.L2:
	.loc 1 9 0 is_stmt 0 discriminator 1
	lw	$2,0($fp)
	addiu	$3,$2,-1
	sw	$3,0($fp)
	bne	$2,$0,.L2
	nop

	.loc 1 13 0 is_stmt 1
	sw	$0,4($fp)
.L3:
	.loc 1 15 0 discriminator 1
	li	$2,-1090519040			# 0xffffffffbf000000
	ori	$2,$2,0x1000
	addiu	$2,$2,52
	lw	$2,0($2)
	sw	$2,4($fp)
	.loc 1 16 0 discriminator 1
	lw	$2,4($fp)
	beq	$2,$0,.L3
	nop

	.loc 1 19 0
	lw	$2,4($fp)
	andi	$2,$2,0x1
	beq	$2,$0,.L4
	nop

	.loc 1 21 0
	move	$2,$0
	b	.L5
	nop

.L4:
	.loc 1 24 0
	lw	$2,4($fp)
.L5:
	.loc 1 26 0
	move	$sp,$fp
	.cfi_def_cfa_register 29
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	sd_send_cmd_blocking
	.cfi_endproc
.LFE0:
	.size	sd_send_cmd_blocking, .-sd_send_cmd_blocking
	.align	2
	.globl	sd_read_sector_blocking
.LFB1 = .
	.loc 1 28 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	sd_read_sector_blocking
	.type	sd_read_sector_blocking, @function
sd_read_sector_blocking:
	.frame	$fp,48,$31		# vars= 24, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-48
	.cfi_def_cfa_offset 48
	sw	$31,44($sp)
	sw	$fp,40($sp)
	.cfi_offset 31, -4
	.cfi_offset 30, -8
	move	$fp,$sp
	.cfi_def_cfa_register 30
	sw	$4,48($fp)
	sw	$5,52($fp)
.LBB2 = .
	.loc 1 30 0
 #APP
 # 30 "sd.c" 1
	di $2; ehb
 # 0 "" 2
 #NO_APP
	sw	$2,24($fp)
.LBE2 = .
	.loc 1 31 0
	sw	$0,16($fp)
	.loc 1 34 0
	li	$2,-1090519040			# 0xffffffffbf000000
	ori	$2,$2,0x1000
	addiu	$2,$2,96
	sw	$0,0($2)
	.loc 1 36 0
	li	$2,-1090519040			# 0xffffffffbf000000
	ori	$2,$2,0x1000
	addiu	$2,$2,60
	sw	$0,0($2)
	.loc 1 38 0
	lw	$5,48($fp)
	li	$4,4409			# 0x1139
	jal	sd_send_cmd_blocking
	sw	$2,16($fp)
	.loc 1 39 0
	lw	$2,16($fp)
	bne	$2,$0,.L14
	.loc 1 44 0
	sw	$0,28($fp)
.L9:
	.loc 1 46 0 discriminator 1
	li	$2,-1090519040			# 0xffffffffbf000000
	ori	$2,$2,0x1000
	addiu	$2,$2,60
	lw	$2,0($2)
	sw	$2,28($fp)
	.loc 1 47 0 discriminator 1
	lw	$2,28($fp)
	beq	$2,$0,.L9
	.loc 1 49 0
	lw	$2,28($fp)
	andi	$2,$2,0x1
	beq	$2,$0,.L10
.LBB3 = .
	.loc 1 51 0
	lw	$2,52($fp)
	sw	$2,32($fp)
.LBB4 = .
	.loc 1 52 0
	sw	$0,20($fp)
	b	.L11
.L12:
	.loc 1 53 0 discriminator 3
	lw	$2,20($fp)
	sll	$2,$2,2
	lw	$3,32($fp)
	addu	$2,$3,$2
	li	$4,-1090519040			# 0xffffffffbf000000
	lw	$3,20($fp)
	sll	$3,$3,2
	addu	$3,$4,$3
	lw	$3,0($3)
	sw	$3,0($2)
	.loc 1 52 0 discriminator 3
	lw	$2,20($fp)
	addiu	$2,$2,1
	sw	$2,20($fp)
.L11:
	.loc 1 52 0 is_stmt 0 discriminator 1
	lw	$2,20($fp)
	slt	$2,$2,128
	bne	$2,$0,.L12
.LBE4 = .
	.loc 1 55 0 is_stmt 1
	sw	$0,16($fp)
.LBE3 = .
	b	.L8
.L10:
	.loc 1 58 0
	lw	$2,28($fp)
	sw	$2,16($fp)
	b	.L8
.L14:
	.loc 1 40 0
	.set	noreorder
	nop
	.set	reorder
.L8:
.LBB5 = .
	.loc 1 62 0
 #APP
 # 62 "sd.c" 1
	ei $2; ehb
 # 0 "" 2
 #NO_APP
	sw	$2,36($fp)
.LBE5 = .
	.loc 1 63 0
	lw	$2,16($fp)
	.loc 1 64 0
	move	$sp,$fp
	.cfi_def_cfa_register 29
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	.cfi_restore 30
	.cfi_restore 31
	.cfi_def_cfa_offset 0
	jr	$31
	.end	sd_read_sector_blocking
	.cfi_endproc
.LFE1:
	.size	sd_read_sector_blocking, .-sd_read_sector_blocking
	.align	2
	.globl	sd_write_sector_blocking
.LFB2 = .
	.loc 1 66 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	sd_write_sector_blocking
	.type	sd_write_sector_blocking, @function
sd_write_sector_blocking:
	.frame	$fp,48,$31		# vars= 24, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-48
	.cfi_def_cfa_offset 48
	sw	$31,44($sp)
	sw	$fp,40($sp)
	.cfi_offset 31, -4
	.cfi_offset 30, -8
	move	$fp,$sp
	.cfi_def_cfa_register 30
	sw	$4,48($fp)
	sw	$5,52($fp)
.LBB6 = .
	.loc 1 68 0
 #APP
 # 68 "sd.c" 1
	di $2; ehb
 # 0 "" 2
 #NO_APP
	sw	$2,24($fp)
.LBE6 = .
	.loc 1 69 0
	sw	$0,16($fp)
	.loc 1 72 0
	li	$2,-1090519040			# 0xffffffffbf000000
	ori	$2,$2,0x1000
	addiu	$2,$2,96
	sw	$0,0($2)
	.loc 1 74 0
	li	$2,-1090519040			# 0xffffffffbf000000
	ori	$2,$2,0x1000
	addiu	$2,$2,60
	sw	$0,0($2)
	.loc 1 76 0
 #APP
 # 76 "sd.c" 1
	nop
	nop
	
 # 0 "" 2
	.loc 1 80 0
 #NO_APP
	lw	$2,52($fp)
	sw	$2,28($fp)
.LBB7 = .
	.loc 1 81 0
	sw	$0,20($fp)
	b	.L16
.L17:
	.loc 1 82 0 discriminator 3
	li	$3,-1090519040			# 0xffffffffbf000000
	lw	$2,20($fp)
	sll	$2,$2,2
	addu	$2,$3,$2
	lw	$3,20($fp)
	sll	$3,$3,2
	lw	$4,28($fp)
	addu	$3,$4,$3
	lw	$3,0($3)
	sw	$3,0($2)
	.loc 1 81 0 discriminator 3
	lw	$2,20($fp)
	addiu	$2,$2,1
	sw	$2,20($fp)
.L16:
	.loc 1 81 0 is_stmt 0 discriminator 1
	lw	$2,20($fp)
	slt	$2,$2,128
	bne	$2,$0,.L17
.LBE7 = .
	.loc 1 85 0 is_stmt 1
	lw	$5,48($fp)
	li	$4,6233			# 0x1859
	jal	sd_send_cmd_blocking
	sw	$2,16($fp)
	.loc 1 86 0
	lw	$2,16($fp)
	bne	$2,$0,.L23
	.loc 1 91 0
	sw	$0,32($fp)
.L20:
	.loc 1 93 0 discriminator 1
	li	$2,-1090519040			# 0xffffffffbf000000
	ori	$2,$2,0x1000
	addiu	$2,$2,60
	lw	$2,0($2)
	sw	$2,32($fp)
	.loc 1 94 0 discriminator 1
	lw	$2,32($fp)
	beq	$2,$0,.L20
	.loc 1 96 0
	lw	$2,32($fp)
	andi	$2,$2,0x1
	beq	$2,$0,.L21
	.loc 1 97 0
	sw	$0,16($fp)
	b	.L19
.L21:
	.loc 1 99 0
	lw	$2,32($fp)
	sw	$2,16($fp)
	b	.L19
.L23:
	.loc 1 87 0
	.set	noreorder
	nop
	.set	reorder
.L19:
.LBB8 = .
	.loc 1 103 0
 #APP
 # 103 "sd.c" 1
	ei $2; ehb
 # 0 "" 2
 #NO_APP
	sw	$2,36($fp)
.LBE8 = .
	.loc 1 104 0
	lw	$2,16($fp)
	.loc 1 105 0
	move	$sp,$fp
	.cfi_def_cfa_register 29
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	.cfi_restore 30
	.cfi_restore 31
	.cfi_def_cfa_offset 0
	jr	$31
	.end	sd_write_sector_blocking
	.cfi_endproc
.LFE2:
	.size	sd_write_sector_blocking, .-sd_write_sector_blocking
	.align	2
	.globl	sd_read_block
.LFB3 = .
	.loc 1 108 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	sd_read_block
	.type	sd_read_block, @function
sd_read_block:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	.cfi_def_cfa_offset 32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	.cfi_offset 31, -4
	.cfi_offset 30, -8
	move	$fp,$sp
	.cfi_def_cfa_register 30
	sw	$4,32($fp)
	sw	$5,36($fp)
	sw	$6,40($fp)
.LBB9 = .
	.loc 1 111 0
	sw	$0,16($fp)
	b	.L25
	nop

.L28:
	.loc 1 112 0
	lw	$3,16($fp)
	lw	$2,36($fp)
	addu	$2,$3,$2
	move	$4,$2
	lw	$2,16($fp)
	sll	$2,$2,9
	move	$3,$2
	lw	$2,32($fp)
	addu	$2,$2,$3
	move	$5,$2
	jal	sd_read_sector_blocking
	nop

	sw	$2,20($fp)
	.loc 1 113 0
	lw	$2,20($fp)
	bne	$2,$0,.L32
	nop

	.loc 1 111 0 discriminator 2
	lw	$2,16($fp)
	addiu	$2,$2,1
	sw	$2,16($fp)
.L25:
	.loc 1 111 0 is_stmt 0 discriminator 1
	lw	$3,16($fp)
	lw	$2,40($fp)
	sltu	$2,$3,$2
	bne	$2,$0,.L28
	nop

.L29 = .
.LBE9 = .
	.loc 1 118 0 is_stmt 1
	move	$2,$0
	b	.L30
	nop

.L32:
.LBB10 = .
	.loc 1 114 0
	nop
.L27 = .
.LBE10 = .
	.loc 1 120 0
	li	$2,1			# 0x1
.L30:
	.loc 1 121 0
	move	$sp,$fp
	.cfi_def_cfa_register 29
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	.cfi_restore 30
	.cfi_restore 31
	.cfi_def_cfa_offset 0
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	sd_read_block
	.cfi_endproc
.LFE3:
	.size	sd_read_block, .-sd_read_block
	.align	2
	.globl	sd_write_block
.LFB4 = .
	.loc 1 124 0
	.cfi_startproc
	.set	nomips16
	.set	nomicromips
	.ent	sd_write_block
	.type	sd_write_block, @function
sd_write_block:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	.cfi_def_cfa_offset 32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	.cfi_offset 31, -4
	.cfi_offset 30, -8
	move	$fp,$sp
	.cfi_def_cfa_register 30
	sw	$4,32($fp)
	sw	$5,36($fp)
	sw	$6,40($fp)
.LBB11 = .
	.loc 1 127 0
	sw	$0,16($fp)
	b	.L34
	nop

.L37:
	.loc 1 128 0
	lw	$3,16($fp)
	lw	$2,36($fp)
	addu	$2,$3,$2
	move	$4,$2
	lw	$2,16($fp)
	sll	$2,$2,9
	move	$3,$2
	lw	$2,32($fp)
	addu	$2,$2,$3
	move	$5,$2
	jal	sd_write_sector_blocking
	nop

	sw	$2,20($fp)
	.loc 1 129 0
	lw	$2,20($fp)
	bne	$2,$0,.L41
	nop

	.loc 1 127 0 discriminator 2
	lw	$2,16($fp)
	addiu	$2,$2,1
	sw	$2,16($fp)
.L34:
	.loc 1 127 0 is_stmt 0 discriminator 1
	lw	$3,16($fp)
	lw	$2,40($fp)
	sltu	$2,$3,$2
	bne	$2,$0,.L37
	nop

.L38 = .
.LBE11 = .
	.loc 1 134 0 is_stmt 1
	move	$2,$0
	b	.L39
	nop

.L41:
.LBB12 = .
	.loc 1 130 0
	nop
.L36 = .
.LBE12 = .
	.loc 1 136 0
	li	$2,1			# 0x1
.L39:
	.loc 1 137 0
	move	$sp,$fp
	.cfi_def_cfa_register 29
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	.cfi_restore 30
	.cfi_restore 31
	.cfi_def_cfa_offset 0
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	sd_write_block
	.cfi_endproc
.LFE4:
	.size	sd_write_block, .-sd_write_block
.Letext0:
	.file 2 "c:\\progra~1\\imagin~1\\toolch~1\\mips-m~1\\2017~1.10-\\mips-mti-elf\\include\\mips\\cpu.h"
	.file 3 "mfp_io.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x3f9
	.2byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF38
	.byte	0xc
	.4byte	.LASF39
	.4byte	.LASF40
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.4byte	.LASF0
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	.LASF1
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.4byte	.LASF2
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.4byte	.LASF3
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.4byte	.LASF4
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF5
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.4byte	.LASF6
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.4byte	.LASF7
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.uleb128 0x2
	.byte	0x8
	.byte	0x4
	.4byte	.LASF8
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF9
	.uleb128 0x4
	.4byte	0x6b
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF10
	.uleb128 0x5
	.byte	0x4
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	.LASF11
	.uleb128 0x6
	.4byte	.LASF12
	.byte	0x2
	.byte	0x41
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF13
	.byte	0x2
	.byte	0x41
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF14
	.byte	0x2
	.byte	0x41
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF15
	.byte	0x2
	.byte	0x42
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF16
	.byte	0x2
	.byte	0x42
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF17
	.byte	0x2
	.byte	0x42
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF18
	.byte	0x2
	.byte	0x43
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF19
	.byte	0x2
	.byte	0x43
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF20
	.byte	0x2
	.byte	0x43
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF21
	.byte	0x2
	.byte	0x44
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF22
	.byte	0x2
	.byte	0x44
	.4byte	0x5d
	.uleb128 0x6
	.4byte	.LASF23
	.byte	0x2
	.byte	0x44
	.4byte	0x5d
	.uleb128 0x7
	.4byte	.LASF24
	.byte	0x3
	.byte	0x2b
	.4byte	0x122
	.uleb128 0x5
	.byte	0x3
	.4byte	SD_CTRL
	.uleb128 0x8
	.byte	0x4
	.4byte	0x72
	.uleb128 0x9
	.4byte	0x11c
	.uleb128 0x7
	.4byte	.LASF25
	.byte	0x3
	.byte	0x2c
	.4byte	0x122
	.uleb128 0x5
	.byte	0x3
	.4byte	SD_BUF
	.uleb128 0xa
	.4byte	.LASF30
	.byte	0x1
	.byte	0x7b
	.4byte	0x48
	.4byte	.LFB4
	.4byte	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x1b1
	.uleb128 0xb
	.ascii	"buf\000"
	.byte	0x1
	.byte	0x7b
	.4byte	0x1b1
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xc
	.4byte	.LASF26
	.byte	0x1
	.byte	0x7b
	.4byte	0x48
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0xc
	.4byte	.LASF27
	.byte	0x1
	.byte	0x7c
	.4byte	0x48
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x7
	.4byte	.LASF28
	.byte	0x1
	.byte	0x7e
	.4byte	0x48
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0xd
	.4byte	.LASF29
	.byte	0x1
	.byte	0x87
	.4byte	.L36
	.uleb128 0xe
	.ascii	"ok\000"
	.byte	0x1
	.byte	0x85
	.4byte	.L38
	.uleb128 0xf
	.4byte	.Ldebug_ranges0+0x18
	.uleb128 0x10
	.ascii	"i\000"
	.byte	0x1
	.byte	0x7f
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.4byte	0x2c
	.uleb128 0xa
	.4byte	.LASF31
	.byte	0x1
	.byte	0x6b
	.4byte	0x48
	.4byte	.LFB3
	.4byte	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x230
	.uleb128 0xb
	.ascii	"buf\000"
	.byte	0x1
	.byte	0x6b
	.4byte	0x1b1
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xc
	.4byte	.LASF26
	.byte	0x1
	.byte	0x6b
	.4byte	0x48
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0xc
	.4byte	.LASF27
	.byte	0x1
	.byte	0x6c
	.4byte	0x48
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x7
	.4byte	.LASF28
	.byte	0x1
	.byte	0x6e
	.4byte	0x48
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0xd
	.4byte	.LASF29
	.byte	0x1
	.byte	0x77
	.4byte	.L27
	.uleb128 0xe
	.ascii	"ok\000"
	.byte	0x1
	.byte	0x75
	.4byte	.L29
	.uleb128 0xf
	.4byte	.Ldebug_ranges0+0
	.uleb128 0x10
	.ascii	"i\000"
	.byte	0x1
	.byte	0x6f
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	.LASF32
	.byte	0x1
	.byte	0x42
	.4byte	0x5d
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2e8
	.uleb128 0xb
	.ascii	"id\000"
	.byte	0x1
	.byte	0x42
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xc
	.4byte	.LASF33
	.byte	0x1
	.byte	0x42
	.4byte	0x7e
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x7
	.4byte	.LASF28
	.byte	0x1
	.byte	0x45
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x7
	.4byte	.LASF34
	.byte	0x1
	.byte	0x50
	.4byte	0x2e8
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xe
	.ascii	"ret\000"
	.byte	0x1
	.byte	0x65
	.4byte	.L19
	.uleb128 0x10
	.ascii	"des\000"
	.byte	0x1
	.byte	0x5b
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x11
	.4byte	.LBB6
	.4byte	.LBE6-.LBB6
	.4byte	0x2b5
	.uleb128 0x10
	.ascii	"__v\000"
	.byte	0x1
	.byte	0x44
	.4byte	0x6b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x11
	.4byte	.LBB7
	.4byte	.LBE7-.LBB7
	.4byte	0x2cf
	.uleb128 0x10
	.ascii	"i\000"
	.byte	0x1
	.byte	0x51
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.byte	0
	.uleb128 0x12
	.4byte	.LBB8
	.4byte	.LBE8-.LBB8
	.uleb128 0x10
	.ascii	"__v\000"
	.byte	0x1
	.byte	0x67
	.4byte	0x6b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.4byte	0x5d
	.uleb128 0xa
	.4byte	.LASF35
	.byte	0x1
	.byte	0x1c
	.4byte	0x5d
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3b0
	.uleb128 0xb
	.ascii	"id\000"
	.byte	0x1
	.byte	0x1c
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xc
	.4byte	.LASF33
	.byte	0x1
	.byte	0x1c
	.4byte	0x7e
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x7
	.4byte	.LASF28
	.byte	0x1
	.byte	0x1f
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0xe
	.ascii	"ret\000"
	.byte	0x1
	.byte	0x3c
	.4byte	.L8
	.uleb128 0x10
	.ascii	"des\000"
	.byte	0x1
	.byte	0x2c
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x11
	.4byte	.LBB2
	.4byte	.LBE2-.LBB2
	.4byte	0x365
	.uleb128 0x10
	.ascii	"__v\000"
	.byte	0x1
	.byte	0x1e
	.4byte	0x6b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x11
	.4byte	.LBB3
	.4byte	.LBE3-.LBB3
	.4byte	0x397
	.uleb128 0x7
	.4byte	.LASF34
	.byte	0x1
	.byte	0x33
	.4byte	0x2e8
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x12
	.4byte	.LBB4
	.4byte	.LBE4-.LBB4
	.uleb128 0x10
	.ascii	"i\000"
	.byte	0x1
	.byte	0x34
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.byte	0
	.byte	0
	.uleb128 0x12
	.4byte	.LBB5
	.4byte	.LBE5-.LBB5
	.uleb128 0x10
	.ascii	"__v\000"
	.byte	0x1
	.byte	0x3e
	.4byte	0x6b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.byte	0
	.uleb128 0x13
	.4byte	.LASF41
	.byte	0x1
	.byte	0x3
	.4byte	0x5d
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xb
	.ascii	"cmd\000"
	.byte	0x1
	.byte	0x3
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xc
	.4byte	.LASF36
	.byte	0x1
	.byte	0x3
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x10
	.ascii	"t\000"
	.byte	0x1
	.byte	0x8
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x7
	.4byte	.LASF37
	.byte	0x1
	.byte	0xd
	.4byte	0x5d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
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
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x34
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
	.uleb128 0x8
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
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
	.uleb128 0x2116
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
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xc
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
	.uleb128 0xd
	.uleb128 0xa
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0xa
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x34
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
	.uleb128 0x11
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0x1
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
	.byte	0
	.byte	0
	.byte	0
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
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.4byte	.LBB9-.Ltext0
	.4byte	.LBE9-.Ltext0
	.4byte	.LBB10-.Ltext0
	.4byte	.LBE10-.Ltext0
	.4byte	0
	.4byte	0
	.4byte	.LBB11-.Ltext0
	.4byte	.LBE11-.Ltext0
	.4byte	.LBB12-.Ltext0
	.4byte	.LBE12-.Ltext0
	.4byte	0
	.4byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF6:
	.ascii	"long long int\000"
.LASF41:
	.ascii	"sd_send_cmd_blocking\000"
.LASF22:
	.ascii	"mips_tcache_linesize\000"
.LASF18:
	.ascii	"mips_scache_size\000"
.LASF38:
	.ascii	"GNU C11 6.3.0 -mel -march=m14kc -msoft-float -mplt -mips"
	.ascii	"32r2 -msynci -mabi=32 -g -O0\000"
.LASF23:
	.ascii	"mips_tcache_ways\000"
.LASF13:
	.ascii	"mips_icache_linesize\000"
.LASF27:
	.ascii	"count\000"
.LASF34:
	.ascii	"buffer_int\000"
.LASF30:
	.ascii	"sd_write_block\000"
.LASF19:
	.ascii	"mips_scache_linesize\000"
.LASF3:
	.ascii	"short unsigned int\000"
.LASF37:
	.ascii	"cmd_event_status\000"
.LASF16:
	.ascii	"mips_dcache_linesize\000"
.LASF5:
	.ascii	"long unsigned int\000"
.LASF36:
	.ascii	"argument\000"
.LASF26:
	.ascii	"addr\000"
.LASF17:
	.ascii	"mips_dcache_ways\000"
.LASF35:
	.ascii	"sd_read_sector_blocking\000"
.LASF25:
	.ascii	"SD_BUF\000"
.LASF12:
	.ascii	"mips_icache_size\000"
.LASF39:
	.ascii	"sd.c\000"
.LASF2:
	.ascii	"short int\000"
.LASF24:
	.ascii	"SD_CTRL\000"
.LASF1:
	.ascii	"unsigned char\000"
.LASF9:
	.ascii	"unsigned int\000"
.LASF32:
	.ascii	"sd_write_sector_blocking\000"
.LASF7:
	.ascii	"long long unsigned int\000"
.LASF28:
	.ascii	"result\000"
.LASF10:
	.ascii	"sizetype\000"
.LASF29:
	.ascii	"error\000"
.LASF15:
	.ascii	"mips_dcache_size\000"
.LASF20:
	.ascii	"mips_scache_ways\000"
.LASF11:
	.ascii	"char\000"
.LASF31:
	.ascii	"sd_read_block\000"
.LASF14:
	.ascii	"mips_icache_ways\000"
.LASF33:
	.ascii	"buffer\000"
.LASF4:
	.ascii	"long int\000"
.LASF40:
	.ascii	"C:\\Users\\zengkai\\Desktop\\MIPSfpga-on-SWORD\\programm"
	.ascii	"ing\\Exp3_SDCard\000"
.LASF8:
	.ascii	"long double\000"
.LASF0:
	.ascii	"signed char\000"
.LASF21:
	.ascii	"mips_tcache_size\000"
	.ident	"GCC: (Codescape GNU Tools 2017.10-05 for MIPS MTI Bare Metal) 6.3.0"
