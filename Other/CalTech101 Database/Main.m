% 显示图像Ground Truth，CalTech101数据集，其他数据集仅需替换相应的show_annotation即可
% 数据可从百度云上下载
clc;clear;close all;

classnum = 14;
imagenum = 20;

if (~exist('Data.mat', 'file'))
    anno_dir = 'Annotation';
    annoData = retr_database(anno_dir,0);
    img_dir = 'Image';
    imgData = retr_database(img_dir,1);
    save('Data.mat', 'annoData', 'imgData');
else
    load('Data.mat');
end

for imagenum=1:10
    imgfile=imgData.classpath{classnum}{imagenum};
    annotation_file=annoData.classpath{classnum}{imagenum};
    show_annotation(imgfile, annotation_file);
    title(['Class:',num2str(classnum),'     Image:',num2str(imagenum)]);
end