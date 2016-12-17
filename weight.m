function w = weight( x,s,a )
z=abs(s-x)/a;
if z>=1
    w=0;
elseif z<1/2
    w=2/3-4*z.^2+4*z.^3;
else
    w=4/3-4*z+4*z.^2-4/3*z.^3;
end
end

