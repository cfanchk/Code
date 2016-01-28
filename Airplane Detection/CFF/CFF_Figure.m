clc;
clear;
close all;

%¶ÁÈ¡Í¼Ïñ
ima1=imread('D:\test.png');
if(numel(size(ima1))>2)
    image=rgb2gray(ima1);
else
    image=ima1;
end

gamma=0.65;
figure;imshow(image);

radius=7;
CFF=sub_Circle(image,radius,gamma);
[r,c,v]=find(CFF);
coor=[r,c];
dist=pdist2(coor,coor);
eucD=pdist(coor,'euclidean');
clustTreeEuc=linkage(eucD,'average');
cNumMax=15;
if(size(r,1))<15
    cNumMax=size(r,1);
end
withArray=zeros(1,cNumMax+1);
centroids=zeros(cNumMax,cNumMax);
for cNum=1:cNumMax
    within=zeros(1,cNum);
    cidx=zeros(1,cNum);
    inds=cluster(clustTreeEuc,'maxclust',cNum);
    tempsort=unique(inds);
    for i=1:cNum
        j=tempsort(i);
        regInd=inds==j;
        temparr=find(regInd);
        [~,tempind]=max(v(regInd));
        cidx(i)=temparr(tempind);
        within(i)=mean(dist(cidx(i),(inds==j)));
    end
    withArray(cNum)=mean(within);
    cidx(cNum+1:cNumMax)=0;
    clearvars tempsort;
    centroids(cNum,:)=cidx;
end
len=size(centroids,1);

tempArray=[0,withArray(1:cNumMax)];
diffArray=tempArray-withArray;
diffArray=diffArray(2:len);
clearvars tempArray;
[core,~,label]=sub_judge(centroids,diffArray,dist);

inds=cluster(clustTreeEuc,'maxclust',core);
cidx=zeros(1,core);

figure,imshow(CFF);
hold on;

color=randperm(core);

for i=1:core
    regInd=inds==i;
    temparr=find(regInd);
    scatter(c(temparr),r(temparr),2,[1/core*color(i),1-1/core*color(i),1/core*color(i)]);
    [~,tempind]=max(v(regInd));
    cidx(i)=temparr(tempind);
end

clearvars tempind temparr;

scatter(c(cidx),r(cidx),'r+');
title(['°ë¾¶',num2str(radius),'    ×î¼Ñ¾ÛÀàÊý:',num2str(core)]);
