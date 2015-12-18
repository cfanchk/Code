#include "LinkedList.h"

Node::Node(int k, Node* p, Node* n) : key(k), prev(p), next(n){}

//拷贝构造函数，若有其他结构成员，利用new操作符分配空间并使用memcpy等命令进行深拷贝
Node::Node(const Node& node)
{
	key = node.key;
}

//=操作符重载，若有其他结构成员，利用new操作符分配空间并使用memcpy等命令进行深拷贝
Node& Node::operator=(const Node& node)
{
	key = node.key;
	return *this;
}

void Node::setPrev(Node* p){ prev = p; }

Node* Node::getPrev(){ return prev; }

void Node::setNext(Node* n){ next = n; }

Node* Node::getNext(){ return next; }

void Node::setKey(int k){ key = k; }

int Node::getKey(){ return key; }

//建链表操作
LinkedList::LinkedList() : head(NULL){}

//析构链表操作
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

//查询元素操作，返回链表对应元素指针s
Node* LinkedList::Search(int k)
{
	Node* s = head;
	while (s != NULL && s->getKey() != k)
		s = s->getNext();
	return s;
}

//插入元素键值操作
void LinkedList::Insert(const Node& node)
{
	Node* n=new Node(node);
	n->setNext(head);
	if (head != NULL)
		head->setPrev(n);
	head = n;
	n->setPrev(NULL);
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
	delete s;
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