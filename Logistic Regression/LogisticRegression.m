% Logistic回归 toy example
function LogisticRegression
clc;clear;close all;

X=[0.05;0.15;0.25;0.35;0.45;0.55;0.65;0.75;0.85;0.95];   %数据
X_0=[1;1;1;1;1;1;1;1;1;1];
Xall = [X_0,X];

Y=[0;0;0;0;0;1;1;1;1;1];   %标签

theta_0_old=rand(1); % 初始化theta_0
theta_1_old=rand(1); % 初始化theta_1
theta = [theta_0_old;theta_1_old];

alfa = 0.01; % 学习率
m = size(X,2);

for iter_time=1:10000
    temp_out = sig_fun(theta,X);
    theta = theta-alfa/m*Xall'*(temp_out-Y);
end

%测试
sig_fun(theta,X)
x=0.25;
sig_fun(theta,x)

end

%%
function out=sig_fun(theta,x)

in=theta(1,1)+theta(2,1)*x;
out = exp(in)./(1+exp(in));
end