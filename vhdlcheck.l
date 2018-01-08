/* Lexical analysis for a toy VHDL-like language */ 

%{
/* need this for the call to atof() below */ 
#include <math.h> 
%}
DIGIT           [0-9] 
ID              [a-z][a-z0-9_]* 
ASSIGNMENT      [(<=)|(:=)] 
GENERIC         [A-Z]
DELIMITER       [;,)(':]
COMMENT         "--"[^\n]*
LABEL           [a-zA-Z][a-zA-Z0-9]*[:]
%% 
{DIGIT}+        { printf( "An integer: %s (%d)\n", yytext, 
                atoi( yytext ) ); } 
IN|OUT|ENTITY|IS|END|PORT|ARCHITECTURE|OF|WAIT|UNTIL {
                printf( "A keyword: %s\n", yytext ); } 
BEGIN|PROCESS { printf( "A keyword: %s\n", yytext ); } 
{ID}            printf( "An identifier: %s\n", yytext ); 
"<="            printf( "An assignment: %s\n", yytext ); 
"="             printf( "Equal condition: %s\n", yytext ); 
{DELIMITER}	printf( "A delimiter: %s\n", yytext ); 
{LABEL}		printf( "A label: %s\n", yytext ); 

"+"|"-"|"*"|"/" 	printf( "An operator: %s\n", yytext ); 
{COMMENT}       printf( "A comment: %s\n", yytext );
[ \t\n]+ 		/* eat up whitespace */ 
. 		printf( "Unrecognized character: %s\n", yytext ); 

%% 

int yywrap(void) { return 1; }

main( argc, argv ) 
int argc; 
char **argv; 
{ 
  ++argv, --argc; /* skip over program name */ 
  if ( argc > 0 ) 
    yyin = fopen( argv[0], "r" ); 
  else 
    yyin = stdin; 
  yylex(); 
} 
