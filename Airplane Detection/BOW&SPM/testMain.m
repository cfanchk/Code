%测试阶段代码，解决了重复计算问题，且通过修改find_sift_grid函数，解决了漏检问题
clc;clear;close all;

%% Initialization
% addpath BOW;
rootpath='C:/Users/tiger/Documents/MATLAB/BOW&SPM/';
globaldatapath=sprintf('%sdata/global',rootpath);
load([globaldatapath,'/SVMModel'],'model');
load([globaldatapath,'/dessift_settings'],'descriptor_opts');
load([globaldatapath,'/sift_dictionary'],'dictionary');

gridSpacing=1;
patchSize = descriptor_opts.patchSize;
dictionary_size = size(dictionary,1);

g=1;f=32;

Img=imread('D:/test.png');
I=im2double(rgb2gray(Img));
[hgt, wid]=size(I);

%% Calculate SIFT
remX = mod(wid-patchSize,gridSpacing);% the right edge
offsetX = floor(remX/2)+1;
remY = mod(hgt-patchSize,gridSpacing);
offsetY = floor(remY/2)+1;

[gridX,gridY] = meshgrid(offsetX:gridSpacing:wid-patchSize+1, offsetY:gridSpacing:hgt-patchSize+1);

siftArr = find_sift_grid(I, gridX, gridY, patchSize, 0.8);
siftArr = normalize_sift(siftArr);

%% Do assignment
d2 = EuclideanDistance(siftArr, dictionary);
[~, index] = min(d2', [], 1);
index = reshape(index,size(gridX,1),size(gridX,2));

%% Prediction
% z=[];
k=0;

gridSpacing = descriptor_opts.gridSpacing;
len = f-patchSize;
rem = mod(len,gridSpacing);% the right edge
offset = floor(rem/2)+1;
dim = length(1:gridSpacing:(len+1))^2;

testlabel=1;
figure,imshow(Img),title('结果');
hold on;
for i=1:g:wid-f
    for j=1:g:hgt-f
        patch = index(j:gridSpacing:(len+j),i:gridSpacing:(len+i));
        patch = reshape(patch,1,dim);
%         patch = index( (features.x > i) & (features.x <= f+i) & ...
%             (features.y > j) & (features.y <= f+j));
        testdata = hist(patch, 1:dictionary_size);
        testlabel=1;
        [predicted_label,~,~]=svmpredict(testlabel,testdata,model,'-q');
        if predicted_label==1
%             B=imcrop(image,[i j f-1 f-1]);
%             imwrite(B,['D:/result/',num2str(k),'.png']);
%             z=[z;i j];
            k=k+1;
            rectangle('Position',[i,j,f,f],'EdgeColor','r');
        end
    end
end

% len=size(z,1);
% dist=pdist2(z,z);
% tranclosure=dist<round(f/35*20);
% for k=1:len
%     for i=1:len
%         for j=1:len
%             tranclosure(i,j)=tranclosure(i,j)|(tranclosure(i,k)&tranclosure(k,j));
%         end
%     end
%  end
% label=zeros(len,1);
% k=1;
% while(~isempty(find(label==0,1)))
%     tempind=find(label==0,1);
%     label(tranclosure(tempind,:)==1)=k;
%     k=k+1;
% end
% 
% k=k-1;
% coor=zeros(k,2);
% for i=1:k
%     tempind2=find(label==i);
%     coor(i,:)=round(mean(z(tempind2,:)));
% end

% figure,imshow(Img),title('结果');
% hold on
% for i=1:k
%     rectangle('Position',[coor(i,2),coor(i,1),f,f],'EdgeColor','r');
%     hold on
% end