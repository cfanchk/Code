function [DoGCorner,DoGValue]=sub_DoG(I,S,sigma)
I=double(I);
% I=I./255;
[r,c]=size(I);
k=2^(1/S);

OctaveNum=floor(log2(min(r,c)))-3;
DoGCorner=cell(1,OctaveNum);
DoGValue=cell(1,OctaveNum);

for i=1:OctaveNum
    [r,c]=size(I);
    ScaleImg=zeros(r,c,S+3);
    DoGValueAll=zeros(r,c,S+2);
    for j=1:S+3
        sigmanow=sigma*k^(j-1);
        masksize=floor(6*sigmanow);
        h=fspecial('gaussian',[masksize masksize],sigmanow);
        ScaleImg(:,:,j)=imfilter(I,h,'replicate','conv');
        if j~=1
            DoGValueAll(:,:,j-1)=ScaleImg(:,:,j)-ScaleImg(:,:,j-1);
        end
    end
    DoGCorner{1,i}=sub_NMS(DoGValueAll,S);
    DoGValue{1,i}=DoGValueAll(:,:,2:S+1);
    I=imresize(ScaleImg(:,:,S+1),[floor(r/2) floor(c/2)]);
end
