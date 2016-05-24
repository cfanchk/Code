function F=calMSAMoment(I,ind)
% function F=msa(I,ind) calculates the Multiscale Autoconvolution
% values for image I using the msa coeffiecients a and b defined in ind
% vector. 
% Inputs:
%     I is a gray scale image matrix in double format
%     ind is a matrix containing the a and b values as a rows
% Output:
%     F is a vector containing the msa values corresponding to the given
%     coefficients a and b defined in the same row in the matrix ind.
%
% Note: This function interpolates image by inserting zeros in the image
%       matrix between known values.

I=double(I);
[m,n]=size(I);
I0=I/sum(I(:));
[y,x,v]=find(I);
k=size(ind,1);

for i=1:k
  a=ind(i,1); b=ind(i,2);
  sc1=a; sc2=b; sc3=(1-a-b);
  tm=ceil((abs(sc1)+abs(sc2)+abs(sc3))*m);
  tn=ceil((abs(sc1)+abs(sc2)+abs(sc3))*n);
  G0=conj(fft2(I,tm,tn));
  if sc1~=0
    I1=full(sparse(round((y-1)*abs(sc1)+1),round((x-1)*abs(sc1)+1),v));
    G1=fft2(I1/sum(I1(:)),tm,tn);  
    if sc1<0
      G1=conj(G1);
    end
  else
    G1=1; sc1=1;
  end   
  if sc2~=0
    I2=full(sparse(round((y-1)*abs(sc2)+1),round((x-1)*abs(sc2)+1),v));
    G2=fft2(I2/sum(I2(:)),tm,tn);  
    if sc2<0
      G2=conj(G2);
    end
  else
    G2=1; sc2=1;
  end
  if sc3~=0
    I3=full(sparse(round((y-1)*abs(sc3)+1),round((x-1)*abs(sc3)+1),v));
    G3=fft2(I3/sum(I3(:)),tm,tn);  
    if sc3<0
      G3=conj(G3);
    end
  else
    G3=1; sc3=1;
  end
  F(i,1)=real(sum(sum(G1.*G2.*G3.*(G0))))/tm/tn;
end