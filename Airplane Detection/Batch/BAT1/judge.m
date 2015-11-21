function [ind,crit,label]=judge(centroids,diffArray,dist)

len=size(centroids,1);
label=zeros(1,len);
for i=2:len
    for j=1:i-1
        for k=j+1:i
            if(dist(centroids(i,j),centroids(i,k))<=25)
                label(i)=label(i)+1;
            end
        end
    end
end

if(any(label))
    ind=find(label,1);
else
    ind=len;
end

if(ind==len||ind==len-1)
    ind=ind-2;
end

if(ind==1||ind==0)
    crit=0;
else
    while(ind>1)
    bd=diffArray(ind-1)-diffArray(ind);
    fd=diffArray(ind)-diffArray(ind+1);
    crit=abs(bd/fd);
        if(bd>0&&fd<0||crit>=5)
            break;
        else
            ind=ind-1;
        end
    end
end