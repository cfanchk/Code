// C语言循环求解矩阵乘积
#include "mex.h"

void Multiply(double* InMatrix1, double* InMatrix2, int m1, 
	int n1, int n2, double* OutMatrix)
{
	int i, j, k;
	for (i = 0; i < m1*n2; i++)
		*(OutMatrix + i) = 0;

	for (i = 0; i < n2; i++)
		for (j = 0; j < m1; j++)
			for (k = 0; k < n1; k++)
				*(OutMatrix + i*m1 + j) = *(OutMatrix + i*m1 + j) + (*(InMatrix1 + k*m1 + j))*(*(InMatrix2 + i*n1 + k));
}

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
	if (nrhs != 2)
        mexErrMsgTxt("Invalid input arguments!");
	else if (nlhs > 1)
        mexErrMsgTxt("Too many output arguments.");
    
	double *inMatrix1, *inMatrix2;
	double *outMatrix;
    
	int m1, n1, m2, n2;
    
	inMatrix1 = mxGetPr(prhs[0]);
	m1 = mxGetM(prhs[0]);
	n1 = mxGetN(prhs[0]);
    
	inMatrix2 = mxGetPr(prhs[1]);
	m2 = mxGetM(prhs[1]);
	n2 = mxGetN(prhs[1]);

	if (n1 != m2)
		mexErrMsgTxt("The row number of matrix A is different from the column number of matrix B!");
	else
	{
		plhs[0] = mxCreateDoubleMatrix(m1, n2, mxREAL);
		outMatrix = mxGetPr(plhs[0]);
		Multiply(inMatrix1, inMatrix2, m1, n1, n2, outMatrix);
	}
}