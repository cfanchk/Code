% ����ͼ��ͣ��ߣ�ͨ�˲�ʵ��
clc;clear;close all;
Option=-1;       %���Ʊ�����1Ϊ��ͨ�˲���-1λ��ͨ�˲�
d=20;     %��ֹƵ�ʾ������ģ�ֱ�������������ؾ���

I=imread('D:\book.jpg');
I=rgb2gray(I);
[r,c]=size(I);

if abs(Option)~=1 || d>(min(r,c)/2)
    error('��������ȷ��');
else
    str={'��','','��'};
end

imshow(I);title('ԭͼ��');
F=fft2(I);
A=abs(F);
P=angle(F);

roffset=fix(-r/2):(fix(r/2)-mod(r+1,2));        %��������ƫ����������
coffset=fix(-c/2):(fix(c/2)-mod(c+1,2));
[x,y]=meshgrid(coffset,roffset);
dist=sqrt(x.^2+y.^2);

Ashift=fftshift(A);
figure;imshow(log(Ashift),[]);title('ԭͼƵ�ʶ�����ֵͼ��');
Ashift(Option*dist>Option*d)=0;
figure;imshow(log(Ashift),[]);title([str{Option+2},'ͨ�˲���Ƶ�ʶ�����ֵͼ��']);
A=ifftshift(Ashift);

I2=ifft2(A.*exp(1i*P));
I2=mat2gray(real(I2));      %��任��Ϊ������������ʵ����Ϣ���鲿ֵ����Ϊ0��
figure;imshow(I2);title([str{Option+2},'ͨ�˲�����任����ԭͼ��']);