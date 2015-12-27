//哈希表实现（链接法，开放寻址法）
//需添加链表类文件（LinkedList.h/LinkedList.cpp）
//采用异常处理，抛出0为没有相应key的节点，抛出1为开放寻址法哈希表上溢，程序中应使用try,catch语句
#include <iostream>
#include "LinkedList.h"

//链接法哈希表类
class Hash_Chained
{
public:
	Hash_Chained(int);
	~Hash_Chained();
	void HashInsert(Node&);
	void HashDelete(Node&);
	Node& HashSearch(int);
private:
	int hashFunction(int);
	int size;
	LinkedList* ll;
};

//开放寻址法哈希表类，size应为质数
class Hash_OpenAddress
{
public:
	Hash_OpenAddress(int);
	~Hash_OpenAddress();
	void HashInsert(Node&);
	Node& HashSearch(int);
private:
	int hashFunction(int,int);
	int size;
	Node* hashpoint;
};