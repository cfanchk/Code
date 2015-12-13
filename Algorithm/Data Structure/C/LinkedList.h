//双向链表实现
#include <iostream>

//节点类
class Node
{
public:
	Node(int = 0, Node* = NULL, Node* = NULL);
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
	Node* Search(int);
	void Insert(Node*);
	void Delete(int);
	void visitAll();
private:
	Node* head;
};