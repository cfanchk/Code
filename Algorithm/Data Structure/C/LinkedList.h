//双向链表实现
//key为0的节点定义为初始化节点，节点赋值时不要赋0
//采用异常处理，抛出0为没有相应key的节点，程序中应使用try,catch语句
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
	Node& Search(int);
	void Insert(Node&);
	void Delete(int);
	void visitAll();
private:
	Node* head;
};