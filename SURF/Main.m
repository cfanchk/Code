clc;
clear;
close all;

I=imread('D:\lena.jpg');
if (numel(size(I))>2)
    I=rgb2gray(I);
end
[r,c]=size(I);
figure;imshow(I);

IntImg=sub_intImage(I);
detHapprox=cell(1,3);
MaxHapprox=zeros(r,c,3);
output=zeros(r,c);
for i=1:3
    [xm,ym,xym]=sub_createmask(9+6*(i-1));
    
    Dxx=imfilter(I,xm,'conv','symmetric');
    Dyy=imfilter(I,ym,'conv','symmetric');
    Dxy=imfilter(I,xym,'conv','symmetric');
    detHapprox{1,i}=Dxx.*Dyy-(0.9*Dxy).^2;
    MaxHapprox(:,:,i)=ordfilt2(detHapprox{1,i},9,ones(3,3));
end

temp1=MaxHapprox(:,:,2)>MaxHapprox(:,:,1) & MaxHapprox(:,:,2)>MaxHapprox(:,:,3);
figure;imshow(temp1);
[rtemp,ctemp]=find(temp1);
figure;imshow(I);
hold on;
plot(ctemp,rtemp,'r.','MarkerSize',4);
