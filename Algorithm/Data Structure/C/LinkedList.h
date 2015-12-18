//双向链表实现
#include <iostream>

//节点类
class Node
{
public:
	Node(int = 0, Node* = NULL, Node* = NULL);
	Node(const Node&);
	Node& operator=(const Node&);
	void setKey(int);
	int getKey();
	void setPrev(Node*);
	Node* getPrev();
	void setNext(Node*);
	Node* getNext();
private:
	int key;
	Node* prev;
	Node* next;
};

//队列类
class LinkedList
{
public:
	LinkedList();
	~LinkedList();
	Node* Search(int);
	void Insert(const Node&);
	void Delete(int);
	void visitAll();
private:
	Node* head;
};