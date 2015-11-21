clc;
clear;
close all;

%读取图像
ima1=imread('D:\temp.png');
if(numel(size(ima1))>2)
    image=rgb2gray(ima1);
else
    image=ima1;
end

gamma=0.65;
result=zeros(15-1+1,2);
idx=cell(1,15-1+1);

radius=5;
CFF=Circle(image,radius,gamma);
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
withArray=withArray(1:len);
diffArray=diffArray(2:len);
clearvars tempArray;

m=1:15;
figure;plot(m,withArray,'color','k');
hold on;
plot(m,withArray,'r*');
title('类内距离');

m=1:14;
figure;plot(m,diffArray,'color','k');
hold on;
plot(m,diffArray,'r*');
title('类内距离差分');