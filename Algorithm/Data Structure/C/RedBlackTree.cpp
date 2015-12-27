#include "RedBlackTree.h"

Node::Node(int k, bool c, Node* l, Node* r, Node* p) : key(k), colour(c), left(l), right(r), parent(p){}

//拷贝构造函数，若有其他结构成员，使用memcpy等命令进行深拷贝
Node::Node(const Node& node)
{
	key = node.key;
	colour = node.colour;
	left = node.left;
	right = node.right;
	parent = node.parent;
}

//=操作符重载，若有其他结构成员，使用memcpy等命令进行深拷贝
Node& Node::operator=(const Node& node)
{
	key = node.key;
	colour = node.colour;
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

void Node::setColour(bool c){ colour = c; }

bool Node::getColour(){ return colour; }

//建红黑树操作
RBTree::RBTree()
{
	NIL = new Node;
	Treepoint = NIL;
}

//析构红黑树操作
RBTree::~RBTree()
{ 
	posterorderTreeWalkDelete(Treepoint); 
	delete NIL;
}

//红黑树插入操作
void RBTree::TreeInsert(Node& node)
{
	Node* z = new Node(node);
	Node* y = NIL;
	Node* x = Treepoint;
	while (x != NIL)
	{
		y = x;
		if (z->getKey() < x->getKey())
			x = x->getLeft();
		else
			x = x->getRight();
	}
	z->setParent(y);
	if (y == NIL)
		Treepoint = z;
	else if (z->getKey() < y->getKey())
		y->setLeft(z);
	else
		y->setRight(z);
	z->setLeft(NIL);
	z->setRight(NIL);
	z->setColour(RED);
	insertFixup(z);
}

//红黑树删除操作
void RBTree::TreeDelete(int key)
{
	Node* z = &TreeSearch(key);
	Node* y = z;
	Node* x;
	bool y_original_colour = y->getColour();

	if (z->getLeft() == NIL)
	{
		x = z->getRight();
		transplant(z, z->getRight());
	}
	else if (z->getRight() == NIL)
	{
		x = z->getLeft();
		transplant(z, z->getLeft());
	}
	else
	{
		y = &(TreeMinimum(z->getRight(), 0));
		y_original_colour = y->getColour();
		x = y->getRight();
		if (y->getParent() == z)
			x->setParent(y);
		else
		{
			transplant(y, y->getRight());
			y->setRight(z->getRight());
			y->getRight()->setParent(y);
		}
		transplant(z, y);
		y->setLeft(z->getLeft());
		y->getLeft()->setParent(y);
		y->setColour(z->getColour());
	}
	if (y_original_colour == BLACK)
		deleteFixup(x);
	delete z;
}

//红黑树中序遍历操作,isFirstCall变量目的：令默认参数为Treepoint，下同
void RBTree::InorderTreeWalk(Node* node, bool isFirstCall)
{
	if (isFirstCall == 1)
		node = Treepoint;
	if (node != NIL)
	{
		InorderTreeWalk(node->getLeft(), 0);
		std::cout << node->getKey() << std::endl;
		InorderTreeWalk(node->getRight(), 0);
	}
}

//红黑树查询操作
Node& RBTree::TreeSearch(int key, Node* node, bool isFirstCall)
{
	if (isFirstCall == 1)
		node = Treepoint;
	if (node == NIL)
		throw 0;
	else if (key == node->getKey())
		return *(node);

	if (key < node->getKey())
		return TreeSearch(key, node->getLeft(), 0);
	else
		return TreeSearch(key, node->getRight(), 0);
}

//红黑树取最小关键字元素操作，isDefault变量目的：令默认参数为Treepoint，下同
Node& RBTree::TreeMinimum(Node* node, bool isDefault)
{
	Node* temp;
	if (isDefault == 1)
		temp = Treepoint;
	else
		temp = node;

	while (temp->getLeft() != NIL)
		temp = temp->getLeft();
	return *temp;
}

//红黑树取最大关键字元素操作
Node& RBTree::TreeMaximum(Node* node, bool isDefault)
{
	Node* temp;
	if (isDefault == 1)
		temp = Treepoint;
	else
		temp = node;

	while (temp->getRight() != NIL)
		temp = temp->getRight();
	return *temp;
}

//红黑树取后继元素操作
Node& RBTree::TreeSuccessor(int key)
{
	Node* x = &TreeSearch(key);
	if (x->getRight() != NIL)
		return TreeMinimum(x->getRight(), 0);
	Node* y = x->getParent();
	while (y != NIL && x == y->getRight())
	{
		x = y;
		y = y->getParent();
	}
	if (y == NIL)
		throw 1;
	return *y;
}

//红黑树取前驱元素操作
Node& RBTree::TreePredecessor(int key)
{
	Node* x = &TreeSearch(key);
	if (x->getLeft() != NIL)
		return TreeMaximum(x->getLeft(), 0);
	Node* y = x->getParent();
	while (y != NIL && x == y->getLeft())
	{
		x = y;
		y = y->getParent();
	}
	if (y == NIL)
		throw 1;
	return *y;
}

//二叉树左旋子程序
void RBTree::leftRotate(Node* x)
{
	Node* y = x->getRight();
	x->setRight(y->getLeft());
	if (y->getLeft() != NIL)
		y->getLeft()->setParent(x);
	y->setParent(x->getParent());
	if (x->getParent() == NIL)
		Treepoint = y;
	else if (x == x->getParent()->getLeft())
		x->getParent()->setLeft(y);
	else
		x->getParent()->setRight(y);
	y->setLeft(x);
	x->setParent(y);
}

//二叉树右旋子程序
void RBTree::rightRotate(Node* y)
{
	Node* x = y->getLeft();
	y->setLeft(x->getRight());
	if (x->getRight() != NIL)
		x->getRight()->setParent(y);
	x->setParent(y->getParent());
	if (y->getParent() == NIL)
		Treepoint = x;
	else if (y == y->getParent()->getLeft())
		y->getParent()->setLeft(x);
	else
		y->getParent()->setRight(x);
	x->setRight(y);
	y->setParent(x);
}

//插入操作保持红黑性质子程序
void RBTree::insertFixup(Node* z)
{
	Node* y;
	while (z->getParent()->getColour() == RED)
	{
		if (z->getParent() == z->getParent()->getParent()->getLeft())
		{
			y = z->getParent()->getParent()->getRight();
			if (y->getColour() == RED)
			{
				z->getParent()->setColour(BLACK);
				y->setColour(BLACK);
				z->getParent()->getParent()->setColour(RED);
				z = z->getParent()->getParent();
			}
			else
			{
				if (z == z->getParent()->getRight())
				{
					z = z->getParent();
					leftRotate(z);
				}
				z->getParent()->setColour(BLACK);
				z->getParent()->getParent()->setColour(RED);
				rightRotate(z->getParent()->getParent());
			}
		}
		else
		{
			y = z->getParent()->getParent()->getLeft();
			if (y->getColour() == RED)
			{
				z->getParent()->setColour(BLACK);
				y->setColour(BLACK);
				z->getParent()->getParent()->setColour(RED);
				z = z->getParent()->getParent();
			}
			else
			{
				if (z == z->getParent()->getLeft())
				{
					z = z->getParent();
					rightRotate(z);
				}
				z->getParent()->setColour(BLACK);
				z->getParent()->getParent()->setColour(RED);
				leftRotate(z->getParent()->getParent());
			}
		}
	}
	Treepoint->setColour(BLACK);
}

//删除操作移动子树子程序
void RBTree::transplant(Node* u, Node* v)
{
	if (u->getParent() == NIL)
		Treepoint = v;
	else if (u == u->getParent()->getLeft())
		u->getParent()->setLeft(v);
	else
		u->getParent()->setRight(v);
	v->setParent(u->getParent());
}

//删除操作保持红黑性质子程序
void RBTree::deleteFixup(Node* x)
{
	Node* w;
	while (x != Treepoint && x->getColour() == BLACK)
	{
		if (x == x->getParent()->getLeft())
		{
			w = x->getParent()->getRight();
			if (w->getColour() == RED)
			{
				w->setColour(BLACK);
				x->getParent()->setColour(RED);
				leftRotate(x->getParent());
				w = x->getParent()->getRight();
			}
			if (w->getLeft()->getColour() == BLACK && w->getRight()->getColour() == BLACK)
			{
				w->setColour(RED);
				x = x->getParent();
			}
			else if (w->getRight()->getColour() == BLACK)
			{
				w->getLeft()->setColour(BLACK);
				w->setColour(RED);
				rightRotate(w);
				w = x->getParent()->getRight();
			}
			w->setColour(x->getParent()->getColour());
			x->getParent()->setColour(BLACK);
			w->getRight()->setColour(BLACK);
			leftRotate(x->getParent());
			x = Treepoint;
		}
		else
		{
			w = x->getParent()->getLeft();
			if (w->getColour() == RED)
			{
				w->setColour(BLACK);
				x->getParent()->setColour(RED);
				rightRotate(x->getParent());
				w = x->getParent()->getLeft();
			}
			if (w->getLeft()->getColour() == BLACK && w->getRight()->getColour() == BLACK)
			{
				w->setColour(RED);
				x = x->getParent();
			}
			else if (w->getLeft()->getColour() == BLACK)
			{
				w->getRight()->setColour(BLACK);
				w->setColour(RED);
				leftRotate(w);
				w = x->getParent()->getLeft();
			}
			w->setColour(x->getParent()->getColour());
			x->getParent()->setColour(BLACK);
			w->getLeft()->setColour(BLACK);
			rightRotate(x->getParent());
			x = Treepoint;
		}
	}
	x->setColour(BLACK);
}

//红黑树析构操作后序遍历析构子程序
void RBTree::posterorderTreeWalkDelete(Node* node)
{
	if (node != NIL)
	{
		posterorderTreeWalkDelete(node->getLeft());
		posterorderTreeWalkDelete(node->getRight());
		delete node;
	}
}