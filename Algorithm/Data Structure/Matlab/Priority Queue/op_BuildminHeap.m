% �����ȶ��У���С�ѣ�����
function A=op_BuildminHeap(A)
heapsize=length(A);
for i=floor(heapsize/2):-1:1
    A=sub_minHeapify(A,i,heapsize);
end
end