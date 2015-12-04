function Ipoint=sub_OriAssignment(Ipoint,I,sigma)
I=double(I);
OctaveNum=size(Ipoint,2);
S=size(Ipoint{1}.Coor,2);
k=2^(1/S);

for i=1:OctaveNum
    [r,c]=size(I);
    for j=1:S
        sigmanow=sigma*k^(j);
        masksize=floor(6*sigmanow);
        h=fspecial('gaussian',[masksize masksize],sigmanow);
        ScaleImg=imfilter(I,h,'replicate','conv');
        [Gmag,Gdir]=imgradient(ScaleImg);
        
        msize=floor(6*1.5*sigmanow);
        if mod(msize,2)==0
            msize=msize-1;
        end
        tempGauss=fspecial('gaussian',[msize msize],sigmanow);
        
        Ipointcoor=Ipoint{i}.Coor{j};
        num=size(Ipointcoor,1);
        
        shift=floor(msize/2);
        fillImg=padarray(Gmag,[shift shift]);
        
        for loops=1:num
            tempGmag=fillImg(Ipointcoor(loops,1):Ipointcoor(loops,1)+2*shift,...
                Ipointcoor(loops,2):Ipointcoor(loops,2)+2*shift);
            weightGmag=tempGauss.*tempGmag;
            
        end
    end
    I=imresize(ScaleImg,[floor(r/2) floor(c/2)]);
end
end