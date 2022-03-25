#include "tnode.h"
#include <stdio.h>

Tree newTree(char *type, int num, int numOfChild, ...)
{
    tnode rootNode = (tnode)malloc(sizeof(struct Tnode));
    tnode child;
    if (!rootNode)
    {
        yyerror("malloc tnode error");
        exit(-1);
    }
    rootNode->type = type;
    rootNode->num = num;
    rootNode->leftchild = rootNode->next = NULL;

    va_list param_list;
    va_start(param_list, numOfChild); //初始化参 数列表

    if (numOfChild > 0) //非终结符 union字段为空
    {
        child = va_arg(param_list, tnode);
        if (child->num >= 0)
            IsChild[child->num] = 1;
        rootNode->lineno = child->lineno;
        rootNode->leftchild = child;
        if (num >= 2)
        {
            for (int i = 0; i < numOfChild - 1; i++)
            {
                child->next = va_arg(param_list, tnode);
                child = child->next;
                if (child->num >= 0)
                    IsChild[child->num] = 1;
            }
        }
    }
    else
    { //终结符 或 空的语法单元
        rootNode->lineno = va_arg(param_list, int);
        if ((!strcmp(type, "ID")) || (!strcmp(type, "TYPE")))
        {
            char *str = (char *)malloc(strlen(yytext) + 2);
            memset(str, 0, strlen(yytext) + 2);
            strncpy(str, yytext, strlen(yytext) + 1);
            rootNode->ID_TYPE = str;
        }
        else if (!strcmp(type, "INT"))
        {
            rootNode->intval = atoi(yytext);
        }
        else if (!strcmp(type, "FLOAT"))
        {
            rootNode->fltval = atof(yytext);
        }
    }
    return rootNode;
}

void Preorder(Tree node, int level)
{
    if (node != NULL)
    {
        for (int i = 0; i < level; i++)
        {
            printf("  ");
        }
        if (node->lineno >= 0) //空语法单元的lineno为-1
        {
            printf("%s", node->type);
            if ((!strcmp(node->type, "ID")) || (!strcmp(node->type, "TYPE")))
            {
                printf(": %s", node->ID_TYPE);
            }
            else if (!strcmp(node->type, "INT"))
            {
                printf(": %d", node->intval);
            }
            else if (!strcmp(node->type, "FLOAT"))
            {
                printf(": %f", node->fltval);
            }
            else
            {
                printf(" (%d)", node->lineno);
            }
        }
        printf("\n");
        Preorder(node->leftchild, level + 1);
        Preorder(node->next, level);
    }
}
int Error = 0;
void yyerror(char *msg)
{
    Error = 1;
    fprintf(stderr, "Error Type B at Line %d : %s \'%s\'\n", yylineno, msg, yytext);
}
int main(int argc, char **argv)
{
    if (argc <= 1)
        return 0;
    FILE *file = fopen(argv[1], "r");
    if (!file)
    {
        perror(argv[1]);
        return 1;
    }
    nodeNum = 0;
    memset(nodeList, NULL, sizeof(tnode) * LISTSIZE);
    memset(IsChild, 0, sizeof(int) * LISTSIZE);
    Error = 0;

    yyrestart(file);
    // yydebug = 1;
    yyparse();
    fclose(file);

    if (Error)
        return 0;
    for (int i = 0; i < nodeNum; i++)
    {
        if (IsChild[i] != 1)
        {
            Preorder(nodeList[i], 0);
        }
    }
    return 0;
}
