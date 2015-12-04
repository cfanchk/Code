% 基数排序，输入数组Array为正整数，且位数均不大于d，非原址
function SortArray=RadixSort(Array,d)
SortArray=Array;
len=length(Array);
Arrorder=zeros(1,len);
for i=1:d
    remainder=rem(Array,10);
    order=sub_countsort(remainder,9);
    for j=1:len
        Arrorder(j)=find(order==j);
    end
    SortArray=SortArray(Arrorder);
    Array=floor(SortArray/10^i);
end
end

function order=sub_countsort(Array,k)
len=length(Array);
CountArray=zeros(1,k+1);
for i=1:len
    CountArray(Array(i)+1)=CountArray(Array(i)+1)+1;
end
for i=2:k+1
    CountArray(i)=CountArray(i)+CountArray(i-1);
end
for i=len:-1:1
    order(i)=CountArray(Array(i)+1);
    CountArray(Array(i)+1)=CountArray(Array(i)+1)-1;
end
end