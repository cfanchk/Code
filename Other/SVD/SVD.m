% ����ֵ�ֽ⼸��������⣬ԭ��ַhttp://blog.sciencenet.cn/blog-696950-699432.html
clc;clear;close all;

R=1;
alpha=0:pi/100:2*pi;   %��λԲ

x=R*cos(alpha); 
y=R*sin(alpha); 

X=zeros(1,201);
Y=zeros(1,201);

plot(x,y,'-') ;
axis([-3 3 -3 3]);
axis equal
hold on;

M=[1,1;0,1];      %����任����
[U,S,V] = svd(M);

quiver(0,0,V(1,1),V(2,1),2);      %ԭ�����ᣬ2������
quiver(0,0,V(1,2),V(2,2),2);

for loops=1:201            %����任
    T=M*[x(loops);y(loops)];
    X(1,loops)=T(1);
    Y(1,loops)=T(2);
end

figure;
plot(X,Y,'-') ;
axis([-3 3 -3 3]);
axis equal
hold on;
quiver(0,0,U(1,1),U(2,1),2);     %�任�������ᣬ2������
quiver(0,0,U(1,2),U(2,2),2);