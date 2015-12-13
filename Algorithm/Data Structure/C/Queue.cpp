#include "Queue.h"

Node::Node() : key(0){}

Node::Node(int k) : key(k){}

//若节点需添加其他结构成员，需添加相应的set与get
void Node::setKey(int k){ key = k; }

int Node::getKey(){ return key; }

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
Node* Queue::Dequeue()
{
	if (isEmpty())
	{
		std::cerr << "Error:Queue underflow!" << std::endl;
		return NULL;
	}
	int temp = head;
	if (head == arraysize - 1)
		head = 0;
	else
		head++;
	return queuepoint + temp;
}

//元素入队操作
void Queue::Enqueue(Node* node)
{
	if (isFull())
	{
		std::cerr << "Error:Queue overflow!" << std::endl;
		return;
	}
	sub_copy(node);
	if (tail == arraysize - 1)
		tail = 0;
	else
		tail++;
}

//节点信息复制操作，若有其他结构成员需利用相应的set与get操作进行复制（注意深拷贝）
void Queue::sub_copy(Node* node)
{
	(queuepoint + tail)->setKey(node->getKey());
}

bool Queue::isEmpty(){ return head == tail; }

bool Queue::isFull(){ return head == tail + 1 || head == 0 && tail == arraysize - 1; }