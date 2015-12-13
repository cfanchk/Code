//ջ�ṹ������ʵ��
#include <iostream>

//�ڵ���
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

//ջ��
class Stack
{
public:
	Stack(int);
	~Stack();
	Node* Pop();
	void Push(Node*);
	bool isEmpty();
	bool isFull();
	void sub_copy(Node*);
private:
	int stacksize;
	Node* stackpoint;
	int top;
};