% ά�����ȶ��У���С�ѣ������ӳ���
function A=sub_minHeapify(A,i,heapsize)
Left=@(i) 2*i;
Right=@(i) 2*i+1;

l=Left(i);
r=Right(i);

if l<=heapsize && A(l)<A(i)
    smallest=l;
else
    smallest=i;
end
if r<=heapsize && A(r)<A(smallest)
    smallest=r;
end
if smallest~=i
    temp=A(i);
    A(i)=A(smallest);
    A(smallest)=temp;
    A=sub_minHeapify(A,smallest,heapsize);
end
end