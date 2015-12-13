% 元素入队列操作
function Q=op_Enqueue(Q,x)
if sub_isFull(Q)
    disp('Error:Queue overflow!');
    return;
end
Q.Element(Q.tail)=x;
if Q.tail==Q.arraysize
    Q.tail=1;
else
    Q.tail=Q.tail+1;
end
end