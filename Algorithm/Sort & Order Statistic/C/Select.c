//添加stdlib.h，该实现小规模数组排序算法采用插入排序
int sub_partition(int* A, int p, int r, int x)
{
	int i;
	for (i = 0; *(A + i) != x; i++);
	*(A + i) = *(A + r - 1);
	*(A + r - 1) = x;

	i = p - 2;
	int temp;
	for (int j = p - 1; j < r - 1; j++)
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

void InsortionSort(int* A, int arraysize)
{
	int i, j;
	int key;
	for (j = 1; j < arraysize; j++)
	{
		key = *(A + j);
		i = j - 1;
		while (i >= 0 && *(A + i)>key)
		{
			*(A + i + 1) = *(A + i);
			i--;
		}
		*(A + i + 1) = key;
	}
}

int Select(int* A, int i, int arraysize)
{
	int num;
	if (arraysize < 5)
	{
		InsortionSort(A, arraysize);
		num = *(A + i - 1);
		return num;
	}

	int groupnum = arraysize / 5;
	int* Median = (int*)malloc(sizeof(int) * groupnum);
	for (int loops = 0; loops < groupnum; loops++)
	{
		InsortionSort(A + 5 * loops, 5);
		*(Median + loops) = *(A + 5 * loops + 2);
	}

	int mm = Select(Median, groupnum / 2 + 1, groupnum);
	int q = sub_partition(A, 1, arraysize, mm) + 1;

	if (i == q)
		num = mm;
	else if (i < q)
		num = Select(A, i, q - 1);
	else
		num = Select(A + q, i - q, arraysize - q);
	return num;
}