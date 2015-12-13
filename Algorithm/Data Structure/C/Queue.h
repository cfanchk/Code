//���нṹ������ʵ��
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

//������
class Queue
{
public:
	Queue(int);
	~Queue();
	Node* Dequeue();
	void Enqueue(Node*);
	bool isEmpty();
	bool isFull();
	void sub_copy(Node*);
private:
	int arraysize;
	Node* queuepoint;
	int head, tail;
};