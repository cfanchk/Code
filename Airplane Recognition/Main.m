clc;clear;close all;
% addpath(genpath('Shape Context'));
% addpath(genpath('Hu'));
% addpath(genpath('Zernike'));
% addpath(genpath('MSA'));

%% ����ͼ������
displayflag = 0;    %�Ƿ���ʾ��������
contouring = 1;    %�Ƿ�Ϊ��ȡ��Ե

w = 10;
sigma = [5 0.05];

Img = imread('D:\temp\02.png');
Img = rgb2gray(Img);
Img = imresize(Img, size(Img)*2);
Img = im2double(Img);
if(displayflag)
    figure; imshow(Img);
end

I1 = sub_bfilter(Img, w, sigma, displayflag);   %˫���˲�

%% ͳ��ֱ��ͼ
% counts = imhist(I1);
% x = 0:255;
% figure; plot(x,counts);
% [pks,locs] = findpeaks(counts,'minpeakdistance',3);
% figure;plot(pks);

%% Ԥ����
I1 = I1*255;
contourImg = sub_contour(I1, displayflag);     %CVģ����ȡ��Ե 

if(contouring)
    outImg = sub_PCA(contourImg, displayflag);     %PCAѰ������
else
    [r,c] = size(Img);
    ind = sub2ind(size(Img), r/2, c/2);
    fillImg = imfill(contourImg == 255, ind);      %�����ڲ����
    
    if(displayflag)
        figure;imshow(fillImg);
    end
    
    outImg = sub_PCA(fillImg, displayflag);     %PCAѰ������
    outImg = bwmorph(outImg == 255, 'close');
    
end

rotateImg = imrotate(outImg, -90, 'bilinear');      %��ת

if(displayflag)
    figure;imshow(rotateImg);
end

%% ��״�����Ĳ���
% class = sub_ShapeContextRec(rotateImg, displayflag);

%% �ز���
class = sub_MomentRec(rotateImg);
