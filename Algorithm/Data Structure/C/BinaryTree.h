//二叉搜索树实现
//采用异常处理，抛出0为没有相应key的节点，抛出1为没有相应的前驱（后继）节点，程序中应使用try,catch语句
#include <iostream>

//节点类
class Node
{
public:
	Node(int = 0, Node* = NULL, Node* = NULL, Node* = NULL);
	Node(const Node&);
	Node& operator=(const Node&);
	void setKey(int);
	int getKey();
	void setLeft(Node*);
	Node* getLeft();
	void setRight(Node*);
	Node* getRight();
	void setParent(Node*);
	Node* getParent();
private:
	int key;
	Node* left;
	Node* right;
	Node* parent;
};

//二叉搜索树类
class BinaryTree
{
public:
	BinaryTree();
	~BinaryTree();
	void TreeInsert(Node&);
	void TreeDelete(int);
	void InorderTreeWalk(Node* = NULL, bool = 1);
	Node& TreeSearch(int, Node* = NULL, bool = 1);
	Node& TreeMinimum(Node* = NULL, bool = 1);
	Node& TreeMaximum(Node* = NULL, bool = 1);
	Node& TreeSuccessor(int);
	Node& TreePredecessor(int);
private:
	void transplant(Node*, Node*);
	void posterorderTreeWalkDelete(Node*);
	Node* Treepoint;
};