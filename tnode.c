#include "tnode.h"

Tree newTree(char *type, int num, int numOfChild, ...)
{
    tnode *rootNode = (tnode *)malloc(sizeof(tnode));
    tnode *child;
    if (!rootNode)
    {
        yyerror("malloc tnode error");
        exit(-1);
    }
    rootNode->type = type;
    rootNode->num = num;
    rootNode->leftchild = rootNode->next = NULL;

    va_list param_list;
    va_start(param_list, numOfChild); //初始化参数列表

    if (numOfChild > 0) //非终结符 union字段为空
    {
        child = va_arg(param_list, tnode *);
        IsChild[child->num] = 1;
        rootNode->lineno = child->lineno;
        rootNode->leftchild = child;
        if (num >= 2)
        {
            for (int i = 0; i < numOfChild - 1; i++)
            {
                child->next = va_arg(param_list, tnode *);
                child = child->next;
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
        else
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
        if (node->lineno >= 0)
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