#include "../common/book.h"

#define imin(a,b) (a<b?a:b)

const int N = 33*1024*1024;
const int threadsPerBlock = 256;
const int blocksPerGrid = imin(32, (N+threadsPerBlock-1) / threadsPerBlock);

struct DataStruct
{
	int deviceID;
	int offset;
	int size;
	float* a;
	float* b;
	float returnValue;
};

__global__ void dot(int size, float* a, float* b, float* c)
{
    __shared__ float cache[threadsPerBlock];
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int cacheIndex = threadIdx.x;

    float temp = 0;
    while (tid < size)
    {
        temp += a[tid] * b[tid];
        tid += blockDim.x * gridDim.x;
    }
    
    cache[cacheIndex] = temp;
    __syncthreads();

    int i = blockDim.x/2;
    while (i != 0) 
    {
        if (cacheIndex < i)
            cache[cacheIndex] += cache[cacheIndex + i];
        __syncthreads();
        i /= 2;
    }

    if (cacheIndex == 0)
        c[blockIdx.x] = cache[0];
}

void* routine(void* pvoidData)
{
	DataStruct* data = (DataStruct*)pvoidData;
	if(data->deviceID != 0)
	{
		HANDLE_ERROR(cudaSetDevice(data->deviceID));
		HANDLE_ERROR(cudaSetDeviceFlags(cudaDeviceMapHost));
	}

	int size = data->size;
	float* a, *b, c, *partial_c;
	float* dev_a, *dev_b, *dev_partial_c;

	a = data->a;
	b = data->b;
	partial_c = (float*)malloc(blocksPerGrid*sizeof(float));

	HANDLE_ERROR(cudaHostGetDevicePointer(&dev_a, a, 0));
	HANDLE_ERROR(cudaHostGetDevicePointer(&dev_b, b, 0));
	HANDLE_ERROR(cudaMalloc((void**)&dev_partial_c, blocksPerGrid*sizeof(float)));

	dev_a += data->offset;
	dev_b += data->offset;

	dot<<<blocksPerGrid,threadsPerBlock>>>(size, dev_a, dev_b, dev_partial_c);

	HANDLE_ERROR(cudaMemcpy(partial_c, dev_partial_c, blocksPerGrid*sizeof(float), cudaMemcpyDeviceToHost));

	c = 0;
	for(int i=0; i<blocksPerGrid; i++)
		c += partial_c[i];

	HANDLE_ERROR(cudaFree(dev_partial_c));

	free(partial_c);

	data->returnValue = 0;
	return 0;
}

int main()
{
	int deviceCount;
	HANDLE_ERROR(cudaGetDeviceCount(&deviceCount));
	if(deviceCount<2)
	{
		printf("Only found %d GPU(s)!\n", deviceCount);
		return 1;
	}

	cudaDeviceProp prop;
	int whichDevice;
	HANDLE_ERROR(cudaGetDevice(&whichDevice));
	HANDLE_ERROR(cudaGetDeviceProperties(&prop, whichDevice));
	if(prop.canMapHostMemory != 1)
	{
		printf("Device cannot map memory!\n");
		return 2;
	}

	float* a, *b;
	HANDLE_ERROR(cudaSetDevice(0));
	HANDLE_ERROR(cudaSetDeviceFlags(cudaDeviceMapHost));
	HANDLE_ERROR(cudaHostAlloc((void**)&a, N*sizeof(float), cudaHostAllocWriteCombined | cudaHostAllocPortable | cudaHostAllocMapped));
	HANDLE_ERROR(cudaHostAlloc((void**)&b, N*sizeof(float), cudaHostAllocWriteCombined | cudaHostAllocPortable | cudaHostAllocMapped));

	for(int i=0; i<N; i++)
	{
		a[i] = i;
		b[i] = i*2;
	}

	DataStruct data[2];

	data[0].deviceID = 0;
	data[0].offset = 0;
	data[0].size = N/2;
	data[0].a = a;
	data[0].b = b;
	
	data[1].deviceID = 1;
	data[1].offset = N/2;
	data[1].size = N/2;
	data[1].a = a;
	data[1].b = b;
	
	CUTThread thread = start_thread(routine, &(data[1]));
	routine(&(data[0]));

	end_thread(thread);

	free(a);
	free(b);

	printf("Value calculated: %f.\n", data[0].returnValue + data[1].returnValue);

	return 0;
}
