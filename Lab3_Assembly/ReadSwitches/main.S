# $12 = address of switches, $13 = address offset of switches
# $10 = switch values 
.globl main
  
main:
   lui   $12, 0xbf80    # $12 = address of LEDs (0xbf800000)
   addiu $13, $12, 4    # $13 = address of switches

readIO: 	
   lw    $10, 0($13)    # read switches: $10 = switch values
   sw    $10, 0($12)    # write switch values to LEDs 
   beq   $0, $0, readIO # repeat
   nop                  # branch delay slot
