% 删除元素键值操作，sub_free为收回自由对象子程序（栈压入操作）
function L=op_Delete(L,key)
if sub_isEmpty(L)
    disp('Error:Linked list is empty!');
    return;
end
x=op_Search(L,key);
if isnan(x)
    return;
end

L=sub_free(L,x);
if x~=L.head
    L.Next(L.Prev(x))=L.Next(x);
else
    L.head=L.Next(x);
end
if ~isnan(L.Next(x))
    L.Prev(L.Next(x))=L.Prev(x);
end
end

function bool=sub_isEmpty(L)
if isnan(L.head)
    bool=true;
else
    bool=false;
end
end

function L=sub_free(L,x)
L.FreeList.top=L.FreeList.top+1;
L.FreeList.Element(L.FreeList.top)=x;
end