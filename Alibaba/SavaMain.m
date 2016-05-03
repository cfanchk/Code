clc;clear;close all;
global conn;
conn = database('Contest','root','829813buaa','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/Contest');
if(~isconnection(conn))
    error('Connection to database failed!')
end

cursor = exec(conn, 'SELECT DISTINCT item_id FROM config1 ORDER BY item_id;');
cursorA = fetch(cursor);
item_all_id = cell2mat(cursorA.data);

save('data/item_all_id.mat', 'item_all_id');
len = length(item_all_id);

for loops=1:len
    SaveData(item_all_id(loops));
end

close(conn);