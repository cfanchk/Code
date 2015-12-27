#include "LinkedList.h"

Node::Node(int k, Node* p, Node* n) : key(k), prev(p), next(n){}

//�������캯�������������ṹ��Ա������new����������ռ䲢ʹ��memcpy������������
Node::Node(const Node& node)
{
	key = node.key;
	prev = node.prev;
	next = node.next;
}

//=���������أ����������ṹ��Ա������new����������ռ䲢ʹ��memcpy������������
Node& Node::operator=(const Node& node)
{
	key = node.key;
	prev = node.prev;
	next = node.next;
	return *this;
}

void Node::setPrev(Node* p){ prev = p; }

Node* Node::getPrev(){ return prev; }

void Node::setNext(Node* n){ next = n; }

Node* Node::getNext(){ return next; }

void Node::setKey(int k){ key = k; }

int Node::getKey(){ return key; }

//���������
LinkedList::LinkedList() : head(NULL){}

//�����������
LinkedList::~LinkedList()
{
	Node* temp;
	while (head != NULL)
	{
		temp = head;
		head = head->getNext();
		delete temp;
	}
}

//��ѯԪ�ز���
Node& LinkedList::Search(int k)
{
	Node* s = head;
	while (s != NULL && s->getKey() != k)
		s = s->getNext();
	if (s == NULL)
		throw 0;
	return *s;
}

//����Ԫ�ز���
void LinkedList::Insert(Node& node)
{
	Node* n=new Node(node);
	n->setNext(head);
	if (head != NULL)
		head->setPrev(n);
	head = n;
	n->setPrev(NULL);
}

//ɾ��Ԫ�ز���
void LinkedList::Delete(int key)
{
	Node* s = &(Search(key));
	if (s->getPrev() != NULL)
		s->getPrev()->setNext(s->getNext());
	else
		head = s->getNext();
	if (s->getNext() != NULL)
		s->getNext()->setPrev(s->getPrev());
	delete s;
}

//������������Ԫ�ز���
void LinkedList::visitAll()
{
	Node* temp = head;
	while (temp != NULL)
	{
		std::cout << temp->getKey() << std::endl;
		temp = temp->getNext();
	}
}