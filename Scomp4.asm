variable B : 0x5555
Variable C : 11
VariABle A : 0x0000
variable X : 32767
variable Y : 0x1111
variable H : 0x6666

LOAD B
ADD C
STORE A
L1: OR B
L1: JUMP L5
ADDI 0x20
JNEG L1
L9: ADD X
L2: SUBT Y
SUBI -4
L5: SUBT B
AND H
ADDI -1
JUMP L3
L3: ADD D
JPOS L2