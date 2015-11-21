function [bh bv] = anna_phogCal(Img,bin,angle,L)
% anna_PHOG Computes Pyramid Histogram of Oriented Gradient over a ROI.
%               
% [BH, BV] = anna_PHOG(I,BIN,ANGLE,L,ROI) computes phog descriptor over a ROI.
% 
% Given and image I, phog computes the Pyramid Histogram of Oriented Gradients
% over L pyramid levels and over a Region Of Interest

%IN:
%	I - Images of size MxN (Color or Gray)
%	bin - Number of bins on the histogram 
%	angle - 180 or 360
%   L - number of pyramid levels
%   roi - Region Of Interest (ytop,ybottom,xleft,xright)
%
%OUT:
%	p - pyramid histogram of oriented gradients

% Img = imread(I);
if size(Img,3) == 3
    G = rgb2gray(Img);
else
    G = Img;
end

bh = [];
bv = [];

G=double(G);
if sum(sum(G))>100
    E = edge(G,'canny');
    [GradientX,GradientY] = gradient(double(G));
    GradientYY = gradient(GradientY);
    Gr = sqrt((GradientX.*GradientX)+(GradientY.*GradientY));
            
    index = GradientX == 0;
    GradientX(index) = 1e-5;
            
    YX = GradientY./GradientX;
    if angle == 180, A = ((atan(YX)+(pi/2))*180)/pi; end
    if angle == 360, A = ((atan2(GradientY,GradientX)+pi)*180)/pi; end
                                
    [bh bv] = anna_binMatrix(A,E,Gr,angle,bin);
else
    bh = zeros(size(I,1),size(I,2));
    bv = zeros(size(I,1),size(I,2));
end