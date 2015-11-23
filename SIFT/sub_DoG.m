function DoGImg=sub_DoG(I,S,sigma)
if(S<4)
    disp('Invalid Input!');
    return;
end

I=double(I);
[r,c]=size(I);
k=2^(1/S);
ScaleImg=zeros(r,c,S);
DScaleImg=zeros(r,c,S-1);
MaxDScale=zeros(r,c,S-1);
MinDScale=zeros(r,c,S-1);
DoGImg=zeros(r,c,2*(S-3));

for i=1:S
    h=fspecial('gaussian',[3 3],sigma*k^(i-1));
    ScaleImg(:,:,i)=imfilter(I,h,'conv');
end
for i=1:S-1
    DScaleImg(:,:,i)=ScaleImg(:,:,i)-ScaleImg(:,:,i+1);
    MaxDScale(:,:,i)=ordfilt2(DScaleImg(:,:,i),9,ones(3,3));
    MinDScale(:,:,i)=ordfilt2(DScaleImg(:,:,i),1,ones(3,3));
end

for i=1:S-3
    DoGImg(:,:,2*(i-1)+1)=MaxDScale(:,:,i+1)>MaxDScale(:,:,i) & MaxDScale(:,:,i+1)>MaxDScale(:,:,i+2);
    DoGImg(:,:,2*i)=MinDScale(:,:,i+1)>MinDScale(:,:,i) & MinDScale(:,:,i+1)>MinDScale(:,:,i+2);
end

end