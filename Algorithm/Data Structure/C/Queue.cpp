#include "Queue.h"

Node::Node() : key(0){}

Node::Node(int k) : key(k){}

//=操作符重载，若有其他结构成员利用memcpy等命令进行深拷贝
Node& Node::operator=(const Node& node)
{
	key = node.key;
	return *this;
}

//建队列操作
Queue::Queue(int queuesize)
{
	arraysize = queuesize + 1;
	queuepoint = new Node[arraysize];
	head = 0;
	tail = 0;
}

Queue::~Queue(){ delete[] queuepoint; }

//元素出队操作
Node& Queue::Dequeue()
{
	if (isEmpty())
		throw 0;
	int temp = head;
	if (head == arraysize - 1)
		head = 0;
	else
		head++;
	return *(queuepoint + temp);
}

//元素入队操作
void Queue::Enqueue(const Node& node)
{
	if (isFull())
		throw 1;
	*(queuepoint + tail) = node;
	if (tail == arraysize - 1)
		tail = 0;
	else
		tail++;
}

bool Queue::isEmpty(){ return head == tail; }

bool Queue::isFull(){ return head == tail + 1 || head == 0 && tail == arraysize - 1; }