clc;clear;close all;
% addpath(genpath('Shape Context'));
% addpath(genpath('Hu'));
% addpath(genpath('Zernike'));
% addpath(genpath('MSA'));

%% 载入图像及设置
displayflag = 0;    %是否显示各步骤结果
contouring = 1;    %是否为求取边缘

w = 10;
sigma = [5 0.05];

Img = imread('D:\temp\02.png');
Img = rgb2gray(Img);
Img = imresize(Img, size(Img)*2);
Img = im2double(Img);
if(displayflag)
    figure; imshow(Img);
end

I1 = sub_bfilter(Img, w, sigma, displayflag);   %双边滤波

%% 统计直方图
% counts = imhist(I1);
% x = 0:255;
% figure; plot(x,counts);
% [pks,locs] = findpeaks(counts,'minpeakdistance',3);
% figure;plot(pks);

%% 预处理
I1 = I1*255;
contourImg = sub_contour(I1, displayflag);     %CV模型求取边缘 

if(contouring)
    outImg = sub_PCA(contourImg, displayflag);     %PCA寻找主轴
else
    [r,c] = size(Img);
    ind = sub2ind(size(Img), r/2, c/2);
    fillImg = imfill(contourImg == 255, ind);      %轮廓内部填充
    
    if(displayflag)
        figure;imshow(fillImg);
    end
    
    outImg = sub_PCA(fillImg, displayflag);     %PCA寻找主轴
    outImg = bwmorph(outImg == 255, 'close');
    
end

rotateImg = imrotate(outImg, -90, 'bilinear');      %旋转

if(displayflag)
    figure;imshow(rotateImg);
end

%% 形状上下文部分
% class = sub_ShapeContextRec(rotateImg, displayflag);

%% 矩部分
class = sub_MomentRec(rotateImg);
