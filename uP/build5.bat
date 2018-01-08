#-----------------------------------------------------------------------
echo -- Bison+Flex compiler script for better infix  calculator
echo -- Digital Signal Processing with FPGAs
echo -- Author: Dr. Uwe Meyer-Baese      EMAIL: Uwe.Meyer-Baese@ieee.org
#-----------------------------------------------------------------------

rm calc.exe  ytab.c  lexyy.c 

echo -- compile calc.exe
echo -- Run bison to generate .c, Bison file ends with .y
bison -y -d -o ytab.c calc.y

echo now run Flex to generate lexical analyzer
flex -olexyy.c calc.l

echo -- Now compile all c code to build calc.exe
gcc -c ytab.c lexyy.c
gcc ytab.o lexyy.o -o calc.exe -lm

echo -- Check a small application factorial.asm if it works
echo "-- add 2+3*5 then 1-2-5 then x=3*10; y=2x5-9;x+y;"
echo -- the "#" sign stops the calculator
./calc.exe < calc.txt

