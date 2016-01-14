% SMO算法实现，原文《Sequential Minimal Optimization:A Fast Algorithm for Training Support Vector Machines》
function [Alpha,w,b]=sub_SMO(train_matrix,train_label,C)
num=size(train_matrix,1);
dimesion=size(train_matrix,2);

Alpha=zeros(num,1);
w=zeros(1,dimesion);
b=0;

numChanged=0;
examineAll=1;
while(numChanged>0||examineAll)
    numChanged=0;
    
    index=Alpha~=0&Alpha~=C;
    NONCindex=find(index);
    N0NCnum=sum(index);
    
    if(examineAll)
        for i=1:num
            [Alpha,w,b,status]=sub_examineExample(train_matrix,train_label,Alpha,w,b,i,C,NONCindex);
            numChanged=numChanged+status;
        end
    else
        for i=1:N0NCnum
            [Alpha,w,b,status]=sub_examineExample(train_matrix,train_label,Alpha,w,b,NONCindex(i),C,NONCindex);
            numChanged=numChanged+status;
        end
    end
    
    if(examineAll==1)
        examineAll=0;
    elseif(numChanged==0)
        examineAll=1;
    end
end
end

function [alpha1new,alpha2new,b,status]=sub_takeStep(x1,x2,o1,o2,y1,y2,alpha1,alpha2,b,C)
if(x1==x2)
    alpha1new=alpha1;
    alpha2new=alpha2;
    status=0;
    return;
end

E1=o1-y1;
E2=o2-y2;
s=y1*y2;
if(y1~=y2)
    Zeta=alpha1-alpha2;
    L=max(0,-Zeta);
    H=min(C,C-Zeta);
else
    Zeta=alpha1+alpha2;
    L=max(0,Zeta-C);
    H=min(C,Zeta);
end
if(L==H)
    alpha1new=alpha1;
    alpha2new=alpha2;
    status=0;
    return;
end

k11=x1*x1';
k12=x1*x2';
k22=x2*x2';
eta=k11+k22-2*k12;
if(eta>0)
    alpha2new=alpha2+y2*(E1-E2)/eta;
    if(alpha2new<L), alpha2new=L;
    elseif(alpha2new>H), alpha2new=H;
    end
else
    f1=y1*(E1+b)-alpha1*k11-s*alpha2*k12;
    f2=y2*(E2+b)-s*alpha1*k12-alpha2*k22;
    L1=alpha1+s*(alpha2-L);
    H1=alpha1+s*(alpha2-H);
    LObj=L1*f1+L*f2+0.5*L1^2*k11+0.5*L^2*k22+s*L*L1*k12;
    HObj=H1*f1+H*f2+0.5*H1^2*k11+0.5*H^2*k22+s*H*H1*k12;
    if(LObj<HObj-eps)
        alpha2new=L;
    elseif(LObj>HObj+eps)
        alpha2new=H;
    else
        alpha2new=alpha2;
    end
end

if(alpha2new<1e-8)
    alpha2new=0;
elseif(alpha2new>C-1e-8)
    alpha2new=C;
end

if(abs(alpha2new-alpha2)<eps*(alpha2new+alpha2+eps))
    alpha1new=alpha1;
    alpha2new=alpha2;
    status=0;
    return;
end

alpha1new=alpha1+s*(alpha2-alpha2new);
if(alpha1new<1e-8)
    alpha1new=0;
elseif(alpha1new>C-1e-8)
    alpha1new=C;
end

b1new=E1+y1*(alpha1new-alpha1)*k11+y2*(alpha2new-alpha2)*k12+b;
b2new=E2+y1*(alpha1new-alpha1)*k12+y2*(alpha2new-alpha2)*k22+b;
if(alpha1new>0&&alpha1new<C)
    b=b1new;
elseif(alpha2new>0&&alpha2new<C)
    b=b2new;
else
    b=(b1new+b2new)/2;
end
status=1;
end

function [Alpha,w,b,status]=sub_examineExample(Feature,Label,Alpha,w,b,ind,C,N0NC_index)
num=size(Feature,1);
dimesion=size(Feature,2);
N0NC_num=length(N0NC_index);

tol=1e-6;
status=0;

Out=(w*Feature'-b)';
x2=Feature(ind,:);
y2=Label(ind);
o2=Out(ind);
alpha2=Alpha(ind);
E2=o2-y2;
r2=E2*y2;

if((r2<-tol&&alpha2<C)||(r2>tol&&alpha2>0))
    if(N0NC_num>1)
        [~,index]=max(abs(Out-Label-E2));
        x1=Feature(index,:);
        y1=Label(index);
        o1=Out(index);
        alpha1=Alpha(index);
        [alpha1new,alpha2new,b,status]=sub_takeStep(x1,x2,o1,o2,y1,y2,alpha1,alpha2,b,C);
        if(status==1)
            Alpha(ind)=alpha2new;
            Alpha(index)=alpha1new;
            w=sum(Feature.*repmat(Label,1,dimesion).*repmat(Alpha,1,dimesion));
            return;
        end
    end
    
    loop=1;
    ran_ind=floor(1+(N0NC_num)*rand);
    while(loop<=N0NC_num)
        temp_ind=N0NC_index(ran_ind);
        x1=Feature(temp_ind,:);
        y1=Label(temp_ind);
        o1=Out(temp_ind);
        alpha1=Alpha(temp_ind);
        [alpha1new,alpha2new,b,status]=sub_takeStep(x1,x2,o1,o2,y1,y2,alpha1,alpha2,b,C);
        if(status==1)
            Alpha(ind)=alpha2new;
            Alpha(temp_ind)=alpha1new;
            w=sum(Feature.*repmat(Label,1,dimesion).*repmat(Alpha,1,dimesion));
            return;
        end
        
        if(ran_ind==N0NC_num)
            ran_ind=1;
        else
            ran_ind=ran_ind+1;
        end
        loop=loop+1;
    end
    
    loop=1;
    ran_ind=floor(1+(N0NC_num)*rand);
    while(loop<=num)
        x1=Feature(ran_ind,:);
        y1=Label(ran_ind);
        o1=Out(ran_ind);
        alpha1=Alpha(ran_ind);
        [alpha1new,alpha2new,b,status]=sub_takeStep(x1,x2,o1,o2,y1,y2,alpha1,alpha2,b,C);
        if(status==1)
            Alpha(ind)=alpha2new;
            Alpha(ran_ind)=alpha1new;
            w=sum(Feature.*repmat(Label,1,dimesion).*repmat(Alpha,1,dimesion));
            return;
        end
        
        if(ran_ind==num)
            ran_ind=1;
        else
            ran_ind=ran_ind+1;
        end
        loop=loop+1;
    end
end
end