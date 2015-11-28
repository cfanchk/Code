% ��ȡ������ȥ�����������ȶ����о�����С����ֵ��Ԫ��
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