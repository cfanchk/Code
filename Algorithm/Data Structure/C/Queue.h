//���нṹ������ʵ��
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

//������
class Queue
{
public:
	Queue(int);
	~Queue();
	Node& Dequeue();
	void Enqueue(const Node&);
	bool isEmpty();
	bool isFull();
private:
	int arraysize;
	Node* queuepoint;
	int head, tail;
};