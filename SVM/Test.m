% SVM简单分类例子，线性SVM，暂时未添加核函数
clc;clear;
train_matrix=[1,1;0.5,0;2,2;1,2;2,0;3,1;2,-1];
train_label=[1;1;1;1;-1;-1;-1];                    %正样本为1，负样本为-1
model=SVMTrain(train_matrix,train_label,10);
model1=svmtrain(train_label,train_matrix,'-t 0 -c 10');    %调用LibSVM，结果作比较
[~,accuracy]=SVMPredict(train_matrix,train_label,model);