profile on

%% Create Shape Function Objects:
no=(1:11)';
xI=(0:pi/2/10:pi/2)';
a=pi/2/10*2;
order=1;
a=ones(length(xI),1)*a;
padding=zeros(length(xI),1);
Nodes=[no,xI,a,padding];
PointCloud=Cloud(Nodes,order);

%% Develop Mesh:
Q =QuadMesh(0,pi/2,10,2);
Q.setElements()

%% Develop Matrices:
n=length(xI);
K=zeros(n);
F=zeros(n,1);
for k=1:Q.noElements % Loop over Integration zones
    for l=1:Q.quadrature % Loop over integration point
        intCordinate=Q.Elements(k).getGlobalX(Q.Elements(k).qPoints(l,1));
        intWeight=Q.Elements(k).qPoints(l,2);
        intJacobian=Q.Elements(k).jV;
        for i=1:n % Loop over Cloud
            for j=1:n % Loop over Cloud
                K(i,j)=K(i,j)+1/5*PointCloud.Nodes(i).sF.getValueDx(intCordinate)*PointCloud.Nodes(j).sF.getValueDx(intCordinate)*intWeight*intJacobian;
            end
            F(i)=F(i)+PointCloud.Nodes(i).sF.getValue(intCordinate)*sin(intCordinate)*intWeight*intJacobian;
        end
    end
end

%% Solve System:
uUnknown=ones(n,1)*-inf; uUnknown(1)=0; logical=(uUnknown==-inf);
Kr=K(logical,logical); Fr=F(logical);
dr=Kr\Fr;
d=[0;dr];

%% Interpolate the Solution
Result=zeros(length(xI),1);
for g=1:length(xI)
    x=xI(g);
    for i=1:n
       Result(g)=Result(g)+PointCloud.Nodes(i).sF.getValue(x)*d(i);
    end
end
plot(xI,Result)
