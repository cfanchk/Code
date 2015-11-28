% 计数排序，输入数组Array为正整数，且值都不大于k，非原址
function SortArray=CountingSort(Array,k)
len=length(Array);
CountArray=zeros(1,k+1);
for i=1:len
    CountArray(Array(i)+1)=CountArray(Array(i)+1)+1;
end
for i=2:k+1
    CountArray(i)=CountArray(i)+CountArray(i-1);
end
for i=len:-1:1
    SortArray(CountArray(Array(i)+1))=Array(i);
    CountArray(Array(i)+1)=CountArray(Array(i)+1)-1;
end
end