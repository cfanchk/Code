//红黑树实现
//采用异常处理，抛出0为没有相应key的节点，抛出1为没有相应的前驱（后继）节点，程序中应使用try,catch语句
#include <iostream>

//0代表黑色，1代表红色
#define BLACK 0
#define RED 1

//节点类
class Node
{
public:
	Node(int = 0, bool = BLACK, Node* = NULL, Node* = NULL, Node* = NULL);
	Node(const Node&);
	Node& operator=(const Node&);
	void setKey(int);
	int getKey();
	void setColour(bool c);
	bool getColour();
	void setLeft(Node*);
	Node* getLeft();
	void setRight(Node*);
	Node* getRight();
	void setParent(Node*);
	Node* getParent();
private:
	int key;
	bool colour;
	Node* left;
	Node* right;
	Node* parent;
};

//红黑树类
class RBTree
{
public:
	RBTree();
	~RBTree();
	void TreeInsert(Node&);
	void TreeDelete(int);
	void InorderTreeWalk(Node* = NULL, bool = 1);
	Node& TreeSearch(int, Node* = NULL, bool = 1);
	Node& TreeMinimum(Node* = NULL, bool = 1);
	Node& TreeMaximum(Node* = NULL, bool = 1);
	Node& TreeSuccessor(int);
	Node& TreePredecessor(int);
private:
	void leftRotate(Node*);
	void rightRotate(Node*);
	void insertFixup(Node*);
	void transplant(Node*, Node*);
	void deleteFixup(Node*);
	void posterorderTreeWalkDelete(Node*);
	Node* Treepoint;
	Node* NIL;
};