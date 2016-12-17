function w = weightdx( x,s,a )

z=abs(s-x)/a;
dz=(s-x)/abs(s-x)/a;
if z<eps && z>-eps
    dz=0;
end
if z>=1
    w=0;
elseif z<1/2
    w=-8*z*dz+12*z.^2*dz;
else
    w=-4*dz+8*z*dz-4*z.^2*dz;
end
end

