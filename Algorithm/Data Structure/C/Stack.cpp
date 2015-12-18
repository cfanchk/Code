#include "Stack.h"

Node::Node() : key(0){}

Node::Node(int k) : key(k){}

//=���������أ����������ṹ��Ա����memcpy������������
Node& Node::operator=(const Node& node)
{
	key = node.key;
	return *this;
}

//��ջ����
Stack::Stack(int size)
{
	stacksize = size;
	stackpoint = new Node[size];
	top = -1;
}

Stack::~Stack(){ delete[] stackpoint; }

//����ջ��Ԫ�ز���
Node& Stack::Pop()
{
	if (isEmpty())
		throw 0;
	top--;
	return *(stackpoint + top + 1);
}

//Ԫ��ѹ��ջ����
void Stack::Push(const Node& node)
{
	if (isFull())
		throw 1;
	top++;
	*(stackpoint + top) = node;
}

bool Stack::isEmpty(){ return top == -1; }

bool Stack::isFull(){ return top == stacksize - 1; }