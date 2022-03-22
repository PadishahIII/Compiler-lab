


INT 0 | [1-9][0-9]{1,31} | 0[0-7]{1,32} | 0[x|X][0-9a-fA-F]{1,32}
FLOAT [0-9]+\.[0-9]+ | ([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)[e|E][+|-]?[0-9]+
ID [_a-zA-Z]+[_a-zA-Z0-9]{0,31}
SEMI ;
COMMA ,
ASSIGNOP =
RELOP > | < | >= | <= | == |!=
PLUS +
MINUS -
STAR \*
DIV /
AND &&
OR ||
DOT .
NOT !
TYPE int | float
LP \(
RP \)
LB \[
RB \]
LC \{
RC \}
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while

%%

{STAR} {printf("star");}
{LP} {printf("LP");}
{LB} {printf("LB");}
{LC} {printf("LC");}
{STRUCT} {printf("STRUCT");}
{DOT} {printf("DOT");}

. {printf("Error Type A ");}
%%

int main(int argc,char** argv){
    yylex();

    return 0;
}

