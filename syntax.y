%{
    //#define YYDEBUG 1
    #include "tnode.h"
%}

%union{
    int type_int;
    float type_float;
    double type_double;
    Tree type_tree;
}

%token <type_int> INT
%token <type_float> FLOAT
%token <type_tree> ID SEMI COMMA ASSIGNOP RELOP PLUS MINUS STAR DIV AND OR 
%token <type_tree> DOT NOT TYPE LP RP LB RB LC RC STRUCT RETURN IF ELSE WHILE

%type <type_tree> Program ExtDefList ExtDef ExtDecList Specifier StructSpecifier OptTag Tag VarDec FunDec VarList ParamDec CompSt StmtList Stmt DefList Def  DecList Dec Exp Args 

%left LP RP LB RB DOT
%right NOT
%left STAR DIV
%left PLUS MINUS
%left RELOP
%left AND OR 
%right ASSIGNOP 

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
/* High-level definitions */
Program:ExtDefList {$$=newTree("Program",nodeNum,1,$1);nodeList[nodeNum++]=$$;int useless=@1.first_line;}
ExtDefList: {$$=newTree("ExtDefList",nodeNum,0,-1);nodeList[nodeNum++]=$$;}
    | ExtDef ExtDefList {$$=newTree("ExtDefList",nodeNum,2,$1,$2);nodeList[nodeNum++]=$$;}
ExtDef: Specifier ExtDecList SEMI {$$=newTree("ExtDef",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    | Specifier SEMI {$$=newTree("ExtDef",nodeNum,2,$1,$2);nodeList[nodeNum++]=$$;}
    | Specifier FunDec CompSt {$$=newTree("ExtDef",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
ExtDecList: VarDec {$$=newTree("ExtDecList",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
    | VarDec COMMA ExtDecList {$$=newTree("ExtDecList",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}

/* Specifiers */
Specifier: TYPE {$$=newTree("Specifier",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
    | StructSpecifier {$$=newTree("Specifier",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
StructSpecifier: STRUCT OptTag LC DefList RC {$$=newTree("StructSpecifier",nodeNum,5,$1,$2,$3,$4,$5);nodeList[nodeNum++]=$$;}
    |STRUCT Tag {$$=newTree("StructSpecifier",nodeNum,2,$1,$2);nodeList[nodeNum++]=$$;}
OptTag: {$$=newTree("OptTag",nodeNum,0,-1);nodeList[nodeNum++]=$$;}
    |ID {$$=newTree("OptTag",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
Tag: ID {$$=newTree("Tag",nodeNum,1,$1);nodeList[nodeNum++]=$$;}

/* Declarators */
VarDec: ID {$$=newTree("VarDec",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
    | VarDec LB INT RB {$$=newTree("VarDec",nodeNum,4,$1,$2,$3,$4);nodeList[nodeNum++]=$$;}
FunDec: ID LP VarList RP {$$=newTree("FunDec",nodeNum,4,$1,$2,$3,$4);nodeList[nodeNum++]=$$;}
    | ID LP RP {$$=newTree("FunDec",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
VarList: ParamDec COMMA VarList {$$=newTree("VarList",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    | ParamDec {$$=newTree("VarList",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
ParamDec: Specifier VarDec {$$=newTree("ParamDec",nodeNum,2,$1,$2);nodeList[nodeNum++]=$$;}

/* Statements */
CompSt: LC DefList StmtList RC {$$=newTree("CompSt",nodeNum,4,$1,$2,$3,$4);nodeList[nodeNum++]=$$;}
StmtList: {$$=newTree("StmtList",nodeNum,0,-1);nodeList[nodeNum++]=$$;}
    |Stmt StmtList {$$=newTree("StmtList",nodeNum,2,$1,$2);nodeList[nodeNum++]=$$;}
Stmt: Exp SEMI {$$=newTree("Stmt",nodeNum,2,$1,$2);nodeList[nodeNum++]=$$;}
    | CompSt {$$=newTree("Stmt",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
    | RETURN Exp SEMI {$$=newTree("Stmt",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |IF LP Exp RP Stmt %prec LOWER_THAN_ELSE {$$=newTree("Stmt",nodeNum,5,$1,$2,$3,$4,$5);nodeList[nodeNum++]=$$;}
    | IF LP Exp RP Stmt ELSE Stmt {$$=newTree("Stmt",nodeNum,7,$1,$2,$3,$4,$5,$6,$7);nodeList[nodeNum++]=$$;}
    |WHILE LP Exp RP Stmt {$$=newTree("Stmt",nodeNum,5,$1,$2,$3,$4,$5);nodeList[nodeNum++]=$$;}

/* Local Definitions*/
DefList: {$$=newTree("DecList",nodeNum,0,-1);nodeList[nodeNum++]=$$;}
    | Def DefList {$$=newTree("DecList",nodeNum,2,$1,$2);nodeList[nodeNum++]=$$;}
Def: Specifier DecList SEMI {$$=newTree("Def",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
DecList:Dec {$$=newTree("DecList",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
    | Dec COMMA DecList {$$=newTree("DecList",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
Dec: VarDec {$$=newTree("Dec",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
    | VarDec ASSIGNOP Exp {$$=newTree("Dec",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}

/* Expressions */
Exp: Exp ASSIGNOP Exp {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    | Exp AND Exp {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |Exp OR Exp {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |Exp RELOP Exp {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |Exp PLUS Exp {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |Exp MINUS Exp {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |Exp STAR Exp {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |Exp DIV Exp {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |LP Exp RP {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |MINUS Exp {$$=newTree("Exp",nodeNum,2,$1,$2);nodeList[nodeNum++]=$$;}
    |NOT Exp {$$=newTree("Exp",nodeNum,2,$1,$2);nodeList[nodeNum++]=$$;}
    |ID LP Args RP {$$=newTree("Exp",nodeNum,4,$1,$2,$3,$4);nodeList[nodeNum++]=$$;}
    |ID LP RP {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |Exp LB Exp RB {$$=newTree("Exp",nodeNum,4,$1,$2,$3,$4);nodeList[nodeNum++]=$$;}
    |Exp DOT ID {$$=newTree("Exp",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |ID {$$=newTree("Exp",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
    |INT {$$=newTree("Exp",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
    |FLOAT {$$=newTree("Exp",nodeNum,1,$1);nodeList[nodeNum++]=$$;}
Args: Exp COMMA Args {$$=newTree("Args",nodeNum,3,$1,$2,$3);nodeList[nodeNum++]=$$;}
    |Exp {$$=newTree("Args",nodeNum,1,$1);nodeList[nodeNum++]=$$;}

%%
#include "lex.yy.c"



