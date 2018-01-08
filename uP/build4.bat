#----------------------------------------------------------------------- 
echo -- Bison compiler script for simple ADD2 calculator 
echo -- Digital Signal Processing with FPGAs
echo -- Author: Dr. Uwe Meyer-Baese      EMAIL: Uwe.Meyer-Baese@ieee.org
#----------------------------------------------------------------------- 
rm add2.c add2.exe
echo -- Run bison to generate add2.c, Bison file ends with .y

bison -v -o add2.c add2.y

echo -- Now run cc or gcc to compile the execetutable               
gcc -o add2.exe add2.c -lm

echo -- Check a small application factorial.asm if it works               
echo -- add 2+3 then 3.4+5.7 fail for 7-2
./add2.exe < add2.txt 
