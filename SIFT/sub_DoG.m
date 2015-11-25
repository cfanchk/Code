function DoGCorner=sub_DoG(I,S,sigma)
I=double(I);
[r,c]=size(I);
k=2^(1/S);

OctaveNum=floor(log2(min(r,c)))-3;
DoGCorner=cell(1,OctaveNum);

for j=1:OctaveNum
    [r,c]=size(I);
    ScaleImg=zeros(r,c,S+3);
    MaxDScale=zeros(r,c,S+2);
    MinDScale=zeros(r,c,S+2);
    Maxima=zeros(r,c,S+2);
    Minima=zeros(r,c,S+2);
    DoGCorner{1,j}=zeros(r,c,S);
    for i=1:S+3
        sigmanow=sigma*k^(i-1);
        masksize=floor(6*sigmanow);
        h=fspecial('gaussian',[masksize masksize],sigmanow);
        ScaleImg(:,:,i)=imfilter(I,h,'conv');
    end
    for i=1:S+2
        DScaleImg=ScaleImg(:,:,i+1)-ScaleImg(:,:,i);
        MaxDScale(:,:,i)=ordfilt2(DScaleImg,9,ones(3,3));
        Maxima(:,:,i)=DScaleImg==MaxDScale(:,:,i);
        MinDScale(:,:,i)=ordfilt2(DScaleImg,1,ones(3,3));
        Minima(:,:,i)=DScaleImg==Minima(:,:,i);
    end
    
    for i=1:S
        DoGCorner{1,j}(:,:,i)=Maxima(:,:,i+1) & MaxDScale(:,:,i+1)>MaxDScale(:,:,i) & MaxDScale(:,:,i+1)>MaxDScale(:,:,i+2) |...
            Minima(:,:,i+1) & MinDScale(:,:,i+1)<MinDScale(:,:,i) & MinDScale(:,:,i+1)<MinDScale(:,:,i+2);
    end
    I=imresize(ScaleImg(:,:,S+1),[floor(r/2) floor(c/2)]);
end
