clc; clear variables; close all; % clearing Command Window and all variables from the Workspace
% This is the main (header) script for generation a grid with object and
% further convolution this grid with the selected spatial mask
%% selection of the parameters for following generation
obj_size=10; % charaterstic object size, for Gaussian-shape object it's a sigma [pixels]
distance=3*obj_size; % distance between centers of objects
obj_type='G'; % it's for a Gaussian-shape object
pic_size=600; % an image size in [pixels]

%% generation of a grid with objects
p=Picture(pic_size); % generation of a instance of a "Pictire" class
p.bckgr; % generation of black background
obj=FluObj(obj_size,obj_type); % generation of a instance of a "FluObj" class
p.grid(obj.d,obj.shape,distance); % generation of a grid with samples
figure; imshow(p.I); % show the result of a generation
% 

%% convolution of a generated grid or open image with a mask
% im=imread();
