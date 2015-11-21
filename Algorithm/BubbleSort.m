function SortArray=BubbleSort(Array)
len=length(Array);
SortArray=Array;

for i=1:len-1
    for j=len:-1:i+1
        if SortArray(j)<SortArray(j-1)
            temp=SortArray(j-1);
            SortArray(j-1)=SortArray(j);
            SortArray(j)=temp;
        end
    end
end
end