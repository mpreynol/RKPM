classdef Weight < handle
    %WEIGHT is a class of statics methods for the weighting function and
    %derivatice
    
    properties
    end
    
    methods(Static)
        function w = w(x,s,a)
            z=abs(s-x)/a;   
            if z>=1
                w=0;
            elseif z<1/2
                w=2/3-4*z.^2+4*z.^3;
            else
                w=4/3-4*z+4*z.^2-4/3*z.^3;
            end
        end
        function wx=wx(x,s,a)
            z=abs(s-x)/a;
            dz=(s-x)/abs(s-x)/a;
            if z<eps && z>-eps
                dz=0;
            end
            if z>=1
                wx=0;
            elseif z<1/2
                wx=-8*z*dz+12*z.^2*dz;
            else
                wx=-4*dz+8*z*dz-4*z.^2*dz;
            end
        end
    end
    
end

