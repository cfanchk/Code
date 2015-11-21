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

gamma=0.65;             %CFF阈值
CFF=zeros(256,320,15-1+1);
result=zeros(15-1+1,2);
idx=cell(1,15-1+1);

%半径1至15进行CFF
for radius=1:15
    CFF(:,:,radius)=Circle(image,radius,gamma);
end

for radius=1:15
    [r,c,v]=find(CFF(:,:,radius));
    coor=[r,c];
    dist=pdist2(coor,coor);            %计算距离矩阵
    eucD=pdist(coor,'euclidean');
    clustTreeEuc=linkage(eucD,'average');
    cNumMax=15;            %聚类最大数
    if(size(r,1))<15
        cNumMax=size(r,1);
    end
    withArray=zeros(1,cNumMax+1);          %类内距离向量
    centroids=zeros(cNumMax,cNumMax);      %聚类中心索引向量
    for cNum=1:cNumMax
        within=zeros(1,cNum);
        cidx=zeros(1,cNum);
        inds=cluster(clustTreeEuc,'maxclust',cNum);    %聚类
        for i=1:cNum                  %计算类中心（类内CFF值最大点处）及类内距离
            regInd=inds==i;
            temparr=find(regInd);
            [~,tempind]=max(v(regInd));
            cidx(i)=temparr(tempind);
            within(i)=mean(dist(cidx(i),(inds==i)));
        end
        withArray(cNum)=mean(within);       %所有类内距离均值该半径下的类内距离
        cidx(cNum+1:cNumMax)=0;
        centroids(cNum,:)=cidx;
    end
    len=size(centroids,1);

    tempArray=[0,withArray(1:cNumMax)];
    diffArray=tempArray-withArray;          %类内距离差分向量
    diffArray=diffArray(2:len);

    [core,~,label]=judge(centroids,diffArray,dist);  %得到最优聚类数core
    
    if(core==0)
        continue;
    end
    
    inds=cluster(clustTreeEuc,'maxclust',core);
    clusternum=zeros(1,core);
    within=zeros(1,core);
    cidx=zeros(1,core);
    
    color=randperm(core);           %类别随机颜色以区分
    
    figure,imshow(CFF(:,:,radius));
    hold on;
    
    for i=1:core
        regInd=inds==i;
        temparr=find(regInd);
        scatter(c(temparr),r(temparr),2,[1/core*color(i),1-1/core*color(i),1/core*color(i)]);
        clusternum(i)=size(temparr,1);
        [~,tempind]=max(v(regInd));
        cidx(i)=temparr(tempind);
        within(i)=mean(dist(cidx(i),(inds==i)));
    end
    idx{radius}=cidx;
    
    weight=mean(within./clusternum);

    scatter(c(cidx),r(cidx),'r+');
    title(['半径',num2str(radius),'    聚类数:',num2str(core),'     权值：',num2str(weight)]);
    result(radius,:)=[core,weight];
end

[~,bestR]=min(result(:,2));          %权值最小半径作为最优半径
bestD=result(bestR,1);
[r,c,~]=find(CFF(:,:,bestR));
figure;imshow(image);
hold on;
for k=1:result(bestR,1)
    rectangle('Position',[c(idx{bestR}(k))-bestR-5,r(idx{bestR}(k))-bestR-5,bestR+20,bestR+20],'EdgeColor','r');
end
title(['最优半径',num2str(bestR),'          聚类数',num2str(bestD)]);