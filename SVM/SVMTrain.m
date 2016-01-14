function model=SVMTrain(train_matrix,train_label,C)
[Alpha,w,b]=sub_SMO(train_matrix,train_label,C);

index=Alpha~=0;
sv_indices=find(index);
SV=train_matrix(index,:);
nSV=[sum(index&train_label==1);sum(index&train_label==-1)];
sv_coef=Alpha(index).*train_label(index);
totalSV=length(SV);

model.totalSV=totalSV;           %支持向量总数
model.sv_indices=sv_indices;     %支持向量下标
model.nSV=nSV;                   %正、负样本支持向量个数
model.sv_coef=sv_coef;           %支持向量对应系数
model.SV=SV;                     %支持向量
model.w=w;                       %分类面w
model.b=b;                       %分类面b,f(x)=<w,x>-b
end