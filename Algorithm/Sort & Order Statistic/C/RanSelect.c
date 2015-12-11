//添加stdlib.h及time.h
int sub_partition(int* A, int p, int r)
{
	int x = *(A + r - 1);
	int j, i = p - 2;
	int temp;
	for (j = p - 1; j < r - 1; j++)
		if (*(A + j) <= x)
		{
			i++;
			temp = *(A + i);
			*(A + i) = *(A + j);
			*(A + j) = temp;
		}
	temp = *(A + i + 1);
	*(A + i + 1) = *(A + r - 1);
	*(A + r - 1) = temp;
	int q = i + 1;
	return q;
}

int sub_ranPartition(int* A, int p, int r)
{
	srand((unsigned)time(NULL));    //产生伪随机数序列的种子，应放在主程序中
	int temp;
	int i = rand() % (r - p + 1) + p;
	temp = *(A + i - 1);
	*(A + i - 1) = *(A + r - 1);
	*(A + r - 1) = temp;
	int q = sub_partition(A, p, r);
	return q;
}

int RanSelect(int* A, int p, int r, int i)
{
	int num;
	if (p == r)
	{
		num = *(A + p - 1);
		return num;
	}
	int q = sub_ranPartition(A, p, r) + 1;
	int k = q - p + 1;

	if (i == k)
		num = *(A + q - 1);
	else if (i < k)
		num = RanSelect(A, p, q - 1, i);
	else
		num = RanSelect(A, q + 1, r, i - k);
	return num;
}