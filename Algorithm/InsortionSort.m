function SortArray=InsortionSort(Array)
    if nargin~=1
        disp('Invalid Parameter Format!');
        return;
    end

    len=length(Array);
    SortArray=Array;
    
    for j=2:len
        key=SortArray(j);
        i=j-1;
        while i>0 && SortArray(i)>key
            SortArray(i+1)=SortArray(i);
            i=i-1;
        end
        SortArray(i+1)=key;
    end
end