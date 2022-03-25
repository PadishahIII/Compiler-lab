%{
    #include "syntax.tab.h"
    #include "tnode.h"
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
{INT} {yylval.type_tree=newTree("INT",-1,0,yylloc.first_line); return INT;}
{FLOAT} {yylval.type_tree=newTree("FLOAT",-1,0,yylloc.first_line);return FLOAT;}
{SEMI} {yylval.type_tree=newTree("SEMI",-1,0,yylloc.first_line);return SEMI;}
{COMMA} {yylval.type_tree=newTree("COMMA",-1,0,yylloc.first_line);return COMMA;}
{ASSIGNOP} {yylval.type_tree=newTree("ASSIGNOP",-1,0,yylloc.first_line);return ASSIGNOP;}
{RELOP} {yylval.type_tree=newTree("RELOP",-1,0,yylloc.first_line);return RELOP;}
{PLUS} {yylval.type_tree=newTree("PLUS",-1,0,yylloc.first_line);return PLUS;}
{MINUS} {yylval.type_tree=newTree("MINUS",-1,0,yylloc.first_line);return MINUS;}
{STAR} {yylval.type_tree=newTree("STAR",-1,0,yylloc.first_line);return STAR;}
{DIV} {yylval.type_tree=newTree("DIV",-1,0,yylloc.first_line);return DIV;}
{AND} {yylval.type_tree=newTree("AND",-1,0,yylloc.first_line);return AND;}
{OR} {yylval.type_tree=newTree("OR",-1,0,yylloc.first_line);return OR;}
{DOT} {yylval.type_tree=newTree("DOT",-1,0,yylloc.first_line);return DOT;}
{NOT} {yylval.type_tree=newTree("NOT",-1,0,yylloc.first_line);return NOT;}
{TYPE} {yylval.type_tree=newTree("TYPE",-1,0,yylloc.first_line);return TYPE;}
{LP} {yylval.type_tree=newTree("LP",-1,0,yylloc.first_line);return LP;}
{RP} {yylval.type_tree=newTree("RP",-1,0,yylloc.first_line);return RP;}
{LB} {yylval.type_tree=newTree("LB",-1,0,yylloc.first_line);return LB;}
{RB} {yylval.type_tree=newTree("RB",-1,0,yylloc.first_line);return RB;}
{LC} {yylval.type_tree=newTree("LC",-1,0,yylloc.first_line);return LC;}
{RC} {yylval.type_tree=newTree("RC",-1,0,yylloc.first_line);return RC;}
{STRUCT} {yylval.type_tree=newTree("STRUCT",-1,0,yylloc.first_line);return STRUCT;}
{RETURN} {yylval.type_tree=newTree("RETURN",-1,0,yylloc.first_line);return RETURN;}
{IF} {yylval.type_tree=newTree("IF",-1,0,yylloc.first_line);return IF;}
{ELSE} {yylval.type_tree=newTree("ELSE",-1,0,yylloc.first_line);return ELSE;}
{WHILE} {yylval.type_tree=newTree("WHILE",-1,0,yylloc.first_line);return WHILE;}
{ID} {yylval.type_tree=newTree("ID",-1,0,yylloc.first_line);return ID;}
\n {yycolumn=1;}

. {printf("Error Type A at Line %d: Mysterious characters \'%s\'\n",yycolumn,yytext);}
%%

