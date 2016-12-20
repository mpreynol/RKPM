%% Plot one Shape Function Object:

x=0:0.1:10;
xI=0:1:10;
RK=RKShape(5,xI,2,1);
r=zeros(1,100);
dr=zeros(1,100);
for i=1:101
    r(i)=RK.getValue(x(i));
    dr(i)=RK.getValueDx(x(i));
end
plot(x,r)
hold on
plot(x,dr)

%% Create Shape Function Objects:
xI=0:1:10;
Shapes=RKShape.empty(size(xI,2),0);
dilation=2;
order=1;
for i=1:size(xI,2)
   Shapes(i)=RKShape(i,xI,dilation,order); 
end

%% Test Partion of Unity:
pu=0;
x=rand()*10;
for i=1:size(xI,2)
    pu=pu+Shapes(i).getValue(x);
end
assert(abs(pu-1.0)<5*eps)

%% Develop Mesh:
Q =QuadMesh(0,10,100,2);
Q.setElements()
