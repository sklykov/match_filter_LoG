classdef SpatialMask < handle
    % Container for a generation of various spatial masks 
    %   LoG, Gaussian mask generation
    
    properties
        size; % spatial size of a mask
        type; % specifying the type of a mask
        M; % container for a pixel data (mask itself)
        sum; % variable for a calibration
        MLoGC; % container for storing of a LoG calibrated mask
    end
    
    %% constructor
    methods
        function mask=SpatialMask(size,type)
            if (size>0)&&(isa(type,'char'))
                size=uint16(size); size=double(size); % additional conversion
                mask.size=size; mask.type=type;
                if type == 'G'
                   sum=0; % for a calibration purposes
                   matrix_size=4*size+1; % definining a spatial mask for a filter
                   av=2*size+1; av=double(av); % the picture center
                   % the influence of spatial masl (matrix or picture size)
                   % shouldn't be so critical for a convolution output
                   M = zeros(matrix_size,matrix_size,'double'); % initialize a mask matrix (picture)
                   for i=1:1:matrix_size
                       for j=1:1:matrix_size
                           M(i,j)=exp(-(((i-av)^2)+((j-av)^2))/(2*(size^2))); % the classic Gaussian distribution
                           sum=sum+M(i,j); % for a calibration
                       end
                   end
                   mask.M=M; clear('M'); mask.sum=sum; clear('sum'); % save generated values and clear variables
                elseif type == 'L'
                   sum=0; % for a calibration purposes
                   matrix_size=6*size+1; % size of a LoG mask is bigger than Gaussian ones... To be tested?
                   av=3*size+1; av=double(av); % the picture center (an odd number)
                   M = zeros(matrix_size,matrix_size,'double'); % initialize a mask matrix (picture)
                   for i=1:1:matrix_size
                       for j=1:1:matrix_size
                           x=i-av; y=j-av; % for equation writing simplification
                           M(i,j)=(2*(size^2)-x^2-y^2)*exp(-(x^2+y^2)/(2*(size^2))); % the LoG distribution
                           sum=sum+M(i,j); % for a calibration
                       end
                   end
                   mask.M=M; clear('M'); mask.sum=sum; clear('sum'); % save generated values
                end
            end
        end
    end
    
    %% special function - show a LoG mask
    methods
        function []=showLoG(SpatialMask,type)
            if SpatialMask.type == 'L'
                if type == 'p'
                    D=SpatialMask.M; % a buffer
                    double minM; minM=min(min(D)); D=D-minM; % makes all values positive
                    double maxM; maxM=max(max(D)); D=D*(255/maxM); % calibration to U8 type image
                    SpatialMask.MLoGC=cast(D,'uint8'); clear('D'); % save values adn clear buffer
                elseif type == 'n'
                    D=SpatialMask.M; % a buffer
                    D=-D; % inversing a mask
                    double maxM; maxM=max(max(D)); D=D*(255/maxM); % calibration to U8 type image
                    SpatialMask.MLoGC=cast(D,'uint8'); clear('D'); % save values adn clear buffer
                end
            end
        end
    end
end

