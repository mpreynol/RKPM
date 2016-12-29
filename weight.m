classdef Weight < handle
    %WEIGHT is a class of statics methods for the weighting function and
    %derivatice
    
    properties
        a; % Dilation Parameter
        s; % Weight Function Home location
        p=2; % Order of the Singularity
        singular=false; % Boolean Flag whether or not weight function is singular
    end
    
    methods
        % Construction
        function obj=Weight(s,a,varargin)
            obj.s=s;
            obj.a=a;
            if nargin>2
                obj.singular=varargin{1};
            end
        end
        
        % Singular Function 
        function f=f(obj,x)
           f=(((x-obj.s)/obj.a)^2*obj.p);
        end
        function df=df(obj,x)
           df=2*obj.p*(((x-obj.s)/obj.a))^(2*obj.p-1)*(1/obj.a);
        end
        
        % Weight Function
        function w = w(obj,x)
            z=abs(obj.s-x)/obj.a;   
            if z>=1
                w=0;
            elseif z<1/2
                w=2/3-4*z.^2+4*z.^3;
            else
                w=4/3-4*z+4*z.^2-4/3*z.^3;
            end
            if obj.singular
                w=w/obj.f(x);
            end
        end
        
        % Weight Function Derivative
        function wx=wx(obj,x)
            z=abs(obj.s-x)/obj.a;
            dz=(obj.s-x)/abs(obj.s-x)/obj.a;
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
            if obj.singular
               wx=(obj.f(x)*wx-obj.w(x)*obj.df(x))/(obj.f(x)^2);
            end
        end
    end
    
end