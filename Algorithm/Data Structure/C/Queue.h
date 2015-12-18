//队列结构的数组实现
//采用异常处理，抛出0为下溢，1为上溢，程序中应使用try,catch语句
#include <iostream>

//节点类
class Node
{
public:
	Node();
	Node(int);
	Node& operator=(const Node&);
private:
	int key;
};

//队列类
class Queue
{
public:
	Queue(int);
	~Queue();
	Node& Dequeue();
	void Enqueue(const Node&);
	bool isEmpty();
	bool isFull();
private:
	int arraysize;
	Node* queuepoint;
	int head, tail;
};