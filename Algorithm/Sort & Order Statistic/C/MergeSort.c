void Merge(int* A, int p, int q, int r)
{
	int n1 = q - p + 1;
	int n2 = r - q;

	int* L = (int*)malloc(sizeof(int) * n1);
	int* R = (int*)malloc(sizeof(int) * n2);

	for (int i = 0; i < n1; i++)
		*(L + i) = *(A + p + i - 1);
	for (int i = 0; i < n2; i++)
		*(R + i) = *(A + q + i);

	int i = 0, j = 0;
	for (int k = p - 1; k < r; k++)
		if (i == n1)
		{
			for (int loops = k; loops < r; loops++)
			{
				*(A + loops) = *(R + j);
				j++;
			}
			break;
		}
		else if (j == n2)
		{
			for (int loops = k; loops < r; loops++)
			{
				*(A + loops) = *(L + i);
				i++;
			}
			break;
		}
		else if (*(L + i)>*(R + j))
		{
			*(A + k) = *(R + j);
			j++;
		}
		else
		{
			*(A + k) = *(L + i);
			i++;
		}
	free(L);
	free(R);
}

void MergeSort(int* A, int p, int r)
{
	if (p < r)
	{
		int q = (p + r) / 2;
		MergeSort(A, p, q);
		MergeSort(A, q + 1, r);
		Merge(A, p, q, r);
	}
}