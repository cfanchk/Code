clc;
clear;
close all;

%��ȡͼ��
files=dir('D:\Test\*.png');
str='D:\result\';

num=50;
f=45;g=4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ima1=imread(['D:\Test\' files(num).name]);
I_bw=imread(['D:\Contour\' files(num).name]);
I_bw(I_bw(:)>=210)=255;
I_bw(I_bw(:)<210)=0;
I_bw=255-I_bw;
figure,imshow(I_bw),title('��ȡ����ͼ��');
    
Q=imread('D:\Origin.png');
Q=rgb2gray(Q);
Q=255-Q;
Q=double(Q./255);
Q=imresize(Q,f/40);

%%% ��ȡ����ͼ�� %%%

%��ȡͼ���С
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
%             imwrite(P,[str,num2str(k),'.jpg']);
                k=k+1;
                z=[z;i j];
            end
        end
    end
end

%     toc;
%     k=k-1;
%     figure,imshow(ima1),title('ԭͼ��');
%     hold on
%     for i=1:k
%         rectangle('Position',[z(i,2),z(i,1),f,f],'EdgeColor','r');
%         hold on
%     end



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

k=k-1;
coor=zeros(k,2);
for i=1:k
    tempind2=find(label==i);
    coor(i,:)=round(mean(z(tempind2,:)));
end

figure,imshow(ima1),title('���');
hold on
for i=1:k
    rectangle('Position',[coor(i,2),coor(i,1),f,f],'EdgeColor','r');
    hold on
end
print(gcf,'-dpng',[str,num2str(num),'.png']);