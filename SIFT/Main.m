clc;
clear;
close all;

I=imread('D:\lena.jpg');
if (numel(size(I))>2)
    I=rgb2gray(I);
end

DoGImg=sub_DoG(I,8,2);
num=size(DoGImg,3)/2;
for i=1:num
    figure;imshow(I);
    hold on;
    [rtemp,ctemp]=find(DoGImg(:,:,2*(i-1)+1));  %极大值点
    plot(ctemp,rtemp,'r.','MarkerSize',4);
    [rtemp,ctemp]=find(DoGImg(:,:,2*i));   %极小值点
    plot(ctemp,rtemp,'g.','MarkerSize',4);
end