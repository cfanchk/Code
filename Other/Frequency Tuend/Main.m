% Frequency Tuned实现，原文“Frequency-tuned Salient Region Detection”
clc;clear;close all;

Img=imread('D:\2.bmp');
imshow(Img);title('原图像');
BlurImg=imfilter(Img,fspecial('gaussian',3,3),'symmetric','conv');
Img=double(Img);
BlurImg=double(BlurImg);

LabImg=rgb2Lab(Img);
LabBlurImg=rgb2Lab(BlurImg);

L=LabImg(:,:,1); Lm=mean(L(:));
A=LabImg(:,:,2); Am=mean(A(:));
B=LabImg(:,:,3); Bm=mean(B(:));

BlurL=LabBlurImg(:,:,1);
BlurA=LabBlurImg(:,:,2);
BlurB=LabBlurImg(:,:,3);

Saliency=sqrt((BlurL-Lm).^2+(BlurA-Am).^2+(BlurB-Bm).^2);
Saliency=mat2gray(Saliency);
figure;imshow(Saliency);title('显著性图');