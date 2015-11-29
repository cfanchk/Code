% µ¯³öÕ»¶¥ÔªËØ²Ù×÷
function [S,x]=op_Pop(S)
if sub_isEmpty(S)
    disp('Error:Stack underflow!');
    x=NaN;
    return;
end
S.top=S.top-1;
x=S.Element(S.top+1);
end