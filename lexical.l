%{
    #include "syntax.tab.h"
    int yycolumn = 1;
    #define YY_USER_ACTION \
        yylloc.first_line=yylloc.last_line=yycolumn;\
        yylloc.first_column = yycolumn;\
        yylloc.last_column =  yycolumn+yyleng-1;\
        yycolumn+=yyleng;
%}


INT 0|[1-9][0-9]{0,31}|0[0-7]{1,32}|0[xX][0-9a-fA-F]{1,32}|0b[01]{1,32}
FLOAT [0-9]+\.[0-9]+|([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)[eE][\+\-]?[0-9]+
ID [_a-zA-Z]+[_a-zA-Z0-9]{0,31}
SEMI ";"
COMMA ","
ASSIGNOP "="
RELOP >|<|>=|<=|==|!=
PLUS "+"
MINUS "-"
STAR "*"
DIV "/"
AND "&&"
OR "||"
DOT "."
NOT "!"
TYPE "int"|"float"
LP "("
RP ")"
LB "["
RB "]"
LC "{"
RC "}"
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while

COMMENT ("//".*\n?)|("/*"([*]*(([^*/])+([/])*)*)*"*/")
SPACE [ \f\r\t\v]+

%%

{COMMENT} {}
{SPACE} {}
{INT} {return INT;}
{FLOAT} {return FLOAT;}
{SEMI} {return SEMI;}
{COMMA} {return COMMA;}
{ASSIGNOP} {return ASSIGNOP;}
{RELOP} {return RELOP;}
{PLUS} {return PLUS;}
{MINUS} {return MINUS;}
{STAR} {return STAR;}
{DIV} {return DIV;}
{AND} {return AND;}
{OR} {return OR;}
{DOT} {return DOT;}
{NOT} {return NOT;}
{TYPE} {return TYPE;}
{LP} {return LP;}
{RP} {return RP;}
{LB} {return LB;}
{RB} {return RB;}
{LC} {return LC;}
{RC} {return RC;}
{STRUCT} {return STRUCT;}
{RETURN} {return RETURN;}
{IF} {return IF;}
{ELSE} {return ELSE;}
{WHILE} {return WHILE;}
{ID} {return ID;}
\n {yycolumn=1;}

. {printf("Error Type A at Line %d: Mysterious characters \'%s\'\n",yycolumn,yytext);}
%%

