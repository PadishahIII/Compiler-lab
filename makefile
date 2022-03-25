target=parser
cfile=main.c syntax.tab.c 
CC=gcc

$(target):$(cfile)
	$(CC) $^ -o $@ -lfl

syntax.tab.c syntax.tab.h:syntax.y lex.yy.c 
	bison -d syntax.y

lex.yy.c:lexical.l makefile
	flex lexical.l
