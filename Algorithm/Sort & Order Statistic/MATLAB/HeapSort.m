% ∂—≈≈–Ú£¨‘≠÷∑
function Array=HeapSort(Array)
len=length(Array);
heapsize=len;
Array=sub_buildmaxHeap(Array);

for i=len:-1:2
    temp=Array(i);
    Array(i)=Array(1);
    Array(1)=temp;
    heapsize=heapsize-1;
    Array=sub_maxHeapify(Array,1,heapsize);
end
end

function A=sub_maxHeapify(A,i,heapsize)
Left=@(i) 2*i;
Right=@(i) 2*i+1;

l=Left(i);
r=Right(i);

if l<=heapsize && A(l)>A(i)
    largest=l;
else
    largest=i;
end
if r<=heapsize && A(r)>A(largest)
    largest=r;
end
if largest~=i
    temp=A(i);
    A(i)=A(largest);
    A(largest)=temp;
    A=sub_maxHeapify(A,largest,heapsize);
end
end

function A=sub_buildmaxHeap(A)
heapsize=length(A);
for i=floor(heapsize/2):-1:1
    A=sub_maxHeapify(A,i,heapsize);
end
end

