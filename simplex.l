/* A simple flex example */
%{
/* C-header and definitions */
#include <stdlib.h> /* needed for malloc, exit etc **/
#define YY_MAIN 1
%}
%%
.|\n ECHO; /* Rule section */
%%
/* User code here */
int yywrap(void) { return 1; }