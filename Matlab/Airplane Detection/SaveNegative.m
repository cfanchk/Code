clear all
clc

bin = 9;
angle = 360;
L=3;
roi = [1;40;1;40];

files=dir('D:\n_sample\*.jpg');
I=imread(['D:\n_sample\' files(1).name]);
Numbers=numel(files);
Dimensions=size(anna_phog(I,bin,angle,L,roi),1);
negative=zeros(Numbers,Dimensions);

for n=1:Numbers
    I=imread(['D:\n_sample\' files(n).name]);
    H=anna_phog(I,bin,angle,L,roi);
    % H=H(:);
    negative(n,:)=H;
end

save ('C:\Users\tiger\Documents\MATLAB\negative.mat','negative');