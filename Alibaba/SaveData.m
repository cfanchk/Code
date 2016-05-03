function SaveData(num)
global conn;

str = ['data/', num2str(num), '/'];
mkdir(str);

command = ['SELECT * FROM config1 WHERE item_id=', num2str(num), ' AND store_code LIKE "all"'];
cursor = exec(conn, command);
cursorA = fetch(cursor);
S = regexp(cursorA.data{3}, '_', 'split');
a_all = str2double(S{1});
b_all = str2double(S{2});

command = ['SELECT * FROM item_feature1 WHERE item_id=', num2str(num), ' ORDER BY date;'];
dataname = ['item_', num2str(num)];
cursor = exec(conn, command);
cursorA = fetch(cursor);
eval([dataname, '=cellfun(@str2double, cursorA.data);']);

savepath = [str dataname '_all.mat'];
save(savepath, dataname, 'a_all', 'b_all');


a = zeros(1,5);
b = zeros(1,5);
command = ['SELECT * FROM config1 WHERE item_id=', num2str(num), ' AND store_code NOT LIKE "all" ORDER BY store_code'];
cursor = exec(conn, command);
cursorA = fetch(cursor);
for loops=1:5
    S = regexp(cursorA.data{loops,3}, '_', 'split');
    a(loops) = str2double(S{1});
    b(loops) = str2double(S{2});
end

for loops=1:5
    command = ['SELECT * FROM item_store_feature1 WHERE item_id=', num2str(num), ' AND store_code=', num2str(loops), ' ORDER BY date;'];
    dataname = ['item_', num2str(num)];
    cursor = exec(conn, command);
    cursorA = fetch(cursor);
    eval([dataname, '=cellfun(@str2double, cursorA.data);']);
    savepath = [str dataname '_', num2str(loops), '.mat'];
    anow = a(loops);
    bnow = b(loops);
    save(savepath, dataname, 'anow', 'bnow');
end


end