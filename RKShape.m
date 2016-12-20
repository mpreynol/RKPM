classdef RKShape < handle
    %Class defines a RKPM shape function 
    % Currently implemeted in 1D
    % Written by Mathew Reynolds on Dec 19, 2016
    
    properties
        nodeNumber; % Global Node Number for this Shape (Int)
        xI; % Nodal coordinates for Model (List, Double)
        a; % Dilation Parameter (Double)
        cordinates=[]; % Cordinates (list, Double)
        order; % Order of polynomial basis used
        n; % Number of Nodes in model
        M; % Moment Matrix
        Minv; % Stored value of matrix Invese
        Mdx; % Moment Matrix Derivative.
        Minvdx; % Inverse Derivative.
    end
    
    methods
        % Basic Function Set Up:
        function obj = RKShape(nodeNumber,xI,a,order)
            obj.setNodeNumber(nodeNumber);
            obj.setXI(xI);
            obj.setCordinates();
            obj.setDilation(a);
            obj.setOrder(order);
            obj.setN(xI);
        end
        function setNodeNumber(obj, nodeNumber)
           obj.nodeNumber = nodeNumber;
        end
        function setXI(obj,xI)
            obj.xI=xI;
        end
        function setCordinates(obj)
            obj.cordinates = obj.xI(obj.nodeNumber);
        end
        function setDilation(obj, a)
            obj.a=a;
        end
        function setOrder(obj,order)
            obj.order=order;
        end
        function setN(obj,xI)
            obj.n=size(xI,2);
        end
        
        
        function H=H(obj,x,s,order)
            %returns a column vector:
            H=zeros(order+1,1);
            for i=0:order
                H(i+1)=(x-s)^i;
            end
        end
        function H=Hdx(obj,x,s,order)
            %returns a column vector:
            H=zeros(order+1,1);
            H(1)=0;
            for i=1:order
                H(i+1)=(-1)^i*i*(x-s)^(i-1);
            end
        end
        
        % Processing for Value:
        % Define Moment Matrix:
        function setMoment(obj,x)
            Mi=zeros(obj.order+1);
            for i=1:(obj.n)
                if (abs(obj.xI(i)-x)<=obj.a) % Only use Nodes from inside dilation of current evaluatioin point
                    Mi=Mi+obj.H(obj.xI(i),x,obj.order)*obj.H(obj.xI(i),x,obj.order)'*Weight.w(obj.xI(i),x,obj.a);
                end
            end
            obj.M=Mi;
            obj.Minv=inv(obj.M);
        end
        % Define Value
        function v=getValue(obj,x)
            if abs(x-obj.cordinates)<=obj.a
                obj.setMoment(x);
                v=obj.H(x,x,obj.order)'*obj.Minv*obj.H(obj.cordinates,x,obj.order)*Weight.w(obj.cordinates,x,obj.a);
            else
                v=0;
            end
        end
        
        % Processing for Derivative:
        function setMomentdx(obj,x)
            Midx=zeros(obj.order+1);
            for i=1:obj.n
                if (abs(obj.xI(i)-x)<=obj.a) % Only use Nodes from inside dilation of current evaluatioin point
                    Midx=Midx+obj.Hdx(obj.xI(i),x,obj.order)*obj.H(obj.xI(i),x,obj.order)'*Weight.w(obj.xI(i),x,obj.a)+ ...
                        obj.H(obj.xI(i),x,obj.order)*obj.Hdx(obj.xI(i),x,obj.order)'*Weight.w(obj.xI(i),x,obj.a)+...
                        obj.H(obj.xI(i),x,obj.order)*obj.H(obj.xI(i),x,obj.order)'*Weight.wx(obj.xI(i),x,obj.a);
                end
            end
            obj.Mdx=Midx;
            obj.Minvdx=-obj.Minv*obj.Mdx*obj.Minv;
        end
        
        % Define Derivative:
        function vDx=getValueDx(obj,x)
            if abs(x-obj.cordinates)<=obj.a
                obj.setMoment(x); % This isn't eff! Need to find a way to only process it once per "point"
                obj.setMomentdx(x);
                vDx=obj.H(x,x,obj.order)'*(obj.Minvdx*obj.H(obj.cordinates,x,obj.order)*Weight.w(obj.cordinates,x,obj.a)+...
                    obj.Minv*obj.Hdx(obj.cordinates,x,obj.order)*Weight.w(obj.cordinates,x,obj.a)+...
                    obj.Minv*obj.H(obj.cordinates,x,obj.order)*Weight.wx(obj.cordinates,x,obj.a));
            else
                vDx=0;
            end
        end
        
        
    end
    
end

