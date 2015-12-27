//�����ʵ��
//�����쳣�����׳�0Ϊû����Ӧkey�Ľڵ㣬�׳�1Ϊû����Ӧ��ǰ������̣��ڵ㣬������Ӧʹ��try,catch���
#include <iostream>

//0�����ɫ��1�����ɫ
#define BLACK 0
#define RED 1

//�ڵ���
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

//�������
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