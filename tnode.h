//#pragma once
#ifndef TNODE_H
#define TNODE_H

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define LISTSIZE 1000

extern int yylineno;
extern char *yytext;
void yyerror(char *msg);

typedef struct Tnode
{
    int num;                 //在nodeList中的编号,终结符的num为-1
    int lineno;              //节点所在行号
    char *type;              //节点类型
    struct Tnode *leftchild; //左子树
    struct Tnode *next;      //当前节点的兄弟 链表
    union
    {
        char *ID_TYPE; // ID和TYPE类型的节点的属性为字符串
        int intval;
        float fltval;
    };
} * Tree, *tnode;
// typedef struct Tnode *Tree;
// typedef struct Tnode tnode;

/*  numOfChild个tnode
    num:根节点的序号
    申请单个节点(叶节点):newTree("ID",-1,0,lineno)  属性由yytext确定
    申请两个节点:newTree("ID",num,2,tnode1,tnode2)
 */
Tree newTree(char *type, int num, int numOfChild, ...);

void Preorder(Tree rootNode, int level);

extern int nodeNum; //节点数量
/*  nodeList和IsChild的作用是在建好语法树之后寻找根节点（因为是从下向上建立），不用存储叶节点
 */
extern tnode nodeList[LISTSIZE]; //存储所有非叶节点
extern int IsChild[LISTSIZE];    // 1:nodeList[]中的对应节点不是根节点

#endif