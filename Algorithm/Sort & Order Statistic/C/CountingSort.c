//Ìí¼Óstdlib.h
void CountingSort(int* A, int* B, int k, int arraysize)
{
	int* CountArray = (int*)malloc(sizeof(int) * (k+1));
	for (int i = 0; i <= k; i++)
		*(CountArray + i) = 0;

	for (int i = 0; i < arraysize; i++)
		*(CountArray + *(A + i)) = *(CountArray + *(A + i)) + 1;
	for (int i = 1; i <= k; i++)
		*(CountArray + i) = *(CountArray + i) + *(CountArray + i - 1);
	for (int i = arraysize - 1; i >= 0; i--)
	{
		*(B + *(CountArray + *(A + i)) - 1) = *(A + i);
		*(CountArray + *(A + i)) = *(CountArray + *(A + i)) - 1;
	}
	free(CountArray);
}