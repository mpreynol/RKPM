function H  = H( x,s,order )
%returns a column vector:
H=zeros(order+1,1);
for i=0:order
    H(i+1)=(x-s)^i;
end


end

