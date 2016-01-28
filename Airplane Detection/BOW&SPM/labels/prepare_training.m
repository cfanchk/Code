%生成所需格式的训练部分文件
clc; clear;

pre_data_path='C:/Users/tiger/Documents/MATLAB/Wu Code/images/';

image_names=[];
labels=[];
testset=[];
trainset=[];
classes={};

file_label = fopen('labels.txt');
class_names = textscan(file_label,'%s');
fclose(file_label);

[num_class, b] = size(class_names{1,1});
classes = class_names{1,1};

num_imgs = 0;
for i = 1 : num_class
    class_name = classes{i,1};
    if strcmp(class_name, 'positive')
        label = 1;
        suffix = '/*.png';
    else
        label = -1;
        suffix = '/*.jpg';
    end
    picstr = dir([pre_data_path, '/training/', class_name, suffix]);
    
    [row,col] = size(picstr);
    picgather = cell(row,1);
    
    for j = 1 : row
        num_imgs = num_imgs + 1
        image_names{num_imgs} = ['training/', class_name,'/' picstr(j).name];
        labels(num_imgs, 1) = label;
        trainset(num_imgs, 1) = 1;
        testset(num_imgs, 1) = 0;
    end
end

save('image_names','image_names');
save('labels','labels');
trainset=logical(trainset);
testset=logical(testset);
save('trainset','trainset');
save('testset','testset');
save('classes', 'classes');


