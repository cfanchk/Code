% 插入元素键值操作，sub_allocate为分配自由对象子程序（栈弹出操作）
function L=op_Insert(L,key)
if sub_isFull(L)
    disp('Error:Linked list is full!');
    return;
end
[L,x]=sub_allocate(L);
L.Key(x)=key;
L.Next(x)=L.head;
if ~isnan(L.head)
    L.Prev(L.head)=x;
end
L.head=x;
L.Prev(x)=NaN;
end

function bool=sub_isFull(L)
if L.FreeList.top==0
    bool=true;
else
    bool=false;
end
end

function [L,x]=sub_allocate(L)
L.FreeList.top=L.FreeList.top-1;
x=L.FreeList.Element(L.FreeList.top+1);
end