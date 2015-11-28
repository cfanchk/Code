% 插入操作，将具有键字值为key的元素插入至优先队列
function A=op_InsertHeap(A,key)
heapsize=length(A);
A=[A,inf];
heapsize=heapsize+1;
A=op_DecreaseKey(A,heapsize,key);
end