function DoGCorner=sub_NMS(DoGValueAll,S)

r=size(DoGValueAll,1);
c=size(DoGValueAll,2);
MaxDScale=zeros(r,c,S+2);
MinDScale=zeros(r,c,S+2);
Maxima=zeros(r,c,S+2);
Minima=zeros(r,c,S+2);
DoGCorner=zeros(r,c,S);

for i=1:S+2
    DScaleImg=DoGValueAll(:,:,i);
    MaxDScale(:,:,i)=ordfilt2(DScaleImg,9,ones(3,3));
    Maxima(:,:,i)=DScaleImg==MaxDScale(:,:,i);
    MinDScale(:,:,i)=ordfilt2(DScaleImg,1,ones(3,3));
    Minima(:,:,i)=DScaleImg==Minima(:,:,i);
end

for i=1:S
    DoGCorner(:,:,i)=Maxima(:,:,i+1) & MaxDScale(:,:,i+1)>MaxDScale(:,:,i) & MaxDScale(:,:,i+1)>MaxDScale(:,:,i+2) |...
        Minima(:,:,i+1) & MinDScale(:,:,i+1)<MinDScale(:,:,i) & MinDScale(:,:,i+1)<MinDScale(:,:,i+2);
end