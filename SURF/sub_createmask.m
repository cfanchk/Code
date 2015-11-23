function [xmask,ymask,xymask]=sub_createmask(s)
ind=s/3;
xmask=zeros(s,s);
xmask(ind:2*ind+1,:)=1;xmask(ind:2*ind+1,ind+1:2*ind)=-2;

ymask=xmask';

index=floor(ind/3);
xymask=zeros(s,s);
xymask(index+1:ind+index,index+1:ind+index)=1;
xymask(index+1:ind+index,s-ind-index+1:s-index)=-1;
xymask(s-ind-index+1:s-index,index+1:ind+index)=-1;
xymask(s-ind-index+1:s-index,s-ind-index+1:s-index)=1;
end