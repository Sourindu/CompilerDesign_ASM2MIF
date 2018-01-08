-- Bison+Flex compiler script for better infix calculator
-- Digital Signal Processing with FPGAs
-- Author: Dr. Uwe Meyer-Baese EMAIL: Uwe.Meyer-Baese@ieee.org
-- Compile all c code to build c2asm.exe
-- Check a small application factorial.c if it works
    PUSHI   1
    POP     x
    SCAN
    POP     k
L00:    PUSH    k
    PUSHI   1
    CNE
    CJP     L01
    PUSH    x
    PUSH    k
    MUL
    POP     x
    PUSH    k
    PUSHI   1
    SUB
    POP     k
    JMP     L00
L01:    PUSH    x
    PRINT
