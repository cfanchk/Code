#include <stdlib.h>
#include <time.h>
#include "HashTable.h"

//����ϣ���������ͬ��
Hash_Chained::Hash_Chained(int m)
{
	size = m;
	ll = new LinkedList[m];
}

//������ϣ���������ͬ��
Hash_Chained::~Hash_Chained(){ delete ll; }

//����Ԫ�ز�������ͬ��
void Hash_Chained::HashInsert(Node& node)
{
	LinkedList* temp=ll+hashFunction(node.getKey());
	temp->Insert(node);
}

//ɾ��Ԫ�ز���
void Hash_Chained::HashDelete(Node& node)
{
	LinkedList* temp = ll + hashFunction(node.getKey());
	temp->Delete(node.getKey());
}

//��ѯԪ�ز�������ͬ��
Node& Hash_Chained::HashSearch(int key)
{
	LinkedList* temp = ll + hashFunction(key);
	return temp->Search(key);
}

//ȫ��ɢ�к�������Ϊ˫��ɢ�к�����
int Hash_Chained::hashFunction(int key)
{
	srand((unsigned)time(NULL));    //����α��������е����ӣ�Ӧ������������
	static int p = 997;               //����size���������ڴ�ȡ997
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