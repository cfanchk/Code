#include "LinkedList.h"

Node::Node(int k, Node* p, Node* n) : key(k), prev(p), next(n){}

void Node::setPrev(Node* p){ prev = p; }

Node* Node::getPrev(){ return prev; }

void Node::setNext(Node* n){ next = n; }

Node* Node::getNext(){ return next; }

//若节点需添加其他结构成员，需添加相应的set与get
void Node::setKey(int k){ key = k; }

int Node::getKey(){ return key; }

//建链表操作
LinkedList::LinkedList() : head(NULL){}

//查询元素操作，返回链表对应元素指针s
Node* LinkedList::Search(int k)
{
	Node* s = head;
	while (s != NULL && s->getKey() != k)
		s = s->getNext();
	return s;
}

//插入元素键值操作
void LinkedList::Insert(Node* node)
{
	node->setNext(head);
	if (head != NULL)
		head->setPrev(node);
	head = node;
	node->setPrev(NULL);
}

//删除元素键值操作
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

//访问链表所有元素操作
void LinkedList::visitAll()
{
	Node* temp = head;
	while (temp != NULL)
	{
		std::cout << temp->getKey() << std::endl;
		temp = temp->getNext();
	}
}