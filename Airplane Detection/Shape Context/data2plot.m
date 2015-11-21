files=dir('D:\temptest\*.png');
str='D:\result\';
pf=[35,30,40,30,30,35,30,40,30,40,30,20,30,35,20,25,20,30,25,30];
for loops=1:20
    ima1=imread(['D:\temptest\' files(loops).name]);
    figure,imshow(ima1),title('½á¹û');
    hold on
    coor=coord{loops};
    k=size(coor,1);
    f=pf(loops);
    for i=1:k
        rectangle('Position',[coor(i,2),coor(i,1),f,f],'EdgeColor','r');
        hold on
    end
    print(gcf,'-dpng',[str,num2str(loops),'.png']);
    clearvars coor;
end