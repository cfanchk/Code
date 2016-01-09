% 对标签和图像数据进行索引
function database = retr_database(data_dir,option)

subfolders = dir(data_dir);

database = [];
database.imnum = 0;       % total image number of the database
database.cname = {};      % name of each class
database.label = [];      % label of each class
database.classnum = [];   % image number of each class
database.path = {};       % contain the pathes for all images
database.classpath = {};  % contain the pathes for each image of each class
database.nclass = 0;      % total class number of the database

if (option==0)
    format = '*.mat';
else
    format = '*.jpg';
end

for ii = 1:length(subfolders)
    subname = subfolders(ii).name;
    
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        database.nclass = database.nclass + 1;
        
        database.cname{database.nclass} = subname;
        
        frames = dir(fullfile(data_dir, subname, format));
        c_num = length(frames);
        
        database.imnum = database.imnum + c_num;
        
        database.classnum = [database.classnum; c_num];
        database.label = [database.label; ones(c_num, 1)*database.nclass];
        database.classpath = [database.classpath, {}];
        database.classpath{database.nclass} = {};
        
        for jj = 1:c_num,
            c_path = fullfile(data_dir, subname, frames(jj).name);
            database.path = [database.path, c_path];
            database.classpath{database.nclass}=...
                [database.classpath{database.nclass}, c_path];
        end;    
    end;
end;