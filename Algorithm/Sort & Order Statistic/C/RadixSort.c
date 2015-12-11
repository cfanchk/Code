//Ìí¼Óstdlib.h¼°math.h
void sub_countsort(int* A, int* order, int k, int arraysize)
{
	int* CountArray = (int*)malloc(sizeof(int) * (k + 1));
	for (int i = 0; i <= k; i++)
		*(CountArray + i) = 0;

	for (int i = 0; i < arraysize; i++)
		*(CountArray + *(A + i)) = *(CountArray + *(A + i)) + 1;
	for (int i = 1; i <= k; i++)
		*(CountArray + i) = *(CountArray + i) + *(CountArray + i - 1);
	for (int i = arraysize - 1; i >= 0; i--)
	{
		*(order + i) = *(CountArray + *(A + i)) - 1;
		*(CountArray + *(A + i)) = *(CountArray + *(A + i)) - 1;
	}
	free(CountArray);
}

void RadixSort(int* A, int* B, int d, int arraysize)
{
	int* tempArray = (int*)malloc(sizeof(int) * arraysize);
	int* order = (int*)malloc(sizeof(int) * arraysize);
	int* remainder = (int*)malloc(sizeof(int) * arraysize);
	int i, j, power;

	for (i = 0; i < arraysize; i++)
		*(tempArray + i) = *(A + i);

	for (i = 1; i <= d; i++)
	{
		for (j = 0; j < arraysize; j++)
			*(remainder + j) = *(A + j) % 10;
		sub_countsort(remainder, order, 9, arraysize);
		
		for (j = 0; j < arraysize; j++)
			*(B + *(order + j)) = *(tempArray + j);
		for (j = 0; j < arraysize; j++)
			*(tempArray + j) = *(B + j);

		power = (int)pow(10.0, i);
		for (j = 0; j < arraysize; j++)
			*(A + j) = *(tempArray + j) / power;
	}
	free(remainder);
	free(order);
	free(tempArray);
}