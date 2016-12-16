% Domain:
xI=0:1:10;

%% For a Single Shape Function:
ShapeFunction=5;
XI=xI(ShapeFunction);
order=1;
xsample=0:0.1:10;
N=zeros(length(xsample),1);
h=1*2; % Dilation Parameter
for t=1:length(xsample)
    x=xsample(t);
    % Moment Matrix:s
    M=zeros(order+1);
    for i=1:length(xI)
        Mi=H(xI(i),x,order)*H(xI(i),x,order)'*weight(xI(i),x,h);
        M=M+Mi;
    end
    N(t)=H(x,x,order)'*inv(M)*H(XI,x,order)*weight(XI,x,h);
end
plot(xsample,N,'.')
%% For a Single Shape Function Derivative
ShapeFunction=5;
XI=xI(ShapeFunction);
order=1;
xsample=0:0.1:10;
N=zeros(length(xsample),1);
h=1*2; % Dilation Parameter
for t=1:length(xsample)
    x=xsample(t);
    % Moment Matrix:s
    M=zeros(order+1);
    for i=1:length(xI)
        Mi=H(xI(i),x,order)*H(xI(i),x,order)'*weight(xI(i),x,h);
        M=M+Mi;
    end
    N(t)=H(x,x,order)'*inv(M)*H(XI,x,order)*weight(XI,x,h);
end
plot(xsample,N,'.')

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