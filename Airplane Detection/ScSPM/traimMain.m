% 训练阶段代码
clc;clear all;

%% set path
addpath('sift');
addpath(genpath('sparse_coding'));

%% parameter setting

% directory setup
img_dir = 'image';                  % directory for dataset images
data_dir = 'data';                  % directory to save the sift features of the chosen dataset
dataSet = 'Airplane';


% sift descriptor extraction
skip_cal_sift = true;              % if 'skip_cal_sift' is false, set the following parameter
gridSpacing = 4;
patchSize = 8;
maxImSize = 300;
nrml_threshold = 1;                 % low contrast region normalization threshold (descriptor length)

% dictionary training for sparse coding
skip_dic_training = false;
nBases = 1024;
nsmp = 20000;
beta = 1e-5;                        % a small regularization for stablizing sparse coding
num_iters = 50;

% feature pooling parameters
skip_cal_feature = false;
pyramid = 1;                        % spatial block number on each level of the pyramid
                                    % 当前无需使用SPM，需要时可设为[1,2,4...]
gamma = 0.15;
knn = 200;                          % find the k-nearest neighbors for approximate sparse coding
                                    % if set 0, use the standard sparse coding

rt_img_dir = fullfile(img_dir, dataSet);
rt_data_dir = fullfile(data_dir, dataSet);

%% calculate sift features or retrieve the database directory
if skip_cal_sift,
    database = retr_database_dir(rt_data_dir);
else
    [database, lenStat] = CalculateSiftDescriptor(rt_img_dir, rt_data_dir, gridSpacing, patchSize, maxImSize, nrml_threshold);
    descriptor_opts.gridSpacing = gridSpacing;
    descriptor_opts.patchSize = patchSize;
    save ([rt_data_dir,'/SIFTfea'],'descriptor_opts');
end;

%% load sparse coding dictionary (one dictionary trained on Caltech101 is provided: dict_Caltech101_1024.mat)
Bpath = ['dictionary/dict_' dataSet '_' num2str(nBases) '.mat'];
Xpath = ['dictionary/rand_patches_' dataSet '_' num2str(nsmp) '.mat'];

if ~skip_dic_training,
    try 
        load(Xpath);
    catch
        X = rand_sampling(database, nsmp);
        save(Xpath, 'X');
    end
    [dictionary, S, stat] = reg_sparse_coding(X, nBases, eye(nBases), beta, gamma, num_iters);
    save(Bpath, 'dictionary', 'S', 'stat');
else
    load(Bpath);
end

nBases = size(dictionary, 2);                    % size of the dictionary

%% calculate the sparse coding feature
Fpath = [rt_data_dir,'/ScFeature.mat'];

if skip_cal_feature,
    load(Fpath);
else
    dimFea = sum(nBases*pyramid.^2);
    numFea = length(database.path);
    
    sc.fea = zeros(dimFea, numFea);
    sc.label = zeros(numFea, 1);
    
    disp('==================================================');
    fprintf('Calculating the sparse coding feature...\n');
    fprintf('Regularization parameter: %f\n', gamma);
    disp('==================================================');
    
    for iter1 = 1:numFea,
        if ~mod(iter1, 50),
            fprintf('.\n');
        else
            fprintf('.');
        end;
        fpath = database.path{iter1};
        load(fpath);
        if knn,
            sc.fea(:, iter1) = sc_approx_pooling(feaSet, dictionary, pyramid, gamma, knn);
        else
            sc.fea(:, iter1) = sc_pooling(feaSet, dictionary, pyramid, gamma);
        end
        sc.label(iter1) = database.label(iter1);
    end;
    
    save ([rt_data_dir,'/ScFeature'],'sc');
end;

%% Training SVM

[bestacc,bestc,bestg] = SVMcgForClass(sc.label,sc.fea');
% bestc=1;bestg=1;
options=sprintf('-s 0 -t 2 -c %f -g %f -q',bestc,bestg);
model=svmtrain(sc.label, sc.fea', options);
save ([rt_data_dir,'/SVMModel'],'model');


