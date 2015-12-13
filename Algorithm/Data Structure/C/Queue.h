//队列结构的数组实现
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

//队列类
class Queue
{
public:
	Queue(int);
	~Queue();
	Node* Dequeue();
	void Enqueue(Node*);
	bool isEmpty();
	bool isFull();
	void sub_copy(Node*);
private:
	int arraysize;
	Node* queuepoint;
	int head, tail;
};