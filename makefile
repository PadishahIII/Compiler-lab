target=lex
cfile=lex.yy.c
lfile=lexical.l
CC=gcc

$(target):$(cfile)
	$(CC) $^ -o $@ -lfl

$(cfile):$(lfile)
	flex $(lfile)