% 判断队列是否满子程序
function bool=sub_isFull(Q)
if Q.head==Q.tail+1 || Q.head==1 && Q.tail==Q.arraysize
    bool=true;
else
    bool=false;
end
end