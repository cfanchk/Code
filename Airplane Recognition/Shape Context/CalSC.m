function [sc_cost,aff_cost]=CalSC(V1,V2,nsamp,displayflag)

%%%
%%%Define flags and parameters:
%%%

eps_dum=0.25;
ndum_frac=0.25;        
mean_dist_global=[];
ori_weight=0.1;
nbins_theta=12;
nbins_r=5;
r_inner=1/8;
r_outer=2;
beta_init=1;
r=1; % annealing rate

%%%
%%% edge detection
%%%
[x2,y2,t2]=bdry_extract_3(V2);
nsamp2=length(x2);
if nsamp2>=nsamp
   [x2,y2,t2]=get_samples_1(x2,y2,t2,nsamp);
else
   error('shape #2 doesn''t have enough samples')
end
Y=[x2 y2];

% get boundary points
[x1,y1,t1]=bdry_extract_3(V1);

nsamp1=length(x1);
if nsamp1>=nsamp
   [x1,y1,t1]=get_samples_1(x1,y1,t1,nsamp);
else
   error('shape #1 doesn''t have enough samples')
end
X=[x1 y1];

%%%
%%% compute correspondences
%%%
Xk=X;
tk=t1;
k=1;
% s=1;
ndum=round(ndum_frac*nsamp);
out_vec_1=zeros(1,nsamp);
out_vec_2=zeros(1,nsamp);

[BH1,~]=sc_compute(Xk',zeros(1,nsamp),mean_dist_global,nbins_theta,nbins_r,r_inner,r_outer,out_vec_1);
[BH2,mean_dist_2]=sc_compute(Y',zeros(1,nsamp),mean_dist_global,nbins_theta,nbins_r,r_inner,r_outer,out_vec_2);

lambda_o=beta_init*r^(k-2);

beta_k=(mean_dist_2^2)*lambda_o;
costmat_shape=hist_cost_2(BH1,BH2);
theta_diff=repmat(tk,1,nsamp)-repmat(t2',nsamp,1);
costmat_theta=0.5*(1-cos(theta_diff));

costmat=(1-ori_weight)*costmat_shape+ori_weight*costmat_theta;
nptsd=nsamp+ndum;
costmat2=eps_dum*ones(nptsd,nptsd);

costmat2(1:nsamp,1:nsamp)=costmat;
cvec=hungarian(costmat2);

X2b=NaN*ones(nptsd,2);
X2b(1:nsamp,:)=X;
X2b=X2b(cvec,:);
Y2=NaN*ones(nptsd,2);
Y2(1:nsamp,:)=Y;  
     
ind_good=find(~isnan(X2b(1:nsamp,1)));
n_good=length(ind_good);
X3b=X2b(ind_good,:);
Y3=Y2(ind_good,:);

[cx,cy,~]=bookstein(X3b,Y3,beta_k);

aff_cost=[cx(n_good+2:n_good+3,:) cy(n_good+2:n_good+3,:)];
s=svd(aff_cost);
aff_cost=log(s(1)/s(2));

[a1,~]=min(costmat,[],1);
[a2,~]=min(costmat,[],2);
sc_cost=max(mean(a1),mean(a2));

if(displayflag)
    X2=NaN*ones(nptsd,2);
    X2(1:nsamp,:)=Xk;
    X2=X2(cvec,:);
    Y2=NaN*ones(nptsd,2);
    Y2(1:nsamp,:)=Y;
    
    figure;
    plot(X2(:,1),-X2(:,2),'b+',Y2(:,1),-Y2(:,2),'ro')
    hold on
    plot([X2(:,1) Y2(:,1)]',[-X2(:,2) -Y2(:,2)]','k-');
end