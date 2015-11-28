% 归并排序，p,r为待排序数组下标，非原址
function SortArray=MergeSort(Array,p,r)
if p<r
    q=floor((p+r)/2);
    part1=MergeSort(Array,p,q);
    part2=MergeSort(Array,q+1,r);
    SortArray=Merge(part1,part2);
else
    SortArray=Array(p);
end
end

function SA=Merge(A1,A2)
n1=length(A1);
n2=length(A2);
SA=zeros(1,n1+n2);
i=1;j=1;
for k=1:n1+n2
    if(i>n1)
        SA(k:end)=A2(j:end);
        break;
    elseif(j>n2)
        SA(k:end)=A1(i:end);
        break;
    elseif(A1(i)>A2(j))
        SA(k)=A2(j);
        j=j+1;
    else
        SA(k)=A1(i);
        i=i+1;
    end
end
end