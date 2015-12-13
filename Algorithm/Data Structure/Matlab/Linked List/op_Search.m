% 查询元素操作，返回链表对应元素的数组下标位置
function x=op_Search(L,key)
if sub_isEmpty(L)
    disp('Error:Linked list is empty!');
    x=NaN;
    return;
end
x=L.head;
while ~isnan(x) && L.Key(x)~=key
    x=L.Next(x);
end

if isnan(x)
    disp('Error:No such element in the linked list!');
end
end

function bool=sub_isEmpty(L)
if isnan(L.head)
    bool=true;
else
    bool=false;
end
end