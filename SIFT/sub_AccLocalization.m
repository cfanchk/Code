function DoGCorner=sub_AccLocalization(DoGCorner,DoGValue,S)
OctaveNum=size(DoGCorner,2);
for i=1:OctaveNum
    for j=1:S
        DValue=DoGValue{1,i}(:,:,j);
        DCorner=DoGCorner{1,i}(:,:,j);
        
        [index,Derivate,Hessian]=sub_calDeriApprox(DValue,DCorner);       
        DCorner=sub_lowContrastEli(index,Derivate,Hessian,DValue,DCorner);
        
        [index,~,Hessian]=sub_calDeriApprox(DValue,DCorner);   
        DCorner=sub_edgeResponseEli(index,Hessian,DCorner);
        
        DoGCorner{1,i}(:,:,j)=DCorner;
    end
end
end