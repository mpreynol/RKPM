classdef QuadMesh < handle
    %QUADMESH is a quadrature mesh for RKPM
    
    properties
        quadrature; % level of quadrature for mesh
        xmin; % xmin for the mesh
        xmax; % xmax for the mesh
        X; % Array of Grid Points
        noElements; % No. for elements
        Elements; % Collection of Element Objects
    end
    
    methods
        function obj=QuadMesh(xmin,xmax,noElements,quadrature)
            obj.quadrature=quadrature;
            obj.xmin=xmin;
            obj.xmax=xmax;
            obj.noElements=noElements;
            obj.Elements=Element.empty(noElements,0); % Declare Empty Collection
            obj.setArray();
        end
        function setArray(obj)
            obj.X=obj.xmin:(obj.xmax-obj.xmin)/obj.noElements:obj.xmax;
        end
        function setElements(obj)
           for i=1:obj.noElements
               obj.Elements(i)=Element(obj.X(i),obj.X(i+1),obj.quadrature);
           end
        end
    end
    
end

