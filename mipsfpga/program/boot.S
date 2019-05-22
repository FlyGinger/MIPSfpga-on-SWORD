// This boot code is derived from https://github.com/sergev/LiteBSD/blob/master/sys/mips/pic32/locore.s

// Place all code in the .reset section
#define _RESETCODE

#include <mips/regdef.h>
#include <mips/asm.h>
#include <mips/m32c0.h>


/*-----------------------------------
 * Reset/NMI exception handler.
 */
.set push
        .set noreorder                  # Don't allow the assembler to reorder instructions.
        .set noat
.set nomicromips
LEAF(__reset_vector)

        mtc0    zero, C0_COUNT          # Clear cp0 Count (Used to measure boot time.)

        //
        // Init CP0 Status, Count, Compare, Watch*, and Cause.
        //
init_cp0:
        # Initialize Status
        li  v1, 0x00400004// (M_StatusERL | M_StatusBEV)
        mtc0    v1, C0_STATUS           # write Status

        # Clear WP bit to avoid watch exception upon user code entry, IV, and software interrupts.
        mtc0    zero, C0_CAUSE          # clear Cause: init AFTER init of WatchHi/Lo registers.

        # Clear timer interrupt. (Count was cleared at the reset vector to allow timing boot.)
        mtc0    zero, C0_COMPARE        # clear Compare

/*-----------------------------------
 * Initialization.
 */
        //
        // Clear TLB: generate unique EntryHi contents per entry pair.
        //
init_tlb:
        # Determine if we have a TLB
        li      v0, 0x0080001f
        mtc0    v0, C0_ENTRYLO0         # clear EntryLo0
        mtc0    v0, C0_ENTRYLO1         # clear EntryLo1

        li      v0, 0x1ffff800
        mtc0    v0, C0_PAGEMASK         # clear PageMask
        li      v0, 1
        mtc0    v0, C0_WIRED            # clear Wired

        mtc0    zero, C0_INDEX          # write Index
        mtc0    zero, C0_ENTRYHI        # write EntryHi
        ehb
        tlbwi

        //
        // Clear L1 instruction cache.
        //
init_icache:
        # Determine how big the I-cache is
        mfc0    v0, C0_CONFIG1          # read Config1
        ext     v1, v0, 19, 3           # extract I-cache line size
        beq     v1, zero, done_icache   # Skip ahead if no I-cache
        nop

        li      a2, 2
        sllv    v1, a2, v1              # Now have true I-cache line size in bytes

        ext     a0, v0, 22, 3           # extract IS
        li      a2, 64
        sllv    a0, a2, a0              # I-cache sets per way

        ext     a1, v0, 16, 3           # extract I-cache Assoc - 1
        add     a1, 1
        mul     a0, a0, a1              # Total number of sets
        lui     a2, 0x8000              # Get a KSeg0 address for cacheops

        mtc0    zero, C0_ITAGLO         # Clear ITagLo register
        move    a3, a0

next_icache_tag:
        # Index Store Tag Cache Op
        # Will invalidate the tag entry, clear the lock bit, and clear the LRF bit
        cache   0x8, 0 (a2)             # ICIndexStTag
        add     a3, -1                  # Decrement set counter
        bne     a3, zero, next_icache_tag
        add     a2, v1                  # Get next line address
done_icache:

        //
        // Enable cacheability of kseg0 segment.
        // Until this point the code is executed from segment bfc00000,
        // (i.e. kseg1), so I-cache is not used.
        // Here we jump to kseg0 and run with I-cache enabled.
        //
enable_k0_cache:
        # Set CCA for kseg0 to cacheable.
        # NOTE! This code must be executed in KSEG1 (not KSEG0 uncached)
        mfc0    v0, C0_CONFIG           # read Config
        li      v1, 3                   # CCA for single-core processors
        ins     v0, v1, 0, 3            # insert K0
        mtc0    v0, C0_CONFIG           # write Config

        la      a2, init_dcache
        jr      a2                      # switch back to KSEG0
        ehb

        //
        // Initialize the L1 data cache
        //
init_dcache:
        mfc0    v0, C0_CONFIG1          # read Config1
        ext     v1, v0, 10, 3           # extract D-cache line size
        beq     v1, zero, init_sd_card  # Skip ahead if no D-cache
        nop

        li      a2, 2
        sllv    v1, a2, v1              # Now have true D-cache line size in bytes

        ext     a0, v0, 13, 3           # extract DS
        li      a2, 64
        sllv    a0, a2, a0              # D-cache sets per way

        ext     a1, v0, 7, 3            # extract D-cache Assoc - 1
        add     a1, 1
        mul     a0, a0, a1              # Get total number of sets
        lui     a2, 0x8000              # Get a KSeg0 address for cacheops

        mtc0    zero, C0_ITAGLO         # Clear ITagLo/DTagLo registers
        mtc0    zero, C0_DTAGLO
        move    a3, a0

next_dcache_tag:
        # Index Store Tag Cache Op
        # Will invalidate the tag entry, clear the lock bit, and clear the LRF bit
        cache   0x9, 0 (a2)             # DCIndexStTag
        add     a3, -1                  # Decrement set counter
        bne     a3, zero, next_dcache_tag
        add     a2, v1                  # Get next line address


