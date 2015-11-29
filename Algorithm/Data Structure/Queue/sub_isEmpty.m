% 判断队列是否为空子程序
function bool=sub_isEmpty(Q)
if Q.head==Q.tail
    bool=true;
else
    bool=false;
end
end