% 奇异值分解几何意义理解，原网址http://blog.sciencenet.cn/blog-696950-699432.html
clc;clear;close all;

R=1;
alpha=0:pi/100:2*pi;   %单位圆

x=R*cos(alpha); 
y=R*sin(alpha); 

X=zeros(1,201);
Y=zeros(1,201);

plot(x,y,'-') ;
axis([-3 3 -3 3]);
axis equal
hold on;

M=[1,1;0,1];      %坐标变换矩阵
[U,S,V] = svd(M);

quiver(0,0,V(1,1),V(2,1),2);      %原坐标轴，2倍长度
quiver(0,0,V(1,2),V(2,2),2);

for loops=1:201            %坐标变换
    T=M*[x(loops);y(loops)];
    X(1,loops)=T(1);
    Y(1,loops)=T(2);
end

figure;
plot(X,Y,'-') ;
axis([-3 3 -3 3]);
axis equal
hold on;
quiver(0,0,U(1,1),U(2,1),2);     %变换后坐标轴，2倍长度
quiver(0,0,U(1,2),U(2,2),2);