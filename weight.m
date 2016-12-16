function w = weight( x,s,h )
d=abs(x-s); d(d>h)=h;
w=(1-d/h).^4.*(4*d/h+1);


end

