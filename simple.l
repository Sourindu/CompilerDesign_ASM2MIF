/* A simple flex example */
%{
/* C-header and definitions */
#define YY_MAIN 1  
%}
%%
.|\n          ECHO; /* Rule section */
%%
/* User code here */
int yywrap(void) { return 1; }
int main(void)
{
	yylex();
	return 0;
}