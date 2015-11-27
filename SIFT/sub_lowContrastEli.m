function DCorner=sub_lowContrastEli(index,Derivate,Hessian,DValue,DCorner)

threshold=5;

[r,c]=size(DCorner);
num=size(index,1);

for k=1:num
    count=0;
    pointr=index(k,1);
    pointc=index(k,2);
    DCorner(pointr,pointc)=0;
    deri=Derivate(k,:)';
    hess=reshape(Hessian(k,:),2,2);
    while(1)
        if count>=4
            pointr=index(k,1);
            pointc=index(k,2);
            deri=Derivate(k,:)';
            hess=reshape(Hessian(k,:),2,2);
            xhat=-inv(hess)*deri;
            break;
        end
        xhat=-inv(hess)*deri;
%         break;
        if pointr==2||pointr==r-1||pointc==2||pointc==c-1
            break;
        end
        if max(abs(xhat))<0.5
            break;
        elseif abs(xhat(1))>abs(xhat(2))
            pointc=pointc+sign(xhat(1));
        else
            pointr=pointr+sign(xhat(2));
        end
        pDX=(DValue(pointr,pointc+1)-DValue(pointr,pointc-1))/2;
        pDY=(DValue(pointr+1,pointc)-DValue(pointr-1,pointc))/2;
        pDX2=DValue(pointr,pointc+1)+DValue(pointr,pointc-1)-2*DValue(pointr,pointc);
        pDY2=DValue(pointr+1,pointc)+DValue(pointr-1,pointc)-2*DValue(pointr,pointc);
        pDXY=(DValue(pointr+1,pointc+1)+DValue(pointr-1,pointc-1)-DValue(pointr+1,pointc-1)-DValue(pointr-1,pointc+1))/4;
        deri=[pDX;pDY];
        hess=[pDX2,pDXY;pDXY,pDY2];
        count=count+1;
    end
    val=DValue(pointr,pointc)+1/2*deri'*xhat;
    if(val>=threshold)
        DCorner(pointr,pointc)=1;
    end
end
end