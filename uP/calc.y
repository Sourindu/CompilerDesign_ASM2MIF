%{
    #include <stdio.h>
    #include <math.h>
    #define YYSTYPE int
    void yyerror(char *);
    int yylex(void);
    int symtable[26];
%}

%token INTEGER VARIABLE
%left '+' '-'
%left '*' '/'
%right '^'   /* exponentiation              */
%left NEG     /* Negation, i.e. unary minus */

%%

program:
        program statement '\n'
        | /* NULL */
        ;

statement:
        expression                      { printf("%d\n", $1); }
        | VARIABLE '=' expression       { symtable[$1] = $3; }
        ;

expression:
        INTEGER
        | VARIABLE                      { $$ = symtable[$1]; }
        | expression '+' expression     { $$ = $1 + $3; }
        | expression '-' expression     { $$ = $1 - $3; }
        | expression '*' expression     { $$ = $1 * $3; }
        | expression '/' expression     { 
              if ($3) $$ = $1 / $3; 
              else {$$=1; yyerror("Division by zero !\n");}}
        /* Exponentiation */
        | expression '^' expression     { $$ = pow($1, $3); }
        /* Unary minus  */
        | '-' expression %prec NEG  { $$ = -$2; }
        | '(' expression ')'            { $$ = $2; }
        ;

%%

void yyerror(char *s) { fprintf(stderr, "%s\n", s); }

int main(void) { yyparse(); }
