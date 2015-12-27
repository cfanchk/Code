#include "BinaryTree.h"

Node::Node(int k, Node* l, Node* r, Node* p) : key(k), left(l), right(r), parent(p){}

//�������캯�������������ṹ��Ա��ʹ��memcpy������������
Node::Node(const Node& node)
{
	key = node.key;
	left = node.left;
	right = node.right;
	parent = node.parent;
}

//=���������أ����������ṹ��Ա��ʹ��memcpy������������
Node& Node::operator=(const Node& node)
{
	key = node.key;
	left = node.left;
	right = node.right;
	parent = node.parent;
	return *this;
}

void Node::setLeft(Node* l){ left = l; }

Node* Node::getLeft(){ return left; }

void Node::setRight(Node* r){ right = r; }

Node* Node::getRight(){ return right; }

void Node::setParent(Node* p){ parent = p; }

Node* Node::getParent(){ return parent; }

void Node::setKey(int k){ key = k; }

int Node::getKey(){ return key; }

//������������
BinaryTree::BinaryTree() : Treepoint(NULL){}

//��������������
BinaryTree::~BinaryTree(){ posterorderTreeWalkDelete(Treepoint); }

//�������������
void BinaryTree::TreeInsert(Node& node)
{
	Node* z = new Node(node);
	Node* y = NULL;
	Node* x = Treepoint;
	while (x != NULL)
	{
		y = x;
		if (z->getKey() < x->getKey())
			x = x->getLeft();
		else
			x = x->getRight();
	}
	z->setParent(y);
	if (y == NULL)
		Treepoint = z;
	else if (z->getKey() < y->getKey())
		y->setLeft(z);
	else
		y->setRight(z);
}

//������ɾ������
void BinaryTree::TreeDelete(int key)
{
	Node* z = &TreeSearch(key);
	if (z->getLeft() == NULL)
		transplant(z, z->getRight());
	else if (z->getRight() == NULL)
		transplant(z, z->getLeft());
	else
	{
		Node* y = &(TreeMinimum(z->getRight(), 0));
		if (y->getParent() != z)
		{
			transplant(y, y->getRight());
			y->setRight(z->getRight());
			y->getRight()->setParent(y);
		}
		transplant(z, y);
		y->setLeft(z->getLeft());
		y->getLeft()->setParent(y);
	}
	delete z;
}

//�����������������,isFirstCall����Ŀ�ģ���Ĭ�ϲ���ΪTreepoint����ͬ
void BinaryTree::InorderTreeWalk(Node* node, bool isFirstCall)
{
	if (isFirstCall == 1)
		node = Treepoint;
	if (node != NULL)
	{
		InorderTreeWalk(node->getLeft(), 0);
		std::cout << node->getKey() << std::endl;
		InorderTreeWalk(node->getRight(), 0);
	}
}

//��������ѯ����
Node& BinaryTree::TreeSearch(int key, Node* node, bool isFirstCall)
{
	if (isFirstCall == 1)
		node = Treepoint;
	if (node == NULL)
		throw 0;
	else if (key == node->getKey())
		return *(node);

	if (key < node->getKey())
		return TreeSearch(key, node->getLeft(), 0);
	else
		return TreeSearch(key, node->getRight(), 0);
}

//������ȡ��С�ؼ���Ԫ�ز�����isDefault����Ŀ�ģ���Ĭ�ϲ���ΪTreepoint����ͬ
Node& BinaryTree::TreeMinimum(Node* node, bool isDefault)
{
	Node* temp;
	if (isDefault == 1)
		temp = Treepoint;
	else
		temp = node;

	while (temp->getLeft() != NULL)
		temp = temp->getLeft();
	return *temp;
}

//������ȡ���ؼ���Ԫ�ز���
Node& BinaryTree::TreeMaximum(Node* node, bool isDefault)
{
	Node* temp;
	if (isDefault == 1)
		temp = Treepoint;
	else
		temp = node;

	while (temp->getRight() != NULL)
		temp = temp->getRight();
	return *temp;
}

//������ȡ���Ԫ�ز���
Node& BinaryTree::TreeSuccessor(int key)
{
	Node* x = &TreeSearch(key);
	if (x->getRight() != NULL)
		return TreeMinimum(x->getRight(), 0);
	Node* y = x->getParent();
	while (y != NULL && x == y->getRight())
	{
		x = y;
		y = y->getParent();
	}
	if (y == NULL)
		throw 1;
	return *y;
}

//������ȡǰ��Ԫ�ز���
Node& BinaryTree::TreePredecessor(int key)
{
	Node* x = &TreeSearch(key);
	if (x->getLeft() != NULL)
		return TreeMaximum(x->getLeft(), 0);
	Node* y = x->getParent();
	while (y != NULL && x == y->getLeft())
	{
		x = y;
		y = y->getParent();
	}
	if (y == NULL)
		throw 1;
	return *y;
}

//ɾ�������ƶ������ӳ���
void BinaryTree::transplant(Node* u, Node* v)
{
	if (u->getParent() == NULL)
		Treepoint = v;
	else if (u == u->getParent()->getLeft())
		u->getParent()->setLeft(v);
	else
		u->getParent()->setRight(v);
	if (v != NULL)
		v->setParent(u->getParent());
}

//��������������������������ӳ���
void BinaryTree::posterorderTreeWalkDelete(Node* node)
{
	if (node != NULL)
	{
		posterorderTreeWalkDelete(node->getLeft());
		posterorderTreeWalkDelete(node->getRight());
		delete node;
	}
}