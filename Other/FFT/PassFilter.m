% 理想图像低（高）通滤波实现
clc;clear;close all;
Option=-1;       %控制变量，1为低通滤波，-1位高通滤波
d=20;     %截止频率距离中心（直流分量）的像素距离

I=imread('D:\book.jpg');
I=rgb2gray(I);
[r,c]=size(I);

if abs(Option)~=1 || d>(min(r,c)/2)
    error('参数不正确！');
else
    str={'高','','低'};
end

imshow(I);title('原图像');
F=fft2(I);
A=abs(F);
P=angle(F);

roffset=fix(-r/2):(fix(r/2)-mod(r+1,2));        %计算坐标偏移量及距离
coffset=fix(-c/2):(fix(c/2)-mod(c+1,2));
[x,y]=meshgrid(coffset,roffset);
dist=sqrt(x.^2+y.^2);

Ashift=fftshift(A);
figure;imshow(log(Ashift),[]);title('原图频率对数幅值图像');
Ashift(Option*dist>Option*d)=0;
figure;imshow(log(Ashift),[]);title([str{Option+2},'通滤波后频率对数幅值图像']);
A=ifftshift(Ashift);

I2=ifft2(A.*exp(1i*P));
I2=mat2gray(real(I2));      %逆变换后为复数，利用其实部信息（虚部值几乎为0）
figure;imshow(I2);title([str{Option+2},'通滤波后逆变换所得原图像']);