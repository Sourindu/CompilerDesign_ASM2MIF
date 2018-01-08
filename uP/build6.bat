#-----------------------------------------------------------------------
echo -- Bison+Flex compiler script for better infix  calculator
echo -- Digital Signal Processing with FPGAs
echo -- Author: Dr. Uwe Meyer-Baese      EMAIL: Uwe.Meyer-Baese@ieee.org
#-----------------------------------------------------------------------


echo -- Compile all c code to build c2asm.exe
gcc -c yc2asm.c lc2asm.c
gcc yc2asm.o lc2asm.o c2asm.c -o c2asm.exe 

echo -- Check a small application factorial.c if it works
./c2asm.exe < factorial.c 
