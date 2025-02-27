#include "mex.h"
#include <math.h>

/*
MINCOLIND Returns the indices of the minimal values in each row of a matrix
z=mincolind(x);
*/

unsigned int *mincolind(double *A, unsigned int *ind, int m, int n)
{
  double temp, *B;
  unsigned int  i, j;
  B=calloc(m,sizeof(double));
  for (i=0; i<m; i++) {B[i]=*A++; ind[i]=1;}
  for (j=2;j<=n; j++) 
    for (i=0; i<m; i++){
      temp=*A++; if (B[i]>temp) {B[i]=temp; ind[i]=j;}
  }
  free(B);
  return(ind);
}


void mexFunction(
   int nlhs, mxArray *plhs[],
   int nrhs, const mxArray *prhs[])
{
  int m, n;
   
  if (nrhs<1) mexErrMsgTxt("No input argument passed.");
  m=mxGetM(prhs[0]);
  n=mxGetN(prhs[0]);
  if (mxIsComplex(prhs[0])) mexErrMsgTxt("Matrix must be real");
  plhs[0]=mxCreateNumericMatrix(m,1,mxUINT32_CLASS,mxREAL);
  mincolind(mxGetPr(prhs[0]),mxGetData(plhs[0]),m,n);
}
