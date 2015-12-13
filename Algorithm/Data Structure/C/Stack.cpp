#include "Stack.h"

Node::Node() : key(0){}

Node::Node(int k) : key(k){}

//���ڵ�����������ṹ��Ա���������Ӧ��set��get
void Node::setKey(int k){ key = k; }

int Node::getKey(){ return key; }

//��ջ����
Stack::Stack(int size)
{
	stacksize = size;
	stackpoint = new Node[size];
	top = -1;
}

Stack::~Stack(){ delete[] stackpoint; }

//����ջ��Ԫ�ز���
Node* Stack::Pop()
{
	if (isEmpty())
	{
		std::cerr << "Error:Stack underflow!" << std::endl;
		return NULL;
	}
	top--;
	return stackpoint + top + 1;
}

//Ԫ��ѹ��ջ����
void Stack::Push(Node* node)
{
	if (isFull())
	{
		std::cerr << "Error:Stack overflow!" << std::endl;
		return;
	}
	top++;
	sub_copy(node);
}

//�ڵ���Ϣ���Ʋ��������������ṹ��Ա��������Ӧ��set��get�������и��ƣ�ע�������
void Stack::sub_copy(Node* node)
{
	(stackpoint + top)->setKey(node->getKey());
}

bool Stack::isEmpty(){ return top == -1; }

bool Stack::isFull(){ return top == stacksize - 1; }