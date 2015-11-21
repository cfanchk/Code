clear;
clc;
load('positive.mat');
load('negative.mat');

samples=[positive;negative];
m=size(positive,1);
n=size(negative,1);

label=ones(m+n,1);
label(m+1:m+n,1)=-1;

save ('C:\Users\tiger\Documents\MATLAB\samples.mat','samples');
save ('C:\Users\tiger\Documents\MATLAB\label.mat','label');