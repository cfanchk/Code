% Spectral Residualʵ�֣�ԭ�ġ�Saliency Detection: A Spectral Residual Approach��
clc;clear;close all;
ShiftOption=1;    %���ڿ����Ƿ�DC�����Ƶ�Ƶ�����ģ�����δ�ἰ���ӽ������Ӧ����Ҫ

I=imread('D:\temp2.png');
I=imresize(I,64/size(I,1));
imshow(I);
I=im2double(rgb2gray(I));

Fourier=fft2(I);
Amplitude=abs(Fourier);
Phase=angle(Fourier);
LogAm=log(Amplitude);

if ShiftOption
    LogAm=fftshift(LogAm);
    Residual=LogAm-imfilter(LogAm,fspecial('average',3),'conv');
    Residual=ifftshift(Residual);
else
    Residual=LogAm-imfilter(LogAm,fspecial('average',3),'conv');
end

Saliency=abs(ifft2(exp(Residual+1i*Phase))).^2;
Saliency=imfilter(Saliency,fspecial('gaussian',15,8),'conv');

I2=mat2gray(Saliency);
figure;imshow(I2);