% ���ȶ���Ԫ�عؼ��ּ�С������Ԫ��i�Ĺؼ��ּ�С��key
function A=op_DecreaseKey(A,i,key)
Parent=@(i) floor(i/2);

if key>A(i)
    disp('Error:New key is bigger than current key!');
    return;
end
A(i)=key;

while i>1 && A(Parent(i))>A(i)
    temp=A(i);
    A(i)=A(Parent(i));
    A(Parent(i))=temp;
    i=Parent(i);
end
end