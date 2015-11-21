clc;
clear;
close all;

squre=[40,35,20,20,50,25,25,20,20,40,40,20,20,22,20,35,35,30,35,20,20,15,10,20,20,35,30,25,30,35,35,25,35,25];

squre=reshape(squre,1,size(squre,1)*size(squre,2));

%读取图像
files=dir('D:\Test\*.png');
str='D:\result\';

g=4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for num=1:34
    ima1=imread(['D:\Test\' files(num).name]);
    I_bw=imread(['D:\Contour\' files(num).name]);
    I_bw(I_bw(:)>=210)=255;
    I_bw(I_bw(:)<210)=0;
    I_bw=255-I_bw;
%     figure,imshow(I_bw),title('求取轮廓图像');
    f=squre(num);
    
    Q=imread('D:\Origin.png');
    Q=rgb2gray(Q);
    Q=255-Q;
    Q=double(Q./255);
    Q=imresize(Q,f/40);

%%% 获取滑窗图像 %%%

%获取图像大小
    [C,D]=size(I_bw);

    z=[];

    k=1;
    thre=ceil((f/40)^2*100);
%     tic;
    for i=1:g:C-f
        for j=1:g:D-f
            P=I_bw(i:i+f-1,j:j+f-1);
            if(sum(P(:)==255)<=thre)
                continue;
            else
                P=double(P./255);
                [sc_cost,aff_cost]=CalSC(P,Q,thre);
                if(sc_cost<0.3)
%                   imwrite(P,[str,num2str(k),'.jpg']);
                    k=k+1;
                    z=[z;i j];
                end
            end
        end
    end

%     toc;
%     k=k-1;
%     figure,imshow(ima1),title('原图像');
%     hold on
%     for i=1:k
%         rectangle('Position',[z(i,2),z(i,1),f,f],'EdgeColor','r');
%         hold on
%     end

%     tic;
    len=size(z,1);
    dist=pdist2(z,z);
    tranclosure=dist<round(f/35*20);
    for k=1:len
        for i=1:len
            for j=1:len
                tranclosure(i,j)=tranclosure(i,j)|(tranclosure(i,k)&tranclosure(k,j));
            end
        end
    end
    label=zeros(len,1);
    k=1;
    while(~isempty(find(label==0,1)))
        tempind=find(label==0,1);
        label(tranclosure(tempind,:)==1)=k;
        k=k+1;
    end
%     clearvars tempind;
    k=k-1;
    coor=zeros(k,2);
    for i=1:k
        tempind2=find(label==i);
        coor(i,:)=round(mean(z(tempind2,:)));
    end

%     toc;
    figure,imshow(ima1),title('结果');
    hold on
    for i=1:k
        rectangle('Position',[coor(i,2),coor(i,1),f,f],'EdgeColor','r');
        hold on
    end
    print(gcf,'-dpng',[str,num2str(num),'.png']);
%     coord{num}=coor;
%     imwrite(ima1,['D:\result\',num2str(num),'.png'])
end