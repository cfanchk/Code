% ����ͼ��ȡ
function IntImg=sub_intImage(Img)
Img=double(Img);
[r,c]=size(Img);
IntImg=zeros(r,c);

IntImg(1,1)=Img(1,1);
% ��һ��
for i=2:r
    IntImg(i,1)=Img(i,1)+IntImg(i-1,1);
end
% ��һ��
for j=2:c
    IntImg(1,j)=Img(1,j)+IntImg(1,j-1);
end
% ʣ�ಿ��
for i=2:r
    for j=2:c
        IntImg(i,j)=Img(i,j)+IntImg(i-1,j)+IntImg(i,j-1)-IntImg(i-1,j-1);
    end
end
end