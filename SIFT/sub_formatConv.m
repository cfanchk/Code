function Ipoint=sub_formatConv(DoGCorner)
OctaveNum=size(DoGCorner,2);
S=size(DoGCorner{1},3);
Ipoint=cell(1,OctaveNum);

for i=1:OctaveNum
    Ipoint{i}.r=size(DoGCorner{i},1);
    Ipoint{i}.c=size(DoGCorner{i},2);
    for j=1:S
        [ipointr,ipointc]=find(DoGCorner{i}(:,:,j));
        Ipoint{i}.Coor{j}=[ipointr,ipointc];
    end
end
end