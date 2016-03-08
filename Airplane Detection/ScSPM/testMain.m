%测试阶段代码
clc;clear;close all;

%% Initialization
dataSet = 'Airplane';
nBases = 1024;
pyramid = 1;
gamma = 0.15;
knn = 200;

rootpath = 'C:/Users/tiger/Documents/MATLAB/ScSPM/';
datapath = sprintf(['%sdata/', dataSet], rootpath);
load([datapath, '/SIFTfea'], 'descriptor_opts');
load([datapath, '/SVMModel'], 'model');
dicpath = sprintf('%sdictionary', rootpath);
load([dicpath,'/dict_' dataSet '_' num2str(nBases)], 'dictionary');

gridSpacing = 1;
patchSize = descriptor_opts.patchSize;
dictionary_size = size(dictionary,1);

g=1;f=32;

Img = imread('D:/test.png');
I = im2double(rgb2gray(Img));
[hgt, wid] = size(I);

%% Calculate SIFT
nrml_threshold = 1;
remX = mod(wid-patchSize, gridSpacing);% the right edge
offsetX = floor(remX/2)+1;
remY = mod(hgt-patchSize, gridSpacing);
offsetY = floor(remY/2)+1;

[gridX,gridY] = meshgrid(offsetX:gridSpacing:wid-patchSize+1, offsetY:gridSpacing:hgt-patchSize+1);
siftArr = sp_find_sift_grid(I, gridX, gridY, patchSize, 0.8);
[siftArr, ~] = sp_normalize_sift(siftArr, nrml_threshold);

[rows, cols] = size(gridX);

%% Prediction
% z=[];
k=0;

gridSpacing = descriptor_opts.gridSpacing;
len = f - patchSize;
rem = mod(len, gridSpacing);% the right edge
offset = floor(rem/2) + 1;
dim = length(1:gridSpacing:(len+1))^2;

feaSet.width = f;
feaSet.height = f;
grid = meshgrid(1:gridSpacing:(len+1),1:gridSpacing:(len+1));
feaSet.x = grid(:) + patchSize/2 - 0.5;
feaSet.y = grid(:) + patchSize/2 - 0.5;

testlabel = 1;
figure,imshow(Img),title('结果');
hold on;
for i=1:g:wid-f
    for j=1:g:hgt-f
        [tempX, tempY] = meshgrid(j:gridSpacing:(len+j),i:gridSpacing:(len+i));
        inds = sub2ind([rows, cols], tempX, tempY);
        feaSet.feaArr = siftArr(inds, :)';
        if knn,
            scfeature = sc_approx_pooling(feaSet, dictionary, pyramid, gamma, knn);
        else
            scfeature = sc_pooling(feaSet, dictionary, pyramid, gamma);
        end
        testlabel=1;
        [predicted_label, ~, ~] = svmpredict(testlabel, scfeature', model, '-q');
        if predicted_label == 2
            k = k + 1;
            rectangle('Position', [i,j,f,f], 'EdgeColor', 'r');
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