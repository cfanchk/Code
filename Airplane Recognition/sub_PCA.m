function outImg=sub_PCA(contourImg, displayflag)
[indr,indc]=find(contourImg);
data=[indr,indc];

[r,c] = size(contourImg);

covmatrix=cov(data);
[D,~]=eig(covmatrix);
xnew=data*D(:,2);
ynew=data*D(:,1);

xmean = mean(xnew);
ymean = mean(ynew);
indx = round(xnew - xmean + size(contourImg,2)/2);
indy = round(ynew - ymean + size(contourImg,1)/2);

ind = indx<=0 | indx>=r | indy<=0 | indy>=c;
indx(ind) = []; indy(ind) = [];
dataind = sub2ind([r,c],indy,indx);

outImg = zeros(size(contourImg));
outImg(dataind) = 255;

if(displayflag)
    figure;imshow(outImg);
end
end