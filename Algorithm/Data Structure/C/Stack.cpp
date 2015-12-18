#include "Stack.h"

Node::Node() : key(0){}

Node::Node(int k) : key(k){}

//=操作符重载，若有其他结构成员利用memcpy等命令进行深拷贝
Node& Node::operator=(const Node& node)
{
	key = node.key;
	return *this;
}

//建栈操作
Stack::Stack(int size)
{
	stacksize = size;
	stackpoint = new Node[size];
	top = -1;
}

Stack::~Stack(){ delete[] stackpoint; }

//弹出栈顶元素操作
Node& Stack::Pop()
{
	if (isEmpty())
		throw 0;
	top--;
	return *(stackpoint + top + 1);
}

//元素压入栈操作
void Stack::Push(const Node& node)
{
	if (isFull())
		throw 1;
	top++;
	*(stackpoint + top) = node;
}

bool Stack::isEmpty(){ return top == -1; }

bool Stack::isFull(){ return top == stacksize - 1; }