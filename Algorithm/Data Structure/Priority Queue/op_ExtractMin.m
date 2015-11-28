% 提取操作，去掉并返回优先队列中具有最小键字值的元素
function [A,minima]=op_ExtractMin(A)
heapsize=length(A);
if heapsize<1
    disp('Error:Heap underflow!');
    minima=[];
    return;
end
minima=A(1);
A(1)=A(heapsize);

heapsize=heapsize-1;
if(heapsize==0)
    A=[];
    return;
else
    A=sub_minHeapify(A,1,heapsize);
    A=A(1:end-1);
end
end