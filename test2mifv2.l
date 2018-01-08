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
int state_name =0; /* end of line prints out IW */
int   icount =0; /* number of instructions */
int   vcount =0; /* number of variables */
int   pp =1; /** preprocessor flag **/
int   vvflag = 0; /** variable flag **/
char  opis[6],lblis[4],immis[4], varname[10];
struct inst {int adr; char opc; int imm; char *txt;} iw;
struct init  {char *name; char code[];} op_table[20] =
{
"ADD"    , "00",
"SUBT"   , "05",
"AND"    , "08",
"OR"     , "07",
"STORE"  , "01",
"ADDI"   , "0B",
"XOR"    , "06",
"0"      ,  "0"
};
FILE      *fid;
int add_symbol(int value, char *symbol);
int lookup_symbol(char *symbol);
void list_symbols();
void conv2hex(int value, int Width);
char* lookup_opc(char *opc);


%}
DIGIT           [0-9] 
VAR             [(a-z)|(A-Z)]+[a-z0-9_]*
VARB			VAR/([ ]*[:])
VARN			VARB[(a-z)|(A-Z)]+[a-z0-9_]*
COMMENT         "--"[^\n]*
LABEL           L[0-9]+[ ]*[:]
GOTO            L[0-9]+

%%

COMMENT			/*Buffer the Comment*/

VARN			vcount++; { printf("The variable is %s", yytext);}

[ \t]+ 			/* eat up whitespace */

\n    			pp = 1;/*Still Now Do Nothing */

.     			/*{printf("Unknown Charecter : %s", yytext);}*/

				
%%
int yywrap(void) { return 1; };

void main( argc, argv ) 
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

char*
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
