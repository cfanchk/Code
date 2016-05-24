function class = sub_MomentRec(Img)
class = 0;
proto = imread('D:\Origin.png');
proto = rgb2gray(proto);
proto = imresize(proto, size(Img));
proto = double(proto/255);
% figure;imshow(proto);

%% Hu��
HuMoment = calHuMoment(Img);

%% Zernike��
n = 4; m = 2;  % Define the order and the repetition of the moment
[~,ZernikeMoment,~] = calZernikeMoment(Img,n,m);

%% ���䲻���
ind = [0.1,0.1];
MSAMoment = calMSAMoment(Img,ind);


%% �ۺ����
if(norm(HuMoment)>0)
    class = 1;
end
end