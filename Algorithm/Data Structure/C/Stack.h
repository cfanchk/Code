//ջ�ṹ������ʵ��
//�����쳣�����׳�0Ϊ���磬1Ϊ���磬������Ӧʹ��try,catch���
#include <iostream>

//�ڵ���
class Node
{
public:
	Node();
	Node(int);
	Node& operator=(const Node&);
private:
	int key;
};

//ջ��
class Stack
{
public:
	Stack(int);
	~Stack();
	Node& Pop();
	void Push(const Node&);
	bool isEmpty();
	bool isFull();
private:
	int stacksize;
	Node* stackpoint;
	int top;
};