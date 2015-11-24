function hCorner=sub_cornerDetect(Img,S)
[r,c]=size(Img);
Img=double(Img);

hCorner=zeros(r,c,S-2);
MaxHapprox=zeros(r,c,S);
Maxima=zeros(r,c,S);

for i=1:3
    [xm,ym,xym]=sub_createmask(9+6*(i-1));
    Dxx=imfilter(Img,xm,'conv','symmetric');
    Dyy=imfilter(Img,ym,'conv','symmetric');
    Dxy=imfilter(Img,xym,'conv','symmetric');
    detHapprox=Dxx.*Dyy-(0.9*Dxy).^2;
    MaxHapprox(:,:,i)=ordfilt2(detHapprox,9,ones(3,3));
    Maxima(:,:,i)=detHapprox==MaxHapprox(:,:,i);
end

for i=1:S-2
    hCorner(:,:,i)=Maxima(:,:,i+1) & MaxHapprox(:,:,i+1)>MaxHapprox(:,:,i) & MaxHapprox(:,:,i+1)>MaxHapprox(:,:,i+2);
end