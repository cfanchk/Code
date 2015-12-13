#include "LinkedList.h"

Node::Node(int k, Node* p, Node* n) : key(k), prev(p), next(n){}

void Node::setPrev(Node* p){ prev = p; }

Node* Node::getPrev(){ return prev; }

void Node::setNext(Node* n){ next = n; }

Node* Node::getNext(){ return next; }

//���ڵ�����������ṹ��Ա���������Ӧ��set��get
void Node::setKey(int k){ key = k; }

int Node::getKey(){ return key; }

//���������
LinkedList::LinkedList() : head(NULL){}

//��ѯԪ�ز��������������ӦԪ��ָ��s
Node* LinkedList::Search(int k)
{
	Node* s = head;
	while (s != NULL && s->getKey() != k)
		s = s->getNext();
	return s;
}

//����Ԫ�ؼ�ֵ����
void LinkedList::Insert(Node* node)
{
	node->setNext(head);
	if (head != NULL)
		head->setPrev(node);
	head = node;
	node->setPrev(NULL);
}

//ɾ��Ԫ�ؼ�ֵ����
void LinkedList::Delete(int k)
{
	Node* s = Search(k);
	if (s == NULL)
	{
		std::cerr << "No Such Element!" << std::endl;
		return;
	}
	if (s->getPrev() != NULL)
		s->getPrev()->setNext(s->getNext());
	else
		head = s->getNext();
	if (s->getNext() != NULL)
		s->getNext()->setPrev(s->getPrev());
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