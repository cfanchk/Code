% 最坏情况为线性时间的顺序统计量查找算法，求取第i个顺序统计量num
function num=Select(Array,i)
len=length(Array);
if len<5
    Array=InsortionSort(Array);
    num=Array(i);
    return;
end
groupnum=floor(len/5);
Median=zeros(1,groupnum);
for loop=1:groupnum
    Array(5*(loop-1)+1:5*loop)=InsortionSort(Array(5*(loop-1)+1:5*loop));
    Median(loop)=Array(5*loop-2);
end
mm=Select(Median,ceil(groupnum/2));
[Array,q]=sub_partition(Array,1,len,mm);
if i==q
    num=mm;
elseif i<q
    num=Select(Array(1:q-1),i);
else
    num=Select(Array(q+1:end),i-q);
end
end

function [A,q]=sub_partition(A,p,r,x)
A(A==x)=A(r);
A(r)=x;
i=p-1;
for j=p:r-1
    if A(j)<=x
        i=i+1;
        temp=A(i);
        A(i)=A(j);
        A(j)=temp;
    end
end
A(r)=A(i+1);
A(i+1)=x;
q=i+1;
end