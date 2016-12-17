function H  = Hdx( x,s,order )
%returns a column vector:
H=zeros(order+1,1);
H(1)=0;
for i=1:order
    H(i+1)=(-1)^i*i*(x-s)^(i-1);
end


end

