#include "mex.h"
#include <string.h>
#include "lsdsourcecode.c"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if (nrhs != 1)
		mexErrMsgTxt("Invalid input arguments!");
	else if (nlhs > 1)
		mexErrMsgTxt("Too many output arguments!");

	double *inMatrix;
	double *outMatrix, *out;

	int m, n;
	int num;

	inMatrix = mxGetPr(prhs[0]);
	m = mxGetM(prhs[0]);
	n = mxGetN(prhs[0]);

	out = lsd(&num, inMatrix, m, n);

	plhs[0] = mxCreateDoubleMatrix(1, 7*num, mxREAL);
	outMatrix = mxGetPr(plhs[0]);
	
	memcpy(outMatrix, out, 7*num*sizeof(double));
}