% ÔªËØÑ¹ÈëÕ»²Ù×÷
function S=op_Push(S,x)
if sub_isFull(S)
    disp('Error:Stack overflow!');
    return;
end
S.top=S.top+1;
S.Element(S.top)=x;
end