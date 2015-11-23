% 圆周频率滤波函数,r为半径,threshold为阈值
function CFF=sub_Circle(image,r,threshold)

bin=32;
theta=linspace(0,2*pi,bin);

x=r*cos(theta);
y=-r*sin(theta);
CTemplate=cos(4*theta);
STemplate=sin(4*theta);

[C,D]=size(image);
CFF=zeros(C,D);

for i=r+1:C-r-1
    for j=r+1:D-r-1
        index=sub2ind([C,D],round(y+i),round(x+j));
        tempI=double(image(index));
        CosSum=(sum(tempI.*CTemplate))^2;
        SinSum=(sum(tempI.*STemplate))^2;
        CFF(i,j)=1/bin*sqrt(CosSum+SinSum);     
    end
end

CFF=CFF./(max(CFF(:)));

% if nargin==2          %尝试自适应阈值
%     threshold=2.7*sum(CFF(:))/(C*D);
% end

CFF(CFF(:)<=threshold)=0;
% CFF(CFF(:)~=0)=1;
% figure,imshow(CFF);
% title(r);
end