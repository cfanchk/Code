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
hCorner=sub_cornerDetect(I,3);
num=size(hCorner,3);

for i=1:num
    figure;imshow(hCorner(:,:,i));
    [rtemp,ctemp]=find(hCorner(:,:,i));
    figure;imshow(I);
    hold on;
    plot(ctemp,rtemp,'r.','MarkerSize',4);
end