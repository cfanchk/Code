function DCorner=sub_edgeResponseEli(index,Hessian,DCorner)

r=10;

num=size(index,1);

for k=1:num
    pointr=index(k,1);
    pointc=index(k,2);
    if DCorner(pointr,pointc)==0
        break;
    end
    Tr=Hessian(k,1)+Hessian(k,4);
    Det=Hessian(k,1)*Hessian(k,4)-Hessian(k,2)^2;
    if Tr^2/Det > (r+1)^2/r
        DCorner(pointr,pointc)=0;
    end
end
end