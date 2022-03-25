#include <stdarg.h>
#include <string.h>
#define LISTSIZE 1000
extern int yylineno;
extern char *yytext;

typedef struct tnode
{
    int num;          //在nodeList中的编号
    int lineno;       //节点所在行号
    char *type;       //节点类型
    tnode *leftchild; //左子树
    tnode *next;      //当前节点的兄弟链表
    union
    {
        char *ID_TYPE; // ID和TYPE类型的节点的属性为字符串
        int intval;
        float fltval;
    };
} * Tree, tnode;

/*  numOfChild个tnode
    num:根节点的序号
    申请单个节点:newTree("ID",num,0,lineno)
    申请两个节点:newTree("ID",num,2,&tnode1,&tnode2)
 */
Tree newTree(char *type, int num, int numOfChild, ...);

void Preorder(Tree rootNode, int level);

int nodeNum;               //节点数量
tnode *nodeList[LISTSIZE]; //存储所有节点
int IsChild[LISTSIZE];     // 1:nodeList[]中的对应节点不是根节点
