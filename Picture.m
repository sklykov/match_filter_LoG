classdef Picture < handle
    % creates of a sample of picture with black background
    % it's supposed that this picture will be a 256-gray gradation (U8)
    % image (the pixel value should lay in the range 0...255)
    properties
        s; % size of the picture (in pixels) 
        I; % picture itself - matrix with pixel values (square matrix)
        FI; % container for a filtered image 
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
   % simply set a pixel value no more than 255 
   methods
       function [] = draw(Picture,i,j,val)
           size=Picture.s; % get the picture size
           if (i>=0)&&(j>=0)&&(i<size)&&(j<size)
               i=uint16(i); j=uint16(j); % additional conversion
               if (Picture.I(i,j)+val)<256
                   Picture.I(i,j)=Picture.I(i,j)+val; % sum pixel values
               else Picture.I(i,j)=255; % assign maximal pixel value
               end
               Picture.I=cast(Picture.I,'uint8'); % additional conversation
           end
       end
   end
   
   %% draw a single object with some shape
   % simple drawing - object doens't touch the border
   methods
       function []=fuse(Picture,object_size,object_type,xC,yC)
           [m,~]=size(Picture.I); % get the size of a row in a picture
           if m>1 % check that background has been created before
               obj=FluObj(object_size,object_type); % sample of an object
               % the following long condition - for fuse a grid inside
               % pictire with taking into account its borders
               if ((xC>=obj.borddist)||(xC<=Picture.s-obj.borddist-1))&&((yC>=obj.borddist)||(yC<=Picture.s-obj.borddist-1))
                   minX=xC-obj.borddist; minY=yC-obj.borddist; % get the minimal values for object drawing
                   maxX=xC+obj.borddist; maxY=yC+obj.borddist; % get the maximal values for object drawing
                   for i=minX:1:maxX
                       for j=minY:1:maxY
                           Picture.draw(i,j,obj.gauss(xC,yC,i,j)); % assigning each pixel value
                       end
                   end
               end
           end
       end
   end
   
   %% draw a grid - collection of objects in different distances
   % main parameter - distance between objects
   methods
       function []=grid(Picture,object_size,object_type,distance)
           d=distance; % for a simplification
           obj=FluObj(object_size,object_type); % sample of an object
           [m,~]=size(Picture.I); % get the size of a row in a picture
           l=m-2*obj.borddist; % available length to fit objects
           N=1; % number of objects which can be drawn in a line
           while (l-N*d)>0
               N=N+1; % count the even number of objects fitted in a line
           end
           if (l-N*d)==0 
               N=N+1; % additional case for symmetrical cases (picture, objects sizes)
           end
           for i=1:1:N
               for j=1:1:N
                   xC=(i-1)*d+obj.borddist+1; yC=(j-1)*d+obj.borddist+1; % get the objects centers
                   Picture.fuse(obj.d,obj.shape,xC,yC); % draw each object
               end
           end
       end
   end
   
   %% filter the image for noise suppresion 
   methods
       function []=convolfilt(Picture,SpatialMask)
           % convolution the sample with the mask
           Picture.I=cast(Picture.I,'double'); % additional conversion
           Picture.FI=imfilter(Picture.I,SpatialMask.M,'replicate')/(SpatialMask.sum); % convolution 
           % conversion of the filtered image adn additional operations
           if SpatialMask.type == 'Gauss'
               double minFI; minFI = min(min(Picture.FI)); % get the minimal pixel value
               Picture.FI=Picture.FI-minFI; % substracting minimal values
           end
           double maxFI; maxFI = max(max(Picture.FI)); % get the max pixel value
           Picture.FI=Picture.FI*(255/maxFI); % making U8 calibration
           Picture.FI=cast(Picture.FI,'uint8'); % transform to the U8 image type
       end
   end
end

