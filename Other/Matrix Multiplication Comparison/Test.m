% ���ڲ��Զ��־���˻���ⷽ���������ٶ�
clc;clear;
A=8*rand(984,1019);
B=12*rand(1019,1947);

% Matlab�Դ�
tic;
C1=A*B;
toc;

% ����Lapace/Blas��
tic;
C2=BlasLapackMul(A,B);
toc;

% C����ѭ��
tic;
C3=MatrixMultiply(A,B);
toc;

% Matlabѭ��
tic;
C4=multiply(A,B);
toc;