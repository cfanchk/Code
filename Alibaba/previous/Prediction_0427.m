% ĞŞ¸ÄÁË35ĞĞ£¬Ö®Ç°µÄÂß¼­²»ÕıÈ·£¬´Ë´Î½á¹û±È0426Æ«Ğ¡
function val = Prediction(data, costA, costB, flag)
if(flag~=0)
    data(:,3) = [];
end

% ·Ö³ÉÑµÁ·²âÊÔ
% n_row = size(data,1);
% n_train = round(n_row*0.7);

% trainSet = data(1:n_train,:);
% trainSet(trainSet(:,1)==20141111,:) = [];
% testSet = data(n_train+1:end,:);

% SVR»Ø¹é
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


% ¶àÔªÏßĞÔ»Ø¹é Y = X*B »¹¿ÉÒÔÓÃ glmfit
ind = data(:,1)>=20141010 & data(:,1)<20150401 ...
    | data(:,1)>=20151120 & data(:,1)<20151225;
n_train = length(find(ind));

if(n_train<40)
    trainX = data(:,[7:10,21:22,25:26]);
    n_train = size(trainX,1);
    trainY = data(:,end-1);
else
    trainX = data(ind,[7:10,21:22,25:26]);
    trainY = data(ind,end-1);
end
trainX = [ones(n_train,1),trainX];
b = regress(trainY,trainX);

% Ô¤²â
ind = data(:,1)>=20141215 & data(:,1)<20150201;
n_predict = length(find(ind));
if(n_predict>20)
    predictDat = [data(ind,7:10),data(ind,21:22),data(ind,25:26)];
    predictDat = [ones(n_predict,1),predictDat];
    predictVal = predictDat*b;
    val = sum(abs(predictVal))*14/n_predict;
    ind = data(:,1)>=20141201 & data(:,1)<=20141227;
    lastSales = sum(data(ind,end-1));
    ind = data(:,1)>=20151201 & data(:,1)<=20151227;
    presentSales = sum(data(ind,end-1));
    if(lastSales==0)
        val = 0;
    else
        val = val*(presentSales/lastSales);
    end
else
    ind = data(:,1)>=20151201 & data(:,1)<=20151227;
    n_predict = length(find(ind));
    if(n_predict==0)
        val = 0;
    else
        predictDat = data(ind,[7:10,21:22,25:26]);
        predictDat = [ones(n_predict,1),predictDat];
        predictVal = predictDat*b;
        val = sum(abs(predictVal))*14/n_predict;
    end
% end

t = 0.2*log(costA/costB);
scale = 2/(1+exp(-t));
val = val*scale;
if(val<1)
    val = 0;
end

% % ¼ìÑé
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
% % »­Í¼±È½ÏÔ¤²âÖµºÍÕæÊµÖµ
% if 1 
%     plot(1:numel(truthVal), truthVal, 'bo'); hold on
%     plot(1:numel(predictVal), predictVal, 'r*'); hold off
% end

end