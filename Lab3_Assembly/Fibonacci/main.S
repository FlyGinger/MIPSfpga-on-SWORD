# $12 = address of switches, $13 = address offset of switches
# $10 = switch values 
.globl main

main:
   lui   $12, 0xbf80       # $12 = address of LEDs 
   addi  $s0, $zero, 11    # n in [1:11]
   addi  $s1, $zero, 0     # F(0) = 0
   addi  $s2, $zero, 1     # F(-1) = 1
   lui   $s3, 0x20         # time internal

fabonacci:
   move  $a0, $s1          # move F(n) to $a0
   move  $a1, $s2          # move F(n-1) to $a1
   jal   peek              # call peek function
   nop                     # branch delay slot
   move  $s2, $s1          # move F(n) to $s2
   move  $s1, $v0          # move F(n+1) to $s1
   move  $a0, $s1          # move the return value into $a0
   move  $a1, $12          # move address of LEDs in $a1
   jal   poke              # call poke function
   nop                     # branch delay slot
   move  $a0, $zero        # count from 0
   jal   delay             # delay
   nop                     # branch delay slot
   addi  $s0, $s0, 0xffff  # count -= 1
   bne   $s0, $0, fabonacci# repeat
   nop                     # branch delay slot
   j     main              # re-start
   nop                     # branch delay slot

peek:
   add   $v0, $a0, $a1     # F(n+2) = F(n+1) + F(n)
   jr    $ra               # return to point of call
   nop                     # branch delay slot

poke:
   sw    $a0, 0($a1)       # write values to I/O register 
   jr    $ra               # return to point of call
   nop                     # branch delay slot
  
delay:
   addi  $a0, $a0, 1       # count
   bne   $a0, $s3, delay   # until time internal
   jr    $ra               # return to point of call
   nop                     # branch delay slot
