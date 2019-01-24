classdef SpatialMask < handle
    % Container for a generation of various spatial masks 
    %   LoG, Gaussian mask generation
    
    properties
        size; % spatial size of a mask
        type; % specifying the type of a mask
        M; % container for a pixel data (mask itself)
        sum; % variable for a calibration
    end
    
    %% constructor
    methods
        function mask=SpatialMask(size,type)
            if (size>0)&&(isa(type,'char'))
                size=uint16(size); size=double(size); % additional conversion
                mask.size=size; mask.type=type;
                if type == 'Gauss'
                   sum=0; % for a calibration purposes
                   matrix_size=4*size+1; % definining a spatial mask for a filter
                   av=2*size+1; av=double(av); % the picture center
                   % the influence of spatial masl (matrix or picture size)
                   % shouldn't be so critical for a convolution output
                   M = zeros(matrix_size,matrix_size,'double'); % initialize a mask matrix (picture)
                   for i=1:1:matrix_size
                       for j=1:1:matrix_size
                           M(i,j)=exp(-(((i-av)^2)+((j-av)^2))/(2*(size^2))); % classical Gaussian distribution
                           sum=sum+M(i,j); % for a calibration
                       end
                   end
                   mask.M=M; clear('M'); mask.sum=sum; clear('sum'); % save generated values and clear variables
                end
            end
        end
    end
    
end

