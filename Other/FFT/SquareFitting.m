% FFT��⣬�������
% ���Ϊ1�ķ����ĸ���Ҷ����չ��ʽ��f(x)=4*sigma[sin(t*w)/(t*pi)],t=1,3,5,...
x=-10:0.01:10;
z=zeros(1,length(x));
n=20;      %ȡǰn�����
for t=1:2:2*n-1
    y=sin(t*x)/(t*pi);
    z=z+y;
end
z=z*4;
plot(x,z);
axis([-10 10 -2 2]);