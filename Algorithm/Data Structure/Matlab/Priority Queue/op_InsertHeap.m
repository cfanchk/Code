% ��������������м���ֵΪkey��Ԫ�ز��������ȶ���
function A=op_InsertHeap(A,key)
heapsize=length(A);
A=[A,inf];
heapsize=heapsize+1;
A=op_DecreaseKey(A,heapsize,key);
end