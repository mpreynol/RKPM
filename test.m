%% Plot one Shape Function Object:

x=0:0.01:pi/2;
xI=0:pi/2/5:pi/2;
RK=RKShape(6,xI,pi/2/5*2,1);
r=zeros(1,length(x));
dr=zeros(1,length(x));
for i=1:length(x)
    r(i)=RK.getValue(x(i));
    dr(i)=RK.getValueDx(x(i));
end
plot(x,r)
hold on
plot(x,dr)

%% Create Shape Function Objects:
xI=0:pi/2/2:pi/2;
Shapes=RKShape.empty(size(xI,2),0);
dilation=pi/2/2*2;
order=1;
for i=1:size(xI,2)
   Shapes(i)=RKShape(i,xI,dilation,order); 
end

%% Test Partion of Unity:
pu=0;
x=rand()*1.5;
for i=1:size(xI,2)
    pu=pu+Shapes(i).getValue(x);
end
assert(abs(pu-1.0)<5*eps)

%% Develop Mesh:
Q =QuadMesh(0,pi/2,5,1);
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
        for i=1:n % Loop over Shape Functions
            for j=1:n % Loop over Shape Functions
                K(i,j)=K(i,j)+1/5*Shapes(i).getValueDx(intCordinate)*Shapes(j).getValueDx(intCordinate)*intWeight*intJacobian;
            end
            F(i)=F(i)+Shapes(i).getValue(intCordinate)*sin(intCordinate)*intWeight*intJacobian;
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
       Result(g)=Result(g)+Shapes(i).getValue(x)*d(i);
    end
end
plot(xI,Result)
