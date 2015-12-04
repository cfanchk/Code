function DoGCorner=sub_AccLocalization(DoGCorner,DoGValue)
OctaveNum=size(DoGCorner,2);
S=size(DoGCorner{1},3);

for i=1:OctaveNum
    for j=1:S
        DValue=DoGValue{i}(:,:,j);
        DCorner=DoGCorner{i}(:,:,j);
        
        [index,Derivate,Hessian]=sub_calDeriApprox(DValue,DCorner);       
        DCorner=sub_lowContrastEli(index,Derivate,Hessian,DValue,DCorner);
        
        [index,~,Hessian]=sub_calDeriApprox(DValue,DCorner);   
        DCorner=sub_edgeResponseEli(index,Hessian,DCorner);
        
        DoGCorner{i}(:,:,j)=DCorner;
    end
end
end