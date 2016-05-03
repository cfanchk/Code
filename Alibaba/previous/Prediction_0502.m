% 在0501基础上修改，54行t由0.5改为0.6
function val = Prediction(data, costA, costB, flag)
if(flag~=0)
    data(:,3) = [];
end

% 分成训练测试
% n_row = size(data,1);
% n_train = round(n_row*0.7);

% trainSet = data(1:n_train,:);
% trainSet(trainSet(:,1)==20141111,:) = [];
% testSet = data(n_train+1:end,:);

% SVR回归
% trainX = [trainSet(:,7:10),trainSet(:,21:22),trainSet(:,25:26)];
% trainY = trainSet(:,end-1);

% [~,bestc] = SVMcgForRegress(trainY,trainX);
% model = svmtrain(trainY,trainX,'-t 0 -c 0.3 -s 3');

% testX = [trainSet(:,7:10),trainSet(:,20:22),trainSet(:,24:26)];
% testY = trainSet(:,end-1);
% predictVal = round(svmpredict(testY,testX,model));
% truthVal = testY;

% ind = trainSet(:,1)>=20141215 & trainSet(:,1)<20150201;
% predictDat = trainSet(ind,:);
% featureDat = [predictDat(:,7:10),predictDat(:,20:22),predictDat(:,24:26)];

% predictVal = round(svmpredict(zeros(48,1),featureDat,model));


% 多元线性回归 Y = X*B 还可以用 glmfit
trainX = [data(:,7:10),data(:,21:22),data(:,25:26)];
n_train = size(trainX,1);
trainY = data(:,end-1);

trainX = [ones(n_train,1),trainX];
b = regress(trainY,trainX);

% 预测
ind = data(:,1)>=20151201 & data(:,1)<=20151227;
n_predict = length(find(ind));
if(n_predict==0)
    val = 0;
else
    predictDat = [data(ind,7:10),data(ind,21:22),data(ind,25:26)];
    predictDat = [ones(n_predict,1),predictDat];
    predictVal = predictDat*b;
    val = sum(abs(predictVal))*14/n_predict;
end

t = 0.6*log(costA/costB);
scale = 2/(1+exp(-t));
val = val*scale;
if(val<1)
    val = 0;
end

% % 检验
% ind = data(:,1)>=20141201 & data(:,1)<20150115 ...
%     & data(:,1)<20151120 & data(:,1)<20151225;
% testX = [data(ind,7:10),data(ind,21:22),data(ind,25:26)];
% n_test = size(testX,1);
% testX = [ones(n_test,1),testX];
% testY = data(ind,end-1);
% 
% predictVal = round(testX*b);
% truthVal = testY;
% 
% % 画图比较预测值和真实值
% if 1 
%     plot(1:numel(truthVal), truthVal, 'bo'); hold on
%     plot(1:numel(predictVal), predictVal, 'r*'); hold off
% end

end