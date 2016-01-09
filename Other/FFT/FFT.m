% FFT理解程序，理解采样频率、模拟频率、采样点数等的关系
clc;clear;close all;

Fs=400;   %采样频率(Hz)，该值应大于信号最大频率的二倍
N=256;    %采样点数

Adc=2;    %直流分量幅度
A1=3;     %频率F1信号的幅度
A2=1.5;   %频率F2信号的幅度
F1=50;    %信号1频率(Hz)
F2=75;    %信号2频率(Hz)

t=0:1/Fs:N/Fs;    %采样时间

%信号
S=Adc+A1*cos(2*pi*F1*t)+A2*cos(2*pi*F2*t);
plot(t,S);
title('原始信号');

Y=fft(S,N);
Ayy=(abs(Y));       %计算幅值
figure;
Ayy=Ayy/(N/2);      %计算实际幅值
Ayy(1)=Ayy(1)/2;
F=(1:N-1)*Fs/N;     %由点数换算实际频率值，再乘以2pi为数字角频率（数字频率）
plot(F(1:N/2),Ayy(1:N/2));
title('幅度-频率曲线图');