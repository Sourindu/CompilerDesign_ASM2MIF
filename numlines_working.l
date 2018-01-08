%{
/* need this for the call to atof() below */
#include <math.h>
#include <stdio.h>
#include <ctype.h>

int num_lines = 0, num_chars = 0;

%}

END		(77)+

%%
[ \t]+ 			/* eat up whitespace */

\n    			++num_lines; ++num_chars;

{END}+ 			printf("The Number Of Lines is %d", num_lines); printf("\nThe number of Characters is %d\n", num_chars-1); num_lines = 0; num_chars =0;

.     			++num_chars;


					
%%
int yywrap(void) { return 1; };

int main(void)
{
    
	yylex();
    
	return 0;
}
