% 快速排序，p,r为待排序数组下标，原址
function Array=QuickSort(Array,p,r)
if p<r
    [Array,q]=sub_ranPartition(Array,p,r);
    Array=QuickSort(Array,p,q-1);
    Array=QuickSort(Array,q+1,r);
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