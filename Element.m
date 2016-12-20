classdef Element < handle
    %ELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xmin % Limits for Element
        xmax % Limits for Element
        quadrature % No Points in Quadrature
        jV % Jacobian for Integration
        qPoints; % List of Quadrature Points
    end
    
    methods 
        function obj=Element(xmin,xmax,quadrature)
           obj.xmin=xmin;
           obj.xmax=xmax;
           obj.quadrature=quadrature;
           obj.jV=(xmax-xmin)/2;
           obj.qPoints=Quadrature.oneDim(obj.quadrature);
        end
    end
    
end

