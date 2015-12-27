#include <stdlib.h>
#include <time.h>
#include "HashTable.h"

//建哈希表操作（下同）
Hash_Chained::Hash_Chained(int m)
{
	size = m;
	ll = new LinkedList[m];
}

//析构哈希表操作（下同）
Hash_Chained::~Hash_Chained(){ delete ll; }

//插入元素操作（下同）
void Hash_Chained::HashInsert(Node& node)
{
	LinkedList* temp=ll+hashFunction(node.getKey());
	temp->Insert(node);
}

//删除元素操作
void Hash_Chained::HashDelete(Node& node)
{
	LinkedList* temp = ll + hashFunction(node.getKey());
	temp->Delete(node.getKey());
}

//查询元素操作（下同）
Node& Hash_Chained::HashSearch(int key)
{
	LinkedList* temp = ll + hashFunction(key);
	return temp->Search(key);
}

//全域散列函数（下为双重散列函数）
int Hash_Chained::hashFunction(int key)
{
	srand((unsigned)time(NULL));    //产生伪随机数序列的种子，应放在主程序中
	static int p = 997;               //大于size的质数，在此取997
	static int a = rand() % (p - 1) + 1;
	static int b = rand() % p;
	return ((a*key + b) % p) % size;
}

Hash_OpenAddress::Hash_OpenAddress(int m)
{
	size = m;
	hashpoint = new Node[m];
}

Hash_OpenAddress::~Hash_OpenAddress(){ delete hashpoint; }

void Hash_OpenAddress::HashInsert(Node& node)
{
	int i, j;
	for (i = 0; i < size; i++)
	{
		j = hashFunction(node.getKey(), i);
		if ((hashpoint + j)->getKey() == 0)
		{
			*(hashpoint + j) = node;
			break;
		}
	}
	if (i == size)
		throw 1;
}

Node& Hash_OpenAddress::HashSearch(int key)
{
	int i, j;
	for (i = 0; i < size; i++)
	{
		j = hashFunction(key, i);
		if ((hashpoint + j)->getKey() == key)
			return *(hashpoint + j);
		if ((hashpoint + j)->getKey() == 0)
			break;
	}
	throw 0;
}

int Hash_OpenAddress::hashFunction(int key, int i)
{
	int h1 = key % size;
	int h2 = 1 + (key % (size - 1));
	return (h1 + i * h2) % size;
}