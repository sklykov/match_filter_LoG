classdef FluObj
    % The class - container for a fluorescent object generation
    
    properties
        d; % characteristic size
        shape; % type of a shape
        borddist; % character distance from a boarder of an image
    end
    
    %% tradionally, a constructor
    methods
        function obj=FluObj(size,shape_type)
            if (size>0) && (isa(shape_type,'char'))
                obj.d=uint16(size); obj.shape=shape_type;
                if shape_type == 'G'; % generation of Gaussian-shape object
                    obj.borddist=3*obj.d; % characteristic of distance from a center to an image border
                end
            else warning('not proper initialization');
            end   
        end
    end
    %% Returning of Gaussian shape as a single pixel value
    methods
        % generation of Gaussian shape
        function p=gauss(FluObj,xC,yC,x,y)
            if FluObj.shape == 'G';
                sigma=double(FluObj.d); % additional conversion
                x=double(x); y=double(y); xC=double(xC); yC=double(yC);
                p=255*exp(-(((x-xC)^2)+((y-yC)^2))/(2*(sigma^2))); % calculate pixel value
                p=cast(p,'uint8'); % round it to the nearest even number
            else p=0; p=cast(p,'uint8'); % return 'uint8' value
            end
        end
    end
end

