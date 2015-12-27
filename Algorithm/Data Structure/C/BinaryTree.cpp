#include "BinaryTree.h"

Node::Node(int k, Node* l, Node* r, Node* p) : key(k), left(l), right(r), parent(p){}

//拷贝构造函数，若有其他结构成员，使用memcpy等命令进行深拷贝
Node::Node(const Node& node)
{
	key = node.key;
	left = node.left;
	right = node.right;
	parent = node.parent;
}

//=操作符重载，若有其他结构成员，使用memcpy等命令进行深拷贝
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

//建二叉树操作
BinaryTree::BinaryTree() : Treepoint(NULL){}

//析构二叉树操作
BinaryTree::~BinaryTree(){ posterorderTreeWalkDelete(Treepoint); }

//二叉树插入操作
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

//二叉树删除操作
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

//二叉树中序遍历操作,isFirstCall变量目的：令默认参数为Treepoint，下同
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

//二叉树查询操作
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

//二叉树取最小关键字元素操作，isDefault变量目的：令默认参数为Treepoint，下同
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

//二叉树取最大关键字元素操作
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

//二叉树取后继元素操作
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

//二叉树取前驱元素操作
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

//删除操作移动子树子程序
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

//二叉树析构操作后序遍历析构子程序
void BinaryTree::posterorderTreeWalkDelete(Node* node)
{
	if (node != NULL)
	{
		posterorderTreeWalkDelete(node->getLeft());
		posterorderTreeWalkDelete(node->getRight());
		delete node;
	}
}