#include <stdio.h>
#include "c2asm.h"
#include "yc2asm.h"

static int lbl;

int ex(nodeType *p) {
    int lbl1, lbl2;

    if (!p) return 0;
    switch(p->type) {
    case typeCon:       
        printf("    PUSHI   %d\n", p->con.value); 
        break;
    case typeId:        
        printf("    PUSH    %c\n", p->id.i + 'a'); 
        break;
    case typeOpr:
        switch(p->opr.oper) {
        case WHILE:
            printf("L%02d:", lbl1 = lbl++);
            ex(p->opr.op[0]);
            printf("    CJP     L%02d\n", lbl2 = lbl++);
            ex(p->opr.op[1]);
            printf("    JMP     L%02d\n", lbl1);
            printf("L%02d:", lbl2);
            break;
        case IF:
            ex(p->opr.op[0]);
            if (p->opr.nops > 2) {
                /* if else */
                printf("    CJP  L%02d\n", lbl1 = lbl++);
                ex(p->opr.op[1]);
                printf("    JMP     L%02d\n", lbl2 = lbl++);
                printf("L%02d:", lbl1);
                ex(p->opr.op[2]);
                printf("L%02d:", lbl2);
            } else {
                /* if */
                printf("    CJP  L%02d\n", lbl1 = lbl++);
                ex(p->opr.op[1]);
                printf("L%02d:", lbl1);
            }
            break;
        case SCANF:     
            printf("    SCAN\n");
            printf("    POP     %c\n", p->opr.op[0]->id.i + 'a');
            break;
        case PRINT:     
            ex(p->opr.op[0]);
            printf("    PRINT\n");
            break;
        case '=':       
            ex(p->opr.op[1]);
            printf("    POP     %c\n", p->opr.op[0]->id.i + 'a');
            break;
        case UMINUS:    
            ex(p->opr.op[0]);
            printf("    NEG\n");
            break;
        default:
            ex(p->opr.op[0]);
            ex(p->opr.op[1]);
            switch(p->opr.oper) {
            case '+':   printf("    ADD\n"); break;
            case '-':   printf("    SUB\n"); break; 
            case '*':   printf("    MUL\n"); break;
            case NE:    printf("    CNE\n"); break;
            case EQ:    printf("    CEQ\n"); break;
            }
        }
    }
    return(0);
}
