//���ȶ��е���С��ʵ��
//�����쳣�����׳�-1Ϊ��ι����ѣ�0Ϊδ�����ѣ�1Ϊ���������Ԫ������2Ϊ�Ƿ��ؼ��ּ�С������������Ӧʹ��try,catch���
#include <iostream>

//�ڵ���
class Node
{
public:
	Node(int = 0);
	Node(const Node&);
	Node& operator=(const Node&);
	void setKey(int);
	int getKey();
private:
	int key;
};

//���ȶ�����
class PriorityQueue
{
public:
	PriorityQueue(int);
	~PriorityQueue();
	void BuildminHeap(const Node*, int);
	void DecreaseKey(int, int);
	Node& ExtractMin();
	void InsertHeap(const Node&);
	Node& Minimum();
private:
	void minHeapify(int);
	int maxHeapsize;
	Node* PQpoint;
	int heapsize;
	bool isBuild;
};