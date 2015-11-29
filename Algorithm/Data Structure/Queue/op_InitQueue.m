% 建队列操作
function Q=op_InitQueue(queuesize)
Q.arraysize=queuesize+1;
Q.Element=zeros(1,queuesize+1);
Q.head=1;
Q.tail=1;
end