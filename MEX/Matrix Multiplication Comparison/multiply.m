% Matlab循环求解矩阵乘积
function C=multiply(A,B)
[m1,n1]=size(A);
[~,n2]=size(B);
C=zeros(m1,n2);
for i=1:m1
    for j=1:n2
        for k=1:n1
            C(i,j)=C(i,j)+A(i,k)*B(k,j);
        end
    end
end
end