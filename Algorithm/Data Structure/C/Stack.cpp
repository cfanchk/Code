#include "Stack.h"

Node::Node() : key(0){}

Node::Node(int k) : key(k){}

//若节点需添加其他结构成员，需添加相应的set与get
void Node::setKey(int k){ key = k; }

int Node::getKey(){ return key; }

//建栈操作
Stack::Stack(int size)
{
	stacksize = size;
	stackpoint = new Node[size];
	top = -1;
}

Stack::~Stack(){ delete[] stackpoint; }

//弹出栈顶元素操作
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

//元素压入栈操作
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

//节点信息复制操作，若有其他结构成员需利用相应的set与get操作进行复制（注意深拷贝）
void Stack::sub_copy(Node* node)
{
	(stackpoint + top)->setKey(node->getKey());
}

bool Stack::isEmpty(){ return top == -1; }

bool Stack::isFull(){ return top == stacksize - 1; }