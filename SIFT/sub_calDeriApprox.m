function [index,Derivate,Hessian]=sub_calDeriApprox(DValue,DCorner)
valuesize=size(DValue);
[r,c]=find(DCorner);
index=[r,c];

ind=sub2ind(valuesize,r,c);

indXPlus=sub2ind(valuesize,r,c+1);
indXMinus=sub2ind(valuesize,r,c-1);
indYPlus=sub2ind(valuesize,r+1,c);
indYMinus=sub2ind(valuesize,r-1,c);

indXPlusYPlus=sub2ind(valuesize,r+1,c+1);
indXMinuxYPlus=sub2ind(valuesize,r+1,c-1);
indXMinuxYMinus=sub2ind(valuesize,r-1,c-1);
indXPlusYMinus=sub2ind(valuesize,r-1,c+1);

partialDeriX=(DValue(indXPlus)-DValue(indXMinus))/2;
partialDeriY=(DValue(indYPlus)-DValue(indYMinus))/2;
Derivate=[partialDeriX,partialDeriY];

partialDeriX2=DValue(indXPlus)+DValue(indXMinus)-2*DValue(ind);
partialDeriY2=DValue(indYPlus)+DValue(indYMinus)-2*DValue(ind);
partialDeriXY=(DValue(indXPlusYPlus)+DValue(indXMinuxYMinus)-DValue(indXMinuxYPlus)-DValue(indXPlusYMinus))/4;
Hessian=[partialDeriX2,partialDeriXY,partialDeriXY,partialDeriY2];
end