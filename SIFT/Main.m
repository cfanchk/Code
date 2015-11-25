clc;
clear;
close all;

I=imread('D:\lena.jpg');
if (numel(size(I))>2)
    I=rgb2gray(I);
end

DoGCorner=sub_DoG(I,3,1.6);
OctaveNum=size(DoGCorner,2);
for i=1:OctaveNum
    [r,c]=size(I);
    num=size(DoGCorner{1,i},3);
    for j=1:num
        figure;imshow(I);
        hold on;
        [rtemp,ctemp]=find(DoGCorner{1,i}(:,:,j));
        plot(ctemp,rtemp,'r.');
    end
    I=imresize(I,[floor(r/2) floor(c/2)]);
end