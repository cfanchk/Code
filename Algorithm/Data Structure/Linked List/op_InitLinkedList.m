% ������������������ʾ����FreeListΪջ�ṹ�����ɱ����ڱ������ɶ���
function L=op_InitLinkedList(listsize)
L.listsize=listsize;
L.Next=zeros(1,listsize)*NaN;
L.Key=zeros(1,listsize)*NaN;
L.Prev=zeros(1,listsize)*NaN;
L.head=NaN;
L.FreeList=sub_initfree(listsize);
end

function FreeList=sub_initfree(listsize)
FreeList.Element=listsize:-1:1;
FreeList.top=listsize;
end