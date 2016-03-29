// 调用Lapace/Blas库求解矩阵乘积，编译时需添加libmwblas.lib库
#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs != 2)
        mexErrMsgTxt("Invalid input arguments!");
    else if (nlhs>1)
        mexErrMsgTxt("Too many output arguments.");
    
    char *trans = "N";
    double alpha = 1.0;
    double beta = 0.0;
    
    double *inMatrix1, *inMatrix2;
    double *outMatrix;
    
    size_t m, n, k;
    
    inMatrix1 = mxGetPr(prhs[0]);
    m = mxGetM(prhs[0]);
    k = mxGetN(prhs[0]);
    
    inMatrix2 = mxGetPr(prhs[1]);
    n = mxGetN(prhs[1]);
    
    if (k != mxGetM(prhs[1]))
        mexErrMsgTxt("Inner dimensions of matrix multiply do not match!");
    
    plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);
    outMatrix = mxGetPr(plhs[0]);
    dgemm(trans, trans, &m, &n, &k, &alpha, inMatrix1, &m,
            inMatrix2, &k, &beta, outMatrix, &m);
}