init_sd_card:
        li      gp, 0xbf001000         # sd ctrl register

        li      t0, 249
        sw      t0, 0x124(gp)         # Set SD clock rate to 400kHz
        li      t0, 511
        sw      t0, 0x144(gp)
        sw      zero, 0x148(gp)       # Block size:512, block count:1
        li      t0, 25000
        sw      t0, 0x120(gp)         # Command timeout:1ms under 25MHz clock
        li      t0, 2500000
        sw      t0, 0x118(gp)         # Data timeout:100ms under 25MHz clock

        # Send CMD0
        li      a0, 0x0
        la      a2, sdInit_err
        move    v0, zero              # v0 carries the current command index(BCD encoded) for error signaling
        jal     sd_sendCmd
        move    a1, zero

        # Send CMD8, check response=0x1aa
        or      a0, zero, 0x819
        li      v0, 0x8
        jal     sd_sendCmd
        or      a1, zero, 0x1aa

        lw      t0, 0x108(gp)
        li      t1, 0x1aa
        bne     t0, t1, sdInit_err1
        nop

        jal     sleep
        or      a0, zero, 4095

        # Send ACMD41 for the first time, voltage window set to empty
        # Note: CMD41 in ACMD41 should not check command index and CRC
        or      a0, zero, 0x3719
        li      v0, 0x55
        jal     sd_sendCmd
        move    a1, zero
        or      a0, zero, 0x2901
        li      v0, 0x41
        jal     sd_sendCmd
        lui     a1, 0x4000

        li      s0, 200                # Try 200 times at most
sd_ACMD41:
        or      a0, zero, 0x3719
        li      v0, 0x55
        jal     sd_sendCmd
        move    a1, zero
        or      a0, zero, 0x2901
        li      v0, 0x41
        jal     sd_sendCmd
        lui     a1, 0x4010

        lw      t0, 0x108(gp)
        lui     t1, 0x8000
        and     t0, t0, t1
        bne     t0, zero, sd_ACMD41_finish
        addu    s0, s0, -1
        beq     s0, zero, sdInit_err2
        nop
        jal     sleep
        or      a0, zero, 4095

        b       sd_ACMD41
        nop

sd_ACMD41_finish:
        # CMD2 followed by CMD3
        or      a0, zero, 0x0202
        li      v0, 0x2
        jal     sd_sendCmd
        move    a1, zero
        or      a0, zero, 0x0319
        li      v0, 0x3
        jal     sd_sendCmd
        move    a1, zero

        # Set SD clock rate to 25MHz
        or      t0, zero, 3
        sw      t0, 0x124(gp)

        jal     sleep
        or      a0, zero, 4095

        # CMD7, select card
        # Store RCA in s0
        lw      a1, 0x108(gp)
        li      a0, 0x071d
        lui     t0, 0xffff
        and     a1, a1, t0
        li      v0, 0x7
        jal     sd_sendCmd
        move    s0, a1

        # ACMD42, disconnect pullup resistor on DAT3
        li      v1, 9
        or      a0, zero, 0x3719
        li      v0, 0x55
        jal     sd_sendCmd
        move    a1, s0

        li      v1, 10
        li      v0, 0x42
        or      a0, zero, 0x2a19
        jal     sd_sendCmd
        move    a1, zero

        # ACMD6, set bus width to 4-bit
        li      v1, 11
        or      a0, zero, 0x3719
        li      v0, 0x55
        jal     sd_sendCmd
        move    a1, s0

        li      v1, 12
        or      a0, zero, 0x0619
        li      v0, 0x6
        jal     sd_sendCmd
        or      a1, zero, 2

        # Set SD controller's bus width to 4
        li      t0, 1
        sw      t0, 0x11c(gp)

        #Initialization done
        move    v0, zero
        b       sdInit_ret
        nop

sdInit_err:
        b       sdInit_ret
        li      v0, 0x100

sdInit_err1:
        b       sdInit_ret
        li      v0, 0x101

sdInit_err2:
        b       sdInit_ret
        li      v0, 0x102

sdInit_ret:
        li      v1, 0xbf80000c
        sw      zero, 0(v1)
        beq     v0, zero, done_init
        nop
        li      v0, 1
        sw      v0, 0(v1)
        j       done_init
        nop

sd_sendCmd:
        #a0=cmd, a1=arg, a2=err return addr
        sw      zero, 0x134(gp)       # Clear flags
        sw      a0, 0x104(gp)
        sw      a1, 0x100(gp)
        li      t0, 4095
sd_sendCmd_wait0:
        nop
        nop
        bne     t0, zero, sd_sendCmd_wait0
        addu    t0, t0, -1
sd_sendCmd_wait1:
        lw      t0, 0x134(gp)
        beq     t0, zero, sd_sendCmd_wait1
        nop
        and     t1, t0, 0x1
        bne     t1, zero, sd_sendCmd_ret
        nop
        j       a2
        nop
sd_sendCmd_ret:
        j       ra
        nop

sleep:
        nop
        nop
        nop
        nop
        nop
        nop
        bne     a0, zero, sleep
        addu    a0, a0, -1
        j       ra
        nop

done_init:
        # Prepare for eret to _start.

        la      ra, all_done        # If main returns then go to all_done:.
        move    a0, zero            # Indicate that there are no arguments available.

        la      v0, _start          # load the address of the CRT entry point _start.
        mtc0    v0, $30              # Write ErrorEPC with the address of main
        ehb                         # clear hazards (makes sure write to ErrorPC has completed)

        # Return from exception will now execute code at _start

        eret                        # Exit reset exception handler and start execution of _start.


/**************************************************************************************/
all_done:
        # If main returns it will return to this point.  Just spin here.
        b       all_done
        nop
END(__reset_vector)


/**************************************************************************************/

