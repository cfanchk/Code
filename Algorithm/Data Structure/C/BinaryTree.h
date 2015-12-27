//����������ʵ��
//�����쳣�����׳�0Ϊû����Ӧkey�Ľڵ㣬�׳�1Ϊû����Ӧ��ǰ������̣��ڵ㣬������Ӧʹ��try,catch���
#include <iostream>

//�ڵ���
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

//������������
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