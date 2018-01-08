typedef union {
    int iValue;                 /* integer value */
    char sIndex;                /* symbol table index */
    nodeType *nPtr;             /* node pointer */
} YYSTYPE;
#define	INTEGER	257
#define	VARIABLE	258
#define	WHILE	259
#define	IF	260
#define	PRINT	261
#define	SCANF	262
#define	IFX	263
#define	ELSE	264
#define	EQ	265
#define	NE	266
#define	UMINUS	267


extern YYSTYPE yylval;
