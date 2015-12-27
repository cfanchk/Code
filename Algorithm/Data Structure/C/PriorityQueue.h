//优先队列的最小堆实现
//采用异常处理，抛出-1为多次构建堆，0为未构建堆，1为超出堆最大元素数，2为非法关键字减小操作，程序中应使用try,catch语句
#include <iostream>

//节点类
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

//优先队列类
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