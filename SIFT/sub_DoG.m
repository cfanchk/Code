function DoGImg=sub_DoG(I,S,sigma)
if(S<4)
    disp('Invalid Input!');
    return;
end

I=double(I);
[r,c]=size(I);
k=2^(1/S);
ScaleImg=zeros(r,c,S);
MaxDScale=zeros(r,c,S-1);
MinDScale=zeros(r,c,S-1);
Maxima=zeros(r,c,S-1);
Minima=zeros(r,c,S-1);
DoGImg=zeros(r,c,2*(S-3));

for i=1:S
    h=fspecial('gaussian',[3 3],sigma*k^(i-1));
    ScaleImg(:,:,i)=imfilter(I,h,'conv');
    figure;imshow(uint8(ScaleImg(:,:,i)));
end
for i=1:S-1
    DScaleImg=ScaleImg(:,:,i)-ScaleImg(:,:,i+1);
    MaxDScale(:,:,i)=ordfilt2(DScaleImg,9,ones(3,3));
    Maxima(:,:,i)=DScaleImg==MaxDScale(:,:,i);
    MinDScale(:,:,i)=ordfilt2(DScaleImg,1,ones(3,3));
    Minima(:,:,i)=DScaleImg==Minima(:,:,i);
end

for i=1:S-3
    DoGImg(:,:,2*(i-1)+1)=Maxima(:,:,i+1) & MaxDScale(:,:,i+1)>MaxDScale(:,:,i) & MaxDScale(:,:,i+1)>MaxDScale(:,:,i+2);
    DoGImg(:,:,2*i)=Minima(:,:,i+1) & MinDScale(:,:,i+1)<MinDScale(:,:,i) & MinDScale(:,:,i+1)<MinDScale(:,:,i+2);
end

end