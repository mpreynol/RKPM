classdef RKShape < handle
    %Class defines a RKPM shape function 
    % Currently implemeted in 1D
    % Written by Mathew Reynolds on Dec 19, 2016
    
    properties
        a; % Dilation Parameter (Double)
        cordinates=[]; % Cordinates (list, Double)
        order; % Order of polynomial basis used
        Cloud; % Cloud Data Handle
        weight; % Weight Data Handle (from This Node)
        M; % Moment Matrix
        Minv; % Stored value of matrix Invese
        Mdx; % Moment Matrix Derivative.
        Minvdx; % Inverse Derivative.
    end
    
    methods
        % Constructor:
        function obj = RKShape(cordinates,a,order,Cloud,weight)
            obj.cordinates=cordinates;
            obj.a=a;
            obj.order=order;
            obj.Cloud=Cloud;
            obj.weight=weight;
        end
        
        function test(obj)
           for i=1:5
           end
        end
        
        
        % Basis Vectors
        function H=H(obj,x)
            H=zeros(obj.order+1,1);
            for i=0:obj.order
                H(i+1)=(x-obj.cordinates)^i;
            end
        end
        function H=Hdx(obj,x)
            H=zeros(obj.order+1,1);
            H(1)=0;
            for i=1:obj.order
                H(i+1)=(-1)^i*i*(x-obj.cordinates)^(i-1);
            end
        end
        
        % Processing for Value:
        % Define Moment Matrix:
        function setMoment(obj,x)
            Mi=zeros(obj.order+1);
            for i=1:(obj.Cloud.numberOfNodes) % Loop through other Nodes in the Mesh
                if abs(obj.Cloud.Nodes(i).cordinates-x)<obj.a % Only use Nodes from inside dilation of current evaluatioin point
                    Mi=Mi+obj.Cloud.Nodes(i).sF.H(x)*obj.Cloud.Nodes(i).sF.H(x)'*obj.Cloud.Nodes(i).weight.w(x);
                end
            end
            obj.M=Mi;
            if sum(isnan(obj.M))>0
                obj.M=zeros(obj.order+1);
                obj.Minv=obj.M;
            else
               obj.Minv=inv(obj.M); 
            end
            
        end
        
        % Define Value
        function v=getValue(obj,x)
            if abs(x-obj.cordinates)<=obj.a
                if (x==obj.cordinates && obj.weight.singular)
                    v=1;
                else
                    obj.setMoment(x);
                    v=obj.H(obj.cordinates)'*obj.Minv*obj.H(x)*obj.weight.w(x);
                end
            else
                v=0;
            end
        end
        
        %% Not Finished Updating!:
        % Processing for Derivative:
        function setMomentdx(obj,x)
            Midx=zeros(obj.order+1);
            for i=1:(obj.Cloud.numberOfNodes)
                if abs(obj.Cloud.Nodes(i).cordinates-x)<obj.a % Only use Nodes from inside dilation of current evaluatioin point
                    Midx=Midx+obj.Cloud.Nodes(i).sF.Hdx(x)*obj.Cloud.Nodes(i).sF.H(x)'*obj.Cloud.Nodes(i).weight.w(x)+ ...
                        obj.Cloud.Nodes(i).sF.H(x)*obj.Cloud.Nodes(i).sF.Hdx(x)'*obj.Cloud.Nodes(i).weight.w(x)+...
                        obj.Cloud.Nodes(i).sF.H(x)*obj.Cloud.Nodes(i).sF.H(x)'*obj.Cloud.Nodes(i).weight.wx(x);
                end
            end
            
            obj.Mdx=Midx;
            
              if sum(isnan(obj.Mdx))>0
                  obj.Mdx;
              end
            obj.Minvdx=-obj.Minv*obj.Mdx*obj.Minv;
        end
        
        % Define Derivative:
        function vDx=getValueDx(obj,x)
            if abs(x-obj.cordinates)<=obj.a
                obj.setMoment(x); % This isn't eff! Need to find a way to only process it once per "point"
                obj.setMomentdx(x);
                vDx=obj.H(obj.cordinates)'*(obj.Minvdx*obj.H(x)*obj.weight.w(x)+...
                    obj.Minv*obj.Hdx(x)*obj.weight.w(x)+...
                    obj.Minv*obj.H(x)*obj.weight.wx(x));
            else
                vDx=0;
            end
        end
        
    end
    
end

