clc;
clear;
close all;

I=imread('D:\009.png');
if (numel(size(I))>2)
    I=rgb2gray(I);
end

S=3;
sigma=1.6;
[DoGCorner,DoGValue]=sub_DoG(I,S,sigma);
OctaveNum=size(DoGCorner,2);
for i=1:OctaveNum
    [r,c]=size(I);
    for j=1:S
        figure;imshow(I);
        hold on;
        [rtemp,ctemp]=find(DoGCorner{1,i}(:,:,j));
        plot(ctemp,rtemp,'r.');
    end
    I=imresize(I,[floor(r/2) floor(c/2)]);
end