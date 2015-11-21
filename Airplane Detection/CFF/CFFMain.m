clc;
clear;
close all;

%��ȡͼ��
ima1=imread('D:\temp.png');
if(numel(size(ima1))>2)
    image=rgb2gray(ima1);
else
    image=ima1;
end

gamma=0.65;             %CFF��ֵ
CFF=zeros(256,320,15-1+1);
result=zeros(15-1+1,2);
idx=cell(1,15-1+1);

%�뾶1��15����CFF
for radius=1:15
    CFF(:,:,radius)=Circle(image,radius,gamma);
end

for radius=1:15
    [r,c,v]=find(CFF(:,:,radius));
    coor=[r,c];
    dist=pdist2(coor,coor);            %����������
    eucD=pdist(coor,'euclidean');
    clustTreeEuc=linkage(eucD,'average');
    cNumMax=15;            %���������
    if(size(r,1))<15
        cNumMax=size(r,1);
    end
    withArray=zeros(1,cNumMax+1);          %���ھ�������
    centroids=zeros(cNumMax,cNumMax);      %����������������
    for cNum=1:cNumMax
        within=zeros(1,cNum);
        cidx=zeros(1,cNum);
        inds=cluster(clustTreeEuc,'maxclust',cNum);    %����
        for i=1:cNum                  %���������ģ�����CFFֵ���㴦�������ھ���
            regInd=inds==i;
            temparr=find(regInd);
            [~,tempind]=max(v(regInd));
            cidx(i)=temparr(tempind);
            within(i)=mean(dist(cidx(i),(inds==i)));
        end
        withArray(cNum)=mean(within);       %�������ھ����ֵ�ð뾶�µ����ھ���
        cidx(cNum+1:cNumMax)=0;
        centroids(cNum,:)=cidx;
    end
    len=size(centroids,1);

    tempArray=[0,withArray(1:cNumMax)];
    diffArray=tempArray-withArray;          %���ھ���������
    diffArray=diffArray(2:len);

    [core,~,label]=judge(centroids,diffArray,dist);  %�õ����ž�����core
    
    if(core==0)
        continue;
    end
    
    inds=cluster(clustTreeEuc,'maxclust',core);
    clusternum=zeros(1,core);
    within=zeros(1,core);
    cidx=zeros(1,core);
    
    color=randperm(core);           %��������ɫ������
    
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
    title(['�뾶',num2str(radius),'    ������:',num2str(core),'     Ȩֵ��',num2str(weight)]);
    result(radius,:)=[core,weight];
end

[~,bestR]=min(result(:,2));          %Ȩֵ��С�뾶��Ϊ���Ű뾶
bestD=result(bestR,1);
[r,c,~]=find(CFF(:,:,bestR));
figure;imshow(image);
hold on;
for k=1:result(bestR,1)
    rectangle('Position',[c(idx{bestR}(k))-bestR-5,r(idx{bestR}(k))-bestR-5,bestR+20,bestR+20],'EdgeColor','r');
end
title(['���Ű뾶',num2str(bestR),'          ������',num2str(bestD)]);