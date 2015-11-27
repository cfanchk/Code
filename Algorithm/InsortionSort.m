% ²åÈëÅÅĞò£¬Ô­Ö·
function Array=InsortionSort(Array)
len=length(Array);

for j=2:len
    key=Array(j);
    i=j-1;
    while i>0 && Array(i)>key
        Array(i+1)=Array(i);
        i=i-1;
    end
    Array(i+1)=key;
end
end