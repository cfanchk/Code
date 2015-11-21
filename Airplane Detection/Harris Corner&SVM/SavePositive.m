clear all
clc

bin = 9;
angle = 360;
L=3;
roi = [1;40;1;40];

files=dir('D:\p_sample\*.png');
I=imread(['D:\p_sample\' files(1).name]);
Numbers=numel(files);
Dimensions=size(anna_phog(I,bin,angle,L,roi),1);
positive=zeros(Numbers,Dimensions);

for n=1:Numbers
    I=imread(['D:\p_sample\' files(n).name]);
    H=anna_phog(I,bin,angle,L,roi);
    % H=H(:);
    positive(n,:)=H;
end

save ('C:\Users\tiger\Documents\MATLAB\positive.mat','positive');