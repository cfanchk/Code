void BubbleSort(int* A,int len)
{
	int temp;
	for (int i = 0; i < len - 1; i++)
		for (int j = len - 1; j > i; j--)
			if (*(A + j) < *(A + j - 1))
			{
				temp = *(A + j);
				*(A + j) = *(A + j - 1);
				*(A + j - 1) = temp;
			}
}