#include "tnode.h"
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

tnode a[10];
tnode a[10];

int b() { return 0; }
int main()
{
    return 1;
}