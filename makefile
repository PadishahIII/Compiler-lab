target=parser
cfile= syntax.tab.c tnode.c
CC=gcc

$(target):$(cfile)
	$(CC) $^ -o $@ -lfl 

syntax.tab.c syntax.tab.h:syntax.y lex.yy.c tnode.c tnode.h
	bison -d syntax.y

lex.yy.c:lexical.l makefile tnode.c tnode.h
	flex lexical.l
