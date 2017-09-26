function edge_case=edge_case(bbox)
x=bbox(1);
y=bbox(2);
bw=bbox(3);
bh=bbox(4);
% if ~exist('height','var')
%     addpath('E:\auto confusion matrix\Pull\Confusion Matrix Auto\Base Images;');
%     img=imread('test_0001.jpg');
%     [height,width,dim]=size(img);
% end
height=720;
width=1280;
%create the 10% bounding box
border_percent=1;
x_border=border_percent/100*width;
y_border=border_percent/100*height;
xmin=x_border;
xmax=width-x_border;
ymin=y_border;
ymax=height-y_border;
xv=[xmin xmin xmax xmax];
yv=[ymin ymax ymax ymin];
if ~inpolygon(x,y,xv,yv)
    edge_case=1;
elseif ~inpolygon(x,y+bh,xv,yv)
    edge_case=1;
elseif ~inpolygon(x+bw,y+bh,xv,yv)
    edge_case=1;
elseif ~inpolygon(x+bw,y,xv,yv)
    edge_case=1;
else
    edge_case=0;
end
