//栈结构的数组实现
#include <iostream>

//节点类
class Node
{
public:
	Node();
	Node(int);
	void setKey(int);
	int getKey();
private:
	int key;
};

//栈类
class Stack
{
public:
	Stack(int);
	~Stack();
	Node* Pop();
	void Push(Node*);
	bool isEmpty();
	bool isFull();
	void sub_copy(Node*);
private:
	int stacksize;
	Node* stackpoint;
	int top;
};