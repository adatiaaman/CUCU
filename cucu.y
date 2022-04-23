%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex();
    void yyerror(char *s);
    FILE *yyin;
    FILE *yyout, *lexout;
%}

%token GE LE EQ NEQ G L 
%token INT CHAR ASSIGN ADD SUB MUL DIV IF ELSE FOR WHILE RETURN
%token SQ_OP SQ_CL PAREN_OP PAREN_CL CURL_OP CURL_CL SEMI_CL COMMA
%union {
    int number;
    char *string;
}
%token <string> VAR 
%token <string> STRING
%token <string> BOOL
%token <number> INTEGER
%left ADD SUB
%left MUL DIV
%left PAREN_OP PAREN_CL

%%
PROGRAM: PROGRAM_BODY 
;
PROGRAM_BODY: VAR_DEC_G PROGRAM_BODY | 
    FUNC_DEC PROGRAM_BODY | 
    FUNCN PROGRAM_BODY | 
    INIT_G PROGRAM_BODY | 
    ;
VAR_DEC_G: CHAR VAR SEMI_CL { fprintf(yyout, "global variable: %s\n", $2); } | 
        CHAR VAR ASSIGN STRING SEMI_CL { fprintf(yyout, "global variable: %s\n", $2); fprintf(yyout, "string: %s\n", $4); } | 
        INT VAR SEMI_CL { fprintf(yyout, "global variable: %s\n", $2); } | 
        INT VAR ASSIGN ARITH SEMI_CL { fprintf(yyout, "global variable: %s\n", $2); } |
        INT VAR ASSIGN COMP SEMI_CL { fprintf(yyout, "global variable: %s\n", $2); } |
        INT VAR ASSIGN FUNC_CALL SEMI_CL { fprintf(yyout, "global variable: %s\n", $2); }
        ;
INIT_G: VAR ASSIGN STRING SEMI_CL { fprintf(yyout, "global variable: %s\n", $1); fprintf(yyout, "string: %s\n", $3); } | 
    VAR ASSIGN ARITH SEMI_CL { fprintf(yyout, "global variable: %s\n", $1); } |
    VAR ASSIGN FUNC_CALL SEMI_CL { fprintf(yyout, "global variable: %s\n", $1); }
    ;

VAR_DEC: CHAR VAR SEMI_CL { fprintf(yyout, "local variable: %s\n", $2); } | 
        CHAR VAR ASSIGN STRING SEMI_CL { fprintf(yyout, "local variable: %s\n", $2); fprintf(yyout, "string: %s\n", $4); } | 
        INT VAR SEMI_CL { fprintf(yyout, "local variable: %s\n", $2); } | 
        INT VAR ASSIGN ARITH SEMI_CL { fprintf(yyout, "local variable: %s\n", $2); } |
        INT VAR ASSIGN COMP SEMI_CL { fprintf(yyout, "local variable: %s\n", $2); } |
        INT VAR ASSIGN FUNC_CALL SEMI_CL { fprintf(yyout, "local variable: %s\n", $2); }
        ;
INIT: VAR ASSIGN STRING SEMI_CL { fprintf(yyout, "local variable: %s\n", $1); fprintf(yyout, "string: %s\n", $3); } | 
    VAR ASSIGN ARITH SEMI_CL { fprintf(yyout, "local variable: %s\n", $1); } |
    VAR ASSIGN FUNC_CALL SEMI_CL { fprintf(yyout, "local variable: %s\n", $1); }
    ;
ARITH: INTEGER { fprintf(yyout, "const-%d\n", $1); } | 
    VAR { fprintf(yyout, "var-%s\n", $1); } | 
    ARITH ADD ARITH { fprintf(yyout, "+\n"); } | 
    ARITH SUB ARITH { fprintf(yyout, "-\n"); } |  
    ARITH MUL ARITH { fprintf(yyout, "*\n"); } | 
    ARITH DIV ARITH { fprintf(yyout, "/\n"); } | 
    PAREN_OP ARITH PAREN_CL 
    ;
