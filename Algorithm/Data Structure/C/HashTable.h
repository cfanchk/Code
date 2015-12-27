//��ϣ��ʵ�֣����ӷ�������Ѱַ����
//������������ļ���LinkedList.h/LinkedList.cpp��
//�����쳣�����׳�0Ϊû����Ӧkey�Ľڵ㣬�׳�1Ϊ����Ѱַ����ϣ�����磬������Ӧʹ��try,catch���
#include <iostream>
#include "LinkedList.h"

//���ӷ���ϣ����
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

//����Ѱַ����ϣ���࣬sizeӦΪ����
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