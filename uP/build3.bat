#----------------------------------------------------------------------- 
echo -- Flex compiler script for ASM2MIF program
echo -- Digital Signal Processing with FPGAs
echo -- Author: Dr. Uwe Meyer-Baese      EMAIL: Uwe.Meyer-Baese@ieee.org
#----------------------------------------------------------------------- 
rm asm2mif.c asm2mif.exe
echo -- Run  flex to generate asm2mif.c, flex file ends with .l

flex -oasm2mif.c asm2mif.l

echo -- Now run cc or gcc to compile the execetutable               
gcc -o asm2mif.exe asm2mif.c 

echo -- Check a small application factorial.asm if it works               
./asm2mif.exe  factorial.asm
