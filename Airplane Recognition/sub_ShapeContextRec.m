function class = sub_ShapeContextRec(Img, displayflag)
class = 0;
proto = imread('D:\Originpq.png');
proto = rgb2gray(proto);
proto = imresize(proto, size(Img));
proto = double(proto/255);

nsamp = 150;
[sc_cost,~] = CalSC(Img, proto, nsamp, displayflag);

if(sc_cost<0.2)
    class = 1;
end

end