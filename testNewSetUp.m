%% Test Node Object
n1=RKNode(5,0.5,1,1);

%% Test Point Cloud:
no=(1:11)';
xI=(0:0.1:1)';
a=0.2;
order=1;
a=ones(length(xI),1)*a;
padding=zeros(length(xI),1);
Nodes=[no,xI,a,padding];
Nodes(5,4)=1;
PointCloud=Cloud(Nodes,order);

%% Test Weight Function
x=0:0.01:1;
y=zeros(length(x),1);
for i=1:length(x)
   y(i)=PointCloud.Nodes(5).weight.w(x(i));
end
plot(x,y)

%% Test Shape Function
x=0:0.01:1;
y=zeros(length(x),1);
for j=1:PointCloud.numberOfNodes
    for i=1:length(x)
       y(i)=PointCloud.Nodes(j).sF.getValue(x(i));
    end
    plot(x,y)
    hold on
end

%% Test Partition of Unity
for i=1:1000
    xTest=rand();
    pu=0;
    for i=1:PointCloud.numberOfNodes
        pu=pu+PointCloud.Nodes(i).sF.getValue(xTest);
    end
    plot(xTest,pu-1,'b+')
    hold on
end

%% Test Shape Function Derivatives
x=0:0.001:1;
y=zeros(length(x),1);
for j=1:PointCloud.numberOfNodes
    for i=1:length(x)
       y(i)=PointCloud.Nodes(j).sF.getValueDx(x(i));
    end
    plot(x,y,'-')
    hold on
end


