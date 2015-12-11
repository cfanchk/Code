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