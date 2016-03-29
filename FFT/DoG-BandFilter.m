% 高斯差分（DoG）为图像带通滤波理解
clc;clear;close all;
sigma1=3;         %较小的高斯模糊sigma
sigma2=10;         %较大的高斯模糊sigma

I=imread('D:\temp1.png');
I=rgb2gray(I);
suptitle('原图像');
subplot(2,1,1);imshow(I);
F=fft2(I);
Ashift=abs(fftshift(F));
subplot(2,1,2);imshow(log(Ashift),[]);

I2=imfilter(I,fspecial('gaussian',3*sigma1,sigma1),'conv');
figure;suptitle('较小sigma高斯滤波后（低通）');
subplot(2,1,1);imshow(I2);
F=fft2(I2);
Ashift=abs(fftshift(F));
subplot(2,1,2);imshow(log(Ashift),[]);

I3=imfilter(I,fspecial('gaussian',3*sigma2,sigma2),'conv');
figure;suptitle('较大sigma高斯滤波后（低通）');
subplot(2,1,1);imshow(I3);
F=fft2(I3);
Ashift=abs(fftshift(F));
subplot(2,1,2);imshow(log(Ashift),[]);

I4=I3-I2;
figure;suptitle('高斯差分后（带通）');
subplot(2,1,1);imshow(I4);
F=fft2(I4);
Ashift=abs(fftshift(F));
subplot(2,1,2);imshow(log(Ashift),[]);