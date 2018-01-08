#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>

void main(void)
{
	while(1)
	{
		signed int i = 0;
		char d[10];
		int g = 0;
		signed int j = -i;
		scanf("%s",&d);
		i = atoi(d);
		j = -i;
		printf("\nDecimal Entered Is : %s  && Hex Is : %x",d,i);
		printf("\n The sum Is is 0x%x", i+j);
	}
}