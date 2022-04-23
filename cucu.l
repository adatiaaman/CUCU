%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "cucu.tab.h"

    FILE* lexout;
%}

%%
int                     { fprintf(lexout, "TYPE : %s\n", yytext); return INT; }
char[ ]\*               { fprintf(lexout, "TYPE : %s\n", yytext); return CHAR; }
if                      { fprintf(lexout, "COND_ST : %s\n", yytext); return IF; }
else                    { fprintf(lexout, "COND_ST : %s\n", yytext); return ELSE; }
for                     { fprintf(lexout, "COND_ST : %s\n", yytext); return FOR; }
while                   { fprintf(lexout, "COND_ST : %s\n", yytext); return WHILE; }
true|false              { 
            fprintf(lexout, "BOOL : %s\n", yytext); 
            yylval.string = strdup(yytext);
            return BOOL; 
        }
return                  { fprintf(lexout, "RETURN : %s\n", yytext); return RETURN; }
[ \t\n]+                ;
[a-zA-Z_][a-zA-Z0-9_]*  { 
            fprintf(lexout, "ID : %s\n", yytext); 
            yylval.string = strdup(yytext);
            return VAR; 
        }
[0-9]+                  { 
            fprintf(lexout, "NUM : %s\n", yytext); 
            yylval.number = atoi(yytext);
            return INTEGER;
        }
\"[a-zA-Z0-9 ]*\"       { 
            fprintf(lexout, "STRING : "); 
            for(int i=1; i<yyleng-1; i++) { 
                fprintf(lexout, "%c", yytext[i]); 
            } 
            fprintf(lexout, "\n");
            yylval.string = strdup(yytext);
            return STRING;
        }
";"                     { fprintf(lexout, "SEMI : %s\n", yytext); return SEMI_CL; }
"="                     { fprintf(lexout, "ASSIGN : %s\n", yytext); return ASSIGN; }
"=="                    { fprintf(lexout, "EQUAL : %s\n", yytext); return EQ; }
"!="                    { fprintf(lexout, "NOT EQUAL : %s\n", yytext); return NEQ; }
">"                     { fprintf(lexout, "GREATER : %s\n", yytext); return G; }
">="                    { fprintf(lexout, "GREATER_EQ : %s\n", yytext); return GE; }
"<"                     { fprintf(lexout, "LESS : %s\n", yytext); return L; }
"<="                    { fprintf(lexout, "LESS_EQ : %s\n", yytext); return LE; }
"("                     { fprintf(lexout, "PAREN_OP : %s\n", yytext); return PAREN_OP; }
")"                     { fprintf(lexout, "PAREN_CL : %s\n", yytext); return PAREN_CL; }
"{"                     { fprintf(lexout, "CURL_OP : %s\n", yytext); return CURL_OP; }
"}"                     { fprintf(lexout, "CURL_CL : %s\n", yytext); return CURL_CL; }
"["                     { fprintf(lexout, "SQ_OP : %s\n", yytext); return SQ_OP; }
"]"                     { fprintf(lexout, "SQ_CL : %s\n", yytext); return SQ_CL; }
"+"                     { fprintf(lexout, "PLUS : %s\n", yytext); return ADD; }
"-"                     { fprintf(lexout, "MINUS : %s\n", yytext); return SUB; }
"*"                     { fprintf(lexout, "MULTIPLY : %s\n", yytext); return MUL; }
"/"                     { fprintf(lexout, "DIVISION : %s\n", yytext); return DIV; }
","                     { return COMMA; }
\/\/.*                           ;
\/\*[^*]*[*]+([^/][^*]*[*]+)*\/  ;
%%

int yywrap(void) {
    return 1;
}
