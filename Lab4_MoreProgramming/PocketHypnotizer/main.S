# $12 = address of switches, $13 = address offset of switches
# $10 = switch values 
.globl main
  
main:
    lui     $12, 0xbf80     # $12 = address of LEDs (0xbf800000)
    addiu   $13, $12, 4     # $13 = address of switches
    ori     $14, $0, 0x8000 # start
    ori     $15, $0, 0x1    # end
    lui     $16, 0x20       # time internal (>0)

hypnotizer:
    sll     $t0, $14, 1     # the first run is special

right:
    srl     $t0, $t0, 1     # shift right
    move    $a0, $t0        # move $t0 to $a0
    move    $a1, $12        # move the address of LED to $a1
    jal     poke            # call poke
    nop                     # delay slot
    move    $a0, $0         # delay time
    jal     delay           # wait for a while
    nop                     # delay slot
    bne     $t0, $15, right # loop
    nop                     # delay slot

left:
    sll     $t0, $t0, 1     # shitf left
    move    $a0, $t0        # move $t0 to $a0
    move    $a1, $12        # move the address of LED to $a1
    jal     poke            # call poke
    nop                     # delay slot
    move    $a0, $0         # delay time
    jal     delay           # wait for a while
    nop                     # delay slot
    bne     $t0, $14, left  # loop
    nop                     # delay slot
    j       right           # repeat
    nop                     # delay slot

poke:
    sw      $a0, 0($a1)     # show $a0 on LED
    jr      $ra             # return
    nop

delay:
    addi    $a0, $a0, 1     # counting
    bne     $a0, $16, delay # loop
    nop                     # delay slot
    jr      $ra             # return 
    nop                     # delay slot
    