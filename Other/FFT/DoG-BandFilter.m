% ��˹��֣�DoG��Ϊͼ���ͨ�˲����
clc;clear;close all;
sigma1=3;         %��С�ĸ�˹ģ��sigma
sigma2=10;         %�ϴ�ĸ�˹ģ��sigma

I=imread('D:\temp1.png');
I=rgb2gray(I);
suptitle('ԭͼ��');
subplot(2,1,1);imshow(I);
F=fft2(I);
Ashift=abs(fftshift(F));
subplot(2,1,2);imshow(log(Ashift),[]);

I2=imfilter(I,fspecial('gaussian',3*sigma1,sigma1),'conv');
figure;suptitle('��Сsigma��˹�˲��󣨵�ͨ��');
subplot(2,1,1);imshow(I2);
F=fft2(I2);
Ashift=abs(fftshift(F));
subplot(2,1,2);imshow(log(Ashift),[]);

I3=imfilter(I,fspecial('gaussian',3*sigma2,sigma2),'conv');
figure;suptitle('�ϴ�sigma��˹�˲��󣨵�ͨ��');
subplot(2,1,1);imshow(I3);
F=fft2(I3);
Ashift=abs(fftshift(F));
subplot(2,1,2);imshow(log(Ashift),[]);

I4=I3-I2;
figure;suptitle('��˹��ֺ󣨴�ͨ��');
subplot(2,1,1);imshow(I4);
F=fft2(I4);
Ashift=abs(fftshift(F));
subplot(2,1,2);imshow(log(Ashift),[]);