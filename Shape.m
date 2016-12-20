% Domain:
xI=0:1:10;

%% Plot the Weight Functions
xsample=0:0.1:10;
ShapeFunction=5;
XI=xI(ShapeFunction);
h=2;
w=zeros(length(xsample),1);
wdx=zeros(length(xsample),1);
for i =1:length(xsample);
    x=xsample(i);
    w(i)=weight(XI,x,h);
    wdx(i)=weightdx(XI,x,h);
end
plot(xsample,w,'o')
hold on
plot(xsample,wdx,'o')

%% For a Single Shape Function:
ShapeFunction=5;
XI=xI(ShapeFunction);
order=1;
xsample=0:0.1:10;
N=zeros(length(xsample),1);
h=1*2; % Dilation Parameter
% for t=1:length(xsample)
    x=8;
    % Moment Matrix:s
    M=zeros(order+1);
    for i=1:length(xI)
        Mi=H(xI(i),x,order)*H(xI(i),x,order)'*weight(xI(i),x,h)
        M=M+Mi;
    end
    N(t)=H(x,x,order)'*inv(M)*H(XI,x,order)*weight(XI,x,h);
% end
plot(xsample,N,'.')
%% For a Single Shape Function Derivative
ShapeFunction=5;
XI=xI(ShapeFunction);
order=1;
xsample=0:0.1:10;
N=zeros(length(xsample),1);
Ndx=N;
h=1*2; % Dilation Parameter
for t=1:length(xsample)
    x=xsample(t);
    % Moment Matrix:s
    M=zeros(order+1);
    Mdx=M;
    for i=1:length(xI)
        M=M+H(xI(i),x,order)*H(xI(i),x,order)'*weight(xI(i),x,h);
        Mdx=Mdx+Hdx(xI(i),x,order)*H(xI(i),x,order)'*weight(xI(i),x,h)+ ...
            H(xI(i),x,order)*Hdx(xI(i),x,order)'*weight(xI(i),x,h)+...
            H(xI(i),x,order)*H(xI(i),x,order)'*weightdx(xI(i),x,h);
    end
    Minvdx=-inv(M)*Mdx*inv(M);
    N(t)=H(x,x,order)'*inv(M)*H(XI,x,order)*weight(XI,x,h);
    Ndx(t)=H(x,x,order)'*(Minvdx*H(XI,x,order)*weight(XI,x,h)+...
        inv(M)*Hdx(XI,x,order)*weight(XI,x,h)+...
        inv(M)*H(XI,x,order)*weightdx(XI,x,h));
end
plot(xsample,N,'.')
hold on
plot(xsample,Ndx,'.')

%% For All Shape Functions
for k=1:length(xI)
XI=xI(k);
order=2;
h=1*3; % Dilation Parameter
xsample=0:0.1:10;
N=zeros(length(xsample),1);

for j=1:length(xsample)
    x=xsample(j);
    % Moment Matrix:
    M=zeros(order+1);
    for i=1:length(xI)
        M=M+H(xI(i),x,order)*H(xI(i),x,order)'*weight(xI(i),x,h);
    end
    N(j)=H(x,x,order)'*inv(M)*H(XI,x,order)*weight(XI,x,h);
end
plot(xsample,N)
hold on
end