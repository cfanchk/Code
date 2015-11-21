function SortArray=MergeSort(Array,p,r)
% if nargin==1
%     p=1;
%     r=length(Array);
% elseif r>length(Array)
%     disp('Invalid Input Format!');
%     SortArray=[];
%     return;
% end

if p<r
    q=floor((p+r)/2);
    sort1=MergeSort(Array,p,q);
    sort2=MergeSort(Array,q+1,r);
    SortArray=Merge(sort1,sort2);
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