#----------------------------------------------------------------------- 
echo -- FLEX simple compile script                              
echo -- Digital Signal Processing with FPGAs
echo -- Author: Dr. Uwe Meyer-Baese      EMAIL: Uwe.Meyer-Baese@ieee.org
#----------------------------------------------------------------------- 
rm simple.c simple.exe
echo -- Run flex to generate simple.c, flex file ends with .l
echo -- Output file is specified via -osimple.c

flex -osimple.c simple.l

echo -- Now run cc or gcc to compile the executable               
gcc -o simple.exe simple.c

echo -- Check a small application d_ff.vhd if it works               
./simple.exe < d_ff.vhd
