% 用于测试多种矩阵乘积求解方法的运行速度
clc;clear;
A=8*rand(984,1019);
B=12*rand(1019,1947);

% Matlab自带
tic;
C1=A*B;
toc;

% 调用Lapace/Blas库
tic;
C2=BlasLapackMul(A,B);
toc;

% C语言循环
tic;
C3=MatrixMultiply(A,B);
toc;

% Matlab循环
tic;
C4=multiply(A,B);
toc;