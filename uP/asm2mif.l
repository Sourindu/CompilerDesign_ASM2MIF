/* Scanner for assembler to MIF file converter */ 

%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <errno.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>
#define DEBUG 0
int state =0; /* end of line prints out IW */
int   icount =0; /* number of instructions */
int   vcount =0; /* number of variables */
int   pp =1; /** preprocessor flag **/
char  opis[6],lblis[4],immis[4];
struct inst {int adr; char opc; int imm; char *txt;} iw;
struct init  {char *name; char code;} op_table[20] =
{
"ADD"    , '0',
"NEG"    , '1', 
"SUB"    , '2',
"OPAND"  , '3',
"OPOR"   , '4',
"INV"    , '5',
"MUL"    , '6',
"POP"    , '7',
"PUSHI"  , '8',
"PUSH"   , '9',
"SCAN"   , 'a',
"PRINT"  , 'b',
"CNE"    , 'c',
"CEQ"    , 'd',
"CJP"    , 'e',
"JMP"    , 'f',
0,0
};
FILE      *fid;
int add_symbol(int value, char *symbol);
int lookup_symbol(char *symbol);
void list_symbols();
void conv2hex(int value, int Width);
char lookup_opc(char *opc);
%}
DIGIT           [0-9] 
VAR             [a-z][a-z0-9_]* 
COMMENT         "--"[^\n]*
LABEL           L[0-9]+[:]
GOTO            L[0-9]+
%% 
\n               {if (pp) printf( "end of line \n");
                  else { if ((state==2) && (pp==0)) /* print out an instruction at end of line */
                  {conv2hex(iw.adr,8);printf("  : %c",iw.opc); conv2hex(iw.imm,8);
                           printf(";  -- %s  %s\n",opis,immis); }                 state=0;iw.imm=0;
                 }}
{DIGIT}+        { if (pp) printf( "An integer: %s (%d)\n", yytext, atoi( yytext ) ); 
                  else   {iw.imm=atoi( yytext );state=2; strcpy(immis,yytext);}}
POP|PUSH|PUSHI|CJP|JMP { 
                if (pp)  printf( "%d) Instruction with operand: %s\n", icount++, yytext ); 
                else  {  state=1;iw.adr=icount++;iw.opc=lookup_opc(yytext);}
                   } 
CNE|CEQ|SCAN|PRINT|ADD|NEG|SUB|OPAND|OPOR|INV|MUL { 
                if (pp)  printf( "%d) ALU Instruction: %s\n", icount++, yytext ); 
                else  {  state=2; iw.adr=icount++; iw.opc=lookup_opc(yytext);strcpy(immis,"   ");}
                   } 
{VAR}            { if (pp)  {printf( "An identifier: %s\n", yytext ); add_symbol(vcount, yytext);}
                  else {state=2;iw.imm=lookup_symbol(yytext);strcpy(immis,yytext);}
                }
{LABEL}         { if (pp) {printf( "A label: %s lenth=%d Icount=%d\n", yytext , yyleng, icount);
                   add_symbol(icount, yytext);}
                }
{GOTO}		{ if (pp) printf( "A goto label: %s\n", yytext ); 
                    else {state=2;sprintf(lblis,"%s:",yytext);iw.imm=lookup_symbol(lblis);strcpy(immis,yytext);}
                }

{COMMENT}        {if (pp) printf( "A comment: %s\n", yytext );}
[ \t]+ 		/* eat up whitespace */ 
. 		printf( "Unrecognized character: %s\n", yytext ); 

%% 

int yywrap(void) { return 1; }

int main( argc, argv ) 
int argc; 
char **argv; 
{ 
  ++argv, --argc; /* skip over program name */ 
  if ( argc > 0 ) 
    yyin = fopen( argv[0], "r" ); 
  else 
{ printf("No input file -> EXIT\n"); exit(1);}
  printf("--- First path though file ---\n");
  yylex(); 
  if (yyin != NULL) fclose(yyin);
  pp=0;
  printf("-- This is the T-RISC program with %d lines and %d variables\n",icount,vcount);
  icount=0;
  printf("-- for the book DSP with FPGAs\n");
  printf("-- Copyright (c) Uwe Meyer-Baese\n");
  printf("WIDTH = 12;\nDEPTH = 256;\n");
  if (DEBUG) list_symbols();
  printf("ADDRESS_RADIX = hex;\nDATA_RADIX = hex;\n\n");
  printf("CONTENT BEGIN\n");
  printf("[0..FF] :  F00; -- Set all address from 0 to 255 => JUMP 0\n");
  if (DEBUG) printf("--- Second path through file ---\n");
  yyin = fopen( argv[0], "r" ); 
  yylex(); 
  printf("END;\n");
} 

/* define a linked list of symbols */
struct symbol {
	char *symbol_name;
	int symbol_value;
	struct symbol *next;
};

struct symbol *symbol_list; /* first element in symbol list */



extern void *malloc();

int
add_symbol(int value, char *symbol)
{
	struct symbol *wp;	

	if(lookup_symbol(symbol) >= 0 ) {
		printf("--- Warning: symbol %s already defined \n", symbol);
		return 0;
	}
	wp = (struct symbol *) malloc(sizeof(struct symbol));
	wp->next = symbol_list;
	wp->symbol_name = (char *) malloc(strlen(symbol)+1);
	strcpy(wp->symbol_name, symbol);
        if (symbol[0]!='L') vcount++;
	wp->symbol_value = value;
	symbol_list = wp;
	return 1;	/* it worked */
}

int
lookup_symbol(char *symbol)
{     int found = -1;
	struct symbol *wp = symbol_list;
	for(; wp; wp = wp->next) {
		if(strcmp(wp->symbol_name, symbol) == 0)
        {if (DEBUG) printf("-- Found symbol %s value is: %d\n",symbol, wp->symbol_value);
			return wp->symbol_value;}
	}
        if (DEBUG) printf("-- Symbol %s not found!!\n",symbol);
	return -1;	/* not found */
}

char
lookup_opc(char *opc)
{   int k;
    strcpy(opis,opc);
    for (k=0;op_table[k].name !=0;k++)
     if (strcmp(opc,op_table[k].name)==0) return (op_table[k].code);

printf("******* Ups, no opcode : %s --> exit \n",opc);exit(1);
}

void
list_symbols()
{
	struct symbol *wp = symbol_list;
      printf("--- Print the Symbol list: ---\n");
	for(; wp; wp = wp->next) 
      if (wp->symbol_name[0]=='L') {
	printf("-- Label    : %s  line = %d\n",wp->symbol_name, wp->symbol_value);
      } else {
	printf("-- Variable : %s  memory @ %d\n",wp->symbol_name, wp->symbol_value);
	}

}

/************* CONV_STD_LOGIC_VECTOR(value, bits) ***********/
void
conv2hex(int value, int Width)
{
	int             k, t;
	int             W;
	extern FILE    *fid;

	t = value;
	for (k = Width - 4; k >= 0; k-=4) {
		W = (t >> k) % 16;
		printf( "%1x", W);
	}
}
