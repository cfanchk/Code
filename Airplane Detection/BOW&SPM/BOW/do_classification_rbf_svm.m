% classification script using SVM

train_flag=1;

if(exist([pg_opts.globaldatapath,'/SVMModel.mat'],'file'))
    train_flag=0;
    display('SVM model has already been computed');
end

%% here you should of course use crossvalidation !

if(train_flag)
    % [bestacc,bestc,bestg] = SVMcgForClass(train_labels, train_data);
    fprintf('\nTraining model\n');
    % load the BOW representations, the labels, and the train and test set
    load(pg_opts.trainset);
    % load(pg_opts.testset);
    load(pg_opts.labels);
    load([pg_opts.globaldatapath,'/',assignment_opts.name])
    
    
    train_labels    = labels(trainset);          % contains the labels of the trainset
    train_data      = BOW(:,trainset)';          % contains the train data
    % test_labels     = labels(testset);           % contains the labels of the testset
    % test_data       = BOW(:,testset)';           % contains the test data
    
%     [bestacc,bestc,bestg] = SVMcgForClass(train_labels,train_data);
    bestc=3.0314;bestg=0.011842;
    options=sprintf('-s 0 -t 2 -c %f -g %f -q',bestc,bestg);
    model=svmtrain(train_labels, train_data, options);
    save ([pg_opts.globaldatapath,'/SVMModel'],'model');
    
    % [predict_label, accuracy , dec_values] = svmpredict(test_labels,test_data, model,'-b 1');
    
end