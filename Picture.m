classdef Picture < handle
    % creates of a sample of picture with black background
    % it's supposed that this picture will be a 256-gray gradation (U8)
    % image (the pixel value should lay in the range 0...255)
    properties
        s; % size of the picture (in pixels) 
        I; % picture itself - matrix with pixel values (square matrix)
    end
    
    %% constructor
    methods
        function bckgr = Picture(size)
            % constuctor
            size=uint16(size); % transfer input number to non-zero integer value (size)
            if size>0
                bckgr.s=size; % assign the size of a picture
            end  
        end
    end
    %% make a black background
    methods
        function [] = bckgr(Picture)
            Picture.I = zeros(Picture.s,Picture.s,'uint8'); % create the black (zero) background 
        end
    end
    
   %% assign (draw) a pixel value in a picture
   methods
       function [] = draw(Picture,i,j,val)
           size=Picture.s; % get the picture size
           if (i>=0)&&(j>=0)&&(i<size)&&(j<size)
               if (Picture.I(i,j)+val)<256
                   Picture.I(i,j)=Picture.I(i,j)+val;
               else Picture.I(i,j)=255;
               end
               
           end
       end
   end
    
end

