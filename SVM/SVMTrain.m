function model=SVMTrain(train_matrix,train_label,C)
[Alpha,w,b]=sub_SMO(train_matrix,train_label,C);

index=Alpha~=0;
sv_indices=find(index);
SV=train_matrix(index,:);
nSV=[sum(index&train_label==1);sum(index&train_label==-1)];
sv_coef=Alpha(index).*train_label(index);
totalSV=length(SV);

model.totalSV=totalSV;           %֧����������
model.sv_indices=sv_indices;     %֧�������±�
model.nSV=nSV;                   %����������֧����������
model.sv_coef=sv_coef;           %֧��������Ӧϵ��
model.SV=SV;                     %֧������
model.w=w;                       %������w
model.b=b;                       %������b,f(x)=<w,x>-b
end