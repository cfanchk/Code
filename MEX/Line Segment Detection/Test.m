% �߶μ��C������matlab���ʵ�֣�ԭ�ġ�LSD: a Line Segment Detector�����ӿ���LSD.c��
clc;clear;close all;
I=imread('D:\chairs.bmp');
if (numel(size(I))>2)
    I=rgb2gray(I);
end

I=double(I);
LineSeg=LSD(I);
num=length(LineSeg)/7;
LineSeg=reshape(LineSeg,7,num)';
LineH=round([LineSeg(:,2),LineSeg(:,4)])';
LineV=round([LineSeg(:,1),LineSeg(:,3)])';

imshow(uint8(I));
hold on;
line(LineH,LineV,'linewidth',2,'color','r');