#include "Queue.h"

Node::Node() : key(0){}

Node::Node(int k) : key(k){}

//=���������أ����������ṹ��Ա����memcpy������������
Node& Node::operator=(const Node& node)
{
	key = node.key;
	return *this;
}

//�����в���
Queue::Queue(int queuesize)
{
	arraysize = queuesize + 1;
	queuepoint = new Node[arraysize];
	head = 0;
	tail = 0;
}

Queue::~Queue(){ delete[] queuepoint; }

//Ԫ�س��Ӳ���
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

//Ԫ����Ӳ���
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