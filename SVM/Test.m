% SVM�򵥷������ӣ�����SVM����ʱδ��Ӻ˺���
clc;clear;
train_matrix=[1,1;0.5,0;2,2;1,2;2,0;3,1;2,-1];
train_label=[1;1;1;1;-1;-1;-1];                    %������Ϊ1��������Ϊ-1
model=SVMTrain(train_matrix,train_label,10);
model1=svmtrain(train_label,train_matrix,'-t 0 -c 10');    %����LibSVM��������Ƚ�
[~,accuracy]=SVMPredict(train_matrix,train_label,model);