void BubbleSort(int* A,int arraysize)
{
	int temp;
	for (int i = 0; i < arraysize - 1; i++)
		for (int j = arraysize - 1; j > i; j--)
			if (*(A + j) < *(A + j - 1))
			{
				temp = *(A + j);
				*(A + j) = *(A + j - 1);
				*(A + j - 1) = temp;
			}
}