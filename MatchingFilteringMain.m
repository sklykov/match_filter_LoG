clc; clear variables; close all; % clearing Command Window and all variables from the Workspace
% This is the main (header) script for generation a grid with object and
% further convolution this grid with the selected spatial mask
%% selection of the parameters for following generation
obj_size=20; % charaterstic object size, for Gaussian-shape object it's a sigma [pixels]
distance=5*obj_size; % distance between centers of objects
obj_type='G'; % it's for a Gaussian-shape object (available now: 'G',... to be continued)
pic_size=620; % an image size in [pixels]
% the hint for creation the symmetrical grid is to calculate pic_size =
% 6*ob_size + N*distance; there N should be an even number
av_noise=0; s_noise=0.01; % noise generation parameters (mean, sigma) for an additive Gaussian noise
mask_size=obj_size/2; % specifying a spatial size of a mask for match filtering

%% generation of a grid with objects
p=Picture(pic_size); % generation of a instance of a "Pictire" class
p.bckgr; % generation of black background
obj=FluObj(obj_size,obj_type); % generation of a instance of a "FluObj" class
p.grid(obj.d,obj.shape,distance); % generation of a grid with samples
% figure; imshow(p.I); % show the result of a generation
p.I=imnoise(p.I,'gaussian',av_noise,s_noise); % embeding an additive Gaussian noise
figure; imshow(p.I); % show the noisy picture
% imwrite(p.I, 'sample.png'); % save the generated picture

%% convolution of a generated grid or open image with a mask
% im=imread('sample.png');
mask=SpatialMask(mask_size,'Gauss'); % sample of a filtering mask
p.convolfilt(mask); % noise supression using generated mask
double maxG; maxG=max(max(mask.M)); mask.M=mask.M*(255/maxG); % making a mask U8 picture
mask.M=cast(mask.M,'uint8'); figure; imshow(mask.M); % check the mask appearance
figure; imshow(p.FI); % check the mask appearance
% imwrite(p.FI, 'filtered.png'); % save the filtered picture
