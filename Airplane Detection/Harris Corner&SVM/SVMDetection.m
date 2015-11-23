% 旧代码，无Harris角点
clc;
clear;
close all;
load('samples.mat');
load('label.mat');

% [bestacc,bestc,bestg] = SVMcgForClass(label,samples);
bestc=3.0314;
bestg=84.4485;

% % 舰船参数
% bestc=3.0314;
% bestg=84.4485;
cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg)];

svmStruct= svmtrain(label,samples,cmd);

RGB=imread('D:\6km.png');
grayimage=rgb2gray(RGB);
% imshow(grayimage);

[height, width]=size(grayimage);

bin = 9;
angle = 360;
L=3;
[bh, bv]=sub_phogCal(RGB,bin,angle,L);

str='D:\result\';
k=1;

imshow(RGB);
% times=zeros(20,1);

% for loops=1:20
    tabo=zeros(width, height);
tic;
for i=10:3:width-15
    for j=10:3:height-15
%         if(tabo(i,j)==0)
            roi = [j;14+j;i;14+i];
            p = sub_phogFeature(bh,bv,L,roi,bin);
            testlabel=1;
            testdata=p;
            [predicted_label, accuracy, decision_values]=svmpredict(testlabel,testdata',svmStruct);   
            if predicted_label==1
                RGB1=imcrop(RGB,[i j 14 14]);
                imwrite(RGB1,[str,num2str(k),'.jpg']);
                plabel(k,1:2)=[i,j];
                k=k+1;
%                 tabo(i+4,j+4)=1;
%                 tabo(i,j+4)=1;
%                 tabo(i,j-4)=1;
%                 tabo(i+4,j)=1;
                break
%             end
        end
    end
end

plabel(:,3)=0;
l=1;
k=k-1;
for i=1:k-1
    for j=i+1:k
        if pdist2(plabel(i,:),plabel(j,:))<10
            if plabel(i,3)~=0
                plabel(j,3)=plabel(i,3);
            elseif plabel(j,3)~=0
                plabel(i,3)=plabel(j,3);
            else
                plabel(i,3)=l;
                plabel(j,3)=l;
                l=l+1;
            end
        end
    end
end

l=l-1;
for i=1:l
    ind=find(plabel(:,3)==i);
    num=length(ind);
    ptemp=sum(plabel(ind,:))/num;
    for j=1:num
        plabel(ind(j),:)=ptemp;
    end
end

figure;
imshow(RGB);
hold on;
for i=1:k
    rectangle('Position',[plabel(i,1),plabel(i,2),15,15]);
    hold on;
end

disp(['运行时间：',num2str(toc)]); 
% times(loops)=toc;
% end
% mean(times)