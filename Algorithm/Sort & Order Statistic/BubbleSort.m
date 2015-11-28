% √∞≈›≈≈–Ú£¨‘≠÷∑
function Array=BubbleSort(Array)
len=length(Array);

for i=1:len-1
    for j=len:-1:i+1
        if Array(j)<Array(j-1)
            temp=Array(j-1);
            Array(j-1)=Array(j);
            Array(j)=temp;
        end
    end
end
end