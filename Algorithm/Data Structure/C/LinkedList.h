//˫������ʵ��
//keyΪ0�Ľڵ㶨��Ϊ��ʼ���ڵ㣬�ڵ㸳ֵʱ��Ҫ��0
//�����쳣�����׳�0Ϊû����Ӧkey�Ľڵ㣬������Ӧʹ��try,catch���
#include <iostream>

//�ڵ���
class Node
{
public:
	Node(int = 0, Node* = NULL, Node* = NULL);
	Node(const Node&);
	Node& operator=(const Node&);
	void setKey(int);
	int getKey();
	void setPrev(Node*);
	Node* getPrev();
	void setNext(Node*);
	Node* getNext();
private:
	int key;
	Node* prev;
	Node* next;
};

//������
class LinkedList
{
public:
	LinkedList();
	~LinkedList();
	Node& Search(int);
	void Insert(Node&);
	void Delete(int);
	void visitAll();
private:
	Node* head;
};