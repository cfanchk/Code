% 最新代码
clc;
clear;
close all;

load('samples.mat');
load('label.mat');

%%%%%%%%%%%%%%%%%%%%%%生成停机坪二值图%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%读取图像
height=input('请输入飞机的高度=');
files=dir('D:\*.png');
image=imread(['D:\' files(height-1).name]);
figure(1),imshow(image),title('原图像');

%%%%%%%%%%%%根据高度设置滑窗参数%%%%%%%%%%%%%
%f=滑窗尺寸
%g=搜索步长
%h=角点阈值

% if (height==4)
%     f=25;g=4;h=3;	
% elseif (height==3)    
%     f=35;g=5;h=5;
% elseif (height==2)
%     f=40;g=5;h=4;	
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (height>=5)
    f=20;g=4;h=1;
elseif (height==4)
    f=25;g=3;h=3;
elseif (height==3)    
    f=35;g=4;h=4;
elseif (height==2)
    f=40;g=6;h=6;
end


%%%%%%%%%%%%% SVM参数设置 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [bestacc,bestc,bestg] = SVMcgForClass(label,samples);
bestc=0.57435;
bestg=256;

cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg)];

bin = 9;
angle = 360;
L=3;
svmStruct= svmtrain(label,samples,cmd);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;
A=rgb2gray(image);
% figure(2),imshow(A),title('灰度图像');
% A=adapthisteq(A);
% figure(3),imshow(A),title('滤波图像');
A=medfilt2(A,[3 3]);
% figure(3),imshow(A),title('滤波图像');
level = graythresh(A);

I=im2bw(A,level);
% figure(2),imshow(I),title('阈值分割图像');

I=double(I);
[a,b]=size(I);

%%%%%%%%%%%%%%%%%%%%机场区域检测（横纵向）%%%%%%%%%%%%%%%%%%%%%%
G1=[];
for i=1:g:b-f
    for j=1:g:a-f
        roi = [j;f+j;i;f+i];
        numb1=sum(sum(I(roi(1,1):roi(2,1),roi(3,1):roi(4,1))));
        if numb1>f*f-6
            G1=[G1;i j];
        end
    end
end

[m1,n1]=hist((G1(:,1)),unique(G1(:,1)));
[c1,d1]=max(m1);
B1=[m1;n1'];
e1=B1(2,d1);

[m2,n2]=hist((G1(:,2)),unique(G1(:,2)));
[c2,d2]=max(m2);
B2=[m2;n2'];
e2=B2(2,d2);

if c1>=c2
    E=find(G1(:,1)==e1);
else
    E=find(G1(:,2)==e2);
end

F=round(mean(G1(E(:),:))); 

while(I(F(1,2),F(1,1))==0)
    F=F-[1,1];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% z=1;
% while(I(F(1,1),F(1,2))==0 && z<length(E))
%     F=round(mean(G1(E(1:length(E)-z))));
%     z=z+1;
% end

ILabel = bwlabel(I,8);
temp=ILabel(F(2),F(1));
Y=zeros(256,320);
idx=find(ILabel==temp);
Y(idx)=1;
% figure(3);imshow(Y),title('第一次生长');

%生成白框套黑框图
B=ones(260,324);
B(2,2:323)=0;
B(259,2:323)=0;
B(2:259,2)=0;
B(2:259,323)=0;

B(3:258,3:322)=Y;
% figure(4),imshow(B),title('生成黑白框图');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

B=~B;
ILabel1 = bwlabel(B,8);
temp=ILabel1(2,2);
BF=zeros(260,324);
idx1=find(ILabel1==temp);
BF(idx1)=1;
W=BF(3:258,3:322);
W=W|Y;
% figure(5),imshow(W),title('第二次生长');

[cim, r, c] = sub_Harris(W.*255, 2, 1000, 1, 0);
% figure(6),imshow(cim),title('角点图1');

%%%%%%%%%%%
% SE=[1];
% SN=[1,1;1,1];
% tic;
% W=imopen(W,SN);
% W=imclose(W,SE);
% toc;
% figure(7),imshow(W),title('腐蚀');
%%%%%%%%%%%%%%%%%%

[height, width]=size(W);
[bh, bv]=sub_phogCal(image,bin,angle,L);

%对角点图进行滑窗检测
str='D:\result\';
k=1;
for i=1:g:width-f
    for j=1:g:height-f
        roi = [j;f+j;i;f+i];
        numbers=length(find(cim(roi(1,1):roi(2,1),roi(3,1):roi(4,1))));
        while (numbers>=h&&numbers<=h+8)
            p = sub_phogFeature(bh,bv,L,roi,bin);
            testlabel=1;
            testdata=p;
            [predicted_label, accuracy, decision_values]=svmpredict(testlabel,testdata',svmStruct);   
            if predicted_label==1
%                 B=imcrop(image,[i j f-1 f-1]);
%                 imwrite(B,[str,num2str(k),'.png']);
                plabel(k,1)=i;
                plabel(k,2)=j;
                k=k+1;
            end
            break
        end
    end
end

plabel(:,3)=0;
threshold=f/2;
l=1;
k=k-1;
for i=1:k-1
    for j=i+1:k
        if pdist2(plabel(i,:),plabel(j,:))<threshold
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

for i=1:k
    if plabel(i,3)==0
        plabel(i,3)=l;
        l=l+1;
    end
end

l=l-1;
for i=1:l
    ind=find(plabel(:,3)==i);
    num=length(ind);
    if(num==1)
        break;
    end
    ptemp2=plabel(ind,:);
    ptemp=round(mean(ptemp2));
    for j=1:num
        plabel(ind(j),:)=ptemp;
    end
end

disp(['运行时间：',num2str(toc)]); 
disp(['飞机目标数目：',num2str(max(plabel(:,3)))]);

figure;imshow(image);
hold on;
for i=1:k
    rectangle('Position',[plabel(i,1),plabel(i,2),f,f],'EdgeColor','r');
    hold on;
end