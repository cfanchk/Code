clc;clear;close all;
load('data/item_all_id.mat');
len = length(item_all_id);
result = [];

for loops=1:len
    num = item_all_id(loops);
    str = ['data/', num2str(num), '/'];
    dataname = ['item_', num2str(num)];
    
    for innerloops=1:5
        loadpath = [str dataname '_', num2str(innerloops), '.mat'];
        load(loadpath);
        if(isnan(eval(dataname)))
            result = [result;[num,innerloops,0]];
            continue; 
        end;
        eval(['val = Prediction(', dataname, ', anow, bnow, innerloops);']);
        result = [result;[num,innerloops,val]];
    end
    
    val = sum(result(end-4:end,3));
    result = [result;[num,12345,val]];
    
    eval(['clear ', dataname, ';']);
    loops
end

xlswrite('result.xls', result); 