void sub_maxHeapify(int* A, int i, int heapsize)
{
	int l = 2 * (i + 1) - 1;
	int r = 2 * (i + 1);
	int largest, temp;
	if (l < heapsize && *(A + l) > *(A + i))
		largest = l;
	else
		largest = i;
	if (r < heapsize && *(A + r) > *(A + largest))
		largest = r;
	if (largest != i)
	{
		temp = *(A + i);
		*(A + i) = *(A + largest);
		*(A + largest) = temp;
		sub_maxHeapify(A, largest, heapsize);
	}
}

void sub_buildmaxHeap(int* A, int heapsize)
{
	for (int i = (heapsize - 1) / 2; i >= 0; i--)
		sub_maxHeapify(A, i, heapsize);
}

void HeapSort(int* A, int arraysize)
{
	int temp;
	int heapsize = arraysize;
	sub_buildmaxHeap(A, heapsize);
	for (int i = arraysize - 1; i > 0; i--)
	{
		temp = *(A + i);
		*(A + i) = *A;
		*A = temp;
		heapsize--;
		sub_maxHeapify(A, 0, heapsize);
	}
}