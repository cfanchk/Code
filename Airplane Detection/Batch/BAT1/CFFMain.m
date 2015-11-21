clc;
clear;
close all;

%读取图像
files=dir('D:\Test\*.png');
str='D:\result\';
num=size(files,1);

for loops=1:num
    ima1=imread(['D:\Test\' files(loops).name]);
    strl=[str,num2str(loops),'\'];
    mkdir(strl);

    if(numel(size(ima1))>2)
        image=rgb2gray(ima1);
    else
        image=ima1;
    end
    figure;imshow(image);
    print(gcf,'-dpng',[strl,'0.png'])
%     imwrite(image,[strl,'origin.png']);
    
    gamma=0.65;
    CFF=zeros(256,320,15-1+1);
    result=zeros(15-1+1,2);
    idx=cell(1,15-1+1);

    % thre=zeros(1,15);
    for radius=1:15
        CFF(:,:,radius)=Circle(image,radius,gamma);
    end

    for radius=1:15
        [r,c,v]=find(CFF(:,:,radius));
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
            for i=1:cNum
                regInd=inds==i;
                temparr=find(regInd);
                [~,tempind]=max(v(regInd));
                cidx(i)=temparr(tempind);
                within(i)=mean(dist(cidx(i),(inds==i)));
            end
            withArray(cNum)=mean(within);
            cidx(cNum+1:cNumMax)=0;
            centroids(cNum,:)=cidx;
        end
        len=size(centroids,1);

        tempArray=[0,withArray(1:cNumMax)];
        diffArray=tempArray-withArray;
        diffArray=diffArray(2:len);
%     clearvars tempArray;

        [core,~,label]=judge(centroids,diffArray,dist);
    
        if(core==0)
            continue;
        end
    
        inds=cluster(clustTreeEuc,'maxclust',core);
        cidx=zeros(1,core);
        for i=1:core
            regInd=inds==i;
            temparr=find(regInd);
            [~,tempind]=max(v(regInd));
            cidx(i)=temparr(tempind);
        end
        idx{radius}=cidx;
    
%     clearvars tempind temparr;
    
        figure(radius),imshow(CFF(:,:,radius));
        hold on;
        scatter(c(cidx),r(cidx),'r+');
        title(['半径',num2str(radius),'    最佳聚类数:',num2str(core),'     类内距离：',num2str(withArray(core))]);
        print(gcf,'-dpng',[strl,num2str(radius),'.png']);
        result(radius,:)=[core,withArray(core)];
    end

    [bestD,bestR]=max(result(:,1));
    tempind=bestD==result(:,1);
    if(sum(tempind)>1)
        [~,bestR]=min(result(tempind,2));
        temparr=find(tempind,bestR);
        bestR=temparr(end);
        clearvars temparr;
    end
    clearvars tempind;
    [r,c,~]=find(CFF(:,:,bestR));
    figure(16);imshow(image);
    hold on;
    for k=1:result(bestR,1)
        rectangle('Position',[c(idx{bestR}(k))-bestR-10,r(idx{bestR}(k))-bestR-10,bestR+20,bestR+20],'EdgeColor','r');
    end
    title(['最优半径',num2str(bestR),'          聚类数',num2str(bestD)]);
    print(gcf,'-dpng',[strl,'result.png']);
end