FUNC_DEC: INT VAR PAREN_OP PARAM_LIST PAREN_CL SEMI_CL { fprintf(yyout, "function declaration:\n return type int"); } | 
        CHAR VAR PAREN_OP PARAM_LIST PAREN_CL SEMI_CL { fprintf(yyout, "function declaration:\n return type char *"); }
        ;
PARAM_LIST: INT VAR COMMA PARAM_LIST { fprintf(yyout, "function arguement: %s\n", $2); } | 
    CHAR VAR COMMA PARAM_LIST { fprintf(yyout, "function arguement: %s\n", $2); } | 
    INT VAR { fprintf(yyout, "function arguement: %s\n", $2); } | 
    CHAR VAR SQ_OP SQ_CL { fprintf(yyout, "function arguement: %s\n", $2); } |
; 
FUNCN: INT VAR PAREN_OP PARAM_LIST PAREN_CL CURL_OP FUNC_BODY CURL_CL { fprintf(yyout, "function body end\n"); } | 
       CHAR VAR PAREN_OP PARAM_LIST PAREN_CL CURL_OP FUNC_BODY CURL_CL { fprintf(yyout, "function body end\n"); }
       ;
FUNC_BODY: VAR_DEC FUNC_BODY | 
    INIT FUNC_BODY | 
    IF_STMT FUNC_BODY | 
    FOR_STMT FUNC_BODY | 
    WHILE_STMT FUNC_BODY | 
    FUNC_CALL SEMI_CL FUNC_BODY | 
    RET_STMT | 
;
COMP: COMP_OP COMP_CH COMP_OP { fprintf(yyout, "comparison\n"); } |
    BOOL { fprintf(yyout, "boolean: %s\n", $1); }
;
COMP_OP: ARITH |
    FUNC_CALL
;
COMP_CH: GE { fprintf(yyout, ">=\n"); } | 
    LE { fprintf(yyout, "<=\n"); } | 
    EQ { fprintf(yyout, "==\n"); } | 
    NEQ { fprintf(yyout, "!=\n"); } | 
    G { fprintf(yyout, ">\n"); } | 
    L { fprintf(yyout, "<\n"); } 
;

IF_STMT: IF PAREN_OP COMP PAREN_CL CURL_OP FUNC_BODY CURL_CL ELSE_STMT { fprintf(yyout, "if/if-else statement end\n\n"); }
;
ELSE_STMT: ELSE CURL_OP FUNC_BODY CURL_CL { fprintf(yyout, "else statement end\n"); } | 
;
FOR_STMT: FOR PAREN_OP FOR_COMP PAREN_CL CURL_OP FUNC_BODY CURL_CL { fprintf(yyout, "for statement end\n"); }
;
FOR_COMP: INIT_FOR SEMI_CL COMP SEMI_CL UPDATE_FOR 
;
INIT_FOR: VAR ASSIGN ARITH  { fprintf(yyout, "for initialise: %s\n", $1); }
;
UPDATE_FOR: VAR ASSIGN ARITH  { fprintf(yyout, "for update: %s\n", $1); }
;
WHILE_STMT: WHILE PAREN_OP COMP PAREN_CL CURL_OP FUNC_BODY CURL_CL { fprintf(yyout, "while statement end\n"); }
;
FUNC_CALL : VAR PAREN_OP PARAMS PAREN_CL  { fprintf(yyout, "function call: %s\n ", $1); }
;
PARAMS: ARITH COMMA PARAMS | 
    ARITH  | 
    COMP COMMA PARAMS |
    COMP |
;
RET_STMT: RETURN ARITH SEMI_CL { fprintf(yyout, "return\n"); } | 
    RETURN COMP SEMI_CL { fprintf(yyout, "return\n"); } |
    RETURN STRING SEMI_CL { fprintf(yyout, "return %s\n", $2); }
;
%%

void yyerror(char *s) {
    fprintf(yyout, "Syntax Error\n");
    exit(0);
}

int main(int argc, char *argv[]) {
    yyin=fopen(argv[1], "r");
    lexout=fopen("Lexer.txt", "w");
    yyout=fopen("Parser.txt", "w");
    yyparse();
    return 0;
}