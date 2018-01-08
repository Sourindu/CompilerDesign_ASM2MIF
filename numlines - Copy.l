%{
/* need this for the call to atof() below */
#include <math.h>
#include <stdio.h>
#include <ctype.h>

int num_lines = 0, num_chars = 0;

%}

END		[7|9]

%%
\n    			++num_lines; ++num_chars;
.     			++num_chars;
[ \t\n]+ 		/* eat up whitespace */
END+   			{printf("The Number Of Lines is %d", num_lines); 
				printf("\n The number of Characters is %d", num_chars); 
				numlines = 0; num_chars =0;}
					
%%
int yywrap(void) { return 1; };

int main(void)
{
    
	yylex();
    
	return 0;
}
