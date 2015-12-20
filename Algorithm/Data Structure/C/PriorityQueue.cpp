#include "PriorityQueue.h"

Node::Node() :key(0){}

Node::Node(int k) : key(k){}

//�������캯�������������ṹ��Ա��ʹ��memcpy������������
Node::Node(const Node& node)
{
	key = node.key;
}

//=���������أ����������ṹ��Ա��ʹ��memcpy������������
Node& Node::operator=(const Node& node)
{
	key = node.key;
	return *this;
}

void Node::setKey(int k){ key = k; }

int Node::getKey(){ return key; }

//�����ȶ��в���
PriorityQueue::PriorityQueue(int maxsize)
{
	maxHeapsize=maxsize;
	PQpoint = new Node[maxHeapsize];
	heapsize = 0;
	isBuild = false;
}

PriorityQueue::~PriorityQueue(){ delete PQpoint; }

//������С�Ѳ�����ͨ��isBuild���ƽ���ִ��һ��
void PriorityQueue::BuildminHeap(const Node* npoint, int num)
{
	if (isBuild)
		throw - 1;
	else if (num > maxHeapsize)
		throw 1;

	heapsize = num;
	for (int i = 0; i < num; i++)
		*(PQpoint + i) = *(npoint + i);
	for (int i = (heapsize - 1) / 2; i >= 0; i--)
		minHeapify(i);
	isBuild = true;
}

//�ؼ��ּ�С����
void PriorityQueue::DecreaseKey(int i, int key)
{
	if (!isBuild)
		throw 0;
	else if (key > (PQpoint + i - 1)->getKey())
		throw 2;

	Node temp;
	i--;
	int p = (i + 1) / 2 - 1;
	(PQpoint + i)->setKey(key);
	while (i > 0 && (PQpoint + p)->getKey() > (PQpoint + i)->getKey())
	{
		temp = *(PQpoint + i);
		*(PQpoint + i) = *(PQpoint + p);
		*(PQpoint + p) = temp;
		i = p;
		p = (i + 1) / 2 - 1;
	}
}

//��С��ֵԪ����ȡ���������ȶ�����ɾ����
Node& PriorityQueue::ExtractMin()
{
	if (!isBuild)
		throw 0;
	Node temp;
	temp = *PQpoint;
	*PQpoint = *(PQpoint + heapsize - 1);
	*(PQpoint + heapsize - 1) = temp;
	heapsize--;
	if (heapsize > 0)
		minHeapify(0);
	return *(PQpoint + heapsize);
}

//���ȶ��в������
void PriorityQueue::InsertHeap(const Node& node)
{
	if (!isBuild)
		throw 0;
	else if (heapsize == maxHeapsize)
		throw 1;
	*(PQpoint + heapsize) = node;
	heapsize++;
	DecreaseKey(heapsize, (PQpoint + heapsize - 1)->getKey());
}

//��С��ֵԪ����ȡ����������ɾ����
Node& PriorityQueue::Minimum()
{
	if (!isBuild)
		throw 0;
	return *PQpoint;
}

//ά����С�������ӳ���
void PriorityQueue::minHeapify(int i)
{
	int l = 2 * (i + 1) - 1;
	int r = 2 * (i + 1);
	int smallest;
	Node temp;
	if (l < heapsize && (PQpoint + l)->getKey() < (PQpoint + i)->getKey())
		smallest = l;
	else
		smallest = i;
	if (r < heapsize && (PQpoint + r)->getKey() < (PQpoint + smallest)->getKey())
		smallest = r;
	if (smallest != i)
	{
		temp = *(PQpoint + i);
		*(PQpoint + i) = *(PQpoint + smallest);
		*(PQpoint + smallest) = temp;
		minHeapify(smallest);
	}
}