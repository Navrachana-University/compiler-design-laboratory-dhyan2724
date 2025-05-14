%{
#include "urdu.tab.h"
#include <string.h>
%}
%%
"متغیر"         { return VAR; }
"اگر"           { return IF; }
"تو"            { return THEN; }
"ورنہ"          { return ELSE; }
"ختم"           { return END; }
"دکھاؤ"         { return PRINT; }
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*   { yylval.str = strdup(yytext); return ID; }
"=="            { return EQ; }
"="             { return ASSIGN; }
\"[^\"]*\"      { 
    yytext[strlen(yytext)-1] = '\0';
    yylval.str = strdup(yytext+1);
    return STRING; 
}
";"             { return SEMI; }
[ \t\n]+        ;  // Skip whitespace
.               { return yytext[0]; }
%%
int yywrap() {
    return 1;
}