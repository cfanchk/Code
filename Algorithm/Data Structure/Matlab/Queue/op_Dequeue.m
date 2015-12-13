% 元素出队列操作
function [Q,x]=op_Dequeue(Q)
if sub_isEmpty(Q)
    disp('Error:Queue underflow!');
    x=NaN;
    return;
end
x=Q.Element(Q.head);
if Q.head==Q.arraysize
    Q.head=1;
else
    Q.head=Q.head+1;
end
end