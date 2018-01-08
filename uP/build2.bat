#----------------------------------------------------------------------- 
echo -- FLEX vhdl syntax checker compile script                              
echo -- Digital Signal Processing with FPGAs
echo -- Author: Dr. Uwe Meyer-Baese      EMAIL: Uwe.Meyer-Baese@ieee.org
#----------------------------------------------------------------------- 
rm lex.yy.c vhdlcheck.exe

echo -- Run  flex to generate lex.yy.c, flex file ends with .l
echo -- Output file is always lex.yy.c

flex vhdlcheck.l

echo -- Now run cc or gcc to compile the executable               
gcc -o vhdlcheck.exe lex.yy.c

echo -- Check a small application d_ff.vhd if it works               
./vhdlcheck.exe < d_ff.vhd
