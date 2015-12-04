% 期望为线性时间的顺序统计量查找算法，p,r为数组下标，求取第i个顺序统计量num
function num=RanSelect(Array,p,r,i)
if p==r
    num=Array(p);
    return;
end
[Array,q]=sub_ranPartition(Array,p,r);
k=q-p+1;
if i==k
    num=Array(q);
elseif i<k
    num=RanSelect(Array,p,q-1,i);
else
    num=RanSelect(Array,q+1,r,i-k);
end
end

function [A,q]=sub_partition(A,p,r)
x=A(r);
i=p-1;
for j=p:r-1
    if A(j)<=x
        i=i+1;
        temp=A(i);
        A(i)=A(j);
        A(j)=temp;
    end
end
temp=A(i+1);
A(i+1)=A(r);
A(r)=temp;
q=i+1;
end

function [A,q]=sub_ranPartition(A,p,r)
i=round(p+(r-p)*rand());
temp=A(i);
A(i)=A(r);
A(r)=temp;
[A,q]=sub_partition(A,p,r);
end