#include "Queue.h"

Node::Node() : key(0){}

Node::Node(int k) : key(k){}

//���ڵ�����������ṹ��Ա���������Ӧ��set��get
void Node::setKey(int k){ key = k; }

int Node::getKey(){ return key; }

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

//Ԫ����Ӳ���
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

//�ڵ���Ϣ���Ʋ��������������ṹ��Ա��������Ӧ��set��get�������и��ƣ�ע�������
void Queue::sub_copy(Node* node)
{
	(queuepoint + tail)->setKey(node->getKey());
}

bool Queue::isEmpty(){ return head == tail; }

bool Queue::isFull(){ return head == tail + 1 || head == 0 && tail == arraysize - 1; }